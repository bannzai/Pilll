import 'package:Pilll/entity/pill_sheet_type.dart';
import 'package:Pilll/entity/setting.dart';
import 'package:Pilll/settings/reminder_times.dart';
import 'package:Pilll/store/setting.dart';
import 'package:Pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';

import '../helper/mock.dart';
import '../helper/supported_device.dart';

void main() {
  setUp(() {
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
  });
  group("appearance widgets dependend on reminderTimes", () {
    testWidgets(
        'when setting has one reminder times. one reminder times mean requires minimum count',
        (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

      final service = MockSettingService();
      final entity = Setting(
        fromMenstruation: 1,
        durationMenstruation: 2,
        isOnReminder: false,
        pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
        reminderTimes: [
          ReminderTime(hour: 10, minute: 0),
        ],
      );
      when(service.fetch())
          .thenAnswer((realInvocation) => Future.value(entity));
      when(service.subscribe())
          .thenAnswer((realInvocation) => Stream.value(entity));

      final store = SettingStateStore(service);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingStoreProvider.overrideWithProvider(
              Provider(
                (ref) => store,
              ),
            )
          ],
          child: MaterialApp(home: ReminderTimes()),
        ),
      );
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      expect(find.text("通知時間の追加"), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => Widget is Dismissible),
          findsNothing);
    });
    testWidgets('when setting has maximum count reminder times︎',
        (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

      final service = MockSettingService();
      final entity = Setting(
        fromMenstruation: 1,
        durationMenstruation: 2,
        isOnReminder: false,
        pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
        reminderTimes: [
          ReminderTime(hour: 10, minute: 0),
          ReminderTime(hour: 11, minute: 0),
          ReminderTime(hour: 12, minute: 0)
        ],
      );
      when(service.fetch())
          .thenAnswer((realInvocation) => Future.value(entity));
      when(service.subscribe())
          .thenAnswer((realInvocation) => Stream.value(entity));
      final store = SettingStateStore(service);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingStoreProvider.overrideWithProvider(
              Provider(
                (ref) => store,
              ),
            )
          ],
          child: MaterialApp(home: ReminderTimes()),
        ),
      );
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      expect(find.text("通知時間の追加"), findsNothing);
      expect(find.byWidgetPredicate((widget) => widget is Dismissible),
          findsNWidgets(3));
    });
  });
}
