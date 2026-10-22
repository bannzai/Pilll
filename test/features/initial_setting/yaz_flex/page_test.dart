import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/features/initial_setting/yaz_flex/page.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/mock.mocks.dart';
import '../../../helper/supported_device.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    Environment.isTest = true;

    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));
  });

  group("#InitialSettingYazFlexPage", () {
    testWidgets("「はい」と「いいえ」の選択肢と、既存アカウントでログインするボタンが表示される",
        (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            initialSettingStateNotifierProvider.overrideWith(
              (ref) => InitialSettingStateNotifier(
                MockEndInitialSetting(),
                MockBatchFactory(),
                MockBatchSetSetting(),
                MockBatchSetPillSheetModifiedHistory(),
                MockBatchSetPillSheetGroup(),
                RemoteConfigParameter(),
                MockRegisterReminderLocalNotificationRunner(),
                DateTime.parse("2022-03-02"),
              ),
            ),
          ],
          child: const MaterialApp(home: InitialSettingYazFlexPage()),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // 「はい」
      expect(find.byType(PrimaryButton), findsOneWidget);
      // 「いいえ」
      expect(find.byType(AppOutlinedButton), findsOneWidget);
      expect(find.byType(AlertButton), findsOneWidget);
    });
  });
}
