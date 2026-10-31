#!/usr/bin/env bash
# managed-by: setup-snapshot-testing (bannzai/castle)
# snapshot テスト (test/snapshot/) が読み込む Noto フォントを test/snapshot/fonts/ に取得する。
#
# flutter test には実フォントが無く文字が Ahem (四角) になり、同じ長さの文言・翻訳の違いを画像で比べられないため、実フォントを読み込む。
# 取得元は google/fonts (OFL)。基準画像の描画を揺らさないため commit を固定して取得する。版を上げたら基準画像を撮り直す。
# 言語を足す時は FONTS に google/fonts の ofl/ の下のパスを足す (ファイル名の [ ] , は URL エンコードする)
#
# 冪等: 取得済み (サイズが 0 でない) のファイルは取得しない
set -euo pipefail

GOOGLE_FONTS_COMMIT=6c1dbe27dcf7d817d4b62cec033ba77fa8e2a5ec
DEST="$(cd "$(dirname "$0")/../.." && pwd)/test/snapshot/fonts"
mkdir -p "$DEST"

# 出力のファイル名と google/fonts の中のパス
FONTS="
NotoSans.ttf ofl/notosans/NotoSans%5Bwdth%2Cwght%5D.ttf
NotoSansJP.ttf ofl/notosansjp/NotoSansJP%5Bwght%5D.ttf
NotoEmoji.ttf ofl/notoemoji/NotoEmoji%5Bwght%5D.ttf
"

while read -r name path; do
  [ -n "${name:-}" ] || continue
  if [ -s "$DEST/$name" ]; then
    echo "skip (取得済み): $name"
    continue
  fi
  curl -fsSL --retry 3 "https://raw.githubusercontent.com/google/fonts/$GOOGLE_FONTS_COMMIT/$path" -o "$DEST/$name.tmp"
  mv "$DEST/$name.tmp" "$DEST/$name"
  echo "ok: $name"
done <<EOF
$FONTS
EOF
