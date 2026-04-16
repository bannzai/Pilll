# FeatureAppeal HelpPage を「機能説明ページ」として完成させる

## Context

PR #1782 の HelpPage 8ページに以下の修正を行った（実装済み）:
- `bottomNavigationBar` 内の `Center` が body 領域を奪う問題を修正
- Premium系3ページの `SizedBox.shrink()` ガードを除去、`ref.read` をコールバック内に移動
- 遷移先の修正（record_pill → 服用履歴、menstruation → 生理設定、calendar_diary/future_schedule → カレンダータブ）

**次のステップ**: 各ページにビジュアルな機能説明を追加する。
- アイコン付きのフィーチャーカード（2-3個/ページ）で機能のポイントをアピール
- 実際のアプリUIコンポーネントを埋め込んで「どこからアクセスできるか」を視覚的に示す

---

## Step 1 (実装済み): レンダリング修正・遷移先修正

- `bottomNavigationBar` から `Center` ラッパー削除（全8ページ）
- Premium系3ページの `hasValue` ガード削除、`ref.read` をコールバックに移動
- 遷移先修正: record_pill→服用履歴, menstruation→生理設定, calendar_diary/future_schedule→カレンダータブ
- テスト1386件全パス、`flutter analyze` error/warningなし、シミュレータでコンテンツ表示確認済み

---

## Step 2: ビジュアルな機能説明を追加

### ページレイアウト構成

```
AppBar (機能名)
─────────────────
[SVG Icon]

見出し (Headline)

[Feature Cards]
  ┌ Icon ─ ポイント1 ┐
  ├ Icon ─ ポイント2 ├
  └ Icon ─ ポイント3 ┘

[Location Preview]  ← "アプリ内の場所"
  パス: "設定 > 通知"
  ┌──────────────────┐
  │ 実際の設定行の    │
  │ プレビュー        │
  └──────────────────┘

─────────────────
[FAB] 実際に試す
```

### 各ページの Feature Cards + Location Preview

| # | 機能 | Feature Cards (Icon + テキスト) | Location Preview |
|---|---|---|---|
| 1 | Critical Alert | `Icons.notifications_active` 集中モード中も通知 / `Icons.schedule` 設定時刻に確実リマインド / `Icons.touch_app` ワンタップで設定 | パス: 設定 > 通知 / プレビュー: `ListTile(title: L.enableNotificationInSilentModeSetting, subtitle: L.silentModeNotificationDescription)` + PremiumBadge |
| 2 | 通知カスタマイズ | `Icons.edit` 通知メッセージを自由に編集 / `Icons.notifications` 毎日の通知に反映 / `Icons.favorite` 自分だけの通知に | パス: 設定 > 通知 / プレビュー: `ListTile(title: L.customizeMedicationNotifications)` + PremiumBadge |
| 3 | 外観モード(date) | `Icons.calendar_today` 日付で表示 / `Icons.visibility` 何日目か一目で把握 / `Icons.settings` ピルシート設定から変更 | パス: 設定 > ピルシート / プレビュー: `ListTile(title: "ピルシートの自動追加", subtitle: "Premium")` |
| 4 | ピル記録 | `Icons.touch_app` ピルシートをタップで記録 / `Icons.undo` 間違えても取り消し可能 / `Icons.history` 服用履歴を確認 | パス: ピルタブ / プレビュー: タブアイコン(tab_icon_pill_enable.svg) + 説明 |
| 5 | 生理記録 | `Icons.edit_calendar` 生理開始日を記録 / `Icons.trending_up` 周期を自動で把握 / `Icons.tune` 設定をカスタマイズ | パス: 設定 > 生理 / プレビュー: `ListTile(title: L.aboutMenstruation)` |
| 6 | カレンダー日記 | `Icons.calendar_month` カレンダーで一覧 / `Icons.note_add` 体調をメモ / `Icons.search` 過去の記録を振り返り | パス: カレンダータブ / プレビュー: タブアイコン(tab_icon_calendar_enable.svg) + 説明 |
| 7 | 未来の予定 | `Icons.event` 予定を書き込み / `Icons.local_hospital` 通院日を管理 / `Icons.alarm` リマインダーで通知 | パス: カレンダータブ / プレビュー: タブアイコン(tab_icon_calendar_enable.svg) + 説明 |
| 8 | ヘルスケア連携 | `Icons.sync` 自動でデータ連携 / `Icons.favorite` 生理記録をヘルスケアに同期 / `Icons.phone_iphone` Apple ヘルスケア対応 | パス: 設定 > 生理 / プレビュー: `ListTile(title: L.healthCareIntegration, subtitle: L.healthCareIntegrationDescription)` |

### 実装方針

- **L10n**: Feature Cards のテキストは `app_ja.arb` / `app_en.arb` に追加（各ページ3個 × 8ページ = 24文字列）→ 実装済み
- **Location Preview**: ステップバイステップガイドとして実装:
  1. モックタブバー（4タブ、対象に丸インジケーター）
  2. `Icons.arrow_downward`（サイズ28、primary色）で次ステップへ
  3. 実際の UI コンポーネントプレビュー（設定行 ListTile or ピルシートの pill mark 行）
- **ピルシート行のモック**: `AppColors.potti`(20px円) × 未服用、`AppColors.lightGray` + ✓ × 服用済み、`AppColors.enable`(オレンジ) × 選択中 を並べて表現
- **各 HelpPage に直接記述**: 共通コンポーネントは作らず、各ページの `body` 内の `Column` に直接 Widget を追加

---

## Step 1 (実装済み) の元の内容

### Premium系3ページの `SizedBox.shrink()` ガードを除去

コーディング規約に従い `requireValue` を使う。ただし `ref.watch` を build で呼ぶ必要はない（provider の値はボタンコールバックでのみ使う）ため、`ref.read` に変更する。

### 1-1. `critical_alert_help_page.dart`

**まずデバッグ状態を HEAD に戻す**。その上で以下を変更:

- `ref.watch(userProvider)` / `ref.watch(settingProvider)` + `hasValue` ガード → 削除
- ボタンコールバック内で `ref.read(userProvider).requireValue` / `ref.read(settingProvider).requireValue` を使う

```dart
// Before (build内)
final userAsync = ref.watch(userProvider);
final settingAsync = ref.watch(settingProvider);
if (!userAsync.hasValue || !settingAsync.hasValue) return const SizedBox.shrink();
final user = userAsync.requireValue;
final setting = settingAsync.requireValue;

// After (build内のガードを削除、ボタンコールバック内で read)
onPressed: () async {
  final user = ref.read(userProvider).requireValue;
  final setting = ref.read(settingProvider).requireValue;
  analytics.logEvent(...);
  if (!user.premiumOrTrial) { ... return; }
  await Navigator.of(context).push(CriticalAlertPageRoutes.route(setting: setting));
},
```

### 1-2. `reminder_notification_customize_word_help_page.dart`

同様に `ref.watch(userProvider)` + `hasValue` ガード → 削除、コールバック内で `ref.read`

```dart
// Before (build内)
final userAsync = ref.watch(userProvider);
if (!userAsync.hasValue) return const SizedBox.shrink();
final user = userAsync.requireValue;

// After (build内のガードを削除、ボタンコールバック内で read)
onPressed: () async {
  final user = ref.read(userProvider).requireValue;
  analytics.logEvent(...);
  if (!user.premiumOrTrial) { ... return; }
  await Navigator.of(context).push(ReminderNotificationCustomizeWordPageRoutes.route());
},
```

### 1-3. `appearance_mode_date_help_page.dart`

`ref.watch(userProvider)` + `hasValue` ガード → 削除、コールバック内で `ref.read`。
`ref.watch(latestPillSheetGroupProvider).valueOrNull` も `ref.read` に変更。

```dart
// Before (build内)
final userAsync = ref.watch(userProvider);
if (!userAsync.hasValue) return const SizedBox.shrink();
final user = userAsync.requireValue;
final pillSheetGroup = ref.watch(latestPillSheetGroupProvider).valueOrNull;

// After (build内のガードを削除、ボタンコールバック内で read)
onPressed: () async {
  final user = ref.read(userProvider).requireValue;
  analytics.logEvent(...);
  if (!user.premiumOrTrial) { ... return; }
  final pillSheetGroup = ref.read(latestPillSheetGroupProvider).valueOrNull;
  if (pillSheetGroup == null) return;
  showSelectAppearanceModeModal(context, user: user, pillSheetGroup: pillSheetGroup);
},
```

---

## Step 2: 無料機能ページの「実際に試す」遷移先を意味のある画面に変更

全て `ref` 不要になるため `StatelessWidget` に変更。

| ページ | 現在 | 変更後 |
|---|---|---|
| `record_pill_help_page.dart` | record タブ切替 | `PillSheetModifiedHistoriesPageRoute.route()` (服用履歴) |
| `menstruation_help_page.dart` | ✅ 修正済み | `SettingMenstruationPageRoute.route()` |
| `calendar_diary_help_page.dart` | calendar タブ切替 | `DiaryPostPageRoute.route(today(), null)` (日記入力) |
| `future_schedule_help_page.dart` | calendar タブ切替 | `SchedulePostPageRoute.route(today().add(Duration(days: 1)))` (予定作成) |
| `health_care_integration_help_page.dart` | setting タブ切替 | 設定タブ切替を維持 (専用ページが存在しない) |

### 具体的な変更

**record_pill**: `ConsumerWidget` → `StatelessWidget`、import変更
```dart
// Before
final tabController = ref.read(homeTabControllerProvider);
Navigator.of(context).popUntil((r) => r.isFirst);
tabController?.animateTo(HomePageTabType.record.index);

// After
Navigator.of(context).push(PillSheetModifiedHistoriesPageRoute.route());
```

**calendar_diary**: `ConsumerWidget` → `StatelessWidget`、import変更
```dart
// Before
final tabController = ref.read(homeTabControllerProvider);
Navigator.of(context).popUntil((r) => r.isFirst);
tabController?.animateTo(HomePageTabType.calendar.index);

// After
Navigator.of(context).push(DiaryPostPageRoute.route(today(), null));
```

**future_schedule**: `ConsumerWidget` → `StatelessWidget`、import変更
```dart
// Before
final tabController = ref.read(homeTabControllerProvider);
Navigator.of(context).popUntil((r) => r.isFirst);
tabController?.animateTo(HomePageTabType.calendar.index);

// After
Navigator.of(context).push(SchedulePostPageRoute.route(today().add(const Duration(days: 1))));
```

**health_care_integration**: `ref` 不要なので `StatelessWidget` に変更するが、遷移先はそのまま維持…と思ったが、タブ切替に `ref.read(homeTabControllerProvider)` が必要。`ConsumerWidget` のまま維持。

---

## Step 3: デバッグ残骸のクリーンアップ

- `critical_alert_help_page.dart`: git checkout で HEAD に戻してから Step 1-1 の変更を適用
- `tmp/` ディレクトリ内のスクリーンショット・デバッグファイルを削除

---

## 変更対象ファイル

| ファイル | 変更内容 |
|---|---|
| `lib/features/feature_appeal/critical_alert/critical_alert_help_page.dart` | デバッグ状態を戻す → `hasValue` ガード除去、`ref.read` に変更 |
| `lib/features/feature_appeal/reminder_notification_customize_word/reminder_notification_customize_word_help_page.dart` | `hasValue` ガード除去、`ref.read` に変更 |
| `lib/features/feature_appeal/appearance_mode_date/appearance_mode_date_help_page.dart` | `hasValue` ガード除去、`ref.read` に変更 |
| `lib/features/feature_appeal/record_pill/record_pill_help_page.dart` | `StatelessWidget` 化、遷移先を `PillSheetModifiedHistoriesPage` に |
| `lib/features/feature_appeal/calendar_diary/calendar_diary_help_page.dart` | `StatelessWidget` 化、遷移先を `DiaryPostPage` に |
| `lib/features/feature_appeal/future_schedule/future_schedule_help_page.dart` | `StatelessWidget` 化、遷移先を `SchedulePostPage` に |
| `lib/features/feature_appeal/menstruation/menstruation_help_page.dart` | ✅ 修正済み (変更なし) |
| `lib/features/feature_appeal/health_care_integration/health_care_integration_help_page.dart` | 変更なし (専用ページなし) |

---

## 検証

1. `flutter analyze` エラーなし
2. `flutter test` 全件パス
3. シミュレータでビルド・インストール
4. 開発者オプション → HelpPage一覧 → 全8ページでコンテンツ（SVG + 見出し + 本文）が表示されることを確認
5. 各ページの「実際に試す」が正しい画面に遷移することを確認

---

## チェックリスト

### 実装内容
- [ ] 変更対象ファイルごとに具体的なコード提案をコードブロックで記載している
- [ ] 既存コードのパターン・構成を確認し、同じパターンで実装している
- [ ] コード生成: `dart run build_runner build` で生成ファイル更新
- [ ] 静的解析: `flutter analyze` エラーなし
- [ ] テスト: `flutter test` 全件パス
- [ ] iOS ビルド: `flutter build ios` 成功
- [ ] Android ビルド: `flutter build apk` 成功
- [ ] 新規・変更機能に対するテストが存在する（なければ新規作成）
- [ ] 引数: 関数・コンストラクタの引数に `{required}` あり（timestamp等メタデータ除く）
- [ ] ref使い分け: build内は `ref.watch`、コールバック・操作は `ref.read`
- [ ] エラーメッセージはそのまま表示（加工・プレフィックス除去なし）
