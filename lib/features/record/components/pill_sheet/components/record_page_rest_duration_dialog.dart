import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class RecordPageRestDurationDialog extends StatelessWidget {
  final RecordPageRestDurationDialogTitle title;
  final PillSheetAppearanceMode appearanceMode;
  final VoidCallback onDone;

  const RecordPageRestDurationDialog({
    Key? key,
    required this.title,
    required this.appearanceMode,
    required this.onDone,
  }) : super(key: key);

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
          const Text("服用をお休みするとピル番号は進みません",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: TextColor.main,
              )),
          const SizedBox(height: 24),
          Text(
            appearanceMode == PillSheetAppearanceMode.date ? "例えば「1/12から3日間」服用お休みした場合" : "例えば「18番から3日間」服用お休みした場合",
            style: const TextStyle(
              color: TextColor.main,
              fontWeight: FontWeight.w700,
              fontFamily: FontFamily.japanese,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          SvgPicture.asset(
              appearanceMode == PillSheetAppearanceMode.date ? "images/explain_rest_duration_date.svg" : "images/explain_rest_duration_number.svg"),
          const SizedBox(height: 24),
        ],
      ),
      actions: <Widget>[
        AppOutlinedButton(
          onPressed: () async => onDone(),
          text: "服用をお休みする",
        ),
        Center(
          child: AlertButton(
            text: "閉じる",
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
  required PillSheet activedPillSheet,
  required PillSheetGroup pillSheetGroup,
  required VoidCallback onDone,
}) {
  showDialog(
    context: context,
    builder: (context) => RecordPageRestDurationDialog(
      title: RecordPageRestDurationDialogTitle(appearanceMode: appearanceMode, activedPillSheet: activedPillSheet, pillSheetGroup: pillSheetGroup),
      appearanceMode: appearanceMode,
      onDone: onDone,
    ),
  );
}

class RecordPageRestDurationDialogTitle extends StatelessWidget {
  final PillSheetAppearanceMode appearanceMode;
  final PillSheet activedPillSheet;
  final PillSheetGroup pillSheetGroup;

  const RecordPageRestDurationDialogTitle({
    Key? key,
    required this.appearanceMode,
    required this.activedPillSheet,
    required this.pillSheetGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("$_numberから服用をお休みしますか？",
        style: const TextStyle(
          color: TextColor.main,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: FontFamily.japanese,
        ));
  }

  String get _number {
    switch (appearanceMode) {
      case PillSheetAppearanceMode.number:
        return "${activedPillSheet.lastTakenPillNumber + 1}番";
      case PillSheetAppearanceMode.date:
        final date = activedPillSheet.displayPillTakeDate(activedPillSheet.lastTakenPillNumber + 1);
        final dateString = DateTimeFormatter.monthAndDay(date);
        return dateString;
      case PillSheetAppearanceMode.sequential:
        return "${pillSheetGroup.sequentialLastTakenPillNumber + 1}番";
    }
  }
}
