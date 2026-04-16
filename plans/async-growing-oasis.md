# FeatureAppeal HelpPage を正しく機能する状態にする

## Context

PR #1782 で追加した FeatureAppeal HelpPage 8ページに2つの問題がある:

1. **Premium系3ページが表示されない**: `ref.watch(userProvider)` の `hasValue` ガードで `SizedBox.shrink()` を返しており、Provider のストリーム初回データ到着前にページ全体が空になる
2. **無料機能5ページの「実際に試す」がタブ切替のみ**: `popUntil(isFirst)` → `animateTo(tab)` で特定の機能画面に遷移しない

L10n文字列・SVG・レイアウト構造自体は正しい。修正は provider ガードの除去と遷移先の変更のみ。

---

## Step 1: Premium系3ページの `SizedBox.shrink()` ガードを除去

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
