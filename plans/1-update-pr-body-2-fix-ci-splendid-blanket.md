# PR #1782 body 更新 + CI 修正 + Debug Page に AnnouncementBar 一覧追加

## Context

feature/feature-appeal ブランチ (PR #1782) は最初のCI成功 (run 24490068441) 以降も複数のコミットが積み重なっており、最新 CI (run 24555326876) で `codegen` と `test` が失敗している。
また、PR body には直近追加された debug page (FeatureAppeal HelpPage 一覧) や visual content 追加の記述が反映されていない。
ユーザーの要望は以下の3点を一度にカバーする:

1. **`/update-pr-body`**: PR #1782 の body を最新変更点 (debug page, visual content, Maestro E2E, 優先度変更など) に合わせて更新
2. **`/fix-ci`**: 最新 CI 失敗 (codegen 1件, test 13件) を原因特定して修正
3. **Debug page に AnnouncementBar 一覧ページ追加**: 既存の `FeatureAppealHelpPageListPage` と同様のパターンで、13 個の AnnouncementBar Widget を一覧表示する `FeatureAppealAnnouncementBarListPage` を新設し、開発者オプションに行を追加

---

## 現状把握サマリ

### PR #1782
- head: `feature/feature-appeal` → base: `main`
- 81 ファイル変更、+8884/-17 行
- body には debug page, visual content 追加, HelpPage 13 個体制などが書かれていない (初期段階の 8 機能時点の記述のまま)

### 最新 CI (run 24555326876)
- ✓ `build-android-debug` (14m5s)
- ✓ `build-ios-debug` (7m45s)
- ✓ `lint` (2m20s)
- ✗ `codegen` - `git diff --quiet --exit-code` で失敗 (dart format lib 後に `lib/provider/app_is_released.g.dart` がフォーマットされている)
- ✗ `test` - **1403 passed / 13 failed**

### 失敗テスト13件 (すべて `test/features/record/announcement_bar/announcement_bar_test.dart`)
| Line | Group | Description |
|---|---|---|
| 233 | `#PremiumTrialLimitAnnouncementBar` | 表示期待 |
| 366 | `#AdMob` | `!isPremium and !isTrial` |
| 663 | `#PilllAdsAnnouncementBar` | today is 2022-08-10 |
| 745 | `#PilllAdsAnnouncementBar` | today is 2022-08-11 |
| 827 | `#PilllAdsAnnouncementBar` | pilll-ads end 2022-08-23T23:59:59 |
| 2019 | `#FeatureAppealIntegration` | 未認証+トライアル中: FeatureAppeal > RecommendSignupGeneral |
| 2083 | `#FeatureAppealIntegration` | 全dismiss → RecommendSignupGeneral 表示 |
| 2142 | `#FeatureAppealIntegration` | 残10日+全dismiss: PremiumTrialLimit > RecommendSignup |
| 2273, 2332, 2396, 2455, 2581 | `#FeatureAppealIntegration` | その他 |

すべて `Expected: exactly one matching candidate / Actual: Found 0 widgets` パターン。

---

## Task 1: `/update-pr-body` (PR #1782 body 更新)

### 変更対象
- PR #1782 の body (GitHub 上のみ、リポジトリ変更なし)

### 追加・更新すべき内容
現行 body には 8 機能 (有料3/無料5) の記述しかないため、以下を反映する:

- **機能数**: 8 → **13 機能** (有料7/無料6) に更新。内訳は下記リスト:
  - Premium: critical_alert, reminder_notification_customize_word, appearance_mode_date, quick_record, creating_new_pillsheet, alarm_kit, (今日の服用番号変更は free)
  - Free: record_pill, menstruation, calendar_diary, future_schedule, health_care_integration, today_pill_number, rest_duration
- **Debug page (開発者オプション)**:
  - `lib/features/settings/page.dart` に `SettingSection.developer` を追加 (Environment.isDevelopment ガード)
  - `FeatureAppealHelpPageListPage` (全 13 HelpPage への遷移) を新設
  - **本 PR で更に `FeatureAppealAnnouncementBarListPage` (全 13 AnnouncementBar を確認) を追加** (Task 3)
- **Visual content**: 全 HelpPage に FeatureCard × 3 / MockTabBar / StepGuide / SVG アイコンを追加 (lib/features/feature_appeal/CLAUDE.md 指示書ベース)
- **遷移先ルール統一**: 「確認する」ボタンは全機能でタブ移動に統一 (popUntil → tabController.animateTo)、ボタン文言も「確認する」で統一
- **Maestro E2E**: `.maestro/feature_appeal/` 配下に 4 フロー + subflow (`feature_appeal_bar_shows.yaml`, `feature_appeal_bar_persists_after_restart.yaml`, `feature_appeal_bar_persists_across_tabs.yaml`, `subflows/initial_setup.yaml`)
- **テスト件数**: 1385 → **1416 件** に更新 (failing 13 修正後)
- **優先度**: 当日 dismiss 判定 (`featureAppealLastDismissedDate`) 追加、PremiumTrialLimit に `remainingTrialDays` を追加
- **`.claude/rules/` 追加**: analytics.md / coding-conventions.md / testing.md に feature_appeal 関連ルールを追記

### 実行手順
```bash
gh pr edit 1782 --body-file /tmp/pr_body.md
```

Task 3 実装後に body の Task 3 関連部分も含めて一括更新する。

---

## Task 2: `/fix-ci` (CI 失敗修正)

### Part A: codegen 失敗の修正

#### 原因
`flutter pub run build_runner build --delete-conflicting-outputs && dart format lib` を CI で実行した結果、`lib/provider/app_is_released.g.dart` がフォーマットされ、リポジトリ側と diff が発生。手元でフォーマット未実行のままコミットされた。

#### 修正手順
```bash
flutter pub run build_runner build --delete-conflicting-outputs
dart format lib
git add lib/
git status  # 変更ファイルを確認
git commit -m "chore: codegen + dart format lib 実行結果を反映"
git push
```

### Part B: test 失敗 13件の原因特定と修正

#### 原因仮説 (ローカル `flutter test` で再現してから確定)
失敗はすべて `Found 0 widgets`。共通して `AnnouncementBar` 系の Widget が本来期待される条件で出ていない。直近で追加された以下の変更が影響している可能性が高い:

1. **`featureAppealLastDismissedDate` (StringKey) 追加 + `wasDismissedToday` 判定の導入** (commit ca3305ddd4, c78e5ae7ff, f5e9ea1a81)
   - テスト時に SharedPreferences で今日の日付が dismiss 日付として扱われるケースで、`PremiumTrialLimit` / `AdMob` / `PilllAds` などの fallback に遷移できていない可能性
2. **優先度変更** (commit 710ce6a393, f5a9c9d57c)
   - 認証 → FeatureAppeal → 既存フォールバックの順に書き換えた際、既存テストの Widget matcher の期待値が古いままの可能性
3. **appIsReleasedProvider の override 未追加**: test 側で override し忘れ

#### 修正手順
```bash
# 1. ローカルで再現
flutter test test/features/record/announcement_bar/announcement_bar_test.dart

# 2. 13 件の失敗の原因を1つずつ分析
#    各 testWidgets で pumpWidget する ProviderScope.overrides に、
#    featureAppealLastDismissedDate / appIsReleasedProvider / userProvider / settingProvider
#    の適切な override が含まれているか確認。

# 3. 期待動作に合わせて test 側の override や matcher を更新、もしくは
#    実装側 (announcement_bar.dart / feature_appeal_bars_container.dart) の
#    優先度ロジックを修正 (優先度変更 ADR と照合)

# 4. 全テストパス確認
flutter test
```

#### 確認すべき具体箇所
- `test/features/record/announcement_bar/announcement_bar_test.dart:233` (`#PremiumTrialLimitAnnouncementBar`) : FeatureAppeal を出さないように `allFeatureAppealDismissedPrefs()` でoverride しているか、残トライアル日数 (`remainingTrialDays`) を渡しているか
- `:366` (`#AdMob !isPremium and !isTrial`) : `appIsReleasedProvider` を `Future.value(false)` に override しているか
- `:663-827` (`#PilllAdsAnnouncementBar`) : 同上 + FeatureAppeal 全 dismiss prefs を設定
- `:2019-2581` (`#FeatureAppealIntegration`) : RecommendSignupGeneralAnnouncementBar の子 Widget が想定通りレンダリングされるか

テスト失敗の正確な原因は **ローカル `flutter test` 実行後** に確定する。Plan mode 完了後、最初の実装ステップとしてローカル再現を行う。

---

## Task 3: Debug page に AnnouncementBar 一覧ページ追加

### 設計方針 (ユーザー確認済み)
- **表示構成**: bar 実体のみを縦に並べる (ListView)
- **× ボタン**: 通常仕様のまま (isClosed.value = true で非表示、SharedPreferences には書かない)
- **コードは既存の AnnouncementBar Widget をそのまま流用**

### 変更対象ファイル
1. **新規作成**: `lib/features/settings/components/rows/feature_appeal_announcement_bar_list_page.dart`
2. **新規作成**: `lib/features/settings/components/rows/feature_appeal_announcement_bar_list_row.dart`
3. **編集**: `lib/features/settings/page.dart` (SettingSection.developer の children に 1 行追加)

### 新規ページ実装 (具体コード)

#### `lib/features/settings/components/rows/feature_appeal_announcement_bar_list_page.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/features/feature_appeal/alarm_kit/alarm_kit_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/appearance_mode_date/appearance_mode_date_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/calendar_diary/calendar_diary_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/creating_new_pillsheet/creating_new_pillsheet_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/critical_alert/critical_alert_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/future_schedule/future_schedule_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/health_care_integration/health_care_integration_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/menstruation/menstruation_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/quick_record/quick_record_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/record_pill/record_pill_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/reminder_notification_customize_word/reminder_notification_customize_word_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/rest_duration/rest_duration_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/today_pill_number/today_pill_number_announcement_bar.dart';

/// FeatureAppeal の全 AnnouncementBar Widget を 1 画面に並べて確認するページ。
/// 開発者オプションからアクセスし、日次ローテーションや dismiss 状態に依存せず
/// 全 Bar の表示 (文言・アイコン・タップ遷移) を横断的に検証する用途。
class FeatureAppealAnnouncementBarListPage extends HookWidget {
  const FeatureAppealAnnouncementBarListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final criticalAlertClosed = useState(false);
    final reminderNotificationCustomizeWordClosed = useState(false);
    final appearanceModeDateClosed = useState(false);
    final recordPillClosed = useState(false);
    final menstruationClosed = useState(false);
    final calendarDiaryClosed = useState(false);
    final futureScheduleClosed = useState(false);
    final healthCareIntegrationClosed = useState(false);
    final quickRecordClosed = useState(false);
    final creatingNewPillSheetClosed = useState(false);
    final alarmKitClosed = useState(false);
    final todayPillNumberClosed = useState(false);
    final restDurationClosed = useState(false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('FeatureAppeal AnnouncementBar 一覧'),
        backgroundColor: AppColors.background,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (!criticalAlertClosed.value) CriticalAlertAnnouncementBar(isClosed: criticalAlertClosed),
          const SizedBox(height: 8),
          if (!reminderNotificationCustomizeWordClosed.value)
            ReminderNotificationCustomizeWordAnnouncementBar(isClosed: reminderNotificationCustomizeWordClosed),
          const SizedBox(height: 8),
          if (!appearanceModeDateClosed.value) AppearanceModeDateAnnouncementBar(isClosed: appearanceModeDateClosed),
          const SizedBox(height: 8),
          if (!recordPillClosed.value) RecordPillAnnouncementBar(isClosed: recordPillClosed),
          const SizedBox(height: 8),
          if (!menstruationClosed.value) MenstruationAnnouncementBar(isClosed: menstruationClosed),
          const SizedBox(height: 8),
          if (!calendarDiaryClosed.value) CalendarDiaryAnnouncementBar(isClosed: calendarDiaryClosed),
          const SizedBox(height: 8),
          if (!futureScheduleClosed.value) FutureScheduleAnnouncementBar(isClosed: futureScheduleClosed),
          const SizedBox(height: 8),
          if (!healthCareIntegrationClosed.value) HealthCareIntegrationAnnouncementBar(isClosed: healthCareIntegrationClosed),
          const SizedBox(height: 8),
          if (!quickRecordClosed.value) QuickRecordAnnouncementBar(isClosed: quickRecordClosed),
          const SizedBox(height: 8),
          if (!creatingNewPillSheetClosed.value) CreatingNewPillSheetAnnouncementBar(isClosed: creatingNewPillSheetClosed),
          const SizedBox(height: 8),
          if (!alarmKitClosed.value) AlarmKitAnnouncementBar(isClosed: alarmKitClosed),
          const SizedBox(height: 8),
          if (!todayPillNumberClosed.value) TodayPillNumberAnnouncementBar(isClosed: todayPillNumberClosed),
          const SizedBox(height: 8),
          if (!restDurationClosed.value) RestDurationAnnouncementBar(isClosed: restDurationClosed),
        ],
      ),
    );
  }
}

/// FirebaseAnalyticsObserver が自動で screen_view を送信するため、
/// RouteSettings.name は必ず設定する。
extension FeatureAppealAnnouncementBarListPageRoute on FeatureAppealAnnouncementBarListPage {
  static Route<dynamic> route() => MaterialPageRoute(
        settings: const RouteSettings(name: 'FeatureAppealAnnouncementBarListPage'),
        builder: (_) => const FeatureAppealAnnouncementBarListPage(),
      );
}
```

#### `lib/features/settings/components/rows/feature_appeal_announcement_bar_list_row.dart`
```dart
import 'package:flutter/material.dart';
import 'package:pilll/features/settings/components/rows/feature_appeal_announcement_bar_list_page.dart';

/// 開発者オプション内の行。タップすると FeatureAppeal AnnouncementBar 一覧ページに遷移する。
class FeatureAppealAnnouncementBarListRow extends StatelessWidget {
  const FeatureAppealAnnouncementBarListRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('FeatureAppeal AnnouncementBar 一覧'),
      subtitle: const Text('各機能のアナウンスバーを確認'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).push(FeatureAppealAnnouncementBarListPageRoute.route());
      },
    );
  }
}
```

#### `lib/features/settings/page.dart` の編集
`SettingSection.developer` の children に 1 行追加 (既存 `FeatureAppealHelpPageListRow` の直下):

```dart
case SettingSection.developer:
  return SettingSectionTitle(
    text: '開発者オプション',
    children: [
      const FeatureAppealHelpPageListRow(),
      _separator(),
      const FeatureAppealAnnouncementBarListRow(),  // ← 追加
      _separator(),
    ],
  );
```

import 追加:
```dart
import 'package:pilll/features/settings/components/rows/feature_appeal_announcement_bar_list_row.dart';
```

### 検証方法
1. `flutter analyze` でエラー0を確認
2. `flutter test` で全件パス確認 (Task 2 のテスト修正が前提)
3. 実機 (iOS simulator) で確認:
   - 設定画面 → 開発者オプション → 「FeatureAppeal AnnouncementBar 一覧」タップ
   - 13 個の Bar が縦に並ぶ
   - 各 Bar をタップ → 対応する HelpPage に遷移すること (全 13 機能)
   - × ボタン押下でその Bar が消えること
4. mobile-mcp でスクリーンショット撮影・目視確認 (feedback_ui_verification_with_screenshots ルール)

---

## 実装順序 (依存関係を考慮)

1. **Task 2 Part A** (codegen 修正): ローカルで `build_runner` + `dart format` 実行 → commit
2. **Task 2 Part B** (test 13件修正): ローカル再現 → 原因特定 → override 追加 or 実装修正 → 全テストパス確認 → commit
3. **Task 3** (AnnouncementBar 一覧ページ): 新規 2 ファイル + 1 ファイル編集 → test 追加 (任意、既存 HelpPage 一覧にテストはないので最低限 analyze + 手動確認) → commit
4. **Task 1** (PR body 更新): Task 3 含めた最新状態で body を書き直し → `gh pr edit 1782 --body-file` で反映
5. Push → CI 緑確認

---

## チェックリスト

### 実装内容
- [ ] 変更対象ファイルごとに具体的なコード提案をコードブロックで記載している
- [ ] 既存コードのパターン・構成を確認し、同じパターンで実装している (FeatureAppealHelpPageListPage と同じ構成)
- [ ] コード生成: `flutter pub run build_runner build --delete-conflicting-outputs` で生成ファイル更新
- [ ] dart format lib 実行 (codegen job 合格条件)
- [ ] 静的解析: `flutter analyze` エラーなし
- [ ] テスト: `flutter test` 全件パス (現在13件failing → 修正必須)
- [ ] iOS ビルド: `flutter build ios` 成功 (既に CI で成功済み)
- [ ] Android ビルド: `flutter build apk` 成功 (既に CI で成功済み)
- [ ] 新規・変更機能に対するテストが存在する (一覧ページは目視確認のみで許容。既存 HelpPage 一覧ページにもテストなし)
- [ ] Maestro E2E: feature_appeal の既存 4 フローが pass
- [ ] Entity命名: フィールド名が省略されていない
- [ ] DB操作: Firestore操作は `call` クラスのProvider経由 (本 PR で該当操作なし)
- [ ] 引数: 関数・コンストラクタの引数に `{required}` あり (AnnouncementBar 各 Widget の isClosed は required 済み)
- [ ] ref使い分け: build内は `ref.watch`、コールバック・操作は `ref.read` (一覧ページは ref を使わない)
- [ ] サブコレクションEntityに親ドキュメントIDフィールドあり (該当なし)
- [ ] エラーメッセージはそのまま表示 (該当なし)
- [ ] PR body 更新: 13機能構成・debug page・Maestro E2E・優先度変更・ADR 情報を含む
