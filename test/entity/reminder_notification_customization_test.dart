import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/reminder_notification_customization.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/l10n/app_localizations.dart';

void main() {
  group('#missedTakenMessageForDisplay', () {
    group('ロケールが en の場合', () {
      setUp(() {
        L = lookupAppLocalizations(const Locale('en'));
      });
      tearDown(() {
        L = lookupAppLocalizations(const Locale('ja'));
      });

      test('保存値が日本語の既定値のまま (未編集) なら en の既定文言を返す', () {
        const reminderNotificationCustomization =
            ReminderNotificationCustomization();

        expect(
            reminderNotificationCustomization.missedTakenMessageForDisplay,
            isNot(
                reminderNotificationCustomizationJapaneseDefaultMissedTakenMessage));
        expect(
            reminderNotificationCustomization.missedTakenMessageForDisplay,
            lookupAppLocalizations(const Locale('en'))
                .defaultMissedTakenMessage);
      });

      test('Firestore から読んだ保存値が日本語の既定値なら en の既定文言を返す', () {
        final reminderNotificationCustomization =
            ReminderNotificationCustomization.fromJson({
          'missedTakenMessage': '飲み忘れていませんか？\n服用記録がない日が複数あります🤔',
        });

        expect(
            reminderNotificationCustomization.missedTakenMessageForDisplay,
            lookupAppLocalizations(const Locale('en'))
                .defaultMissedTakenMessage);
      });

      test('ユーザーが編集した保存値ならそのまま返す', () {
        const reminderNotificationCustomization =
            ReminderNotificationCustomization(
                missedTakenMessage: 'Take your pill');

        expect(reminderNotificationCustomization.missedTakenMessageForDisplay,
            'Take your pill');
      });

      test('ユーザーが空にした保存値なら空のまま返す', () {
        const reminderNotificationCustomization =
            ReminderNotificationCustomization(missedTakenMessage: '');

        expect(
            reminderNotificationCustomization.missedTakenMessageForDisplay, '');
      });
    });

    group('ロケールが ja の場合', () {
      test('保存値が日本語の既定値のまま (未編集) なら同じ文字列を返す', () {
        const reminderNotificationCustomization =
            ReminderNotificationCustomization();

        expect(reminderNotificationCustomization.missedTakenMessageForDisplay,
            reminderNotificationCustomizationJapaneseDefaultMissedTakenMessage);
      });
    });
  });
}
