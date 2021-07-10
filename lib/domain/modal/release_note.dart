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
                        "通知から服用記録ができるようになりました！",
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
Apple Watchからも服用記録ができます。
その他にも新機能が続々登場！
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
                      analytics.logEvent(name: "pressed_show_release_note");
                      Navigator.of(context).pop();
                      await openReleaseNote();
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

showReleaseNotePreDialog(BuildContext context) async {
  final key = ReleaseNoteKey.version2_4_0;
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
          "https://pilll.anotion.so/6b4ac5d845f24f7ca864f6b501690694"),
      options: ChromeSafariBrowserClassOptions(
          android:
              AndroidChromeCustomTabsOptions(addDefaultShareMenuItem: false),
          ios: IOSSafariOptions(
              barCollapsingEnabled: true,
              presentationStyle: IOSUIModalPresentationStyle.PAGE_SHEET)));
}
