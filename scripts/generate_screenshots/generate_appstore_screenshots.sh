#!/bin/sh
# App Store スクリーンショットを生成する。
#
# 撮影ハーネス(test/appstore_screenshot/generate_screenshots_test.dart)を
# flutter test で実行し、scripts/generate_screenshots/artifacts/ 配下へ PNG を出力する。
#
# 使い方:
#   bash scripts/generate_screenshots/generate_appstore_screenshots.sh [-l LANGS] [-n PAGES] [--variant NAME]
#     -l LANGS     カンマ区切りの arb 言語コード(例: ja,en,zh)。未指定は全対象言語。
#     -n PAGES     カンマ区切りのページ番号(例: 1,2)。未指定は生成対象の全ページ。
#     --variant N  バリアント名。未指定は main。
#
# 例:
#   bash scripts/generate_screenshots/generate_appstore_screenshots.sh -l ja -n 1
#   bash scripts/generate_screenshots/generate_appstore_screenshots.sh -l en,ar,zh,th

set -eu

. "$(cd "$(dirname "$0")" && pwd)/appstore_screenshot_env.sh"

LANGS=""
PAGES=""
VARIANT="$SCREENSHOT_VARIANT_DEFAULT"

while [ $# -gt 0 ]; do
  case "$1" in
    -l)
      LANGS="$2"
      shift 2
      ;;
    -n)
      PAGES="$2"
      shift 2
      ;;
    --variant)
      VARIANT="$2"
      shift 2
      ;;
    *)
      echo "unknown option: $1" >&2
      exit 1
      ;;
  esac
done

# バリアント名を検証する。定義は screenshot_variant.dart(SSOT)から読み取る。
VALID_VARIANTS="$(grep -oE "'[a-z0-9-]+':" "$SCREENSHOT_VARIANT_FILE" | tr -d "':")"
if ! printf '%s\n' $VALID_VARIANTS | grep -qx "$VARIANT"; then
  echo "unknown variant: $VARIANT" >&2
  echo "valid variants: $(printf '%s ' $VALID_VARIANTS)" >&2
  exit 1
fi

# フォント未取得なら先に案内する(撮影ハーネスも fail するが、ここで早めに気付けるように)。
if [ ! -d "$SCREENSHOT_FONT_DIR" ] || [ -z "$(ls -A "$SCREENSHOT_FONT_DIR" 2>/dev/null)" ]; then
  echo "フォントが未取得です。先に実行してください: bash scripts/generate_screenshots/fetch_fonts.sh" >&2
  exit 1
fi

cd "$SCREENSHOT_PROJECT_ROOT"

echo "generate screenshots: variant=$VARIANT langs=${LANGS:-(all)} pages=${PAGES:-(all)}"

SCREENSHOT_VARIANT="$VARIANT" \
SCREENSHOT_LANGS="$LANGS" \
SCREENSHOT_PAGES="$PAGES" \
  flutter test "$SCREENSHOT_TEST_FILE"

echo ""
echo "出力先: $SCREENSHOT_ARTIFACT_DIR/_variant-$VARIANT/"
