import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/reminder_notification_customization.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/reminder_notification_customize_word/components/missed_taken_message_text_field.dart';
import 'package:pilll/features/reminder_notification_customize_word/components/preview.dart';
import 'package:pilll/features/reminder_notification_customize_word/page.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/local_notification.dart';

import '../../helper/fake.dart';
import '../../helper/localization.dart';
import '../../helper/mock.mocks.dart';

/// 画面の表示だけを確認するため、通知の登録を行わない RegisterReminderLocalNotification
class _FakeRegisterReminderLocalNotification extends Fake implements RegisterReminderLocalNotification {}

void main() {
  setUp(() {
    analytics = FakeAnalytics();
  });

  /// [reminderNotificationCustomization] を持つ設定で服用通知のカスタマイズ画面を表示する Widget を返す
  ///
  /// 設定の保存と通知の登録は Mock / Fake に差し替えるため、表示の確認だけに使う。
  Widget subject({required ReminderNotificationCustomization reminderNotificationCustomization}) {
    return ProviderScope(
      overrides: [
        settingProvider.overrideWith(
          (ref) => Stream.value(
            Setting(
              pillNumberForFromMenstruation: 0,
              durationMenstruation: 0,
              isOnReminder: true,
              timezoneDatabaseName: 'Asia/Tokyo',
              reminderNotificationCustomization: reminderNotificationCustomization,
            ),
          ),
        ),
        setSettingProvider.overrideWith((ref) => MockSetSetting()),
        registerReminderLocalNotificationProvider.overrideWith((ref) => _FakeRegisterReminderLocalNotification()),
      ],
      // settingProvider の requireValue が値を持ってから画面を組み立てる
      child: MaterialApp(
        home: Consumer(
          builder: (context, ref, _) => ref.watch(settingProvider).hasValue ? const ReminderNotificationCustomizeWordPage() : const SizedBox(),
        ),
      ),
    );
  }

  /// 飲み忘れのプレビュー (2 つ目の ReminderPushNotificationPreview) に表示されている本文
  String missedPreviewMessage(WidgetTester tester) => tester.widgetList<ReminderPushNotificationPreview>(find.byType(ReminderPushNotificationPreview)).last.message;

  /// 飲み忘れの入力欄に入っている文字列
  String missedTextFieldText(WidgetTester tester) => tester
      .widget<TextField>(find.descendant(of: find.byType(MissedTakenMessageTextField), matching: find.byType(TextField)))
      .controller!
      .text;

  group('#ReminderNotificationCustomizeWordPage', () {
    testWidgets('飲み忘れの文言が未設定で英語の時、プレビューと入力欄に英語の既定文言が出る', (tester) async {
      useLanguage('en');
      await tester.pumpWidget(subject(reminderNotificationCustomization: const ReminderNotificationCustomization()));
      await tester.pumpAndSettle();

      const expected = "Haven't taken your pill yet?\nThere are a few days with no pill log 🤔";
      expect(missedPreviewMessage(tester), expected);
      expect(missedTextFieldText(tester), expected);
    });

    testWidgets('飲み忘れの文言が未設定でドイツ語の時、プレビューと入力欄にドイツ語の既定文言が出る', (tester) async {
      useLanguage('de');
      await tester.pumpWidget(subject(reminderNotificationCustomization: const ReminderNotificationCustomization()));
      await tester.pumpAndSettle();

      const expected = 'Hast du deine Pille schon genommen?\nFür mehrere Tage fehlt ein Einnahmeprotokoll 🤔';
      expect(missedPreviewMessage(tester), expected);
      expect(missedTextFieldText(tester), expected);
    });

    testWidgets('飲み忘れの文言が保存済みの時、端末の言語によらずプレビューと入力欄に保存済みの値が出る', (tester) async {
      useLanguage('en');
      await tester.pumpWidget(subject(reminderNotificationCustomization: const ReminderNotificationCustomization(missedTakenMessage: 'カスタム')));
      await tester.pumpAndSettle();

      expect(missedPreviewMessage(tester), 'カスタム');
      expect(missedTextFieldText(tester), 'カスタム');
    });
  });
}
