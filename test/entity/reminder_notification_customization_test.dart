import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/reminder_notification_customization.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/l10n/app_localizations.dart';

void main() {
  void useLanguage(String lang) {
    final originalL = L;
    addTearDown(() => L = originalL);
    L = lookupAppLocalizations(Locale(lang));
  }

  group('#resolvedMissedTakenMessage', () {
    test('未設定 (既定値) で日本語の時、日本語の既定文言を返す', () {
      useLanguage('ja');
      expect(
        const ReminderNotificationCustomization().resolvedMissedTakenMessage,
        '飲み忘れていませんか？\n服用記録がない日が複数あります🤔',
      );
    });

    test('未設定 (既定値) で英語の時、英語の既定文言を返す', () {
      useLanguage('en');
      expect(
        const ReminderNotificationCustomization().resolvedMissedTakenMessage,
        "Haven't taken your pill yet?\nThere are a few days with no pill log 🤔",
      );
    });

    test('Firestore に missedTakenMessage が無いドキュメントを読んだ時、端末の言語の既定文言を返す', () {
      useLanguage('de');
      expect(
        ReminderNotificationCustomization.fromJson(const {'version': 'v2'}).resolvedMissedTakenMessage,
        'Hast du deine Pille schon genommen?\nFür mehrere Tage fehlt ein Einnahmeprotokoll 🤔',
      );
    });

    test('保存済みの値がある時、端末の言語によらずその値を返す', () {
      useLanguage('en');
      expect(
        const ReminderNotificationCustomization(missedTakenMessage: '飲み忘れていませんか？\n服用記録がない日が複数あります🤔').resolvedMissedTakenMessage,
        '飲み忘れていませんか？\n服用記録がない日が複数あります🤔',
      );
      expect(
        const ReminderNotificationCustomization(missedTakenMessage: 'カスタム').resolvedMissedTakenMessage,
        'カスタム',
      );
    });
  });
}
