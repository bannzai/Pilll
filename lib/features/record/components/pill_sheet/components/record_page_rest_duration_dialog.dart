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
            appearanceMode == PillSheetAppearanceMode.date
                ? L.exampleRestDurationDate
                : L.exampleRestDurationNumber,
            style: const TextStyle(
              color: TextColor.main,
              fontWeight: FontWeight.w700,
              fontFamily: FontFamily.japanese,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          SvgPicture.asset(
            appearanceMode == PillSheetAppearanceMode.date
                ? 'images/explain_rest_duration_date.svg'
                : 'images/explain_rest_duration_number.svg',
          ),
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
      title: RecordPageRestDurationDialogTitle(
        appearanceMode: appearanceMode,
        pillSheetGroup: pillSheetGroup,
      ),
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
          (pillSheetGroup
                      .lastTakenPillSheetOrFirstPillSheet
                      .lastTakenOrZeroPillNumber +
                  1)
              .toString(),
        );
      case PillSheetAppearanceMode.date:
        final date = pillSheetGroup.lastTakenPillSheetOrFirstPillSheet
            .displayPillTakeDate(
              pillSheetGroup
                      .lastTakenPillSheetOrFirstPillSheet
                      .lastTakenOrZeroPillNumber +
                  1,
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
