import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/lifetime_offer/page.dart';
import 'package:pilll/features/lifetime_offer/provider.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/features/root/resolver/show_paywall_on_app_launch.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/utils/shared_preference/keys.dart';

/// アプリ起動時に買い切りオファーのモーダルを永続的に1回だけ自動表示するResolver
///
/// 表示条件は shouldShowLifetimeOfferProvider に従う。表示済みかどうかは
/// BoolKey.lifetimeOfferAutoModalShown で永続化する。
class ShowLifetimeOfferOnAppLaunch extends HookConsumerWidget {
  final Widget Function(BuildContext) builder;
  const ShowLifetimeOfferOnAppLaunch({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShowLifetimeOffer = ref.watch(shouldShowLifetimeOfferProvider);
    final lifetimeOfferAutoModalShown = ref.watch(
      boolSharedPreferencesProvider(BoolKey.lifetimeOfferAutoModalShown),
    );
    final lifetimeOfferAutoModalShownNotifier = ref.watch(
      boolSharedPreferencesProvider(
        BoolKey.lifetimeOfferAutoModalShown,
      ).notifier,
    );
    // 起動時ペイウォールが表示された起動ではモーダルの二重表示を避け、次回以降の起動での表示に回す
    final shownPaywallOnThisAppLaunch = ref.watch(shownPaywallOnThisAppLaunchProvider);

    useEffect(() {
      // shouldShowLifetimeOfferProvider はRevenueCat等の非同期取得の完了後にtrueへ変わるため、
      // マウント時1回ではなく値の変化を契機に判定する
      if (shouldShowLifetimeOffer && !shownPaywallOnThisAppLaunch && lifetimeOfferAutoModalShown.value != true) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // 表示条件の再評価等でcallbackが複数回走っても二重表示しないよう、表示前にフラグを立てる
          await lifetimeOfferAutoModalShownNotifier.set(true);
          if (context.mounted) {
            await showLifetimeOfferPage(
              context,
              source: PaywallSource.lifetimeOfferAppLaunch,
              lifetimeOfferIsClosed: null,
            );
          }
        });
      }
      return null;
    }, [shouldShowLifetimeOffer]);

    return builder(context);
  }
}
