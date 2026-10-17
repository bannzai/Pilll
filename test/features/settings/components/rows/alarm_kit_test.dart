import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/features/settings/components/rows/alarm_kit.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/alarm_kit_service.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../helper/fake.dart';
import '../../../../helper/mock.mocks.dart';

/// 通知の再登録が呼ばれた回数を記録する RegisterReminderLocalNotification
class _FakeRegisterReminderLocalNotification extends Fake
    implements RegisterReminderLocalNotification {
  int callCount = 0;

  @override
  Future<void> call() async {
    callCount += 1;
  }
}

void main() {
  setUp(() {
    analytics = FakeAnalytics();
  });

  group('#AlarmKitSetting', () {
    Widget subject({
      required Setting setting,
      required bool isPremium,
      required bool isTrial,
      required bool isAlarmKitAvailable,
      required MockSetSetting setSetting,
      required _FakeRegisterReminderLocalNotification
          registerReminderLocalNotification,
    }) {
      // showModalBottomSheet のルートからも Provider を参照できるよう、ProviderScope を MaterialApp の外に置く
      return ProviderScope(
        overrides: [
          isAlarmKitAvailableProvider
              .overrideWith((ref) => isAlarmKitAvailable),
          setSettingProvider.overrideWith((ref) => setSetting),
          registerReminderLocalNotificationProvider
              .overrideWith((ref) => registerReminderLocalNotification),
          // プレミアム紹介シートは読み込み中の表示のままにして、RevenueCat に触れないようにする
          purchaseOfferingsProvider
              .overrideWith((ref) => Completer<Offerings>().future),
          userProvider
              .overrideWith((ref) => Stream.value(User(isPremium: isPremium))),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: AlarmKitSetting(
                setting: setting, isPremium: isPremium, isTrial: isTrial),
          ),
        ),
      );
    }

    const setting = Setting(
      pillNumberForFromMenstruation: 0,
      durationMenstruation: 0,
      isOnReminder: true,
      timezoneDatabaseName: 'Asia/Tokyo',
      useAlarmKit: false,
    );

    testWidgets(
        '無料ユーザーがスイッチをタップするとアラーム機能の行の PaywallSource でプレミアム紹介シートが開き、設定は更新されない',
        (tester) async {
      final setSetting = MockSetSetting();
      final registerReminderLocalNotification =
          _FakeRegisterReminderLocalNotification();
      await tester.pumpWidget(subject(
        setting: setting,
        isPremium: false,
        isTrial: false,
        isAlarmKitAvailable: true,
        setSetting: setSetting,
        registerReminderLocalNotification: registerReminderLocalNotification,
      ));

      await tester.tap(find.byType(Switch));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(PremiumIntroductionSheet), findsOneWidget);
      expect(
          tester
              .widget<PremiumIntroductionSheet>(
                  find.byType(PremiumIntroductionSheet))
              .source,
          PaywallSource.settingsAlarmKitRow);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
      verifyNever(setSetting(any));
      expect(registerReminderLocalNotification.callCount, 0);
    });

    testWidgets(
        'トライアル中のユーザーがOFFのスイッチをタップするとOSのアラーム権限を求め、拒否されるとスナックバーが表示されプレミアム紹介シートは開かない',
        (tester) async {
      final setSetting = MockSetSetting();
      final registerReminderLocalNotification =
          _FakeRegisterReminderLocalNotification();
      await tester.pumpWidget(subject(
        setting: setting,
        isPremium: false,
        isTrial: true,
        isAlarmKitAvailable: true,
        setSetting: setSetting,
        registerReminderLocalNotification: registerReminderLocalNotification,
      ));

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // テスト環境は iOS ではないため AlarmKitService.requestPermission は false (拒否) を返す
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(PremiumIntroductionSheet), findsNothing);
      verifyNever(setSetting(any));
      expect(registerReminderLocalNotification.callCount, 0);
    });

    testWidgets(
        'プレミアムユーザーがOFFのスイッチをタップするとOSのアラーム権限を求め、拒否されるとスナックバーが表示されプレミアム紹介シートは開かない',
        (tester) async {
      final setSetting = MockSetSetting();
      final registerReminderLocalNotification =
          _FakeRegisterReminderLocalNotification();
      await tester.pumpWidget(subject(
        setting: setting,
        isPremium: true,
        isTrial: false,
        isAlarmKitAvailable: true,
        setSetting: setSetting,
        registerReminderLocalNotification: registerReminderLocalNotification,
      ));

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // テスト環境は iOS ではないため AlarmKitService.requestPermission は false (拒否) を返す
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(PremiumIntroductionSheet), findsNothing);
      verifyNever(setSetting(any));
      expect(registerReminderLocalNotification.callCount, 0);
    });

    testWidgets('プレミアムユーザーがONのスイッチをタップすると設定がOFFに更新され、通知が再登録される',
        (tester) async {
      final setSetting = MockSetSetting();
      when(setSetting(any)).thenAnswer((_) async {});
      final registerReminderLocalNotification =
          _FakeRegisterReminderLocalNotification();
      await tester.pumpWidget(subject(
        setting: setting.copyWith(useAlarmKit: true),
        isPremium: true,
        isTrial: false,
        isAlarmKitAvailable: true,
        setSetting: setSetting,
        registerReminderLocalNotification: registerReminderLocalNotification,
      ));

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      verify(setSetting(setting.copyWith(useAlarmKit: false))).called(1);
      expect(registerReminderLocalNotification.callCount, 1);
      expect(find.byType(PremiumIntroductionSheet), findsNothing);
    });

    testWidgets('AlarmKitが利用できない場合はスイッチが表示されない', (tester) async {
      await tester.pumpWidget(subject(
        setting: setting,
        isPremium: true,
        isTrial: false,
        isAlarmKitAvailable: false,
        setSetting: MockSetSetting(),
        registerReminderLocalNotification:
            _FakeRegisterReminderLocalNotification(),
      ));

      expect(find.byType(Switch), findsNothing);
    });
  });
}
