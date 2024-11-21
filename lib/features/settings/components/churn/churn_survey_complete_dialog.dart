import 'package:flutter/material.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/root/localization/l.dart';  // Lクラスをインポート

class ChurnSurveyCompleteDialog extends StatelessWidget {
  const ChurnSurveyCompleteDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        L.thankYouForCooperation,  // ご協力頂きありがとうございますを翻訳
        style: const TextStyle(
          fontFamily: FontFamily.japanese,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: TextColor.main,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            L.feedbackUsage,  // いただいた意見は今後の改善へと活用させていただきます。を翻訳
            style: const TextStyle(
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
          text: L.close,  // 閉じるを翻訳
          onPressed: () async {
            analytics.logEvent(name: 'close_churn');
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
