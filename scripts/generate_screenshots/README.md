# generate_screenshots

App Store 用スクリーンショットを、シミュレータ・実機ビルドなしで生成・配置するスクリプト群。

`flutter test` の widget test で画面を描画し、`RepaintBoundary` を PNG 化して書き出す方式。
描画に使う Widget は `lib/features/appstore_screenshot/`、撮影ハーネスは
`test/appstore_screenshot/generate_screenshots_test.dart`。

## データフロー

```
fetch_fonts.sh
  └─ google/fonts から Noto フォントを取得 → scripts/generate_screenshots/fonts/*.ttf

generate_appstore_screenshots.sh -l LANGS -n PAGES --variant NAME
  └─ 環境変数 SCREENSHOT_LANGS / SCREENSHOT_PAGES / SCREENSHOT_VARIANT を渡して
     flutter test test/appstore_screenshot/generate_screenshots_test.dart を実行
       └─ 各 (言語, ページ):
            L と MaterialApp.locale を対象ロケールへ差し替え
            → screenshotPage() を 1290×2796 で描画
            → RepaintBoundary.toImage → PNG
            → artifacts/_variant-{NAME}/{fastlaneロケール}/{idx}_APP_IPHONE_67_{idx}.png

apply_variant.sh NAME
  └─ artifacts/_variant-{NAME}/{locale}/*.png を fastlane/screenshots/{locale}/ へ cp -f
```

`{fastlaneロケール}` は `lib/features/appstore_screenshot/screenshot_locale.dart` の
arb→ASC 対応表で決まる。`{idx}` はバリアントの並び順における位置（0 始まり）。
deliver は画像のピクセル寸法でデバイス種別を判定するため、ファイル名のラベル
（`APP_IPHONE_67`）は可読性のためだけに使う。

## バリアント（Custom Product Page 別のページ並び順）

`--variant` でページの表示順を切り替える。v1 はコピー差し替えなしで、CPP ごとに
主役ページを先頭へ並べ替える。定義の SSOT は
`lib/features/appstore_screenshot/screenshot_variant.dart`（未知の名前を渡すとエラー）。
設計根拠は `cpp/plan.md`。

| variant | ページ並び順 | 主役 | 備考 |
| --- | --- | --- | --- |
| `main` | 1,2,3,4,5 | 社会的証明 | 通常配信 |
| `cpp-reminder` | 4,2,1,3,5 | 複数回リマインド | 飲み忘れ防止・王道 |
| `cpp-privacy` | 3,1,2,4,5 | 伏せた通知 | プライバシー独自性 |
| `cpp-menstruation` | 5,2,1,4,3 | 生理管理 | クロスセル集客 |
| `cpp-beginner` | 2,4,1,3,5 | ピルシート | 初心者オンボーディング |
| `cpp-birthcontrol` | 1,3,2,4,5 | 社会的証明 | 英語圏専用（`-l en` で生成） |

## 使い方

```sh
# 1. フォント取得（冪等。取得済みはスキップ）
bash scripts/generate_screenshots/fetch_fonts.sh

# 2. 生成（例: 日本語 p1 のみ）
bash scripts/generate_screenshots/generate_appstore_screenshots.sh -l ja -n 1

#    多言語・全ページ
bash scripts/generate_screenshots/generate_appstore_screenshots.sh -l en,ar,zh,th
bash scripts/generate_screenshots/generate_appstore_screenshots.sh   # 全対象言語・全ページ

# 3. fastlane/screenshots へ配置
bash scripts/generate_screenshots/apply_variant.sh main

# CPP バリアント（ページ並び替え）
bash scripts/generate_screenshots/generate_appstore_screenshots.sh --variant cpp-privacy
bash scripts/generate_screenshots/generate_appstore_screenshots.sh --variant cpp-birthcontrol -l en
```

## スクリプト

| スクリプト | 役割 |
| --- | --- |
| `appstore_screenshot_env.sh` | 共通設定（バリアント既定値・各種パス）。他スクリプトから source する |
| `fetch_fonts.sh` | Noto フォント一式を取得（冪等・検証付き） |
| `generate_appstore_screenshots.sh` | `-l` / `-n` / `--variant` を解釈して撮影ハーネスを実行 |
| `apply_variant.sh` | 生成物を `fastlane/screenshots/` へ配置 |

## SSOT

- **arb→ASC ロケール対応 / 生成対象言語**: `lib/features/appstore_screenshot/screenshot_locale.dart`
- **バリアント別のページ並び順**: `lib/features/appstore_screenshot/screenshot_variant.dart`
- **出力寸法・レイアウト比率**: `lib/features/appstore_screenshot/screenshot_device.dart`

シェル側はこれらを複製しない（`apply_variant.sh` は生成済みディレクトリ名を辿って配置する）。

## 生成物の扱い

`fonts/` と `artifacts/` は `.gitignore` 対象（フォントは再取得可能、画像は再生成可能なため）。
`fastlane/` 配下もリポジトリ全体で `.gitignore` 済み。
