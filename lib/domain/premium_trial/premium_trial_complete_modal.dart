import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';

class PremiumTrialCompleteModal extends StatelessWidget {
  const PremiumTrialCompleteModal({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: PilllColors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          width: 304,
          height: 302,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "プレミアム体験が始まりました！",
                        style: FontType.subTitle.merge(TextColorStyle.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '''
今日から30日間プレミアム機能をお試しいただけます。プレミアム機能の詳細については[詳細を見る]からご覧ください。
                      ''',
                      style: FontType.assisting.merge(TextColorStyle.main),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 230,
                child: SecondaryButton(
                    onPressed: () async {
                      analytics.logEvent(
                          name: "pressed_show_premium_for_trial");
                      Navigator.of(context).pop();
                      await openPremiumFunctions();
                    },
                    text: "詳細を見る"),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

showPremiumTrialCompleteModalPreDialog(BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) {
        return PremiumTrialCompleteModal();
      });
}

openPremiumFunctions() async {
  final ChromeSafariBrowser browser = new ChromeSafariBrowser();
  await browser.open(
      url: Uri.parse("TODO"),
      options: ChromeSafariBrowserClassOptions(
          android:
              AndroidChromeCustomTabsOptions(addDefaultShareMenuItem: false),
          ios: IOSSafariOptions(
              barCollapsingEnabled: true,
              presentationStyle: IOSUIModalPresentationStyle.PAGE_SHEET)));
}
