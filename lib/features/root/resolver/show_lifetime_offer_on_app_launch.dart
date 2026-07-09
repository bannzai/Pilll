import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/lifetime_offer/page.dart';
import 'package:pilll/features/lifetime_offer/provider.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/features/root/resolver/show_paywall_on_app_launch.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';

/// アプリ起動時に買い切りオファーのモーダルを周期（利用開始からの経過年数）ごとに1回だけ自動表示するResolver
///
/// 表示条件は shouldShowLifetimeOfferProvider に従う。表示済みかどうかは
/// 周期番号付きのキー（lifetimeOfferAutoModalShownKey）で永続化し、翌年の周期では再度1回表示する。
class ShowLifetimeOfferOnAppLaunch extends HookConsumerWidget {
  final Widget Function(BuildContext) builder;
  const ShowLifetimeOfferOnAppLaunch({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShowLifetimeOffer = ref.watch(shouldShowLifetimeOfferProvider);
    // 周期番号が確定するまで（null）はshouldShowLifetimeOfferがfalseのため、仮のキー(cycle: 0)が使われることはない
    final lifetimeOfferCycle = ref.watch(lifetimeOfferCycleProvider);
    final lifetimeOfferAutoModalShown = ref.watch(
      boolSharedPreferencesProvider(lifetimeOfferAutoModalShownKey(cycle: lifetimeOfferCycle ?? 0)),
    );
    final lifetimeOfferAutoModalShownNotifier = ref.watch(
      boolSharedPreferencesProvider(
        lifetimeOfferAutoModalShownKey(cycle: lifetimeOfferCycle ?? 0),
      ).notifier,
    );
    // 起動時ペイウォールが表示された起動ではモーダルの二重表示を避け、次回以降の起動での表示に回す
    final shownPaywallOnThisAppLaunch = ref.watch(shownPaywallOnThisAppLaunchProvider);

    useEffect(() {
      // shouldShowLifetimeOfferProvider はRevenueCat等の非同期取得の完了後にtrueへ変わるため、
      // マウント時1回ではなく値の変化を契機に判定する
      if (shouldShowLifetimeOffer && !shownPaywallOnThisAppLaunch && lifetimeOfferAutoModalShown.value != true) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // フレーム描画前にunmountされた場合、モーダルを一度も表示しないまま表示済みフラグだけが永続化され
          // 二度と表示されなくなるため、フラグを立てる前にmountedを確認する
          if (!context.mounted) {
            return;
          }
          // 表示期限の起点となる初回表示時刻を記録する
          await setLifetimeOfferFirstDisplayedDateTimeIfAbsent(ref);
          // 表示条件の再評価等でcallbackが複数回走っても二重表示しないよう、表示前にフラグを立てる
          await lifetimeOfferAutoModalShownNotifier.set(true);
          if (context.mounted) {
            await showLifetimeOfferPage(
              context,
              source: PaywallSource.lifetimeOfferAppLaunch,
            );
          }
        });
      }
      return null;
    }, [shouldShowLifetimeOffer]);

    return builder(context);
  }
}
