import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/settings/reminder_times_page.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';
import '../../helper/supported_device.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
  });
  group("appearance widgets dependend on reminderTimes", () {
    testWidgets('when setting has one reminder times. one reminder times mean requires minimum count', (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

      const setting = Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 2,
        isOnReminder: false,
        timezoneDatabaseName: null,
        pillSheetTypeInfos: [PillSheetType.pillsheet_21],
        reminderTimes: [
          ReminderTime(hour: 10, minute: 0),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingProvider.overrideWith((ref) => Stream.value(setting)),
            setSettingProvider.overrideWith((ref) => MockSetSetting()),
          ],
          child: const MaterialApp(home: ReminderTimesPage()),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text("通知時間の追加"), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is Dismissible), findsNothing);
    });
    testWidgets('when setting has maximum count reminder times︎', (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

      const setting = Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 2,
        isOnReminder: false,
        timezoneDatabaseName: null,
        pillSheetTypeInfos: [PillSheetType.pillsheet_21],
        reminderTimes: [ReminderTime(hour: 10, minute: 0), ReminderTime(hour: 11, minute: 0), ReminderTime(hour: 12, minute: 0)],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingProvider.overrideWith((ref) => Stream.value(setting)),
            setSettingProvider.overrideWith((ref) => MockSetSetting()),
          ],
          child: const MaterialApp(home: ReminderTimesPage()),
        ),
      );

      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text("通知時間の追加"), findsNothing);
      expect(find.byWidgetPredicate((widget) => widget is Dismissible), findsNWidgets(3));
    });
  });
}
