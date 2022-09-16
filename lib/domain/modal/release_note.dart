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
                        padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
                        child: Text(
                          "ロック画面で服用するピルの番号を確認できるようになりました",
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
ロック画面にPilllのウィジェットが配置できるようになりました。本日服用するピルの番号が一目で確認できます。追加方法は詳細よりご確認ください
                        ''',
                        style: FontType.assisting.merge(TextColorStyle.main),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 230,
                  child: AlertButton(
                      onPressed: () async {
                        analytics.logEvent(name: "pressed_show_release_note");
                        Navigator.of(context).pop();
                        openReleaseNote();
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

void showReleaseNotePreDialog(BuildContext context) async {
  const key = ReleaseNoteKey.version3_14_0;
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

void openReleaseNote() async {
  final ChromeSafariBrowser browser = ChromeSafariBrowser();
  await browser.open(
      url: Uri.parse("https://pilll.wraptas.site/f8693e05085f4f0280eea0d9b574361a"),
      options: ChromeSafariBrowserClassOptions(
          android: AndroidChromeCustomTabsOptions(shareState: CustomTabsShareState.SHARE_STATE_OFF),
          ios: IOSSafariOptions(barCollapsingEnabled: true, presentationStyle: IOSUIModalPresentationStyle.PAGE_SHEET)));
}
