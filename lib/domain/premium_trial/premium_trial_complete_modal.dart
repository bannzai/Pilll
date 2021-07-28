import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/util/links.dart';

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
          width: 314,
          height: 400,
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
                        style: FontType.subTitle.merge(TextColorStyle.main),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    Text(
                      '''
体験後も自動で課金はされません
                ''',
                      style: FontType.assisting.merge(TextColorStyle.main),
                    ),
                    Image.asset(
                      "images/quick-record.gif",
                    ),
                    SizedBox(height: 20),
                    Text(
                      '''
通知を長押しすると服用記録ができます
                  ''',
                      style: FontType.assisting.merge(TextColorStyle.main),
                    ),
                  ],
                ),
              ),
              Container(
                width: 230,
                child: SecondaryButton(
                    onPressed: () async {
                      analytics.logEvent(
                          name: "pressed_show_premium_for_trial");
                      Navigator.of(context).pop();
                      await openPremiumFunctions();
                    },
                    text: "プレミアム機能を見る"),
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
  analytics.logEvent(name: "show_trial_completed");
  showDialog(
      context: context,
      builder: (context) {
        return PremiumTrialCompleteModal();
      });
}

openPremiumFunctions() async {
  analytics.logEvent(name: "trial_completed_open_premium_link");
  final ChromeSafariBrowser browser = new ChromeSafariBrowser();
  await browser.open(
      url: Uri.parse(preimumLink),
      options: ChromeSafariBrowserClassOptions(
          android:
              AndroidChromeCustomTabsOptions(addDefaultShareMenuItem: false),
          ios: IOSSafariOptions(
              barCollapsingEnabled: true,
              presentationStyle: IOSUIModalPresentationStyle.PAGE_SHEET)));
}
