import 'dart:io';

import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ReleaseNote extends StatelessWidget {
  const ReleaseNote({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
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
                        padding: const EdgeInsets.only(
                          top: 40,
                          left: 40,
                          right: 40,
                        ),
                        child: const Text(
                          '服薬時刻に目覚ましアラームが鳴るようにしました',
                          style: TextStyle(
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: TextColor.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 25, left: 25, right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '''
集中モードがONまたはデバイスが消音時でも、目覚ましのようにアラームが鳴らせるオプションを追加しました
                        ''',
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: TextColor.main,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 230,
                  child: AlertButton(
                    onPressed: () async {
                      analytics.logEvent(name: 'pressed_show_release_note');
                      Navigator.of(context).pop();
                      openReleaseNote();
                    },
                    text: L.seeDetails,
                  ),
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
  const String key = ReleaseNoteKey.version20250920;
  final storage = await SharedPreferences.getInstance();
  if (storage.getBool(key) ?? false) {
    return;
  }
  // iOSのみのリリースノート
  if (Platform.isAndroid) {
    return;
  }

  await storage.setBool(key, true);

  if (context.mounted) {
    showDialog(
      context: context,
      builder: (context) {
        return const ReleaseNote();
      },
    );
  }
}

void openReleaseNote() async {
  // NOTE: www.notion.so から始まっている場合は間違い
  launchUrl(
    Uri.parse(
      'https://pilll.notion.site/202509-20-x-273293831717809790f9e6cbd8f948c2?pvs=74',
    ),
    mode: LaunchMode.inAppBrowserView,
  );
}
