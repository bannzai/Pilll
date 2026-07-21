# generate_screenshots

App Store 用スクリーンショットを生成・配置するスクリプト群。生成経路は 2 つある。

- **正式（ストア提出用）: Simulator 実描画キャプチャ** — `capture_screenshots.sh`。
  実 iOS のフォント・絵文字で描画されるため見た目が実機と一致する。
- **高速プレビュー: widget test レンダラ** — `generate_appstore_screenshots.sh`。
  シミュレータ・実機ビルド不要で速いが、テスト用フォントで描画するため実機と細部が異なる。
  レイアウト確認やコピー調整の反復に使う。

描画に使う Widget は `lib/features/appstore_screenshot/`（両経路で共通）。
Simulator 経路のカタログアプリは `lib/features/appstore_screenshot/screenshot_catalog_app.dart`、
widget test 撮影ハーネスは `test/appstore_screenshot/generate_screenshots_test.dart`。

## 正式経路: Simulator 実描画キャプチャ

```
capture_screenshots.sh
  ├─ sim-boot で 1290×2796 の Simulator（iPhone 15 Pro Max）を起動
  ├─ flutter build ios --simulator -t lib/main.dev.dart --dart-define=SCREENSHOT_CATALOG=true
  │    → main.dev.dart が entrypoint() を通さず ScreenshotCatalogApp を runApp
  ├─ simctl install
  └─ capture_langs.sh: 言語ごとに .maestro/flows/appstore_screenshot/capture.yaml を実行
       言語一覧タップ → 各ページ全画面表示 → takeScreenshot(1290×2796) → 戻る
       出力: artifacts/simulator/{arbコード}/p{N}.png

organize_screenshots.dart（dart run）
  └─ screenshot_variant.dart の並び順(SSOT)で simulator/{lang}/p{N}.png を
     _variant-{variant}/{fastlaneロケール}/{idx}_APP_IPHONE_67_{idx}.png へ全6バリアント配置
     （CPP は並び替えだけなので撮影は 1 回、ここでファイル並びとして表現）

apply_variant.sh NAME
  └─ _variant-{NAME}/{locale}/*.png を fastlane/screenshots/{locale}/ へ配置
```

**ja の例外**: メイン商品ページの日本語は従来の App Store 掲載スクショ（横長4枚）を維持する方針のため、
`apply_variant.sh main` の後に `fastlane/screenshots/ja/` の中身を `cpp/assets/ja-appstore-202607/` の
4枚へ差し替えてからアップロードする。`fastlane/metadata/ja/` もライブ値のまま維持する（cpp/plan.md 参照）。

**前提（この worktree に無い場合は用意が必要。すべて gitignore 済みのシークレット/設定）:**
- `lib/secret/secret.dart`（`scripts/secret.sh` が secret.dart.sample と env から生成）
- `ios/Flutter/Secret.xcconfig`（`ios/Flutter/Debug.xcconfig` が `#include`。bundle id 等を定義）
- `ios/Runner/GoogleService-Info.plist`（Firebase）
- `environment/dev.json`（`--dart-define-from-file`）
- `ios/Pods`（worktree では `flutter-pod-warmup`。※このリポジトリでは `flutter build ... --config-only` で pod install 完走を確認済み）

```sh
bash scripts/generate_screenshots/capture_screenshots.sh -l ja            # ja だけ
bash scripts/generate_screenshots/capture_screenshots.sh                  # 全32言語
dart run scripts/generate_screenshots/organize_screenshots.dart           # 全6バリアントへ並べ替え
bash scripts/generate_screenshots/apply_variant.sh main
```

### GitHub Actions での並列撮影（ローカル Mac の資源を使わない）

`.github/workflows/appstore-screenshots.yml` が同じ経路（カタログアプリビルド +
`capture.yaml` + `capture_langs.sh`）を macOS Runner 上で実行する。ビルドは 1 回だけ行って
artifact 共有し、言語を `group_count`（既定 5）グループへ分割して Runner を並列に使う。

```sh
gh workflow run appstore-screenshots.yml --ref <branch>
gh run watch <run-id>

# 生成物の回収: 各グループの artifact を artifacts/simulator/ へマージする
gh run download <run-id> -p 'simulator-screenshots-*' -D tmp/ci-screenshots
for d in tmp/ci-screenshots/simulator-screenshots-*/; do
  cp -R "$d". scripts/generate_screenshots/artifacts/simulator/
done
```

通常商品ページは32言語の撮影元から地域別派生を含む37ロケールへ展開する。
CPPはロシア語と地域別派生を除いた31代表ロケールを使用し、英語圏専用の
`cpp-birthcontrol`だけは`en-US`のみを使用する。最終的な画像数は通常商品ページ259枚、
CPP 5種875枚、合計1134枚。

## 高速プレビュー経路: widget test レンダラ

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
| `main` | 1,2,3,4,5,6,7 | 社会的証明 | 通常配信 |
| `cpp-reminder` | 4,7,2,1,3,5,6 | 複数回リマインド | 飲み忘れ防止・王道。服用履歴(p7)を2枚目に |
| `cpp-privacy` | 3,1,2,4,5,6,7 | 伏せた通知 | プライバシー独自性 |
| `cpp-menstruation` | 5,6,2,1,4,3,7 | 生理管理 | クロスセル集客。カレンダー(p6)を2枚目に |
| `cpp-beginner` | 2,4,1,3,5,6,7 | ピルシート | 初心者オンボーディング |
| `cpp-birthcontrol` | 1,3,2,4,5,6,7 | 社会的証明 | 英語圏専用（`-l en` で生成） |

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
| `capture_screenshots.sh` | ローカルでsim-boot・ビルド・installして`capture_langs.sh`を呼ぶ |
| `capture_langs.sh` | install済みSimulator上で言語ごとに撮影・寸法検証する（ローカル/GitHub Actions共通） |
| `organize_screenshots.dart` | Simulator撮影結果を通常商品ページ・CPPのロケールへ展開する |
| `print_langs.dart` | 撮影元となる全言語をSSOTから出力する |
| `print_store_locales.dart` | 通常商品ページの全37ロケールをSSOTから出力する |
| `apply_variant.sh` | 指定バリアントの生成物を`fastlane/screenshots/`へ配置する |

## SSOT

- **arb→ASC ロケール対応 / 生成対象言語**: `lib/features/appstore_screenshot/screenshot_locale.dart`
- **バリアント別のページ並び順**: `lib/features/appstore_screenshot/screenshot_variant.dart`
- **出力寸法・レイアウト比率**: `lib/features/appstore_screenshot/screenshot_device.dart`

シェル側はこれらを複製しない（`apply_variant.sh` は生成済みディレクトリ名を辿って配置する）。

## 生成物の扱い

`fonts/`、`artifacts/`、`fastlane/screenshots/`は`.gitignore`対象
（フォントと画像は再生成可能なため）。`fastlane/Appfile`、`fastlane/Fastfile`、
`fastlane/metadata/`はApp Store Connectへ反映する設定・メタデータとして追跡する。
