import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';

void main() {
  group('#PaywallSourceFunction', () {
    test('全 PaywallSource の value がユニーク', () {
      final values = PaywallSource.values.map((e) => e.value).toList();
      expect(values.toSet().length, values.length, reason: '重複: $values');
    });

    test('全 PaywallSource の value が snake_case', () {
      final pattern = RegExp(r'^[a-z][a-z0-9_]*$');
      for (final source in PaywallSource.values) {
        expect(pattern.hasMatch(source.value), isTrue, reason: source.value);
      }
    });

    test('全 PaywallSource の value が Firebase Analytics の40字制限内', () {
      for (final source in PaywallSource.values) {
        expect(source.value.length, lessThanOrEqualTo(40), reason: source.value);
      }
    });

    test('代表値の value が期待通り', () {
      expect(PaywallSource.appLaunch.value, 'app_launch');
      expect(PaywallSource.settingsPremiumIntroductionRow.value, 'settings_premium_introduction_row');
      expect(PaywallSource.featureAppealAlarmKit.value, 'feature_appeal_alarm_kit');
      expect(PaywallSource.specialOfferingBar2.value, 'special_offering_bar2');
    });
  });
}
