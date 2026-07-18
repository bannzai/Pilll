# appstore_screenshot

App Store 用スクリーンショットを生成するための Widget 群。

正式なストア用画像は`ScreenshotCatalogApp`をiPhone 15 Pro Max Simulatorで実描画し、
Maestroから1290×2796のPNGとして撮影する。widget test
（`test/appstore_screenshot/generate_screenshots_test.dart`）は同じWidgetを使う高速プレビューで、
レイアウト調整に使用する。撮影・出力の仕組みや実行スクリプトは
`scripts/generate_screenshots/README.md`を参照。

## 役割・使い方

1 枚のスクリーンショットは次のレイヤ構造で構成する。

1. 背景 `LinearGradient`（2色） … `screenshot_background.dart`
2. 上部にキャッチコピー（タイトル＋サブタイトル） … `screenshot_text.dart`
3. コード描画の iPhone フレーム（角丸・ベゼル・Dynamic Island・影） … `device_frame_overlay.dart`
4. フレーム内に論理サイズ 430×932 で描いた Mock 画面を実寸へ拡大 … `mock_screens/`

これらを組み合わせる共通コンテナが `frame_layout.dart`、ページ番号から
（背景・コピー・Mock）を合成して 1 枚分の Widget を返すのが `screenshot_page.dart`。

## ページ構成（5-A）

競合調査（`tmp/research/report.md` 5-A）の 5 枚構成に対応する。

| # | 役割 | Mock 画面 |
| --- | --- | --- |
| 1 | 社会的証明＋中核価値 | ピルシート画面＋通知バナー＋「14万人」バッジ |
| 2 | ピルシート UI | ピルシート画面（曜日ライン・錠番号つき） |
| 3 | 伏せた通知 | ロック画面の伏せ通知 |
| 4 | 複数回リマインド | 積み重なった通知バナー＋服用済み確認 |
| 5 | 生理管理 | 週カレンダー＋生理予定日カード |

## ファイル構成

| ファイル | 役割 |
| --- | --- |
| `screenshot_device.dart` | 出力寸法・レイアウト比率のデバイス定義 SSOT（現状 iPhone 6.7" のみ） |
| `screenshot_locale.dart` | arb 言語コード → ASC（fastlane）ロケール名の対応表 SSOT |
| `screenshot_variant.dart` | バリアント（CPP 別のページ並び順）の対応表 SSOT |
| `screenshot_background.dart` | ページ番号 → 背景グラデーション（2色） |
| `screenshot_text.dart` | 言語×ページ → キャッチコピー（未定義言語はenフォールバック） |
| `device_frame_overlay.dart` | コード描画の iPhone フレーム |
| `frame_layout.dart` | 1 枚のレイヤ構造を組む共通コンテナ |
| `mock_screens/mock_components.dart` | Mock 共通部品（アプリアイコン・通知バナー・描画ヘルパー） |
| `mock_screens/mock_social_proof_screen.dart` | #1 社会的証明 |
| `mock_screens/mock_record_screen.dart` | #2 ピルシート画面 |
| `mock_screens/mock_lock_screen.dart` | #3 伏せた通知（ロック画面） |
| `mock_screens/mock_multiple_reminder_screen.dart` | #4 複数回リマインド |
| `mock_screens/mock_menstruation_screen.dart` | #5 生理管理 |
| `screenshot_page.dart` | ページ番号 → 1 枚分の Widget を合成 |

## 設計上の要点

- **論理サイズで描いて拡大**: Mock 画面は iPhone 相当の論理サイズ 430×932 で描き、
  フレーム内実寸へ `FittedBox` で拡大する。出力ピクセル寸法で直接描くと UI が極小になるため。
- **UI 言語とコピーの両方をロケール切替**: 撮影ハーネスが `MaterialApp.locale` と
  グローバル `L`（`lib/features/localizations/l.dart`）を対象ロケールへ差し替える。
  Mock 画面はフォントファミリーを明示せず、ハーネスが言語ごとに設定するテーマの
  `fontFamily` / `fontFamilyFallback` を継承する（CJK の字形を言語ごとに正しく出すため）。
  スクリーンショット固有のキャッチコピーはMockに渡す`lang`で切り替え、通知や日付などの
  アプリUI文言はARB・`DateTimeFormatter`から取得する。
- **タイトルの折り返し**: タイトルは明示改行（`\n`）だけで改行し、幅を超える行は
  `FittedBox(scaleDown)` で縮小して語中折り返しを防ぐ。
- **本番部品の再利用と豆腐回避**: ピルシートは本番の円マーク部品（`NormalPillMark` 等）で構成する。
  ただし flutter test 環境では SVG アセットと Material Icons が解決されず豆腐になるため、
  チェックマーク・タブ・バッジ等の記号は `CustomPainter` / `Container` で自前描画する。
  通知本文の絵文字は NotoEmoji フォントで描画する。

## 拡張の指針

- **言語追加**: ARB、`screenshot_locale.dart`の対応表、`screenshot_text.dart`の`_copies`を更新する。
  アプリUI文言はARBを利用し、Mock内に言語別文言を重複定義しない。
- **ページ追加**: `mock_screens/` に専用 Mock を追加し、`screenshot_page.dart` の
  `_mockScreen` と `screenshot_variant.dart` の並び順を更新する。
- **バリアント追加**: `screenshot_variant.dart` に「名前 → ページ並び順」を追記する。
- **デバイス追加**: `screenshot_device.dart` に同じフィールド構成で別インスタンスを追加する。
