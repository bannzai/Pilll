import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/settings/components/rows/notification_in_rest_duration.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/local_notification.dart';

import '../../../../helper/fake.dart';
import '../../../../helper/mock.mocks.dart';

/// 通知の再登録が呼ばれた回数を記録する RegisterReminderLocalNotification
class _FakeRegisterReminderLocalNotification extends Fake
    implements RegisterReminderLocalNotification {
  /// 通知の再登録が呼ばれた回数。スイッチの切り替えで再登録が 1 回だけ行われることの検証に使う
  int callCount = 0;

  /// 通知を登録せず、呼ばれた回数だけを数える
  @override
  Future<void> call() async {
    callCount += 1;
  }
}

/// ひらがな・カタカナ・漢字のいずれかを含むか。日本語以外の表示言語で日本語が混ざっていないかの検証に使う
final _japaneseCharacterPattern = RegExp(r'[぀-ヿ一-鿿]');

/// スペイン語で休薬期間の通知を ON にした時の案内。app_es.arb の notificationForNotTakenPeriodChanged に descanso と ON を入れた文
const _esChangedDescansoOn =
    'Las notificaciones para el período de descanso se han configurado en ON';

/// スペイン語でプラセボ期間の通知を OFF にした時の案内。app_es.arb の notificationForNotTakenPeriodChanged に placebo と OFF を入れた文
const _esChangedPlaceboOff =
    'Las notificaciones para el período de placebo se han configurado en OFF';

void main() {
  setUp(() {
    analytics = FakeAnalytics();
  });

  group('#NotificationInRestDuration', () {
    /// pillSheetType のピルシートと setting を渡した NotificationInRestDuration を返す。
    /// 設定の保存と通知の再登録は、受け取った setSetting と registerReminderLocalNotification に差し替える
    Widget subject({
      required PillSheetType pillSheetType,
      required Setting setting,
      required MockSetSetting setSetting,
      required _FakeRegisterReminderLocalNotification
          registerReminderLocalNotification,
    }) {
      return ProviderScope(
        overrides: [
          setSettingProvider.overrideWith((ref) => setSetting),
          registerReminderLocalNotificationProvider
              .overrideWith((ref) => registerReminderLocalNotification),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: NotificationInRestDuration(
              pillSheet: PillSheet.v1(
                id: 'pill_sheet_id',
                typeInfo: pillSheetType.typeInfo,
                beginDate: DateTime(2020, 9, 1),
                lastTakenDate: null,
                createdAt: DateTime(2020, 9, 1),
              ),
              setting: setting,
            ),
          ),
        ),
      );
    }

    /// 各テストで isOnNotifyInNotTakenDuration だけを copyWith で変えて使う設定。他の値はこの行の表示に影響しない
    const setting = Setting(
      pillNumberForFromMenstruation: 0,
      durationMenstruation: 0,
      isOnReminder: true,
      timezoneDatabaseName: 'Asia/Tokyo',
    );

    /// 表示言語を切り替え、テスト終了時に L.dart の初期値の ja に戻す
    void useLocale(Locale locale) {
      L = lookupAppLocalizations(locale);
      addTearDown(() => L = lookupAppLocalizations(const Locale('ja')));
    }

    group('表示言語が日本語', () {
      testWidgets('休薬のあるピルシートでは設定名が休薬期間の通知になり、OFFからONにすると休薬期間の案内が出て通知が再登録される',
          (tester) async {
        useLocale(const Locale('ja'));
        final setSetting = MockSetSetting();
        when(setSetting(any)).thenAnswer((_) async {});
        final registerReminderLocalNotification =
            _FakeRegisterReminderLocalNotification();
        await tester.pumpWidget(subject(
          pillSheetType: PillSheetType.pillsheet_21,
          setting: setting.copyWith(isOnNotifyInNotTakenDuration: false),
          setSetting: setSetting,
          registerReminderLocalNotification: registerReminderLocalNotification,
        ));

        expect(find.text('休薬期間の通知'), findsOneWidget);

        // 案内の SnackBar はスイッチを切り替えた後にしか表示されないため、タップして検証する
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        expect(find.text('休薬期間の通知をONにしました'), findsOneWidget);
        verify(setSetting(setting.copyWith(isOnNotifyInNotTakenDuration: true)))
            .called(1);
        expect(registerReminderLocalNotification.callCount, 1);
      });

      testWidgets('プラセボのあるピルシートでは設定名が偽薬期間の通知になり、ONからOFFにすると偽薬期間の案内が出る',
          (tester) async {
        useLocale(const Locale('ja'));
        final setSetting = MockSetSetting();
        when(setSetting(any)).thenAnswer((_) async {});
        await tester.pumpWidget(subject(
          pillSheetType: PillSheetType.pillsheet_28_4,
          setting: setting.copyWith(isOnNotifyInNotTakenDuration: true),
          setSetting: setSetting,
          registerReminderLocalNotification:
              _FakeRegisterReminderLocalNotification(),
        ));

        expect(find.text('偽薬期間の通知'), findsOneWidget);

        // 案内の SnackBar はスイッチを切り替えた後にしか表示されないため、タップして検証する
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        expect(find.text('偽薬期間の通知をOFFにしました'), findsOneWidget);
      });
    });

    group('表示言語がスペイン語', () {
      testWidgets('休薬のあるピルシートでは設定名と案内がスペイン語の休薬の名称で表示され、日本語が混ざらない',
          (tester) async {
        useLocale(const Locale('es'));
        final setSetting = MockSetSetting();
        when(setSetting(any)).thenAnswer((_) async {});
        await tester.pumpWidget(subject(
          pillSheetType: PillSheetType.pillsheet_21,
          setting: setting.copyWith(isOnNotifyInNotTakenDuration: false),
          setSetting: setSetting,
          registerReminderLocalNotification:
              _FakeRegisterReminderLocalNotification(),
        ));

        expect(
            find.text('Notificación del período de descanso'), findsOneWidget);

        // 案内の SnackBar はスイッチを切り替えた後にしか表示されないため、タップして検証する
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        expect(find.text(_esChangedDescansoOn), findsOneWidget);
        expect(
          tester
              .widgetList<Text>(find.byType(Text))
              .where((text) => _japaneseCharacterPattern.hasMatch(text.data!)),
          isEmpty,
        );
      });

      testWidgets('プラセボのあるピルシートでは設定名と案内がスペイン語のプラセボの名称で表示され、日本語が混ざらない',
          (tester) async {
        useLocale(const Locale('es'));
        final setSetting = MockSetSetting();
        when(setSetting(any)).thenAnswer((_) async {});
        await tester.pumpWidget(subject(
          pillSheetType: PillSheetType.pillsheet_28_4,
          setting: setting.copyWith(isOnNotifyInNotTakenDuration: true),
          setSetting: setSetting,
          registerReminderLocalNotification:
              _FakeRegisterReminderLocalNotification(),
        ));

        expect(
            find.text('Notificación del período de placebo'), findsOneWidget);

        // 案内の SnackBar はスイッチを切り替えた後にしか表示されないため、タップして検証する
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        expect(find.text(_esChangedPlaceboOff), findsOneWidget);
        expect(
          tester
              .widgetList<Text>(find.byType(Text))
              .where((text) => _japaneseCharacterPattern.hasMatch(text.data!)),
          isEmpty,
        );
      });
    });
  });
}
