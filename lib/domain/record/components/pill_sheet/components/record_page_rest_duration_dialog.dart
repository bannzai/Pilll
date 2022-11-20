import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class RecordPageRestDurationDialog extends StatelessWidget {
  final RecordPageRestDurationDialogTitle title;
  final VoidCallback onDone;

  const RecordPageRestDurationDialog({
    Key? key,
    required this.title,
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
          Text("休薬するとピル番号は進みません",
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.main,
              )),
          const SizedBox(height: 24),
          SvgPicture.asset("images/explain_rest_duration.svg"),
          const SizedBox(height: 24),
          const Text(
            "※休薬開始日を変えたい場合",
            style: TextStyle(
              color: TextColor.main,
              fontSize: 14,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 8),
          const Text(
            "希望日まで未服用にする必要があります。服用済みのピルマークをタップすることで未服用にできます",
            style: TextStyle(
              color: TextColor.main,
              fontFamily: FontFamily.japanese,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 24),
        ],
      ),
      actions: <Widget>[
        AppOutlinedButton(
          onPressed: () async => onDone(),
          text: "休薬する",
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

showRecordPageRestDurationDialog(
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
    return Text("$_numberから休薬しますか？",
        style: const TextStyle(
          color: TextColor.main,
          fontSize: 16,
          fontWeight: FontWeight.w600,
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
