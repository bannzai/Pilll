#!/bin/sh
# App Store スクリーンショットを iOS Simulator の実描画から撮影する（正式な生成経路）。
#
# ScreenshotCatalogApp（lib/main.dev.dart の SCREENSHOT_CATALOG 分岐）を Simulator に載せ、
# Maestro で「言語 × 5 ページ」を全画面表示して OS スクリーンショット（1290×2796）を撮る。
# widget test 方式（generate_appstore_screenshots.sh）は実 iOS フォントと見た目が異なるため
# 高速プレビュー用に残すが、ストア提出用の正式な生成はこちらを使う。
#
# 前提（この worktree に無い場合は用意が必要）:
# - lib/secret/secret.dart（scripts/secret.sh で生成。REVENUE_CAT 等の env が必要）
# - ios/Flutter/Secret.xcconfig（Debug.xcconfig が #include）
# - ios/Runner/GoogleService-Info.plist（Firebase）
# - environment/dev.json（--dart-define-from-file）
# - ios/Pods（worktree では flutter-pod-warmup で用意）
#
# 使い方:
#   bash scripts/generate_screenshots/capture_screenshots.sh [-l LANGS] [--device "iPhone 15 Pro Max"]
#     -l LANGS   カンマ区切りの arb 言語コード（未指定は全対象言語）
#     --device   1290×2796 になる Simulator 機種名（既定 iPhone 15 Pro Max）

set -eu

. "$(cd "$(dirname "$0")" && pwd)/appstore_screenshot_env.sh"

# iPhone 15 Pro Max は 1290×2796（App Store 6.7"）。16 Pro Max は 1320×2868 なので使わない。
LANGS=""
DEVICE="iPhone 15 Pro Max"
APP_ID="com.mizuki.Ohashi.Pilll.dev"

while [ $# -gt 0 ]; do
  case "$1" in
    -l) LANGS="$2"; shift 2 ;;
    --device) DEVICE="$2"; shift 2 ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
done

cd "$SCREENSHOT_PROJECT_ROOT"

# 対象言語（未指定は screenshot_locale.dart の全対象言語を dart で取得）。
if [ -z "$LANGS" ]; then
  LANGS="$(dart run scripts/generate_screenshots/print_langs.dart)"
fi

# 1. Simulator 起動（プロジェクト規約: sim-boot 経由。1290×2796 の機種を選ぶ）。
# sim-boot の第1引数は SIM_NAME なので、デバイス型は SIM_DEVICE_TYPE で指定する。
echo "boot simulator: $DEVICE"
DEVICE_UDID="$(SIM_DEVICE_TYPE="$DEVICE" sim-boot | awk -F= '/^DEVICE_UDID=/{print $2}')"
if [ -z "$DEVICE_UDID" ]; then
  echo "sim-boot で DEVICE_UDID を取得できませんでした" >&2
  exit 1
fi
echo "DEVICE_UDID=$DEVICE_UDID"

# 2. カタログアプリをビルド（Firebase 初期化は通らないが、アプリ全体はコンパイルされる）。
echo "build catalog app (SCREENSHOT_CATALOG=true)"
# --flavor は付けない。Xcode に Debug-Development 構成が無く flavor 指定の Debug ビルドは
# 失敗する（Release は simulator 非対応）。dev の bundle id は Debug.xcconfig が include する
# Secret.xcconfig 由来で、flavor 無しでも com.mizuki.Ohashi.Pilll.dev になる（実測確認済み）。
flutter build ios --simulator -t lib/main.dev.dart \
  --dart-define=SCREENSHOT_CATALOG=true \
  --dart-define-from-file=environment/dev.json

# 3. Simulator へインストール。
xcrun simctl install "$DEVICE_UDID" build/ios/iphonesimulator/Runner.app

# arb 言語コード → iOS の言語 ID。DateTimeFormatter が Platform.localeName(=端末言語)で
# DateFormat を作るため、撮影言語ごとに端末言語を切り替えて実アプリと同じ日付書式にする。
# arb と iOS で表記が異なるのは pt(ブラジル)・zh(簡体)・no(ブークモール)のみ。
ios_language_id() {
  case "$1" in
    pt) echo "pt-BR" ;;
    zh) echo "zh-Hans" ;;
    no) echo "nb" ;;
    *) echo "$1" ;;
  esac
}

# 4. 言語ごとに端末言語を切り替え、Maestro フローを実行して 5 ページ撮影。
# カンマ区切りの LANGS を空白区切りへ変換して 1 言語ずつ確実に分割する。
for lang in $(printf '%s' "$LANGS" | tr ',' ' '); do
  [ -z "$lang" ] && continue
  case "$lang" in
    *[!A-Za-z0-9_-]*) echo "invalid language code: $lang" >&2; exit 1 ;;
  esac
  lang_artifact_dir="$SCREENSHOT_ARTIFACT_DIR/simulator/$lang"
  # この言語の生成物だけを作り直し、前回撮影のp*.pngが成功扱いになるのを防ぐ。
  if [ -d "$lang_artifact_dir" ]; then
    find "$lang_artifact_dir" -maxdepth 1 -type f -name 'p*.png' -delete
  fi
  mkdir -p "$lang_artifact_dir"
  ios_lang="$(ios_language_id "$lang")"
  echo "capture: $lang (device language: $ios_lang)"
  xcrun simctl spawn "$DEVICE_UDID" defaults write .GlobalPreferences AppleLanguages -array "$ios_lang"
  xcrun simctl spawn "$DEVICE_UDID" defaults write .GlobalPreferences AppleLocale -string "$(printf '%s' "$ios_lang" | tr '-' '_')"
  # 言語設定はアプリ起動時に読まれるため、切替後に必ずプロセスを終了して Maestro に再起動させる。
  xcrun simctl terminate "$DEVICE_UDID" "$APP_ID" 2>/dev/null || true
  maestro --device "$DEVICE_UDID" test .maestro/flows/appstore_screenshot/capture.yaml --env "LANG=$lang"
done

# 5. 寸法検証（1290×2796 であること）。
echo ""
echo "verify dimensions:"
bad=0
verified=0
for lang in $(printf '%s' "$LANGS" | tr ',' ' '); do
  for page in 1 2 3 4 5; do
    png="$SCREENSHOT_ARTIFACT_DIR/simulator/$lang/p$page.png"
    if [ ! -f "$png" ]; then
      echo "  NG (missing): $png" >&2
      bad=$((bad + 1))
      continue
    fi
    w="$(sips -g pixelWidth "$png" | awk '/pixelWidth/{print $2}')"
    h="$(sips -g pixelHeight "$png" | awk '/pixelHeight/{print $2}')"
    if [ "$w" != "1290" ] || [ "$h" != "2796" ]; then
      echo "  NG ($w x $h): $png" >&2
      bad=$((bad + 1))
    fi
    verified=$((verified + 1))
  done
done
if [ "$bad" != "0" ]; then
  echo "寸法が 1290×2796 でない画像が $bad 枚あります。" >&2
  exit 1
fi
echo "  OK: $verified 枚"

echo ""
echo "撮影完了: $SCREENSHOT_ARTIFACT_DIR/simulator/ 配下"
echo "次に並べ替え配置: dart run scripts/generate_screenshots/organize_screenshots.dart"
