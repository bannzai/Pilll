import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/customer_info.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../helper/fake.dart';
import '../helper/mock.mocks.dart';

// purchases_flutter の plugin が getCustomerInfo・logIn で返す CustomerInfo の JSON。区別のため originalAppUserId に [appUserID] を入れる
Map<String, Object> _customerInfoJson({required String appUserID}) => {
      'entitlements': {'all': {}, 'active': {}},
      'allPurchaseDates': {},
      'activeSubscriptions': [],
      'allPurchasedProductIdentifiers': [],
      'nonSubscriptionTransactions': [],
      'firstSeen': '',
      'originalAppUserId': appUserID,
      'allExpirationDates': {},
      'requestDate': '',
    };

void main() {
  setUp(() {
    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now())
        .thenReturn(DateTime.parse('2026-11-07T12:00:00Z').toLocal());
  });

  group('#isPremium', () {
    test('月額のサブスクリプションを購読中ならtrue', () {
      expect(premiumCustomerInfo.isPremium, isTrue);
    });

    test('課金もトライアルも無いならfalse', () {
      expect(freeCustomerInfo.isPremium, isFalse);
    });

    test('トライアル (Promotional Entitlement) だけが有効ならfalse', () {
      final customerInfo = fakeCustomerInfo(
        activeSubscriptions: ['rc_promo_Premium_custom'],
        allExpirationDates: {'rc_promo_Premium_custom': '2026-12-01T00:00:00Z'},
        activePremiumProductIdentifier: 'rc_promo_Premium_custom',
      );
      expect(customerInfo.isPremium, isFalse);
    });

    test(
        'Promotional Entitlement の期限が課金より後で entitlement が Promotional Entitlement を指していても、課金のサブスクリプションを購読中ならtrue',
        () {
      final customerInfo = fakeCustomerInfo(
        activeSubscriptions: ['rc_promo_Premium_custom', 'premium_monthly'],
        allExpirationDates: {
          'rc_promo_Premium_custom': '2026-12-01T00:00:00Z',
          'premium_monthly': '2026-11-20T00:00:00Z'
        },
        activePremiumProductIdentifier: 'rc_promo_Premium_custom',
      );
      expect(customerInfo.isPremium, isTrue);
    });

    test('期限の無い Promotional Entitlement (ダッシュボードでの恒久的な付与) で Premium が有効ならtrue',
        () {
      final customerInfo = fakeCustomerInfo(
        allExpirationDates: {'rc_promo_Premium_lifetime': null},
        activePremiumProductIdentifier: 'rc_promo_Premium_lifetime',
      );
      expect(customerInfo.isPremium, isTrue);
      expect(customerInfo.premiumOrTrial(user: const User()), isTrue);
      expect(customerInfo.isTrial(user: const User()), isFalse);
    });

    test('買い切り (サブスクリプションではない) で Premium entitlement が有効ならtrue', () {
      final customerInfo =
          fakeCustomerInfo(activePremiumProductIdentifier: 'premium_lifetime');
      expect(customerInfo.isPremium, isTrue);
    });

    test('rc_promo_Premium で始まらない商品 ID (rc_promo を途中に含むだけ) は課金として扱う', () {
      final customerInfo =
          fakeCustomerInfo(activeSubscriptions: ['premium_rc_promo_Premium']);
      expect(customerInfo.isPremium, isTrue);
    });
  });

  group('#promotionalPremiumExpirationDate', () {
    test('Promotional Entitlement が無いならnull', () {
      expect(premiumCustomerInfo.promotionalPremiumExpirationDate, isNull);
    });

    test('Promotional Entitlement の期限を返す', () {
      final customerInfo = fakeCustomerInfo(allExpirationDates: {
        'rc_promo_Premium_custom': '2026-12-01T00:00:00Z'
      });
      expect(customerInfo.promotionalPremiumExpirationDate,
          DateTime.parse('2026-12-01T00:00:00Z').toLocal());
    });

    test('期限切れの Promotional Entitlement の期限も返す', () {
      final customerInfo = fakeCustomerInfo(allExpirationDates: {
        'rc_promo_Premium_custom': '2026-10-01T00:00:00Z'
      });
      expect(customerInfo.promotionalPremiumExpirationDate,
          DateTime.parse('2026-10-01T00:00:00Z').toLocal());
    });

    test('Promotional Entitlement が複数あれば最も遅い期限を返す', () {
      final customerInfo = fakeCustomerInfo(
        allExpirationDates: {
          'rc_promo_Premium_custom': '2026-10-01T00:00:00Z',
          'rc_promo_Premium_three_day': '2026-12-01T00:00:00Z',
        },
      );
      expect(customerInfo.promotionalPremiumExpirationDate,
          DateTime.parse('2026-12-01T00:00:00Z').toLocal());
    });

    test('Promotional Entitlement ではない商品の期限は使わない', () {
      final customerInfo = fakeCustomerInfo(
          allExpirationDates: {'premium_monthly': '2026-12-01T00:00:00Z'});
      expect(customerInfo.promotionalPremiumExpirationDate, isNull);
    });

    test('期限が null の Promotional Entitlement は使わない', () {
      final customerInfo = fakeCustomerInfo(
          allExpirationDates: {'rc_promo_Premium_custom': null});
      expect(customerInfo.promotionalPremiumExpirationDate, isNull);
    });
  });

  group('#trialDeadlineDate', () {
    test(
        'Promotional Entitlement があれば users の期限より Promotional Entitlement の期限を使う',
        () {
      final customerInfo = fakeCustomerInfo(allExpirationDates: {
        'rc_promo_Premium_custom': '2026-12-01T00:00:00Z'
      });
      final user =
          User(trialDeadlineDate: DateTime.parse('2027-01-01T00:00:00Z'));
      expect(customerInfo.trialDeadlineDate(user: user),
          DateTime.parse('2026-12-01T00:00:00Z').toLocal());
    });

    test('Promotional Entitlement が無い既存ユーザーは users の期限を使う', () {
      final user =
          User(trialDeadlineDate: DateTime.parse('2026-12-01T00:00:00Z'));
      expect(freeCustomerInfo.trialDeadlineDate(user: user),
          DateTime.parse('2026-12-01T00:00:00Z'));
    });

    test('どちらも無いならnull', () {
      expect(freeCustomerInfo.trialDeadlineDate(user: const User()), isNull);
    });
  });

  group('#trialComparisonDate', () {
    test('requestDate が端末の時刻より後 (端末の時計を戻した) なら requestDate', () {
      final customerInfo =
          fakeCustomerInfo(requestDate: '2026-11-28T00:00:00Z');
      expect(customerInfo.trialComparisonDate,
          DateTime.parse('2026-11-28T00:00:00Z').toLocal());
    });

    test('requestDate が端末の時刻より前なら端末の時刻', () {
      final customerInfo =
          fakeCustomerInfo(requestDate: '2026-11-01T00:00:00Z');
      expect(customerInfo.trialComparisonDate,
          DateTime.parse('2026-11-07T12:00:00Z').toLocal());
    });

    test('requestDate を解釈できない (空文字) なら端末の時刻', () {
      expect(freeCustomerInfo.trialComparisonDate,
          DateTime.parse('2026-11-07T12:00:00Z').toLocal());
    });
  });

  group('#isTrial', () {
    group(
        'RevenueCat のサーバーが CustomerInfo を返した時刻 (requestDate) が端末の時刻より遅い (端末の時計を戻した)',
        () {
      test('requestDate がトライアルの期限より後ならfalse (時計を戻しても期限を延ばせない)', () {
        final customerInfo = fakeCustomerInfo(
          allExpirationDates: {
            'rc_promo_Premium_custom': '2026-12-01T00:00:00Z'
          },
          requestDate: '2026-12-02T00:00:00Z',
        );
        expect(customerInfo.isTrial(user: const User()), isFalse);
      });

      test('requestDate がトライアルの期限と同じならfalse', () {
        final customerInfo = fakeCustomerInfo(
          allExpirationDates: {
            'rc_promo_Premium_custom': '2026-12-01T00:00:00Z'
          },
          requestDate: '2026-12-01T00:00:00Z',
        );
        expect(customerInfo.isTrial(user: const User()), isFalse);
      });

      test('requestDate がトライアルの期限の1秒前ならtrue', () {
        final customerInfo = fakeCustomerInfo(
          allExpirationDates: {
            'rc_promo_Premium_custom': '2026-12-01T00:00:00Z'
          },
          requestDate: '2026-11-30T23:59:59Z',
        );
        expect(customerInfo.isTrial(user: const User()), isTrue);
      });

      test(
          'Promotional Entitlement が無い既存ユーザーも、requestDate が users の期限より後ならfalse',
          () {
        final customerInfo =
            fakeCustomerInfo(requestDate: '2026-12-02T00:00:00Z');
        final user =
            User(trialDeadlineDate: DateTime.parse('2026-12-01T00:00:00Z'));
        expect(customerInfo.isTrial(user: user), isFalse);
      });
    });

    test('requestDate が端末の時刻より前なら端末の時刻で判定する (期限が端末の時刻より後ならtrue)', () {
      final customerInfo = fakeCustomerInfo(
        allExpirationDates: {'rc_promo_Premium_custom': '2026-12-01T00:00:00Z'},
        requestDate: '2026-11-01T00:00:00Z',
      );
      expect(customerInfo.isTrial(user: const User()), isTrue);
    });

    test('requestDate が端末の時刻より前で、期限が端末の時刻より前ならfalse', () {
      final customerInfo = fakeCustomerInfo(
        allExpirationDates: {'rc_promo_Premium_custom': '2026-11-05T00:00:00Z'},
        requestDate: '2026-11-01T00:00:00Z',
      );
      expect(customerInfo.isTrial(user: const User()), isFalse);
    });

    group('Promotional Entitlement のトライアル', () {
      test('期限が現在時刻の1秒後ならtrue', () {
        final customerInfo = fakeCustomerInfo(allExpirationDates: {
          'rc_promo_Premium_custom': '2026-11-07T12:00:01Z'
        });
        expect(customerInfo.isTrial(user: const User()), isTrue);
      });

      test('期限が現在時刻と同じならfalse', () {
        final customerInfo = fakeCustomerInfo(allExpirationDates: {
          'rc_promo_Premium_custom': '2026-11-07T12:00:00Z'
        });
        expect(customerInfo.isTrial(user: const User()), isFalse);
      });

      test('期限が過ぎていて users に未来の期限があっても、Promotional Entitlement の期限を優先してfalse',
          () {
        final customerInfo = fakeCustomerInfo(allExpirationDates: {
          'rc_promo_Premium_custom': '2026-11-01T00:00:00Z'
        });
        final user =
            User(trialDeadlineDate: DateTime.parse('2027-01-01T00:00:00Z'));
        expect(customerInfo.isTrial(user: user), isFalse);
      });
    });

    group('Promotional Entitlement が無い既存ユーザー', () {
      test('users の期限が未来ならtrue', () {
        final user =
            User(trialDeadlineDate: DateTime.parse('2026-11-08T00:00:00Z'));
        expect(freeCustomerInfo.isTrial(user: user), isTrue);
      });

      test('users の期限が過去ならfalse', () {
        final user =
            User(trialDeadlineDate: DateTime.parse('2026-11-06T00:00:00Z'));
        expect(freeCustomerInfo.isTrial(user: user), isFalse);
      });
    });

    test('トライアルを始めていないならfalse', () {
      expect(freeCustomerInfo.isTrial(user: const User()), isFalse);
    });
  });

  group('#premiumOrTrial', () {
    test('課金中ならtrue', () {
      expect(premiumCustomerInfo.premiumOrTrial(user: const User()), isTrue);
    });

    test('Promotional Entitlement のトライアル中ならtrue', () {
      final customerInfo = fakeCustomerInfo(allExpirationDates: {
        'rc_promo_Premium_custom': '2026-12-01T00:00:00Z'
      });
      expect(customerInfo.premiumOrTrial(user: const User()), isTrue);
    });

    test('Promotional Entitlement が無い既存ユーザーが users の期限内ならtrue', () {
      final user =
          User(trialDeadlineDate: DateTime.parse('2026-12-01T00:00:00Z'));
      expect(freeCustomerInfo.premiumOrTrial(user: user), isTrue);
    });

    test('課金もトライアルも無いならfalse', () {
      expect(freeCustomerInfo.premiumOrTrial(user: const User()), isFalse);
    });

    test('トライアルが終わって課金していないならfalse', () {
      final customerInfo = fakeCustomerInfo(allExpirationDates: {
        'rc_promo_Premium_custom': '2026-11-01T00:00:00Z'
      });
      expect(customerInfo.premiumOrTrial(user: const User()), isFalse);
    });
  });

  group('#trialIsAlreadyBegin', () {
    test('Promotional Entitlement が付与されていればtrue (期限切れを含む)', () {
      final customerInfo = fakeCustomerInfo(allExpirationDates: {
        'rc_promo_Premium_custom': '2026-11-01T00:00:00Z'
      });
      expect(customerInfo.trialIsAlreadyBegin(user: const User()), isTrue);
    });

    test('Promotional Entitlement が無くても users にトライアル開始日があればtrue', () {
      final user = User(beginTrialDate: DateTime.parse('2026-09-01T00:00:00Z'));
      expect(freeCustomerInfo.trialIsAlreadyBegin(user: user), isTrue);
    });

    test('課金中でもトライアルを始めていなければfalse', () {
      expect(
          premiumCustomerInfo.trialIsAlreadyBegin(user: const User()), isFalse);
    });

    test('どちらも無いならfalse', () {
      expect(freeCustomerInfo.trialIsAlreadyBegin(user: const User()), isFalse);
    });
  });

  group('#discountEntitlementDeadlineDate', () {
    test('Promotional Entitlement があればその期限の discountEntitlementOffsetDay 日後',
        () {
      final customerInfo = fakeCustomerInfo(allExpirationDates: {
        'rc_promo_Premium_custom': '2026-12-01T00:00:00Z'
      });
      expect(
        customerInfo.discountEntitlementDeadlineDate(
            user: const User(), discountEntitlementOffsetDay: 2),
        DateTime.parse('2026-12-01T00:00:00Z').toLocal().addDays(2),
      );
    });

    test('月をまたいで discountEntitlementOffsetDay 日後になる', () {
      final customerInfo = fakeCustomerInfo(allExpirationDates: {
        'rc_promo_Premium_custom': '2026-11-30T03:00:00Z'
      });
      expect(
        customerInfo.discountEntitlementDeadlineDate(
            user: const User(), discountEntitlementOffsetDay: 2),
        DateTime.parse('2026-11-30T03:00:00Z').toLocal().addDays(2),
      );
    });

    test('年をまたいで discountEntitlementOffsetDay 日後になる', () {
      final customerInfo = fakeCustomerInfo(allExpirationDates: {
        'rc_promo_Premium_custom': '2026-12-31T03:00:00Z'
      });
      expect(
        customerInfo.discountEntitlementDeadlineDate(
            user: const User(), discountEntitlementOffsetDay: 2),
        DateTime.parse('2026-12-31T03:00:00Z').toLocal().addDays(2),
      );
    });

    test('Promotional Entitlement が無い既存ユーザーは users の割引期限を使う', () {
      final user = User(
          discountEntitlementDeadlineDate:
              DateTime.parse('2026-12-03T00:00:00Z'));
      expect(
        freeCustomerInfo.discountEntitlementDeadlineDate(
            user: user, discountEntitlementOffsetDay: 2),
        DateTime.parse('2026-12-03T00:00:00Z'),
      );
    });

    test('トライアルを始めていないならnull', () {
      expect(
          freeCustomerInfo.discountEntitlementDeadlineDate(
              user: const User(), discountEntitlementOffsetDay: 2),
          isNull);
    });
  });

  group('#hasDiscountEntitlement', () {
    test('割引期限が決まっていない (トライアル前) ならtrue', () {
      expect(
          freeCustomerInfo.hasDiscountEntitlement(
              user: const User(), discountEntitlementOffsetDay: 2),
          isTrue);
    });

    test('トライアル終了から discountEntitlementOffsetDay 日以内ならtrue', () {
      final customerInfo = fakeCustomerInfo(allExpirationDates: {
        'rc_promo_Premium_custom': '2026-11-06T12:00:00Z'
      });
      expect(
          customerInfo.hasDiscountEntitlement(
              user: const User(), discountEntitlementOffsetDay: 2),
          isTrue);
    });

    test('トライアル終了から discountEntitlementOffsetDay 日を過ぎたらfalse', () {
      final customerInfo = fakeCustomerInfo(allExpirationDates: {
        'rc_promo_Premium_custom': '2026-11-04T12:00:00Z'
      });
      expect(
          customerInfo.hasDiscountEntitlement(
              user: const User(), discountEntitlementOffsetDay: 2),
          isFalse);
    });

    test('割引期限が現在時刻と同じならfalse', () {
      final customerInfo = fakeCustomerInfo(allExpirationDates: {
        'rc_promo_Premium_custom': '2026-11-05T12:00:00Z'
      });
      expect(
          customerInfo.hasDiscountEntitlement(
              user: const User(), discountEntitlementOffsetDay: 2),
          isFalse);
    });

    test('Promotional Entitlement が無い既存ユーザーは users の割引期限が過ぎていたらfalse', () {
      final user = User(
          discountEntitlementDeadlineDate:
              DateTime.parse('2026-11-01T00:00:00Z'));
      expect(
          freeCustomerInfo.hasDiscountEntitlement(
              user: user, discountEntitlementOffsetDay: 2),
          isFalse);
    });
  });

  group('#fetchCustomerInfoOutsideUI', () {
    const purchasesChannel = MethodChannel('purchases_flutter');

    test('SDK が別のユーザーで設定済みなら、uid のユーザーに logIn してその CustomerInfo を返す', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(purchasesChannel, (call) async {
        calls.add(call);
        return switch (call.method) {
          'isConfigured' => true,
          'getAppUserID' => 'previous_user',
          'logIn' => {
              'customerInfo': _customerInfoJson(
                  appUserID: (call.arguments as Map)['appUserID'] as String),
              'created': false,
            },
          'getCustomerInfo' => _customerInfoJson(appUserID: 'previous_user'),
          _ => null,
        };
      });
      addTearDown(() => TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger
          .setMockMethodCallHandler(purchasesChannel, null));

      final customerInfo =
          await fetchCustomerInfoOutsideUI(uid: 'current_user');

      expect(customerInfo.originalAppUserId, 'current_user');
      expect(
          calls.map((call) => call.method), isNot(contains('getCustomerInfo')));
    });

    test('SDK が同じユーザーで設定済みなら、logIn せずに CustomerInfo を返す', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(purchasesChannel, (call) async {
        calls.add(call);
        return switch (call.method) {
          'isConfigured' => true,
          'getAppUserID' => 'current_user',
          'getCustomerInfo' => _customerInfoJson(appUserID: 'current_user'),
          _ => null,
        };
      });
      addTearDown(() => TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger
          .setMockMethodCallHandler(purchasesChannel, null));

      final customerInfo =
          await fetchCustomerInfoOutsideUI(uid: 'current_user');

      expect(customerInfo.originalAppUserId, 'current_user');
      expect(calls.map((call) => call.method), isNot(contains('logIn')));
    });
  });
}
