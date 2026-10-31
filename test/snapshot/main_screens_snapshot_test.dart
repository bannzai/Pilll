@Tags(['snapshot'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/pill_sheet_group_select_pill_sheet_type_page.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart';
import 'package:pilll/features/calendar/page.dart';
import 'package:pilll/features/menstruation/page.dart';
import 'package:pilll/features/record/page.dart';
import 'package:pilll/features/settings/page.dart';
import 'package:pilll/features/settings/provider.dart';
import 'package:pilll/provider/app_is_released.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/provider/diary.dart';
import 'package:pilll/provider/menstruation.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/provider/schedule.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/provider/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.mocks.dart';
import 'snapshot_harness.dart';

/// 主要 5 画面 (記録・カレンダー・生理・設定・ピルシートの種類の選択シート) の見た目を、言語ごとの基準画像 (goldens/) と比べる。
///
/// 文言・色・余白・翻訳の変更を、simulator を動かす QA ではなく画像の比較で検出するためのテスト。
/// 基準画像は CI (.github/workflows/snapshot-testing.yml) の runner で撮ったものだけを使う (OS でフォントの描画が変わるため)。
void main() {
  setUpAll(setUpSnapshotEnvironment);

  for (final lang in snapshotLanguages) {
    group('#$lang', () {
      testWidgets('記録の画面', (tester) async {
        await expectSnapshot(
          tester,
          goldenName: 'record_$lang',
          widget: snapshotApp(lang: lang, overrides: await _overrides(), child: const RecordPage()),
        );
      });
      testWidgets('カレンダーの画面', (tester) async {
        await expectSnapshot(
          tester,
          goldenName: 'calendar_$lang',
          widget: snapshotApp(lang: lang, overrides: await _overrides(), child: const CalendarPage()),
        );
      });
      testWidgets('生理の画面', (tester) async {
        await expectSnapshot(
          tester,
          goldenName: 'menstruation_$lang',
          widget: snapshotApp(lang: lang, overrides: await _overrides(), child: const MenstruationPage()),
        );
      });
      testWidgets('設定の画面', (tester) async {
        await expectSnapshot(
          tester,
          goldenName: 'settings_$lang',
          widget: snapshotApp(lang: lang, overrides: await _overrides(), child: const SettingPage()),
        );
      });
      testWidgets('ピルシートの種類の選択シート', (tester) async {
        await expectSnapshot(
          tester,
          goldenName: 'pill_sheet_type_select_sheet_$lang',
          widget: snapshotApp(
            lang: lang,
            overrides: await _overrides(),
            child: Scaffold(
              backgroundColor: Colors.black54,
              body: PillSheetGroupSelectPillSheetTypePage(pillSheetType: PillSheetType.pillsheet_28_7, onSelect: (_) {}),
            ),
          ),
        );
      });
    });
  }
}

/// 5 画面が読む provider を、Firestore を使わない固定のデータに差し替える。
///
/// プレミアムのユーザーにして、無料プランの案内・広告・ペイウォールの重ね表示を出さない (画面そのものの見た目を比べるため)。
Future<List<Override>> _overrides() async {
  SharedPreferences.setMockInitialValues({});
  final sharedPreferences = await SharedPreferences.getInstance();
  final pillSheet = PillSheet.create(
    PillSheetType.pillsheet_28_7,
    beginDate: snapshotToday.subtract(const Duration(days: 10)),
    lastTakenDate: snapshotToday.subtract(const Duration(days: 1)),
    pillTakenCount: 1,
  );
  final pillSheetGroup = PillSheetGroup(
    pillSheetIDs: [pillSheet.id!],
    pillSheets: [pillSheet],
    createdAt: snapshotToday.subtract(const Duration(days: 10)),
  );
  const setting = Setting(
    pillNumberForFromMenstruation: 24,
    durationMenstruation: 4,
    isOnReminder: true,
    reminderTimes: [ReminderTime(hour: 21, minute: 0)],
    timezoneDatabaseName: 'Asia/Tokyo',
  );
  final menstruation = Menstruation(
    beginDate: DateTime(2026, 10, 3),
    endDate: DateTime(2026, 10, 7),
    createdAt: DateTime(2026, 10, 3),
  );
  final user = User(isPremium: true, beginTrialDate: DateTime(2025, 1, 1), trialDeadlineDate: DateTime(2025, 1, 31));
  return [
    // 記録・服用のボタン等が操作用の provider を通して読む。描画では Firestore に書き込まないため Mock にする
    databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
    appIsReleasedProvider.overrideWith((ref) => true),
    sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
    remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
    isLinkedProvider.overrideWithValue(true),
    userProvider.overrideWith((ref) => Stream.value(user)),
    settingProvider.overrideWith((ref) => Stream.value(setting)),
    latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
    allMenstruationProvider.overrideWith((ref) => Stream.value([menstruation])),
    isHealthDataAvailableProvider.overrideWith((ref) => Future.value(false)),
    diaryForTodayProvider.overrideWith((ref) => Stream.value(null)),
    diariesForMonthProvider.overrideWith((ref, month) => Stream.value(<Diary>[])),
    diariesFor90Days.overrideWith((ref, base) => Stream.value(<Diary>[])),
    schedulesForMonthProvider.overrideWith((ref, month) => Stream.value(<Schedule>[])),
    schedules90Days.overrideWith((ref, base) => Stream.value(<Schedule>[])),
    pillSheetModifiedHistoriesWithLimitProvider(
      limit: CalendarPillSheetModifiedHistoryCardState.pillSheetModifiedHistoriesThreshold + 1,
    ).overrideWith((ref) => Stream.value(<PillSheetModifiedHistory>[])),
  ];
}
