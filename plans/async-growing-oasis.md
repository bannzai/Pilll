# FeatureAppeal HelpPage の CLAUDE.md 指示書を作成

## Context

FeatureAppeal HelpPage 8ページの実装で得たルール・パターン・アンチパターンを `lib/features/feature_appeal/CLAUDE.md` にまとめる。新しい HelpPage を量産する際に読み込んで、同じ品質・パターンで実装するための指示書。

## 記載内容

### 1. ページ構成（レイアウト）

```
Scaffold
├─ AppBar (機能名)
├─ body: SingleChildScrollView(padding: fromLTRB(24, 24, 24, 40))
│  └─ Column
│     ├─ SVG Icon (Center, 80x80)
│     ├─ Headline (fontSize: 22, w700)
│     ├─ Feature Cards × 3 (_featureCard)
│     ├─ 「アプリ内の場所」ラベル
│     ├─ _mockTabBar(selectedIndex: N)
│     ├─ ↓ 矢印 (Icons.arrow_downward, size: 28)
│     └─ コンポーネントプレビュー
└─ bottomNavigationBar: SafeArea > Padding(16) > PrimaryButton
```

### 2. レイアウトの禁止事項

- `bottomNavigationBar` 内に `Center` を入れない
  - **理由**: Scaffold が loose height constraints を渡すため `Center` が最大高さに膨張し、body の領域が 0 になる
- `if (!xxxAsync.hasValue) return SizedBox.shrink()` のガードパターン禁止
  - **理由**: ページ全体（AppBar含む）が消える

### 3. ステップバイステップガイドのパターン

コンポーネントプレビューは機能のアクセス経路に応じて使い分ける:

| アクセス経路 | タブ選択 | プレビュー |
|---|---|---|
| 設定タブ内の行 | `selectedIndex: 3` | `Container(primary border) > IgnorePointer > ListTile` |
| ピルタブの操作 | `selectedIndex: 0` | pill mark 行 + touch_app アイコン → 矢印 → 服用履歴リスト |
| カレンダータブの操作 | `selectedIndex: 2` | ミニカレンダー(曜日 + 日付行) + touch_app アイコン |
| ピルタブのボタン | `selectedIndex: 0` | ボタン風 Container (実際の設定ボタンの見た目を再現) |

### 4. touch_app アイコンの配置ルール

- 対象の**下側**に配置（指先がタップ位置に触れる見た目）
- `Positioned(bottom: 0, right: -4〜-6)` + `Icon(Icons.touch_app, size: 22)`
- 親 Container に `clipBehavior: Clip.none` と bottom padding を多めに取る

### 5. 矢印

- `Icons.arrow_downward`（size: 28, color: AppColors.primary）
- `Icons.keyboard_arrow_down` は使わない（Expandable に見えるため）

### 6. L10n キー命名規則

| キー | 用途 |
|---|---|
| `{feature}FeatureAppealTitle` | AppBar タイトル |
| `{feature}FeatureAppealHeadline` | 見出し |
| `{feature}FeatureAppealBody` | 本文（現在未使用、将来用） |
| `{feature}FeatureAppealPoint1/2/3` | フィーチャーカードのテキスト |
| `featureAppealLocationLabel` | 「アプリ内の場所」共通ラベル |
| `featureAppealTryFeature` | 「実際に試す」共通ボタンテキスト |

### 7. AnnouncementBar との関係

- 各機能には AnnouncementBar (`*_announcement_bar.dart`) と HelpPage (`*_help_page.dart`) がセット
- AnnouncementBar タップで HelpPage に遷移
- 日次ローテーション: `daysBetween(epoch, today()) % candidates.length`
- dismiss は SharedPreferences のキーで機能ごとに管理

### 8. Route 定義

```dart
extension XxxHelpPageRoute on XxxHelpPage {
  static Route<dynamic> route() => MaterialPageRoute(
    settings: const RouteSettings(name: 'XxxHelpPage'),
    builder: (_) => const XxxHelpPage(),
  );
}
```

`RouteSettings.name` は必須（FirebaseAnalyticsObserver の screen_view 送信に使用）

### 9. 開発者オプションへの登録

新しい HelpPage を追加したら `lib/features/settings/components/rows/feature_appeal_help_page_list_page.dart` の `pages` リストにエントリを追加する

## 対象ファイル

| ファイル | 操作 |
|---|---|
| `lib/features/feature_appeal/CLAUDE.md` | 新規作成 |

## 検証

- CLAUDE.md の内容が既存8ページの実装と矛盾しないこと
- 新しい HelpPage を追加する手順が CLAUDE.md だけで分かること
