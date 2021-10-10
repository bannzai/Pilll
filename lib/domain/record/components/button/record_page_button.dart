import 'package:flutter/material.dart';
import 'package:pilll/domain/record/components/button/cancel_button.dart';
import 'package:pilll/domain/record/components/button/rest_duration_button.dart';
import 'package:pilll/domain/record/components/button/taken_button.dart';
import 'package:pilll/entity/pill_sheet.dart';

class RecordPageButton extends StatelessWidget {
  final PillSheet currentPillSheet;

  const RecordPageButton({
    Key? key,
    required this.currentPillSheet,
  }) : super(key: key);

  Widget build(BuildContext context) {
    if (currentPillSheet.activeRestDuration != null)
      return RestDurationButton();
    else if (currentPillSheet.isAllTaken)
      return CancelButton(currentPillSheet);
    else
      return TakenButton(
        parentContext: context,
        pillSheet: currentPillSheet,
      );
  }
}
