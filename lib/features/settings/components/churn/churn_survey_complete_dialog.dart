import 'package:flutter/material.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class ChurnSurveyCompleteDialog extends StatelessWidget {
  const ChurnSurveyCompleteDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: const Text(
        "ご協力頂きありがとうございました",
        style: TextStyle(
          fontFamily: FontFamily.japanese,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: TextColor.main,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "いただいた意見は今後の改善へと活用させていただきます。",
            style: TextStyle(
              fontFamily: FontFamily.japanese,
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: TextColor.main,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        AlertButton(
          text: "閉じる",
          onPressed: () async {
            analytics.logEvent(name: "close_churn");
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
