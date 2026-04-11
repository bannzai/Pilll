import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/feature_appeal/reminder_notification_customize_word/reminder_notification_customize_word_help_page.dart';
import 'package:pilll/features/localizations/l.dart';

void main() {
  group('#ReminderNotificationCustomizeWordHelpPage', () {
    testWidgets('ヘッドライン文言が表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ReminderNotificationCustomizeWordHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.text(L.reminderNotificationCustomizeWordFeatureAppealHeadline), findsOneWidget);
    });

    testWidgets('本文が表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ReminderNotificationCustomizeWordHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.text(L.reminderNotificationCustomizeWordFeatureAppealBody), findsOneWidget);
    });

    testWidgets('「実際に試す」ボタン (PrimaryButton) が表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ReminderNotificationCustomizeWordHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text(L.featureAppealTryFeature), findsOneWidget);
    });

    testWidgets('AppBar にタイトルが表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ReminderNotificationCustomizeWordHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.text(L.reminderNotificationCustomizeWordFeatureAppealTitle), findsOneWidget);
    });
  });
}
