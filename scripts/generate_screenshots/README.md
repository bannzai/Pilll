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

## iPhone Duo（外側 1398×2034・内側 2853×2007）

Apple の Screenshot specifications（ https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications ）
に載る iPhone Duo の寸法で、同じ 7 ページ × 32 言語を撮る。内側は仕様が縦（2007×2853）も受け付けるが、
開いた姿勢の Simulator が回転なしで横長（2853×2007）を返すため横で作る。
正式経路と同じカタログアプリを iPhone Duo Simulator に載せ、姿勢（閉じた = 外側、開いた = 内側）
ごとに全言語を撮る。全画面プレビューは画面の縦横比から `ScreenshotDevice` を選ぶため、
同じビルドで 6.7" / Duo 外側 / Duo 内側の 3 種を撮れる。

```
capture_duo_screenshots.sh [-l LANGS] [--poses closed,open] [--skip-build] [--udid UDID]
  ├─ sim-boot（SIM_DEVICE_TYPE="iPhone Duo"）で Simulator を起動
  ├─ $FLUTTER build ios --simulator -t lib/main.dev.dart --dart-define=SCREENSHOT_CATALOG=true → simctl install
  ├─ 姿勢ごと（duo-pose.sh set closed|open）に、言語ごと:
  │    端末言語を切替 → Documents/screenshot_autoplay.txt を書いて起動
  │    → アプリが各ページを全画面表示して screenshot_ready.txt を書く
  │    → ホストが simctl io screenshot --display=primary|primary-1 で撮り、magick で alpha を除去し、
  │      screenshot_ack.txt を書く（同期手順は lib/features/appstore_screenshot/screenshot_autoplay.dart）
  │    出力: artifacts/iphone-duo/_captured/{outer|inner}/{arbコード}/p{N}.png
  └─ 寸法（1398×2034 / 2853×2007）・alpha 無し・枚数を sips で検証

organize_duo_screenshots.dart（dart run）
  └─ _captured/{outer|inner}/{lang}/p{N}.png を main の並び順で
     artifacts/iphone-duo/{ASCロケール}/{idx}_APP_IPHONE_DUO_{OUTER|INNER}_p{N}.png へ 37 ロケール展開
```

```sh
FLUTTER=~/fvm/versions/3.44.9/bin/flutter bash scripts/generate_screenshots/capture_duo_screenshots.sh   # 全32言語 × 外側・内側
dart run scripts/generate_screenshots/organize_duo_screenshots.dart
```

- `FLUTTER`: Xcode 27 の Simulator ビルドは Flutter 3.44.8 以降が要る（3.41.9 は lipo の `-verify_arch` で失敗した）。未指定は PATH の `flutter`
- `DUO_POSE_SH`: 姿勢切替スクリプト（既定 `~/.claude/skills/ios-simulator/scripts/duo-pose.sh`。Device Hub のウィンドウを
  アクセシビリティ API で操作するためローカルの Mac 限定で、GitHub Actions では撮れない）
- `magick`（ImageMagick）: `xcrun simctl io screenshot` の PNG は alpha 付き（`sips -g hasAlpha` が yes）で、
  Apple の Screenshot specifications は「Images can't include alpha channels or transparencies.」としているため除去する
- OS が描く時刻・Wi-Fi の表示は消せない。iOS 27.1 の iPhone Duo Simulator は、アプリがステータスバーを隠しても
  （`Info.plist` の `UIViewControllerBasedStatusBarAppearance` = false で全画面表示）、外側ディスプレイの右端の列と
  内側ディスプレイの右上に時刻・Wi-Fi を描き続けた（ja の 14 枚で実測。`simctl status_bar override` を手で打っても
  表示自体は残った）。そのためスクリプトが `simctl status_bar override --time 9:41 --wifiMode active --wifiBars 3
  --cellularMode notSupported --batteryState discharging --batteryLevel 100` で全ページ同じ見た目に固定し、終了時に
  `status_bar clear` で戻す。`ScreenshotDevice` の文言の帯・フレームの座標はこの表示に掛からない位置にしてある
  （`lib/features/appstore_screenshot/screenshot_device.dart` のコメント）。OS の表示が無い画像が要る時は
  widget test レンダラ（下の「高速プレビュー経路」の `SCREENSHOT_DEVICE=duo-outer|duo-inner`）で描けるが、
  フォントは Simulator 撮影と異なる
- Maestro の `capture.yaml` は使わない。Maestro の `takeScreenshot` は XCTest 経由で、XCTest の API では開いた姿勢の内側ディスプレイを
  仕様の寸法で撮れない（`XCUIScreen.main` は外側の 1398×2034、`screens[1]` は 90 度回った 2006×2852 を返す。
  appstore-screenshot-builder skill `references/iphone-duo.md` の実測）ため、ホスト側の `simctl io screenshot` で撮る

**配置先と配信**: fastlane deliver は Duo の寸法を知らず（`deliver/lib/deliver/app_screenshot.rb` の `DEVICE_RESOLUTIONS` に無い）、
`fastlane/screenshots/{locale}/` に置くと検証で全体が止まる。そのため `artifacts/iphone-duo/` に出し、
`apply_variant.sh` と `organize_screenshots.dart` の対象にしない。App Store Connect への登録は Web UI
（App Store > バージョン > iPhone Duo の枠へドラッグ）か、`APP_IPHONE_DUO` に対応した
`asc`（rorkai/App-Store-Connect-CLI 5.12.0 以降。`asc --version` で確認）で行う:

外側と内側は 1 つの枠（最大 10 枚）に入るため、`organize_duo_screenshots.dart` が出す 14 枚すべては登録できない。
どの 10 枚を選ぶかは配信時に決め、選んだ 10 枚だけを集めたディレクトリを作ってから渡す
（ロケールのディレクトリをそのまま渡すと、ファイル名順で外側と内側が交互に並び、上限を超えた分が失敗する）:

外側を先に並べたい時は、コピー先で外側に 0〜6、内側に 7〜9 の番号を付け直す（展開後の名前は `<idx>` ごとに
INNER と OUTER が交互に並ぶ。asc がファイル名順に上げるかは未確認で、順序を名前で固定しておく方が安全）:

```sh
mkdir -p tmp/duo-upload/<locale>
for n in 1 2 3 4 5 6 7; do cp scripts/generate_screenshots/artifacts/iphone-duo/<locale>/*_OUTER_p$n.png tmp/duo-upload/<locale>/$((n - 1))_APP_IPHONE_DUO_OUTER_p$n.png; done
for n in 1 2 3; do cp scripts/generate_screenshots/artifacts/iphone-duo/<locale>/*_INNER_p$n.png tmp/duo-upload/<locale>/$((n + 6))_APP_IPHONE_DUO_INNER_p$n.png; done
asc screenshots upload --version-localization <LOCALIZATION_ID> --path tmp/duo-upload/<locale> --device-type APP_IPHONE_DUO --skip-existing
```

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
            （SCREENSHOT_DEVICE=duo-outer|duo-inner を渡すと iPhone Duo の寸法で描き、
              artifacts/_preview-APP_IPHONE_DUO_{OUTER|INNER}/ へ出す。apply_variant.sh の対象外）

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
| `capture_duo_screenshots.sh` | iPhone Duo Simulator で姿勢（外側・内側）ごとに全言語を撮影し、寸法・alpha・枚数を検証する（ローカル限定） |
| `organize_duo_screenshots.dart` | iPhone Duo の撮影結果を通常商品ページの 37 ロケールへ展開する（`artifacts/iphone-duo/`） |
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
