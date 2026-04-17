# FeatureAppeal HelpPage 指示書

HelpPage を新規追加・修正する際のルール。既存8ページの実装パターンに従うこと。

## ページ構成

```
Scaffold
├─ AppBar (機能名)
├─ body: SingleChildScrollView(padding: fromLTRB(24, 24, 24, 40))
│  └─ Column
│     ├─ SVG Icon (Center, 80x80)
│     ├─ Headline (Center, fontSize: 22, w700)
│     ├─ Feature Cards × 3 (_featureCard)
│     ├─ 「アプリ内の場所」ラベル (L.featureAppealLocationLabel)
│     ├─ _mockTabBar(selectedIndex: N)
│     ├─ ↓ 矢印 (Icons.arrow_downward, size: 28, AppColors.primary)
│     └─ コンポーネントプレビュー（任意・タブバーだけでも可）
└─ bottomNavigationBar: SafeArea > Padding(16) > PrimaryButton(L.featureAppealTryFeature = "確認する")
```

## レイアウト禁止事項

- `bottomNavigationBar` 内に `Center` を入れない。Scaffold が loose height constraints を渡すため `Center` が最大高さに膨張し body 領域が 0 になる
- `if (!xxxAsync.hasValue) return SizedBox.shrink()` でローディングガードしない。ページ全体（AppBar 含む）が消える

## 「確認する」ボタンの遷移先ルール

**遷移先はタブ移動のみに統一する**。個別の機能ページへの直接遷移はしない。

- 理由: 動線の判断コストを下げる。まずは該当タブに飛ばしてユーザーに探索させる方針
- ボタン文言も「確認する」（履歴確認など「試す」でない機能にも合わせるため）

```dart
final tabController = ref.read(homeTabControllerProvider);
Navigator.of(context).popUntil((r) => r.isFirst);
tabController?.animateTo(HomePageTabType.{record|menstruation|calendar|setting}.index);
```

Premium 機能の場合のみ、タブ移動前に `ref.watch(userProvider).requireValue` で user を取得し、`!user.premiumOrTrial` のとき `showPremiumIntroductionSheet(context)` でペイウォール表示。

## ステップバイステップガイド

### 矢印

`Icons.arrow_downward`（size: 28, color: AppColors.primary）を使う。`Icons.keyboard_arrow_down` は Expandable に見えるため使わない。

### touch_app アイコン

- 対象の**下側**に配置する（指先がタップ位置に触れる見た目）
- `Positioned(bottom: 0, right: -4〜-6)` + `Icon(Icons.touch_app, size: 22)`
- 親 Container に `clipBehavior: Clip.none` と bottom padding を多めに設定して見切れを防ぐ

## Feature Card の文言

- **実機能と齟齬がないか必ず確認**する（実装されていない機能を書かない）
- 過去の事例: 「検索」機能は未実装なのに Feature Card に記載されていた
- アイコンも内容と合っているか確認

## L10n キー命名

| キー | 用途 |
|---|---|
| `{feature}FeatureAppealTitle` | AppBar タイトル |
| `{feature}FeatureAppealHeadline` | 見出し |
| `{feature}FeatureAppealBody` | 本文（将来用） |
| `{feature}FeatureAppealPoint1/2/3` | フィーチャーカードのテキスト |
| `featureAppealLocationLabel` | 「アプリ内の場所」共通ラベル |
| `featureAppealTryFeature` | 「確認する」共通ボタンテキスト |

## AnnouncementBar との関係

- 各機能には AnnouncementBar (`*_announcement_bar.dart`) と HelpPage (`*_help_page.dart`) がセット
- AnnouncementBar タップで HelpPage に遷移する
- 日次ローテーション: `daysBetween(epoch, today()) % candidates.length`
- dismiss は SharedPreferences のキーで機能ごとに管理

## Route 定義

```dart
extension XxxHelpPageRoute on XxxHelpPage {
  static Route<dynamic> route() => MaterialPageRoute(
    settings: const RouteSettings(name: 'XxxHelpPage'),
    builder: (_) => const XxxHelpPage(),
  );
}
```

`RouteSettings.name` は必須（FirebaseAnalyticsObserver の screen_view 送信に使用）。

## 新規 HelpPage 追加時の手順

1. `lib/features/feature_appeal/{feature}/` にディレクトリ作成
2. `{feature}_help_page.dart` を既存ページをコピーして作成（ConsumerWidget推奨）
3. `{feature}_announcement_bar.dart` を作成
4. `lib/l10n/app_ja.arb` / `app_en.arb` に L10n キーを追加（Title, Headline, Point1/2/3）
5. `flutter gen-l10n` で生成
6. `lib/features/feature_appeal/feature_appeal_bars_container.dart` に AnnouncementBar を登録
7. `lib/features/settings/components/rows/feature_appeal_help_page_list_page.dart` の `pages` リストにエントリを追加
