import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:url_launcher/url_launcher.dart';

class UserSurvey extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onClose;
  const UserSurvey({
    Key? key,
    required this.onTap,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: PilllColors.primary,
      child: GestureDetector(
        onTap: () async {
          analytics.logEvent(name: "user_survey_open", parameters: {"key": BoolKey.userAnsweredSurvey});
          await launchUrl(Uri.parse("https://docs.google.com/forms/d/e/1FAIpQLSda8_Ri7SSMAwj5mTBryc6_GBVgTw14u9l5txPRnA1xrqiUZw/viewform"));
          onTap();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                analytics.logEvent(name: "user_survey_close", parameters: {"key": BoolKey.userClosedSurvey});
                onClose();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const Spacer(),
            const Text(
              "サービス改善のアンケートにご協力ください\n所要時間：1分",
              style: TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w700, fontSize: 12, color: TextColor.white),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SvgPicture.asset(
              "images/arrow_right.svg",
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
