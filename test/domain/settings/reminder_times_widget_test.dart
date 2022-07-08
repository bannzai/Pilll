import 'package:pilll/domain/settings/setting_page_state.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/domain/settings/reminder_times_page.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/fake.dart';
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
    testWidgets(
        'when setting has one reminder times. one reminder times mean requires minimum count',
        (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

      final state = SettingState(
        setting: const Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 2,
          isOnReminder: false,
          timezoneDatabaseName: null,
          pillSheetTypes: [PillSheetType.pillsheet_21],
          reminderTimes: [
            ReminderTime(hour: 10, minute: 0),
          ],
        ),
        premiumAndTrial: FakePremiumAndTrial(),
        latestPillSheetGroup: PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [PillSheet.create(PillSheetType.pillsheet_21)],
            createdAt: now()),
        isHealthDataAvailable: false,
        userIsUpdatedFrom132: false,
        deviceTimezoneName: "Asia/Tokyo",
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingStateProvider.overrideWithValue(AsyncValue.data(state)),
          ],
          child: MaterialApp(
              home: ReminderTimesPage(store: MockSettingStateNotifier())),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text("通知時間の追加"), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is Dismissible),
          findsNothing);
    });
    testWidgets('when setting has maximum count reminder times︎',
        (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

      final state = SettingState(
        setting: const Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 2,
          isOnReminder: false,
          timezoneDatabaseName: null,
          pillSheetTypes: [PillSheetType.pillsheet_21],
          reminderTimes: [
            ReminderTime(hour: 10, minute: 0),
            ReminderTime(hour: 11, minute: 0),
            ReminderTime(hour: 12, minute: 0)
          ],
        ),
        premiumAndTrial: FakePremiumAndTrial(),
        latestPillSheetGroup: PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [PillSheet.create(PillSheetType.pillsheet_21)],
            createdAt: now()),
        isHealthDataAvailable: false,
        userIsUpdatedFrom132: false,
        deviceTimezoneName: "Asia/Tokyo",
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingStateProvider.overrideWithValue(AsyncValue.data(state)),
          ],
          child: MaterialApp(
              home: ReminderTimesPage(store: MockSettingStateNotifier())),
        ),
      );

      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text("通知時間の追加"), findsNothing);
      expect(find.byWidgetPredicate((widget) => widget is Dismissible),
          findsNWidgets(3));
    });
  });
}
