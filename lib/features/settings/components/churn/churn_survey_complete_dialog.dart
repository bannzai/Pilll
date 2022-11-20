import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pilll/util/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:url_launcher/url_launcher.dart';

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
            "解約は下記の「解約ページへ」から行ってください",
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
          onPressed: () async {
            analytics.logEvent(
              name: "pressed_store_support_page",
            );
            if (Platform.isIOS) {
              launchUrl(Uri.parse("https://support.apple.com/ja-jp/HT202039"), mode: LaunchMode.inAppWebView);
            }
            if (Platform.isAndroid) {
              launchUrl(
                  Uri.parse(
                      "https://support.google.com/googleplay/answer/7018481?hl=ja&co=GENIE.Platform%3DAndroid#zippy=%2Cgoogle-play-%E3%82%A2%E3%83%97%E3%83%AA%E3%81%A7%E5%AE%9A%E6%9C%9F%E8%B3%BC%E5%85%A5%E3%82%92%E8%A7%A3%E7%B4%84%E3%81%99%E3%82%8B%2C%E5%AE%9A%E6%9C%9F%E8%B3%BC%E5%85%A5%E3%81%AE%E8%A7%A3%E7%B4%84%E6%96%B9%E6%B3%95%E3%82%92%E8%A6%8B%E3%82%8B"),
                  mode: LaunchMode.inAppWebView);
            }
          },
          text: "ヘルプ",
        ),
        AlertButton(
          text: "解約ページへ",
          onPressed: () async {
            analytics.logEvent(name: "pressed_go_to_churn");
            if (Platform.isIOS) {
              launchUrl(Uri.parse("https://apps.apple.com/account/subscriptions"), mode: LaunchMode.externalApplication);
            }
            if (Platform.isAndroid) {
              launchUrl(Uri.parse("https://play.google.com/store/account/subscriptions"), mode: LaunchMode.externalApplication);
            }
          },
        ),
      ],
    );
  }
}
