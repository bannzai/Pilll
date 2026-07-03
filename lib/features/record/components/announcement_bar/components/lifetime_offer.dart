import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/lifetime_offer/page.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/utils/analytics.dart';

/// 買い切りオファー画面への導線となるお知らせバー
class LifetimeOfferAnnouncementBar extends HookConsumerWidget {
  final ValueNotifier<bool> lifetimeOfferIsClosed;
  const LifetimeOfferAnnouncementBar({
    super.key,
    required this.lifetimeOfferIsClosed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      analytics.logEvent(name: 'lifetime_offer_announcement_bar_viewed');
      return null;
    }, []);
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 4, left: 8, right: 8),
      color: AppColors.primary,
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(name: 'lifetime_offer_announcement_bar_tap');
          showLifetimeOfferPage(
            context,
            source: PaywallSource.lifetimeOfferBar,
            lifetimeOfferIsClosed: lifetimeOfferIsClosed,
          );
        },
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Pilllのご利用ありがとうございます！\n今回限りの割引価格で買い切りプランをゲット！',
                style: TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: TextColor.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: SvgPicture.asset(
                  'images/arrow_right.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
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
