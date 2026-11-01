import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/reminder_notification_customize_word/page.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/environment.dart';

import '../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Environment.isTest = true;
  });

  group('#ReminderNotificationCustomizeWordPage', () {
    testWidgets('翻訳の画面比較の撮影フローが表示を待つ identifier を持つ', (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          settingProvider.overrideWith(
            (ref) => Stream.value(
              const Setting(
                pillNumberForFromMenstruation: 22,
                durationMenstruation: 2,
                isOnReminder: true,
                timezoneDatabaseName: null,
                pillSheetTypes: [PillSheetType.pillsheet_21],
                reminderTimes: [ReminderTime(hour: 10, minute: 0)],
              ),
            ),
          ),
          setSettingProvider.overrideWith((ref) => MockSetSetting()),
        ],
      );
      addTearDown(container.dispose);
      // 画面は settingProvider を requireValue で読むため、読み込みを終えてから表示する
      container.listen(settingProvider, (_, __) {});
      await container.read(settingProvider.future);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: ReminderNotificationCustomizeWordPage()),
        ),
      );
      await tester.pump();

      expect(find.bySemanticsIdentifier('reminder_notification_customize_word_page_body'), findsOneWidget);
    });
  });
}
