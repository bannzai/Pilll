#!/bin/sh
# 指定した Simulator 上で、言語ごとに .maestro/flows/translation_screenshot/capture.yaml を実行して主要画面を撮る。
# .github/workflows/translation-screenshots.yml が言語グループごとに呼ぶ撮影本体で、ローカルでも同じ形で使える。
# dev の debug ビルドが install 済みの起動中 Simulator を前提とする (build / install は呼び出し側の責務)。
# 出力は scripts/translation_screenshots/artifacts/<画面>/<言語>.png (撮る画面は flow の takeScreenshot)。
#
# 使い方:
#   sh scripts/translation_screenshots/capture_langs.sh --udid UDID -l LANGS
#     --udid UDID  撮影に使う起動済み Simulator の UDID
#     -l LANGS     カンマ区切りの arb 言語コード

set -eu

LANGS=""
DEVICE_UDID=""
APP_ID="com.mizuki.Ohashi.Pilll.dev"
FLOW=".maestro/flows/translation_screenshot/capture.yaml"
ARTIFACT_DIR="scripts/translation_screenshots/artifacts"

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

cd "$(dirname "$0")/../.."

# arb 言語コード → iOS の言語 ID。DateTimeFormatter と Material の組み込み文言は端末の言語に従うため、
# 撮影言語ごとに端末の言語も切り替えて利用者と同じ表示にする。
# 対応は scripts/generate_screenshots/capture_langs.sh と同じ (arb と iOS で表記が異なるのは pt・zh・no のみ)。
ios_language_id() {
  case "$1" in
    pt) echo "pt-BR" ;;
    zh) echo "zh-Hans" ;;
    no) echo "nb" ;;
    *) echo "$1" ;;
  esac
}

# flow の takeScreenshot の数。1 言語あたりこの枚数の png が揃えば成功とする
screen_count="$(grep -c '^- takeScreenshot:' "$FLOW")"

# 遅い環境 (GitHub Actions Runner) では描画待ちでフローが落ちることがあるため、言語単位でやり直す。
# 回数は scripts/generate_screenshots/capture_langs.sh と同じ
MAX_ATTEMPTS=3
failed_langs=""
for lang in $(printf '%s' "$LANGS" | tr ',' ' '); do
  [ -z "$lang" ] && continue
  case "$lang" in
    *[!A-Za-z0-9_-]*) echo "invalid language code: $lang" >&2; exit 1 ;;
  esac
  ios_lang="$(ios_language_id "$lang")"
  echo "capture: $lang (device language: $ios_lang)"
  xcrun simctl spawn "$DEVICE_UDID" defaults write .GlobalPreferences AppleLanguages -array "$ios_lang"
  xcrun simctl spawn "$DEVICE_UDID" defaults write .GlobalPreferences AppleLocale -string "$(printf '%s' "$ios_lang" | tr '-' '_')"
  attempt=1
  captured=false
  while [ "$attempt" -le "$MAX_ATTEMPTS" ]; do
    # 前の試行で途中まで撮れた png が成功扱いにならないよう消す
    find "$ARTIFACT_DIR" -type f -name "$lang.png" -delete 2>/dev/null || true
    # 端末の言語はアプリの起動時に読まれるため、切り替え後にプロセスを終了して Maestro に起動させる
    xcrun simctl terminate "$DEVICE_UDID" "$APP_ID" 2>/dev/null || true
    if maestro --device "$DEVICE_UDID" test "$FLOW" --env "LANG=$lang"; then
      captured=true
      break
    fi
    echo "capture failed: $lang (attempt $attempt/$MAX_ATTEMPTS)" >&2
    attempt=$((attempt + 1))
  done
  if [ "$captured" = false ]; then
    failed_langs="$failed_langs $lang"
  fi
done

echo ""
echo "verify:"
bad=0
for lang in $(printf '%s' "$LANGS" | tr ',' ' '); do
  count="$(find "$ARTIFACT_DIR" -type f -name "$lang.png" | wc -l | tr -d ' ')"
  if [ "$count" != "$screen_count" ]; then
    echo "  NG: $lang は $count / $screen_count 枚" >&2
    bad=$((bad + 1))
  else
    echo "  OK: $lang ($count 枚)"
  fi
done
if [ -n "$failed_langs" ] || [ "$bad" != "0" ]; then
  echo "撮影に失敗した言語:$failed_langs" >&2
  exit 1
fi
