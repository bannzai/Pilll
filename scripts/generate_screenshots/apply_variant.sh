#!/bin/sh
# 生成済みスクリーンショットを fastlane/screenshots へ配置する。
#
# artifacts/_variant-{name}/{locale}/*.png を fastlane/screenshots/{locale}/ へ cp -f する。
# deliver は fastlane/screenshots/{locale}/ 配下の PNG をアップロード対象にする。
#
# 使い方:
#   bash scripts/generate_screenshots/apply_variant.sh [VARIANT]
#     VARIANT  バリアント名。未指定は main。

set -eu

. "$(cd "$(dirname "$0")" && pwd)/appstore_screenshot_env.sh"

VARIANT="${1:-$SCREENSHOT_VARIANT_DEFAULT}"
SRC_DIR="$SCREENSHOT_ARTIFACT_DIR/_variant-$VARIANT"
DEST_ROOT="$SCREENSHOT_PROJECT_ROOT/fastlane/screenshots"

if [ ! -d "$SRC_DIR" ]; then
  echo "生成物が見つかりません: $SRC_DIR" >&2
  echo "先に generate_appstore_screenshots.sh --variant $VARIANT を実行してください。" >&2
  exit 1
fi

count=0
for locale_dir in "$SRC_DIR"/*/; do
  [ -d "$locale_dir" ] || continue
  locale="$(basename "$locale_dir")"
  dest="$DEST_ROOT/$locale"
  mkdir -p "$dest"
  for png in "$locale_dir"*.png; do
    [ -f "$png" ] || continue
    cp -f "$png" "$dest/"
    count=$((count + 1))
    echo "applied: $locale/$(basename "$png")"
  done
done

echo ""
echo "配置完了: $count 枚を $DEST_ROOT/ 配下へ配置しました(variant=$VARIANT)。"
