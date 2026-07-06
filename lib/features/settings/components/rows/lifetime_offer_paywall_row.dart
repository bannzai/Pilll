import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/lifetime_offer/page.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/user.dart';

/// 開発者オプション内の行。タップすると買い切りオファーPaywallを解約誘導文言あり/なしの2パターンで確認できる。
class LifetimeOfferPaywallRow extends StatelessWidget {
  const LifetimeOfferPaywallRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('買い切りオファー Paywall'),
      subtitle: const Text('解約誘導文言あり/なしを確認'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final isActiveSubscriber = await showDialog<bool>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('表示パターンを選択'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('解約誘導文言あり（月額・年額プラン課金中）'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('解約誘導文言なし（非課金）'),
              ),
            ],
          ),
        );
        if (isActiveSubscriber == null || !context.mounted) {
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => ProviderScope(
              overrides: [
                // 解約誘導文言は user.isPremium && 買い切り未購入 のときのみ表示されるため、この2つを固定して両パターンを再現する。
                // 価格等の他のProviderはoverrideせずroot側の実データを使う
                userProvider.overrideWith(
                  (ref) => Stream.value(
                    User(
                      isPremium: isActiveSubscriber,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLifetimePurchasedProvider.overrideWith((ref) => Future.value(false)),
              ],
              child: const LifetimeOfferPage(source: PaywallSource.lifetimeOfferBar),
            ),
          ),
        );
      },
    );
  }
}
