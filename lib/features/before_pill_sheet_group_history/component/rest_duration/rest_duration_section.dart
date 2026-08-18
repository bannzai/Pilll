import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/theme/date_range_picker.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/before_pill_sheet_group_history/component/rest_duration/provider.dart';
import 'package:pilll/features/error/alert_error.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/provider.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

/// 前回のピルシートグループの服用お休み期間の一覧と、期間の追加・変更の操作
/// 新しいピルシートグループに切り替わった後でも、前回のピルシートグループの期間内の服用お休みを後から記録・修正できるようにする
/// 継続中 (終了日なし) の服用お休みはここでは作らず、終了日つきの期間だけを扱う。継続中の服用お休みは最新のピルシートグループの服用お休み開始で記録する
class BeforePillSheetGroupRestDurationSection extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;

  const BeforePillSheetGroupRestDurationSection({super.key, required this.pillSheetGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    return Theme(
      data: themeData.copyWith(
        listTileTheme: themeData.listTileTheme.copyWith(
          iconColor: AppColors.primary,
          titleTextStyle: const TextStyle(
            color: TextColor.main,
            fontSize: 14,
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final restDuration in pillSheetGroup.restDurations) _ChangeRestDuration(restDuration: restDuration, pillSheetGroup: pillSheetGroup),
          _AddRestDuration(pillSheetGroup: pillSheetGroup),
        ],
      ),
    );
  }
}

String _format(DateTime dateTime) => '${DateTimeFormatter.monthAndDay(dateTime)}(${DateTimeFormatter.shortWeekday(dateTime)})';

Future<DateTimeRange?> _showRestDurationRangePicker(
  BuildContext context, {
  required PillSheetGroup pillSheetGroup,
  required DateTimeRange? initialDateRange,
}) {
  // 前回のピルシートグループの期間内で完結する期間だけを扱う。終了日は服用再開日なので今日まで選択できる
  // 変更対象の既存の開始日・終了日は常に選択できるようにする (DateRangePickerのinitialDateRangeがfirstDate〜lastDateの範囲外だと表示できないため)
  final initialBeginDate = initialDateRange?.start;
  final initialEndDate = initialDateRange?.end;
  final firstBeginDate = pillSheetGroup.pillSheets.first.beginDate;
  final firstDate = initialBeginDate != null && initialBeginDate.isBefore(firstBeginDate) ? initialBeginDate : firstBeginDate;
  final lastDate = initialEndDate != null && initialEndDate.isAfter(today()) ? initialEndDate : today();
  return showDateRangePicker(
    context: context,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    initialDateRange: initialDateRange,
    firstDate: firstDate,
    lastDate: lastDate,
    helpText: L.selectPausePeriod,
    fieldStartHintText: L.pauseStartDate,
    fieldEndLabelText: L.pauseEndDate,
    builder: (context, child) => DateRangePickerTheme(child: child!),
  );
}

class _ChangeRestDuration extends HookConsumerWidget {
  final RestDuration restDuration;
  final PillSheetGroup pillSheetGroup;

  const _ChangeRestDuration({required this.restDuration, required this.pillSheetGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changeRestDuration = ref.watch(changeRestDurationProvider);
    final endDate = restDuration.endDate;

    return ListTile(
      leading: const Icon(Icons.date_range_outlined),
      title: Text(L.changePausePeriod),
      subtitle: Text('${_format(restDuration.beginDate)} - ${endDate != null ? _format(endDate) : ''}'),
      onTap: () async {
        analytics.logEvent(
          name: 'change_rest_duration_in_before_group',
          parameters: {'rest_duration_id': restDuration.id},
        );

        // 継続中 (終了日なし) の服用お休みは今日を終了日の初期値にして、終了日つきの期間として変更してもらう
        final dateTimeRange = await _showRestDurationRangePicker(
          context,
          pillSheetGroup: pillSheetGroup,
          initialDateRange: DateTimeRange(start: restDuration.beginDate, end: endDate ?? today()),
        );
        if (dateTimeRange == null || !context.mounted) {
          return;
        }

        final errorMessage = pillSheetGroup.restDurationRangeErrorMessageForBeforePillSheetGroup(
          dateTimeRange: dateTimeRange,
          excludingRestDuration: restDuration,
        );
        if (errorMessage != null) {
          showErrorAlert(context, AlertError(errorMessage));
          return;
        }

        try {
          await changeRestDuration(
            fromRestDuration: restDuration,
            toRestDuration: RestDuration(
              id: firestoreIDGenerator(),
              beginDate: dateTimeRange.start,
              endDate: dateTimeRange.end,
              createdDate: now(),
            ),
            pillSheetGroup: pillSheetGroup,
          );
          ref.invalidate(beforePillSheetGroupProvider);
          if (!context.mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(duration: const Duration(seconds: 2), content: Text(L.editPausePeriod)),
          );
        } catch (e) {
          debugPrint(e.toString());
          if (context.mounted) {
            showErrorAlert(context, e);
          }
        }
      },
    );
  }
}

class _AddRestDuration extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;

  const _AddRestDuration({required this.pillSheetGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addCompletedRestDuration = ref.watch(addCompletedRestDurationProvider);

    return ListTile(
      leading: const Icon(Icons.dark_mode_outlined),
      title: Text(L.addPausePeriod),
      onTap: () async {
        analytics.logEvent(name: 'add_rest_duration_to_before_group');

        final dateTimeRange = await _showRestDurationRangePicker(context, pillSheetGroup: pillSheetGroup, initialDateRange: null);
        if (dateTimeRange == null || !context.mounted) {
          return;
        }

        final errorMessage = pillSheetGroup.restDurationRangeErrorMessageForBeforePillSheetGroup(
          dateTimeRange: dateTimeRange,
          excludingRestDuration: null,
        );
        if (errorMessage != null) {
          showErrorAlert(context, AlertError(errorMessage));
          return;
        }

        try {
          await addCompletedRestDuration(
            restDuration: RestDuration(
              id: firestoreIDGenerator(),
              beginDate: dateTimeRange.start,
              endDate: dateTimeRange.end,
              createdDate: now(),
            ),
            pillSheetGroup: pillSheetGroup,
          );
          ref.invalidate(beforePillSheetGroupProvider);
          if (!context.mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(duration: const Duration(seconds: 2), content: Text(L.addedPausePeriod)),
          );
        } catch (e) {
          debugPrint(e.toString());
          if (context.mounted) {
            showErrorAlert(context, e);
          }
        }
      },
    );
  }
}
