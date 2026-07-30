#!/bin/sh
# スクリーンショット描画に使う Noto フォント一式を取得する。
#
# flutter test 環境には実フォントが無く、文字が Ahem(豆腐)になるため、
# 撮影ハーネスが FontLoader で読み込む ttf をここで用意する。
#
# 取得元は google/fonts リポジトリ(OFL ライセンス)。可変フォントはファイル名に
# 軸(例: NotoSans[wdth,wght].ttf)が付き、フォントごとに軸構成が異なるため、
# GitHub API で実ファイル名を都度取得してからダウンロードする。
#
# 冪等性: 既に取得済み(サイズ非ゼロ)のフォントはスキップする。
# 検証: ダウンロード後にサイズ非ゼロ・file コマンドで TrueType/OpenType であることを確認する。
#       HTML(404 ページ等)が落ちてきた場合は破棄して失敗扱いにする。
#
# GITHUB_TOKEN があれば API のレート制限緩和のため Authorization ヘッダに使う。

set -eu

. "$(cd "$(dirname "$0")" && pwd)/appstore_screenshot_env.sh"

mkdir -p "$SCREENSHOT_FONT_DIR"

if [ -n "${GITHUB_TOKEN:-}" ]; then
  AUTH_HEADER="Authorization: Bearer $GITHUB_TOKEN"
else
  AUTH_HEADER=""
fi

# 取得対象フォント: "ofl配下ディレクトリ名 出力ファミリー名 critical(1/0)"
# critical=1 は現在の生成対象言語(30言語)に必須。取得失敗で異常終了する。
# critical=0 は将来の言語追加用。取得失敗しても警告のみで続行する。
FONTS="
notosans NotoSans 1
notoemoji NotoEmoji 1
notosansjp NotoSansJP 1
notosanskr NotoSansKR 1
notosanssc NotoSansSC 1
notosanstc NotoSansTC 0
notosansthai NotoSansThai 1
notosansarabic NotoSansArabic 1
notosanshebrew NotoSansHebrew 1
notosansdevanagari NotoSansDevanagari 1
notosansbengali NotoSansBengali 0
notosanstamil NotoSansTamil 0
notosanstelugu NotoSansTelugu 0
notosanskannada NotoSansKannada 0
notosansmalayalam NotoSansMalayalam 0
notosansgujarati NotoSansGujarati 0
notosansgurmukhi NotoSansGurmukhi 0
notosansoriya NotoSansOriya 0
notosanssinhala NotoSansSinhala 0
notosanskhmer NotoSansKhmer 0
notosanslao NotoSansLao 0
notosansmyanmar NotoSansMyanmar 0
notosansethiopic NotoSansEthiopic 0
notosansgeorgian NotoSansGeorgian 0
notosansarmenian NotoSansArmenian 0
"

# ファイル名の [ ] , を URL エンコードする。
url_encode_filename() {
  printf '%s' "$1" | sed 's/\[/%5B/g; s/\]/%5D/g; s/,/%2C/g'
}

# 1 フォントを取得する。成功で 0、失敗で 1 を返す。
fetch_one() {
  ofl_dir="$1"
  family="$2"
  dest="$SCREENSHOT_FONT_DIR/$family.ttf"

  if [ -s "$dest" ]; then
    echo "skip (取得済み): $family"
    return 0
  fi

  # ofl 配下の非 Italic な .ttf ファイル名を GitHub API から取得する。
  api_url="https://api.github.com/repos/google/fonts/contents/ofl/$ofl_dir"
  if [ -n "$AUTH_HEADER" ]; then
    listing="$(curl -sfL -H "$AUTH_HEADER" "$api_url" 2>/dev/null || true)"
  else
    listing="$(curl -sfL "$api_url" 2>/dev/null || true)"
  fi
  ttf_name="$(printf '%s' "$listing" | grep '"name"' | grep -iE '\.ttf"' | grep -iv 'Italic' | head -1 | sed 's/.*"name": "//; s/".*//')"
  if [ -z "$ttf_name" ]; then
    echo "warn: ofl/$ofl_dir に ttf が見つかりませんでした(API 応答が空か、ディレクトリ名が違う可能性)" >&2
    return 1
  fi

  raw_url="https://raw.githubusercontent.com/google/fonts/main/ofl/$ofl_dir/$(url_encode_filename "$ttf_name")"
  if ! curl -sfL "$raw_url" -o "$dest.tmp"; then
    echo "warn: ダウンロード失敗: $raw_url" >&2
    rm -f "$dest.tmp"
    return 1
  fi

  # 検証: サイズ 10KB 以上、かつ TrueType/OpenType であること。
  bytes="$(wc -c < "$dest.tmp" | tr -d ' ')"
  kind="$(file -b "$dest.tmp")"
  case "$kind" in
    *TrueType* | *OpenType* | *"font data"*)
      if [ "$bytes" -lt 10240 ]; then
        echo "warn: フォントが小さすぎます($bytes bytes): $family" >&2
        rm -f "$dest.tmp"
        return 1
      fi
      mv "$dest.tmp" "$dest"
      echo "ok: $family ($ttf_name, $bytes bytes)"
      return 0
      ;;
    *)
      echo "warn: フォントではないデータが返りました($kind): $family" >&2
      rm -f "$dest.tmp"
      return 1
      ;;
  esac
}

# here-doc で while を現在シェルで回す(パイプだとサブシェルになり失敗フラグが伝播しない)。
CRITICAL_FAILED=0
while read -r ofl_dir family critical; do
  [ -z "${ofl_dir:-}" ] && continue
  if fetch_one "$ofl_dir" "$family"; then
    continue
  fi
  if [ "$critical" = "1" ]; then
    echo "error: 必須フォントの取得に失敗しました: $family" >&2
    CRITICAL_FAILED=1
  else
    echo "warn: 任意フォントをスキップしました: $family" >&2
  fi
done <<EOF
$FONTS
EOF

if [ "$CRITICAL_FAILED" != "0" ]; then
  echo "必須フォントの取得に失敗したため中断します。" >&2
  exit 1
fi

echo ""
echo "取得済みフォント:"
ls -1 "$SCREENSHOT_FONT_DIR"
