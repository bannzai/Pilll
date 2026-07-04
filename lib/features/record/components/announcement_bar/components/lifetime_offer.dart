import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/lifetime_offer/page.dart';
import 'package:pilll/features/lifetime_offer/provider.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/utils/analytics.dart';

/// 買い切りオファー画面への導線となるお知らせバー
///
/// 初回表示から表示期限までの残り時間を毎秒更新でカウントダウン表示し、期限を過ぎると自動で消える。
class LifetimeOfferAnnouncementBar extends HookConsumerWidget {
  const LifetimeOfferAnnouncementBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      analytics.logEvent(name: 'lifetime_offer_announcement_bar_viewed');
      // 表示期限の起点となる初回表示時刻を記録する
      setLifetimeOfferFirstDisplayedDateTimeIfAbsent(ref);
      return null;
    }, []);

    final remainingDuration = ref.watch(lifetimeOfferRemainingDurationProvider);
    if (remainingDuration.inSeconds <= 0) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 4, left: 8, right: 8),
      color: AppColors.primary,
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(name: 'lifetime_offer_announcement_bar_tap');
          showLifetimeOfferPage(
            context,
            source: PaywallSource.lifetimeOfferBar,
          );
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Pilllのご利用ありがとうございます！\n期間限定の割引価格は残り ${lifetimeOfferCountdownString(remainingDuration)}',
                style: const TextStyle(
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
