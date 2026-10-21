import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/theme/date_range_picker.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class RecordPageRestDurationDialog extends HookConsumerWidget {
  final RecordPageRestDurationDialogTitle title;
  final PillSheetAppearanceMode appearanceMode;
  final PillSheetGroup pillSheetGroup;

  /// ダイアログを開いた時点で選択済みにする服用再開予定日。未選択で開く時はnull。
  /// 選択状態は[useState]で持つため、開いた後に変わっても反映しない
  final DateTime? initialEndDate;

  /// 服用再開予定日（任意）を受け取って服用お休みを開始する。未選択ならnull
  final void Function(DateTime? endDate) onDone;

  const RecordPageRestDurationDialog({
    super.key,
    required this.title,
    required this.appearanceMode,
    required this.pillSheetGroup,
    required this.initialEndDate,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final endDate = useState<DateTime?>(initialEndDate);

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 32),
      actionsPadding: const EdgeInsets.only(left: 24, right: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          title,
          const SizedBox(height: 24),
          Text(
            L.pauseTakingDoesNotAdvancePillNumber,
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: TextColor.main,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            appearanceMode == PillSheetAppearanceMode.date ? L.exampleRestDurationDate : L.exampleRestDurationNumber,
            style: const TextStyle(
              color: TextColor.main,
              fontWeight: FontWeight.w700,
              fontFamily: FontFamily.japanese,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          SvgPicture.asset(
            appearanceMode == PillSheetAppearanceMode.date ? 'images/explain_rest_duration_date.svg' : 'images/explain_rest_duration_number.svg',
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              L.plannedResumeDateOptional,
              style: const TextStyle(
                color: TextColor.main,
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.japanese,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              endDate.value == null
                  ? L.plannedResumeDateNotSet
                  : '${DateTimeFormatter.monthAndDay(endDate.value!)}(${DateTimeFormatter.shortWeekday(endDate.value!)})',
              style: const TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 14,
              ),
            ),
            trailing: endDate.value == null
                ? null
                : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      analytics.logEvent(name: 'clear_planned_resume_date');
                      endDate.value = null;
                    },
                  ),
            onTap: () async {
              analytics.logEvent(name: 'show_planned_resume_date_picker');
              // 終了日は服用再開日でお休みに含まれないため、最短でも開始日の翌日
              final firstDate = pillSheetGroup.availableRestDurationBeginDate.date().addDays(1);
              final selectedDate = await showDatePicker(
                context: context,
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                initialDate: endDate.value ?? firstDate,
                firstDate: firstDate,
                lastDate: pillSheetGroup.availableRestDurationBeginDate.date().addDays(PillSheetGroupRestDurationDomain.maxRestDurationDays),
                helpText: L.selectPlannedResumeDate,
                builder: (context, child) {
                  return DateRangePickerTheme(child: child!);
                },
              );
              if (selectedDate == null) {
                return;
              }
              analytics.logEvent(
                name: 'select_planned_resume_date',
                parameters: {'end_date': selectedDate.toIso8601String()},
              );
              endDate.value = selectedDate;
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
      actions: <Widget>[
        AppOutlinedButton(
          onPressed: () async => onDone(endDate.value),
          text: L.startPauseTaking,
        ),
        Center(
          child: AlertButton(
            text: L.close,
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

void showRecordPageRestDurationDialog(
  BuildContext context, {
  required PillSheetAppearanceMode appearanceMode,
  required PillSheetGroup pillSheetGroup,
  required void Function(DateTime? endDate) onDone,
}) {
  showDialog(
    context: context,
    builder: (context) => RecordPageRestDurationDialog(
      title: RecordPageRestDurationDialogTitle(
        appearanceMode: appearanceMode,
        pillSheetGroup: pillSheetGroup,
      ),
      appearanceMode: appearanceMode,
      pillSheetGroup: pillSheetGroup,
      initialEndDate: null,
      onDone: onDone,
    ),
  );
}

class RecordPageRestDurationDialogTitle extends StatelessWidget {
  final PillSheetAppearanceMode appearanceMode;
  final PillSheetGroup pillSheetGroup;

  const RecordPageRestDurationDialogTitle({
    super.key,
    required this.appearanceMode,
    required this.pillSheetGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      L.pauseTakingFromNumber(_number),
      style: const TextStyle(
        color: TextColor.main,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontFamily: FontFamily.japanese,
      ),
    );
  }

  String get _number {
    switch (appearanceMode) {
      case PillSheetAppearanceMode.number:
        return L.withNumber(
          (pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.lastTakenOrZeroPillNumber + 1).toString(),
        );
      case PillSheetAppearanceMode.date:
        final date = pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.displayPillTakeDate(
          pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.lastTakenOrZeroPillNumber + 1,
        );
        final dateString = DateTimeFormatter.monthAndDay(date);
        return dateString;
      case PillSheetAppearanceMode.sequential:
      case PillSheetAppearanceMode.cyclicSequential:
        return L.withNumber(
          (pillSheetGroup.sequentialLastTakenPillNumber + 1).toString(),
        );
    }
  }
}
