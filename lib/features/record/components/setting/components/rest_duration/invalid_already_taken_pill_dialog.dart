import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:url_launcher/url_launcher.dart';

class InvalidAlreadyTakenPillDialog extends StatelessWidget {
  const InvalidAlreadyTakenPillDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // 訳文が日本語より長い表示言語や小さい画面で、本文がダイアログの高さに収まらず切れるため
      scrollable: true,
      contentPadding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 4,
        bottom: 24,
      ),
      actionsPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
      titlePadding: const EdgeInsets.only(top: 32),
      title: SvgPicture.asset('images/alert_24.svg', width: 24, height: 24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            L.cannotPauseAlreadyTakenToday,
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: TextColor.main,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // 説明図の文言を表示言語で出すため、images/invalid_rest_duration.svg には線と丸だけを置き、文言と吹き出しはここで重ねる。
          // 幅 218 と左余白 9・列幅 100 は SVG の幅と、昨日・今日の丸の中心 (x=59, x=159) に列の中心を合わせるための値
          SizedBox(
            width: 218,
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 9),
                    SizedBox(
                      width: 100,
                      child: Text(
                        L.invalidRestDurationIllustrationYesterday,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: TextColor.main,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        L.invalidRestDurationIllustrationToday,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: TextColor.main,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SvgPicture.asset('images/invalid_rest_duration.svg'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 9),
                    SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'images/invalid_rest_duration_bubble_tip.svg',
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: Text(
                              L.invalidRestDurationIllustrationTakenUntilThisDay,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: FontFamily.japanese,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: TextColor.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            '↑',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: TextColor.main,
                            ),
                          ),
                          Text(
                            L.invalidRestDurationIllustrationUnmarkAsTaken,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: FontFamily.japanese,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: TextColor.main,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // 2 つの文を連結すると、ja 以外の表示言語で文の境目が消えるため、それぞれ完結した文として行を分ける
          Text(
            L.invalidAlreadyTakenPillUnmarkThenPause,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.7,
              color: TextColor.main,
            ),
          ),
          Text(
            L.invalidAlreadyTakenPillPauseOtherDaysGuide,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w300,
              fontSize: 14,
              height: 1.7,
              color: TextColor.main,
            ),
          ),
        ],
      ),
      actions: [
        AppOutlinedButton(
          onPressed: () async {
            analytics.logEvent(name: 'invalid_already_taken_pill_faq');
            launchUrl(
              Uri.parse(
                'https://pilll.notion.site/467128e667ae4d6cbff4d61ee370cce5',
              ),
            );
          },
          text: L.seeHowToUsePauseTakingFeature,
        ),
        Center(
          child: AlertButton(
            text: L.close,
            onPressed: () async {
              analytics.logEvent(name: 'invalid_already_taken_pill_close');
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

void showInvalidAlreadyTakenPillDialog(BuildContext context) {
  analytics.logScreenView(screenName: 'InvalidAlreadyTakenPillDialog');
  showDialog(
    context: context,
    builder: (context) => const InvalidAlreadyTakenPillDialog(),
  );
}
