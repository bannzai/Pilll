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
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: PilllColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 40, left: 40, right: 40),
                        child: Text(
                          "服用通知がタイムゾーンに対応しました",
                          style: FontType.subTitle.merge(TextColorStyle.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '''
設定 > 通知時刻 > 右上の⏰ボタンを押していただくと、お住まいの地域のタイムゾーンへと変更することができます。通知時刻は設定されているタイムゾーンの時刻が設定されます。デフォルトでは日本時間になります
                        ''',
                        style: FontType.assisting.merge(TextColorStyle.main),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 230,
                  child: AlertButton(
                      onPressed: () async {
                        analytics.logEvent(name: "pressed_show_release_note");
                        Navigator.of(context).pop();
                        await openReleaseNote();
                      },
                      text: "詳細を見る"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

showReleaseNotePreDialog(BuildContext context) async {
  final key = ReleaseNoteKey.version3_11_0;
  final storage = await SharedPreferences.getInstance();
  if (storage.getBool(key) ?? false) {
    return;
  }
  await storage.setBool(key, true);

  showDialog(
      context: context,
      builder: (context) {
        return const ReleaseNote();
      });
}

openReleaseNote() async {
  final ChromeSafariBrowser browser = new ChromeSafariBrowser();
  await browser.open(
      url: Uri.parse(
          "https://pilll.wraptas.site/e78b91bc246a4669bfbe3fda9e058e79"),
      options: ChromeSafariBrowserClassOptions(
          android:
              AndroidChromeCustomTabsOptions(addDefaultShareMenuItem: false),
          ios: IOSSafariOptions(
              barCollapsingEnabled: true,
              presentationStyle: IOSUIModalPresentationStyle.PAGE_SHEET)));
}
