import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/record/components/announcement_bar/components/premium_trial_limit.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../../../../helper/fake.dart';
import '../../../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(DateTime(2026, 11, 20));
  });

  group('#remainingTrialDays', () {
    test('トライアル中なら端末の時刻から期限までの日数', () {
      final customerInfo = fakeCustomerInfo(
        allExpirationDates: {
          'rc_promo_Premium_custom':
              DateTime(2026, 12, 1).toUtc().toIso8601String()
        },
      );
      expect(
          PremiumTrialLimitAnnouncementBar.remainingTrialDays(
              customerInfo: customerInfo, user: const User()),
          11);
    });

    test('端末の時計を戻していて requestDate が端末の時刻より後なら、requestDate から期限までの日数', () {
      final customerInfo = fakeCustomerInfo(
        allExpirationDates: {
          'rc_promo_Premium_custom':
              DateTime(2026, 12, 1).toUtc().toIso8601String()
        },
        requestDate: DateTime(2026, 11, 28).toUtc().toIso8601String(),
      );
      expect(
          PremiumTrialLimitAnnouncementBar.remainingTrialDays(
              customerInfo: customerInfo, user: const User()),
          3);
    });

    test('課金中なら null', () {
      expect(
          PremiumTrialLimitAnnouncementBar.remainingTrialDays(
              customerInfo: premiumCustomerInfo, user: const User()),
          isNull);
    });

    test('トライアル中でなければ null', () {
      expect(
          PremiumTrialLimitAnnouncementBar.remainingTrialDays(
              customerInfo: freeCustomerInfo, user: const User()),
          isNull);
    });
  });

  // 文言に出る日数は remainingTrialDays と同じ時刻から数えるため、日数の数え方は #remainingTrialDays で確かめる。
  // ここでは文言を出すかどうかだけを確かめる (文言はローカライズ定数で比べない)
  group('#premiumTrialLimitMessage', () {
    test('トライアル中なら文言を返す', () {
      final customerInfo = fakeCustomerInfo(
        allExpirationDates: {
          'rc_promo_Premium_custom':
              DateTime(2026, 12, 1).toUtc().toIso8601String()
        },
      );
      expect(
          PremiumTrialLimitAnnouncementBar.premiumTrialLimitMessage(
              customerInfo: customerInfo, user: const User()),
          isNotNull);
    });

    test('課金中なら null', () {
      expect(
          PremiumTrialLimitAnnouncementBar.premiumTrialLimitMessage(
              customerInfo: premiumCustomerInfo, user: const User()),
          isNull);
    });

    test('トライアル中でなければ null', () {
      expect(
          PremiumTrialLimitAnnouncementBar.premiumTrialLimitMessage(
              customerInfo: freeCustomerInfo, user: const User()),
          isNull);
    });
  });
}
