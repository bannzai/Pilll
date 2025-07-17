import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:url_launcher/url_launcher.dart';

class InvalidAlreadyTakenPillDialog extends StatelessWidget {
  const InvalidAlreadyTakenPillDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 4, bottom: 24),
      actionsPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
      titlePadding: const EdgeInsets.only(top: 32),
      title: SvgPicture.asset('images/alert_24.svg', width: 24, height: 24),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
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
          SvgPicture.asset('images/invalid_rest_duration.svg'),
          const SizedBox(
            height: 15,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(height: 1.7),
              children: [
                // TODO: [Localizations]
                TextSpan(
                  text: L.unmarkTodayPillAsTakenToPause,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: TextColor.main,
                  ),
                ),
                TextSpan(
                  text: L.pauseStartingOtherDaysInstructions,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: TextColor.main,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        AppOutlinedButton(
          onPressed: () async {
            analytics.logEvent(name: 'invalid_already_taken_pill_faq');
            launchUrl(Uri.parse('https://pilll.notion.site/467128e667ae4d6cbff4d61ee370cce5'));
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

void showInvalidAlreadyTakenPillDialog(
  BuildContext context,
) {
  analytics.setCurrentScreen(screenName: 'InvalidAlreadyTakenPillDialog');
  showDialog(
    context: context,
    builder: (context) => const InvalidAlreadyTakenPillDialog(),
  );
}
