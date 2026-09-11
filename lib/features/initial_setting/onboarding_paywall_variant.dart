/// オンボーディング内 Paywall 表示の A/B バリアント。
/// Firebase Remote Config の `onboardingPaywallVariant` で配信される文字列に対応する。
/// 割当は Firebase A/B Testing が行い、アプリはリマインダー時刻設定 (3/3) の「次へ」で
/// `onboarding_paywall_assigned` イベントに variant を載せて記録する。
enum OnboardingPaywallVariant {
  /// 対照群: 現行フロー (initial_setting → premium_trial 紹介)
  control,

  /// 実験群: initial_setting 完了後、premium_trial 紹介前に Paywall (premium_introduction) を表示
  paywall,
}

extension OnboardingPaywallVariantFunction on OnboardingPaywallVariant {
  /// Firebase Analytics の variant パラメータ / Remote Config に対応する snake_case 文字列。
  String get value {
    switch (this) {
      case OnboardingPaywallVariant.control:
        return 'control';
      case OnboardingPaywallVariant.paywall:
        return 'paywall';
    }
  }
}

/// Remote Config の文字列値から variant を解決する。空文字・未知値は null (実験未参加。割当イベントも送らない)。
OnboardingPaywallVariant? onboardingPaywallVariantFromRemoteConfig(String value) {
  switch (value) {
    case 'control':
      return OnboardingPaywallVariant.control;
    case 'paywall':
      return OnboardingPaywallVariant.paywall;
    default:
      return null;
  }
}
