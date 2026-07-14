import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/record/components/button/midnight_taken_warning_dialog.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 表示条件を満たす基本形のSettingを生成する
///
/// デフォルト値は「19:00のリマインダー通知がONで設定されている」状態。
/// 深夜0:00-1:59の記録操作に対して通知が未到達になる、ダイアログ表示対象の典型ケースを表す
Setting buildSetting({
  List<ReminderTime> reminderTimes = const [ReminderTime(hour: 19, minute: 0)],
  bool isOnReminder = true,
}) {
  return Setting(
    pillNumberForFromMenstruation: 1,
    durationMenstruation: 4,
    reminderTimes: reminderTimes,
    timezoneDatabaseName: null,
    isOnReminder: isOnReminder,
  );
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group("#midnightTakenWarningRemainingReminderTimes", () {
    test("記録時刻より後の通知時刻のみ残る", () {
      expect(
        midnightTakenWarningRemainingReminderTimes(
          reminderTimes: const [
            ReminderTime(hour: 1, minute: 0),
            ReminderTime(hour: 19, minute: 0),
          ],
          recordedAt: DateTime(2026, 7, 11, 1, 30),
        ),
        const [ReminderTime(hour: 19, minute: 0)],
      );
    });

    test("記録時刻と同時刻の通知時刻は残らない", () {
      expect(
        midnightTakenWarningRemainingReminderTimes(
          reminderTimes: const [ReminderTime(hour: 0, minute: 30)],
          recordedAt: DateTime(2026, 7, 11, 0, 30),
        ),
        isEmpty,
      );
    });

    test("記録時刻より1分後の通知時刻は残る", () {
      expect(
        midnightTakenWarningRemainingReminderTimes(
          reminderTimes: const [ReminderTime(hour: 0, minute: 31)],
          recordedAt: DateTime(2026, 7, 11, 0, 30),
        ),
        const [ReminderTime(hour: 0, minute: 31)],
      );
    });
  });

  group("#shouldShowMidnightTakenWarningDialog", () {
    group("記録操作時刻の境界値", () {
      test("23:59の記録操作の場合は表示しない", () async {
        SharedPreferences.setMockInitialValues({});
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 10, 23, 59),
            recordedAt: DateTime(2026, 7, 10, 23, 59),
            setting: buildSetting(),
          ),
          false,
        );
      });

      test("0:00の記録操作の場合は表示する", () async {
        SharedPreferences.setMockInitialValues({});
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 11, 0, 0),
            recordedAt: DateTime(2026, 7, 11, 0, 0),
            setting: buildSetting(),
          ),
          true,
        );
      });

      test("1:59の記録操作の場合は表示する", () async {
        SharedPreferences.setMockInitialValues({});
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 11, 1, 59),
            recordedAt: DateTime(2026, 7, 11, 1, 59),
            setting: buildSetting(),
          ),
          true,
        );
      });

      test("2:00の記録操作の場合は表示しない", () async {
        SharedPreferences.setMockInitialValues({});
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 11, 2, 0),
            recordedAt: DateTime(2026, 7, 11, 2, 0),
            setting: buildSetting(),
          ),
          false,
        );
      });
    });

    group("服用記録された日", () {
      test("過去のピル番号タップ等、当日分まで記録されない場合は表示しない", () async {
        SharedPreferences.setMockInitialValues({});
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 10),
            recordedAt: DateTime(2026, 7, 11, 0, 30),
            setting: buildSetting(),
          ),
          false,
        );
      });

      test("当日のピル番号タップで当日分まで記録された場合は表示する", () async {
        SharedPreferences.setMockInitialValues({});
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 11),
            recordedAt: DateTime(2026, 7, 11, 0, 30),
            setting: buildSetting(),
          ),
          true,
        );
      });
    });

    group("通知時刻の設定", () {
      test("通知時刻が未設定の場合は表示しない", () async {
        SharedPreferences.setMockInitialValues({});
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 11, 0, 10),
            recordedAt: DateTime(2026, 7, 11, 0, 10),
            setting: buildSetting(reminderTimes: const []),
          ),
          false,
        );
      });

      test("通知時刻1:00で0:30に記録した場合は表示する(1:00の通知はまだ届いていない)", () async {
        SharedPreferences.setMockInitialValues({});
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 11, 0, 30),
            recordedAt: DateTime(2026, 7, 11, 0, 30),
            setting: buildSetting(
                reminderTimes: const [ReminderTime(hour: 1, minute: 0)]),
          ),
          true,
        );
      });

      test("リマインダー通知がOFFの場合は表示しない", () async {
        SharedPreferences.setMockInitialValues({});
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 11, 0, 10),
            recordedAt: DateTime(2026, 7, 11, 0, 10),
            setting: buildSetting(isOnReminder: false),
          ),
          false,
        );
      });

      test("通知時刻1:00で1:30に記録した場合は表示しない(通知は既に届いている)", () async {
        SharedPreferences.setMockInitialValues({});
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 11, 1, 30),
            recordedAt: DateTime(2026, 7, 11, 1, 30),
            setting: buildSetting(
                reminderTimes: const [ReminderTime(hour: 1, minute: 0)]),
          ),
          false,
        );
      });
    });

    group("SharedPreferencesの保存状態", () {
      test("「二度と表示しない」が保存済みの場合は表示しない", () async {
        SharedPreferences.setMockInitialValues({
          BoolKey.midnightTakenWarningDialogNeverShowAgain: true,
        });
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 11, 0, 10),
            recordedAt: DateTime(2026, 7, 11, 0, 10),
            setting: buildSetting(),
          ),
          false,
        );
      });

      test("前日に表示済みの場合は表示しない(2日連続で表示されない)", () async {
        SharedPreferences.setMockInitialValues({
          DoubleKey.midnightTakenWarningDialogLastShownDateTime:
              DateTime(2026, 6, 30, 0, 30).millisecondsSinceEpoch.toDouble(),
        });
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 1, 0, 10),
            recordedAt: DateTime(2026, 7, 1, 0, 10),
            setting: buildSetting(),
          ),
          false,
        );
      });

      test("前回表示から29日後の場合は表示しない", () async {
        SharedPreferences.setMockInitialValues({
          DoubleKey.midnightTakenWarningDialogLastShownDateTime:
              DateTime(2026, 6, 12, 0, 30).millisecondsSinceEpoch.toDouble(),
        });
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 11, 0, 10),
            recordedAt: DateTime(2026, 7, 11, 0, 10),
            setting: buildSetting(),
          ),
          false,
        );
      });

      test("前回表示から30日後の場合は表示する", () async {
        SharedPreferences.setMockInitialValues({
          DoubleKey.midnightTakenWarningDialogLastShownDateTime:
              DateTime(2026, 6, 11, 0, 30).millisecondsSinceEpoch.toDouble(),
        });
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2026, 7, 11, 0, 10),
            recordedAt: DateTime(2026, 7, 11, 0, 10),
            setting: buildSetting(),
          ),
          true,
        );
      });

      test("年をまたいで前回表示から30日以上経過している場合は表示する", () async {
        SharedPreferences.setMockInitialValues({
          DoubleKey.midnightTakenWarningDialogLastShownDateTime:
              DateTime(2026, 12, 10, 0, 30).millisecondsSinceEpoch.toDouble(),
        });
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2027, 1, 9, 0, 10),
            recordedAt: DateTime(2027, 1, 9, 0, 10),
            setting: buildSetting(),
          ),
          true,
        );
      });

      test("年をまたいでも前回表示から30日未満の場合は表示しない", () async {
        SharedPreferences.setMockInitialValues({
          DoubleKey.midnightTakenWarningDialogLastShownDateTime:
              DateTime(2026, 12, 31, 0, 30).millisecondsSinceEpoch.toDouble(),
        });
        expect(
          shouldShowMidnightTakenWarningDialog(
            sharedPreferences: await SharedPreferences.getInstance(),
            takenDate: DateTime(2027, 1, 1, 0, 10),
            recordedAt: DateTime(2027, 1, 1, 0, 10),
            setting: buildSetting(),
          ),
          false,
        );
      });
    });
  });

  group("MidnightTakenWarningDialog", () {
    testWidgets("初回表示の場合は「二度と表示しない」ボタンが表示されない", (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MidnightTakenWarningDialog(
            takenDate: DateTime(2026, 7, 11, 0, 10),
            reminderTimes: const [ReminderTime(hour: 19, minute: 0)],
            showsNeverShowAgainButton: false,
          ),
        ),
      );
      await tester.pump();

      // FAQリンクボタンと「閉じる」ボタンのみ表示される
      expect(find.byType(AppOutlinedButton), findsOneWidget);
      expect(find.byType(AlertButton), findsOneWidget);
    });

    testWidgets("2回目以降の表示の場合は「二度と表示しない」ボタンが表示される", (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MidnightTakenWarningDialog(
            takenDate: DateTime(2026, 7, 11, 0, 10),
            reminderTimes: const [ReminderTime(hour: 19, minute: 0)],
            showsNeverShowAgainButton: true,
          ),
        ),
      );
      await tester.pump();

      // 「閉じる」に加えて「二度と表示しない」のAlertButtonが表示される
      expect(find.byType(AppOutlinedButton), findsOneWidget);
      expect(find.byType(AlertButton), findsNWidgets(2));
    });

    testWidgets("本文に服用記録された日付と通知時刻が表示される", (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MidnightTakenWarningDialog(
            takenDate: DateTime(2026, 7, 11, 0, 10),
            reminderTimes: const [ReminderTime(hour: 19, minute: 0)],
            showsNeverShowAgainButton: false,
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('7/11'), findsOneWidget);
      expect(find.textContaining('19:00'), findsOneWidget);
    });

    testWidgets("通知時刻が複数ある場合は全ての時刻が表示される", (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MidnightTakenWarningDialog(
            takenDate: DateTime(2026, 7, 11, 0, 10),
            reminderTimes: const [
              ReminderTime(hour: 19, minute: 0),
              ReminderTime(hour: 22, minute: 30),
            ],
            showsNeverShowAgainButton: false,
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('19:00, 22:30'), findsOneWidget);
    });
  });
}
