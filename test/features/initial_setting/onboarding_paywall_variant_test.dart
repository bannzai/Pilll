import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/initial_setting/onboarding_paywall_variant.dart';

void main() {
  group('#onboardingPaywallVariantFromRemoteConfig', () {
    test("'control' → control", () {
      expect(onboardingPaywallVariantFromRemoteConfig('control'), OnboardingPaywallVariant.control);
    });

    test("'paywall' → paywall", () {
      expect(onboardingPaywallVariantFromRemoteConfig('paywall'), OnboardingPaywallVariant.paywall);
    });

    test('空文字 (Remote Config 未設定・実験未参加) → null', () {
      expect(onboardingPaywallVariantFromRemoteConfig(''), isNull);
    });

    test('未知の値 → null (現行フローにフォールバック)', () {
      expect(onboardingPaywallVariantFromRemoteConfig('unknown'), isNull);
    });
  });

  group('#OnboardingPaywallVariantFunction', () {
    test('value は Remote Config / Analytics の variant パラメータと一致する', () {
      expect(OnboardingPaywallVariant.control.value, 'control');
      expect(OnboardingPaywallVariant.paywall.value, 'paywall');
    });

    test('全 variant の value から元の variant に戻せる (Remote Config の値と 1:1)', () {
      for (final variant in OnboardingPaywallVariant.values) {
        expect(onboardingPaywallVariantFromRemoteConfig(variant.value), variant);
      }
    });
  });
}
