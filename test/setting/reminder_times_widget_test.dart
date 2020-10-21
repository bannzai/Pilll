import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/settings/list/reminder_times.dart';
import 'package:Pilll/state/setting.dart';
import 'package:Pilll/store/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/all.dart';

void main() {
  setUp(() {
    WidgetsBinding.instance.renderView.configuration =
        new TestViewConfiguration(size: const Size(375.0, 667.0));
  });
  group("appearance widgets dependend on reminderTimes", () {
    testWidgets('when setting has one reminder times︎',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        final store = SettingStateStore(null);
        // ignore: invalid_use_of_protected_member
        store.state = SettingState(
          entity: Setting(
            fromMenstruation: 1,
            durationMenstruation: 2,
            isOnReminder: false,
            pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
            reminderTimes: [ReminderTime(hour: 10, minute: 0)],
          ),
        );
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
        expect(find.text("通知時間の追加"), findsOneWidget);
      });
    });
  });
}
