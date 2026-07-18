#!/bin/sh
# 指定した Simulator 上で、言語ごとに端末言語を切り替えながら Maestro で 5 ページを撮影する。
# capture_screenshots.sh（ローカル）と .github/workflows/appstore-screenshots.yml（GitHub Actions）が
# 共通で使う撮影本体。SCREENSHOT_CATALOG=true でビルドしたアプリが install 済みの
# 起動中 Simulator を前提とする（build / install は呼び出し側の責務）。
#
# 使い方:
#   bash scripts/generate_screenshots/capture_langs.sh --udid UDID -l LANGS
#     --udid UDID  撮影に使う起動済み Simulator の UDID
#     -l LANGS     カンマ区切りの arb 言語コード

set -eu

. "$(cd "$(dirname "$0")" && pwd)/appstore_screenshot_env.sh"

LANGS=""
DEVICE_UDID=""
APP_ID="com.mizuki.Ohashi.Pilll.dev"

while [ $# -gt 0 ]; do
  case "$1" in
    -l) LANGS="$2"; shift 2 ;;
    --udid) DEVICE_UDID="$2"; shift 2 ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
done

if [ -z "$DEVICE_UDID" ] || [ -z "$LANGS" ]; then
  echo "usage: capture_langs.sh --udid UDID -l LANGS" >&2
  exit 1
fi

cd "$SCREENSHOT_PROJECT_ROOT"

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

# 言語ごとに端末言語を切り替え、Maestro フローを実行して 5 ページ撮影。
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

# 寸法検証（1290×2796 であること）。
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
