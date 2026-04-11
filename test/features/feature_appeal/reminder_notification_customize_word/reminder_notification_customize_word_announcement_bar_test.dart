import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/feature_appeal/reminder_notification_customize_word/reminder_notification_customize_word_announcement_bar.dart';
import 'package:pilll/features/localizations/l.dart';

void main() {
  group('#ReminderNotificationCustomizeWordAnnouncementBar', () {
    testWidgets('isClosed=false の状態でタイトル文言が表示される', (tester) async {
      final isClosed = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ReminderNotificationCustomizeWordAnnouncementBar(isClosed: isClosed),
          ),
        ),
      );

      expect(find.text(L.reminderNotificationCustomizeWordFeatureAppealTitle), findsOneWidget);
    });

    testWidgets('isClosed=false の状態で短い説明文が表示される', (tester) async {
      final isClosed = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ReminderNotificationCustomizeWordAnnouncementBar(isClosed: isClosed),
          ),
        ),
      );

      expect(find.text(L.reminderNotificationCustomizeWordFeatureAppealShortDescription), findsOneWidget);
    });

    testWidgets('isClosed=false の状態で × ボタン (Icons.close) が表示される', (tester) async {
      final isClosed = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ReminderNotificationCustomizeWordAnnouncementBar(isClosed: isClosed),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('isClosed=false の状態で右矢印 SVG が表示される', (tester) async {
      final isClosed = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ReminderNotificationCustomizeWordAnnouncementBar(isClosed: isClosed),
          ),
        ),
      );

      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });
}
