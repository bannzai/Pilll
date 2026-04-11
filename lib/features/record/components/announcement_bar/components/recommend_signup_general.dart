import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/sign_in/sign_in_sheet.dart';
import 'package:pilll/utils/analytics.dart';

/// 非 Premium ユーザー (トライアル中・トライアル未開始・期限切れ) 向けの認証推奨 Bar。
/// Premium 向けの RecommendSignupForPremiumAnnouncementBar とは別 Widget として独立させる
/// (文言・表示条件・event_name が異なるため共通化しない)。
class RecommendSignupGeneralAnnouncementBar extends StatelessWidget {
  const RecommendSignupGeneralAnnouncementBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
      color: AppColors.primary,
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(name: 'feature_appeal_signup_recommend_tapped');
          showSignInSheet(context, SignInSheetStateContext.recordPage, null);
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'images/alert_24.svg',
                        width: 16,
                        height: 16,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        L.recommendSignupGeneralTitle,
                        style: const TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: TextColor.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    L.recommendSignupGeneralDescription,
                    style: const TextStyle(
                      color: TextColor.white,
                      fontFamily: FontFamily.japanese,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: SvgPicture.asset(
                  'images/arrow_right.svg',
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                onPressed: () {},
                iconSize: 24,
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
