# HelpPage の遷移をタブ移動に統一 + 文言齟齬修正 + CLAUDE.md 更新

## Context

FeatureAppeal HelpPage について以下の方針変更:

1. **ボタン文言**: "実際に試す" → "確認する"（履歴確認等「試す」でない機能もあるため）
2. **遷移先を全てタブ移動に統一**: 個別ページ遷移をやめる（動線の判断コストを下げる）
3. **実機能との齟齬修正**:
   - `calendar_diary` Point3 "過去の記録をかんたん検索" → 検索機能は未実装
   - `appearance_mode_date` Point2 "何日目か一目で把握できる" → date モードは「日付」表示であり「何日目か」は number モード。誤解を招く
4. **CLAUDE.md に方針を追記**: 「遷移先は全てタブ移動に統一」

## Step 1: L10n 文字列の修正（app_ja.arb / app_en.arb）

### ボタン文言変更
- `featureAppealTryFeature`: "実際に試す" → "確認する"（en: "Try feature" → "View"）

### 齟齬修正
- `calendarDiaryFeatureAppealPoint3`: "過去の記録をかんたん検索" → "過去の記録をカレンダーで振り返り"
- `appearanceModeDateFeatureAppealPoint2`: "何日目か一目で把握できる" → "カレンダーを見なくても日付がわかる"

実行後 `flutter gen-l10n` で生成。

## Step 2: 全 HelpPage の遷移先をタブ移動に統一

### 各ページの遷移先タブ

| ページ | タブ (selectedIndex) | Premium チェック |
|---|---|---|
| critical_alert | 設定 (3) | あり → 非Premium: ペイウォール / Premium: 設定タブ |
| reminder_notification_customize_word | 設定 (3) | あり → 非Premium: ペイウォール / Premium: 設定タブ |
| appearance_mode_date | ピル (0) | あり → 非Premium: ペイウォール / Premium: ピルタブ |
| record_pill | ピル (0) | なし |
| menstruation | 設定 (3) | なし |
| calendar_diary | カレンダー (2) | なし（現状維持） |
| future_schedule | カレンダー (2) | なし（現状維持） |
| health_care_integration | 設定 (3) | なし（現状維持） |

### 実装変更

**遷移コードの共通パターン**:
```dart
final tabController = ref.read(homeTabControllerProvider);
Navigator.of(context).popUntil((r) => r.isFirst);
tabController?.animateTo(HomePageTabType.{tab}.index);
```

### 変更箇所

- `critical_alert_help_page.dart`: `CriticalAlertPageRoutes.route` → setting タブ
  - import 削除: `pilll/features/settings/critical_alert/page.dart`, `pilll/provider/setting.dart`
  - 不要になる: `ref.watch(settingProvider).requireValue`
  - 追加: `ref.read(homeTabControllerProvider)`, `features/home/page.dart` import

- `reminder_notification_customize_word_help_page.dart`: `ReminderNotificationCustomizeWordPageRoutes.route` → setting タブ
  - import 削除: `features/reminder_notification_customize_word/page.dart`
  - 追加: `ref.read(homeTabControllerProvider)`, `features/home/page.dart` import

- `appearance_mode_date_help_page.dart`: `showSelectAppearanceModeModal` → pill タブ
  - import 削除: `features/record/components/setting/components/appearance_mode/select_appearance_mode_modal.dart`, `provider/pill_sheet_group.dart`
  - 不要になる: `ref.watch(latestPillSheetGroupProvider).valueOrNull`
  - 追加: `ref.read(homeTabControllerProvider)`, `features/home/page.dart` import

- `record_pill_help_page.dart`:
  - `PillSheetModifiedHistoriesPageRoute.route()` → pill タブ
  - import 削除: `features/pill_sheet_modified_history/page.dart`
  - 追加: `features/home/page.dart` import, `ConsumerWidget` 化して `ref.read(homeTabControllerProvider)`
  - **履歴リストプレビュー削除**: `_mockHistoryRow` メソッドと下向き矢印+履歴Container を削除（タブバー + 矢印 + pill mark 行 だけにする）

- `menstruation_help_page.dart`: `SettingMenstruationPageRoute.route()` → setting タブ
  - import 削除: `features/settings/menstruation/page.dart`
  - 追加: `features/home/page.dart` import, `ConsumerWidget` 化
  - モックタブバー `selectedIndex` を `3` (設定) に変更（現在は?）

- `calendar_diary_help_page.dart`, `future_schedule_help_page.dart`, `health_care_integration_help_page.dart`: 既にタブ移動なので変更なし

### Premium チェックの保持

Premium ページ3つは `ref.watch(userProvider).requireValue` で user を取得し、`!user.premiumOrTrial` のときはペイウォール表示、そうでなければタブ移動。

## Step 3: calendar_diary の Feature Card アイコン修正

`Icons.search` (Point3) → 齟齬修正後の文言に合うアイコンに変更。`Icons.replay` or `Icons.history` が候補。

## Step 4: CLAUDE.md 更新

`lib/features/feature_appeal/CLAUDE.md` に以下を追記/修正:

### 追記セクション: 「遷移先のルール」

```markdown
## 遷移先のルール

「確認する」ボタンの遷移先は**タブ移動のみに統一**する。個別の機能ページへの直接遷移はしない。
理由: 動線を機能ごとに判断するコストを下げる。まずは該当タブに飛ばしてユーザーに探索してもらう方針。

```dart
final tabController = ref.read(homeTabControllerProvider);
Navigator.of(context).popUntil((r) => r.isFirst);
tabController?.animateTo(HomePageTabType.{tab}.index);
```

Premium 機能の場合は `ref.watch(userProvider).requireValue` で user を取得し、非Premium のときは `showPremiumIntroductionSheet(context)` でペイウォール、Premium のときはタブ移動。
```

### 既存記述の更新

- ページ構成セクション: bottomNavigationBar の PrimaryButton の text を「確認する」と明記
- ステップバイステップガイドの表から「コンポーネントプレビュー」の個別具体例（服用履歴リスト等）を削除、シンプルに「タブバー + 矢印 + 機能画面の象徴的なUI（任意）」へ簡素化
- L10n 命名規則は変更なし

## 対象ファイル

| ファイル | 操作 |
|---|---|
| `lib/l10n/app_ja.arb` | `featureAppealTryFeature`, `calendarDiaryFeatureAppealPoint3`, `appearanceModeDateFeatureAppealPoint2` 修正 |
| `lib/l10n/app_en.arb` | 同上 |
| `lib/features/feature_appeal/critical_alert/critical_alert_help_page.dart` | 遷移先を setting タブに |
| `lib/features/feature_appeal/reminder_notification_customize_word/reminder_notification_customize_word_help_page.dart` | 遷移先を setting タブに |
| `lib/features/feature_appeal/appearance_mode_date/appearance_mode_date_help_page.dart` | 遷移先を pill タブに、selectedIndex を 0 に |
| `lib/features/feature_appeal/record_pill/record_pill_help_page.dart` | 遷移先を pill タブに、履歴リストプレビュー削除、ConsumerWidget化 |
| `lib/features/feature_appeal/menstruation/menstruation_help_page.dart` | 遷移先を setting タブに、selectedIndex を 3 に、ConsumerWidget化 |
| `lib/features/feature_appeal/calendar_diary/calendar_diary_help_page.dart` | Point3 アイコン修正 |
| `lib/features/feature_appeal/CLAUDE.md` | 遷移先ルール追記、「確認する」ボタン文言明記 |

## 検証

1. `flutter gen-l10n` 成功
2. `flutter analyze` error/warning なし
3. `flutter test` 全件パス
4. シミュレータで各ページを確認:
   - ボタンテキストが「確認する」
   - タップで該当タブに切り替わる
   - Premium ページは非Premium の場合ペイウォール表示

## チェックリスト

- [ ] 変更対象ファイルごとに具体的なコード提案をコードブロックで記載している
- [ ] 既存コードのパターン・構成を確認し、同じパターンで実装している
- [ ] コード生成: `flutter gen-l10n` で生成ファイル更新
- [ ] 静的解析: `flutter analyze` エラーなし
- [ ] テスト: `flutter test` 全件パス
- [ ] 引数: 関数・コンストラクタの引数に `{required}` あり
- [ ] ref使い分け: build内は `ref.watch`、コールバック・操作は `ref.read`
