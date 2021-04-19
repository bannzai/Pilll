import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReleaseNote extends StatelessWidget {
  const ReleaseNote({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ChromeSafariBrowser();
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: PilllColors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.only(),
          width: 304,
          height: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Text(
                          "新機能・機能改善のお知らせ✨",
                          style: FontType.subTitle.merge(TextColorStyle.black),
                        ),
                      ]),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "生理記録ができるようになりました🎉",
                      style: FontType.assisting.merge(TextColorStyle.main),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "詳しい使い方は詳細をご覧ください🙌",
                      style: FontType.assisting.merge(TextColorStyle.main),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Container(
                    width: 230,
                    child: SecondaryButton(
                        onPressed: () async {
                          analytics.logEvent(name: "pressed_show_release_note");
                          Navigator.of(context).pop();
                          await openReleaseNote();
                        },
                        text: "詳細を見る")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showReleaseNotePreDialog(BuildContext context) async {
  final key = ReleaseNoteKey.version2_3_0;
  final storage = await SharedPreferences.getInstance();
  if (storage.getBool(key) ?? false) {
    return;
  }
  storage.setBool(key, true);

  showDialog(
      context: context,
      builder: (context) {
        return ReleaseNote();
      });
}

openReleaseNote() async {
  final ChromeSafariBrowser browser = new ChromeSafariBrowser();
  await browser.open(
      url: Uri.parse(
          "https://pilll.anotion.so/172cae6bced04bbabeab1d8acad91a61"),
      options: ChromeSafariBrowserClassOptions(
          android:
              AndroidChromeCustomTabsOptions(addDefaultShareMenuItem: false),
          ios: IOSSafariOptions(
              barCollapsingEnabled: true,
              presentationStyle: IOSUIModalPresentationStyle.PAGE_SHEET)));
}
