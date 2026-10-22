import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/features/initial_setting/yaz_flex_rest_duration/page.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/mock.mocks.dart';
import '../../../helper/supported_device.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;

    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));
  });

  // 初期設定の状態を [input] で用意した InitialSettingStateNotifier を返す
  InitialSettingStateNotifier initialSettingStateNotifier({
    required void Function(InitialSettingStateNotifier store) input,
  }) {
    final store = InitialSettingStateNotifier(
      MockEndInitialSetting(),
      MockBatchFactory(),
      MockBatchSetSetting(),
      MockBatchSetPillSheetModifiedHistory(),
      MockBatchSetPillSheetGroup(),
      RemoteConfigParameter(),
      MockRegisterReminderLocalNotificationRunner(),
      DateTime.parse("2022-03-02"),
    );
    input(store);
    return store;
  }

  group("#InitialSettingYazFlexRestDurationPage", () {
    testWidgets("「休薬はまだしていない」を選んでいる場合は休薬の日付の入力欄が表示されない", (
      WidgetTester tester,
    ) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            initialSettingStateNotifierProvider.overrideWith(
              (ref) => initialSettingStateNotifier(
                input: (store) {
                  store.selectYazFlex();
                  store.setTodayPillNumber(
                      pageIndex: 1, pillNumberInPillSheet: 2);
                  store.setYazFlexHasNotRestedYet(yazFlexHasNotRestedYet: true);
                },
              ),
            ),
          ],
          child: const MaterialApp(
            home: InitialSettingYazFlexRestDurationPage(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.byType(YazFlexRestDurationDateRow), findsNothing);
      expect(
        tester.widget<Checkbox>(find.byType(Checkbox)).value,
        true,
      );
      // 休薬の日付が無くても次へ進める
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets("「休薬はまだしていない」を選んでいない場合は休薬の開始日と終了日の入力欄が表示される", (
      WidgetTester tester,
    ) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            initialSettingStateNotifierProvider.overrideWith(
              (ref) => initialSettingStateNotifier(
                input: (store) {
                  store.selectYazFlex();
                  store.setTodayPillNumber(
                      pageIndex: 1, pillNumberInPillSheet: 2);
                },
              ),
            ),
          ],
          child: const MaterialApp(
            home: InitialSettingYazFlexRestDurationPage(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.byType(YazFlexRestDurationDateRow), findsNWidgets(2));
      // 休薬の日付が未入力の間は次へ進めない
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNull,
      );
    });

    testWidgets("休薬の開始日と終了日を入力済みの場合は次へ進める", (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            initialSettingStateNotifierProvider.overrideWith(
              (ref) => initialSettingStateNotifier(
                input: (store) {
                  store.selectYazFlex();
                  store.setTodayPillNumber(
                      pageIndex: 1, pillNumberInPillSheet: 2);
                  store.setYazFlexLastRestDurationBeginDate(
                    yazFlexLastRestDurationBeginDate:
                        DateTime.parse("2022-02-13"),
                  );
                  store.setYazFlexLastRestDurationEndDate(
                    yazFlexLastRestDurationEndDate:
                        DateTime.parse("2022-02-17"),
                  );
                },
              ),
            ),
          ],
          child: const MaterialApp(
            home: InitialSettingYazFlexRestDurationPage(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.byType(YazFlexRestDurationDateRow), findsNWidgets(2));
      expect(
        tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
        isNotNull,
      );
    });
  });
}
