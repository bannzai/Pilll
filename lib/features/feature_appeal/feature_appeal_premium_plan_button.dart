import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';

/// Premium 機能の HelpPage で、トライアル中ユーザーを paywall (PremiumIntroductionSheet) へ接続するボタン。
///
/// 「確認する」はトライアル中ユーザーには機能画面 (タブ) へ遷移して paywall に到達しない。
/// FeatureAppeal 分析 (PilllBackend issue #417) で try 後に paywall 未到達のユーザーが 667 人いたため、
/// 機能を試す前後どちらでも paywall へ進める入口を HelpPage 内に置く。
/// 非トライアルの無料ユーザーには「確認する」自体が paywall を開くので出さない。Premium 会員にも出さない。
class FeatureAppealPremiumPlanButton extends ConsumerWidget {
  /// feature_appeal_try_tapped と同じ feature_key (BigQuery でファネルを結合するため)。
  final String featureKey;
  final PaywallSource paywallSource;

  const FeatureAppealPremiumPlanButton({super.key, required this.featureKey, required this.paywallSource});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // HelpPage はホーム画面から開かれ userProvider は読み込み済みのため、未読込 (AsyncLoading) の間は何も出さない
    final user = ref.watch(userProvider).valueOrNull;
    if (user == null || user.isPremium || !user.isTrial) {
      return const SizedBox.shrink();
    }
    return AppOutlinedButton(
      text: L.viewPremiumPlan,
      onPressed: () async {
        analytics.logEvent(
          name: 'feature_appeal_paywall_shown',
          parameters: {'feature_key': featureKey, 'trigger': 'premium_plan_button'},
        );
        await showPremiumIntroductionSheet(context, source: paywallSource);
      },
    );
  }
}
