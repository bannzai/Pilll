import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class RecordPageRestDurationDialog extends StatelessWidget {
  final RecordPageRestDurationDialogTitle title;
  final PillSheetAppearanceMode appearanceMode;
  final VoidCallback onDone;

  const RecordPageRestDurationDialog({
    super.key,
    required this.title,
    required this.appearanceMode,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
              appearanceMode == PillSheetAppearanceMode.date ? 'images/explain_rest_duration_date.svg' : 'images/explain_rest_duration_number.svg'),
          const SizedBox(height: 24),
        ],
      ),
      actions: <Widget>[
        AppOutlinedButton(
          onPressed: () async => onDone(),
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
  required VoidCallback onDone,
}) {
  showDialog(
    context: context,
    builder: (context) => RecordPageRestDurationDialog(
      title: RecordPageRestDurationDialogTitle(appearanceMode: appearanceMode, pillSheetGroup: pillSheetGroup),
      appearanceMode: appearanceMode,
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
    final targetPillSheet = pillSheetGroup.targetBeginRestDurationPillSheet;
    final lastTakenPillSheet = pillSheetGroup.lastTakenPillSheetOrFirstPillSheet;

    // 最後のピルシートが全て飲み終わっていて、次のピルシートがない場合
    if (lastTakenPillSheet.isTakenAll && targetPillSheet.id == lastTakenPillSheet.id) {
      return Text(L.pauseTakingConfirm,
          style: const TextStyle(
            color: TextColor.main,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: FontFamily.japanese,
          ));
    }

    return Text(L.pauseTakingFromNumber(_number),
        style: const TextStyle(
          color: TextColor.main,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: FontFamily.japanese,
        ));
  }

  String get _number {
    final targetPillSheet = pillSheetGroup.targetBeginRestDurationPillSheet;

    switch (appearanceMode) {
      case PillSheetAppearanceMode.number:
        // targetPillSheetのlastTakenOrZeroPillNumberが0の場合は1番から
        final nextNumber = targetPillSheet.lastTakenOrZeroPillNumber == 0 ? 1 : targetPillSheet.lastTakenOrZeroPillNumber + 1;
        return L.withNumber(nextNumber.toString());
      case PillSheetAppearanceMode.date:
        // targetPillSheetのavailableRestDurationBeginDateを使用
        final date = pillSheetGroup.availableRestDurationBeginDate;
        final dateString = DateTimeFormatter.monthAndDay(date);
        return dateString;
      case PillSheetAppearanceMode.sequential:
      case PillSheetAppearanceMode.cyclicSequential:
        // 複数ピルシートの場合の通算番号
        int sequentialNumber;
        if (targetPillSheet.id != pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.id) {
          // 次のピルシートの1番目
          final offset = pillSheetGroup.pillSheets.take(targetPillSheet.groupIndex).fold<int>(0, (sum, sheet) => sum + sheet.typeInfo.totalCount);
          sequentialNumber = offset + 1;
        } else {
          sequentialNumber = pillSheetGroup.sequentialLastTakenPillNumber + 1;
        }
        return L.withNumber(sequentialNumber.toString());
    }
  }
}
