#!/bin/sh
# iPhone Duo 用の App Store スクリーンショット（外側 1398×2034・内側 2853×2007）を
# iPhone Duo Simulator の実描画から撮影する。
#
# 既存の iPhone 6.7" の撮影（capture_screenshots.sh）と同じ ScreenshotCatalogApp を使い、
# Simulator の姿勢（閉じた = 外側ディスプレイ、開いた = 内側ディスプレイ）ごとに
# 全言語 × 全ページを撮る。姿勢の切り替えは simctl に手段が無く、ios-simulator skill の
# duo-pose.sh（Device Hub をアクセシビリティ API で操作。ローカルの Mac 限定）で行う。
# 内側ディスプレイは Maestro の takeScreenshot で撮れないため、Maestro ではなく
# アプリの Documents ディレクトリ経由の同期（lib/features/appstore_screenshot/screenshot_autoplay.dart）で
# ページを進め、`xcrun simctl io <UDID> screenshot --display=...` で撮る。
#
# 出力（deliver が読む fastlane/screenshots/ と organize_screenshots.dart が消す _variant-* には置かない）:
#   scripts/generate_screenshots/artifacts/iphone-duo/_captured/{outer|inner}/{arb言語}/p{N}.png
# 撮影後に organize_duo_screenshots.dart が App Store Connect のロケールごとに展開する。
#
# 前提: capture_screenshots.sh と同じ（secret.dart / Secret.xcconfig / GoogleService-Info.plist /
# environment/dev.json / ios/Pods）。加えて ImageMagick（magick。simctl の PNG は alpha 付きで
# App Store Connect が拒否するため除去する）と duo-pose.sh。
#
# 使い方:
#   bash scripts/generate_screenshots/capture_duo_screenshots.sh [-l LANGS] [--poses closed,open] [--skip-build] [--udid UDID]
#     -l LANGS      カンマ区切りの arb 言語コード（未指定は全対象言語）
#     --poses       撮る姿勢（既定 closed,open。closed = 外側、open = 内側）
#     --skip-build  ビルドとインストールを飛ばす（インストール済みのアプリで撮り直す時）
#     --udid UDID   起動済みの iPhone Duo Simulator を使う（未指定は sim-boot で起動）
#   環境変数:
#     FLUTTER       flutter コマンド（既定 flutter。Xcode 27 の Simulator ビルドには Flutter 3.44.8 以降が要る。
#                   例: FLUTTER=~/fvm/versions/3.44.9/bin/flutter）
#     DUO_POSE_SH   duo-pose.sh のパス（既定 ~/.claude/skills/ios-simulator/scripts/duo-pose.sh）

set -eu

. "$(cd "$(dirname "$0")" && pwd)/appstore_screenshot_env.sh"

LANGS=""
POSES="closed,open"
SKIP_BUILD=0
DEVICE_UDID=""
APP_ID="com.mizuki.Ohashi.Pilll.dev"
FLUTTER="${FLUTTER:-flutter}"
# 既定は ios-simulator skill の配置先。リポジトリは public で skill を同梱しないため、パスだけ環境変数で差し替えられるようにする。
DUO_POSE_SH="${DUO_POSE_SH:-$HOME/.claude/skills/ios-simulator/scripts/duo-pose.sh}"
DUO_ROOT="$SCREENSHOT_ARTIFACT_DIR/iphone-duo"
CAPTURED_ROOT="$DUO_ROOT/_captured"

while [ $# -gt 0 ]; do
  case "$1" in
    -l) LANGS="$2"; shift 2 ;;
    --poses) POSES="$2"; shift 2 ;;
    --skip-build) SKIP_BUILD=1; shift ;;
    --udid) DEVICE_UDID="$2"; shift 2 ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
done

if [ ! -x "$DUO_POSE_SH" ]; then
  echo "duo-pose.sh が見つかりません: $DUO_POSE_SH（DUO_POSE_SH で指定）" >&2
  exit 1
fi
if ! command -v magick >/dev/null 2>&1; then
  echo "magick (ImageMagick) が見つかりません。brew install imagemagick" >&2
  exit 1
fi

cd "$SCREENSHOT_PROJECT_ROOT"

if [ -z "$LANGS" ]; then
  LANGS="$(dart run scripts/generate_screenshots/print_langs.dart)"
fi

# UDID の機種が iPhone Duo なら 0 を返す。
is_duo() {
  xcrun simctl list devices -j | jq -e --arg u "$1" \
    '[.devices | to_entries[].value[] | select(.udid == $u) | .deviceTypeIdentifier] | any(. == "com.apple.CoreSimulator.SimDeviceType.iPhone-Duo")' >/dev/null
}

# 1. Simulator 起動（iPhone Duo。sim-boot の既定名を使い、sim-id / sim-shutdown で辿れるようにする）。
# sim-boot は既定名の既存端末を機種を見ずに再利用するため、同じ worktree で capture_screenshots.sh が
# 6.7" を作成済みだと Duo が起動しない。その時は --number 2 の名前（sim-id / sim-shutdown は prefix で辿れる）で
# 別端末として起動する。
if [ -z "$DEVICE_UDID" ]; then
  echo "boot simulator: iPhone Duo"
  booted_before="$(xcrun simctl list devices booted -j | jq -r '.devices[][] | .udid')"
  DEVICE_UDID="$(SIM_DEVICE_TYPE="iPhone Duo" sim-boot | awk -F= '/^DEVICE_UDID=/{print $2}')"
  if [ -n "$DEVICE_UDID" ] && ! is_duo "$DEVICE_UDID"; then
    echo "既定名の Simulator ($DEVICE_UDID) は iPhone Duo ではないため、--number 2 で別に起動します"
    # この呼び出しで起動してしまった別機種は戻す（Booted が 2 台になると sim-id が Duo でない方を返しうる）。
    # 呼び出し前から Booted だったものは他の作業が使っている可能性があるため触らない。
    case "$booted_before" in
      *"$DEVICE_UDID"*) ;;
      *) xcrun simctl shutdown "$DEVICE_UDID" >/dev/null 2>&1 || true ;;
    esac
    DEVICE_UDID="$(SIM_DEVICE_TYPE="iPhone Duo" sim-boot --number 2 | awk -F= '/^DEVICE_UDID=/{print $2}')"
  fi
  if [ -z "$DEVICE_UDID" ]; then
    echo "sim-boot で DEVICE_UDID を取得できませんでした" >&2
    exit 1
  fi
fi
if ! is_duo "$DEVICE_UDID"; then
  echo "Simulator $DEVICE_UDID は iPhone Duo ではありません（xcrun simctl list devices で機種を確認）" >&2
  exit 1
fi
echo "DEVICE_UDID=$DEVICE_UDID"

# 2. カタログアプリをビルドしてインストール（flavor を付けない理由は capture_screenshots.sh と同じ）。
if [ "$SKIP_BUILD" = "0" ]; then
  echo "build catalog app (SCREENSHOT_CATALOG=true) with $FLUTTER"
  "$FLUTTER" build ios --simulator -t lib/main.dev.dart \
    --dart-define=SCREENSHOT_CATALOG=true \
    --dart-define-from-file=environment/dev.json
  xcrun simctl install "$DEVICE_UDID" build/ios/iphonesimulator/Runner.app
fi

# アプリの Documents ディレクトリ（screenshot_autoplay.dart と同期ファイルをやり取りする）。
DOCUMENTS_DIR="$(xcrun simctl get_app_container "$DEVICE_UDID" "$APP_ID" data)/Documents"
mkdir -p "$DOCUMENTS_DIR"

# arb 言語コード → iOS の言語 ID（capture_langs.sh と同じ対応）。
ios_language_id() {
  case "$1" in
    pt) echo "pt-BR" ;;
    zh) echo "zh-Hans" ;;
    no) echo "nb" ;;
    *) echo "$1" ;;
  esac
}

# 姿勢を切り替える。起動直後の Device Hub は姿勢を返せないことがあるため、失敗したら数回やり直す。
# 切り替え後はディスプレイの再構成と Flutter の再レイアウトを待つ（実測で 2〜5 秒）。
set_pose() {
  attempt=1
  while [ "$attempt" -le 5 ]; do
    if "$DUO_POSE_SH" set --udid "$DEVICE_UDID" "$1"; then
      sleep 5
      return 0
    fi
    echo "duo-pose set $1 failed (attempt $attempt/5)" >&2
    attempt=$((attempt + 1))
    sleep 3
  done
  return 1
}

# 1 ページ分の ready ファイル（内容 `<lang> p<N>`）が現れるまで待つ。上限はアプリ起動を含めて 90 秒。
wait_ready() {
  waited=0
  while [ "$waited" -lt 900 ]; do
    if [ -f "$DOCUMENTS_DIR/screenshot_ready.txt" ] && [ "$(cat "$DOCUMENTS_DIR/screenshot_ready.txt")" = "$1" ]; then
      return 0
    fi
    sleep 0.1
    waited=$((waited + 1))
  done
  return 1
}

# 1 言語分を 1 姿勢で撮る。失敗したら 1 を返す（呼び出し側でリトライ）。
capture_lang() {
  pose="$1"
  lang="$2"
  case "$pose" in
    closed) side="outer"; display="primary" ;;
    open) side="inner"; display="primary-1" ;;
    *) echo "unknown pose: $pose" >&2; exit 1 ;;
  esac
  # 撮影は作業ディレクトリ（<lang>.tmp）に出し、7 ページ揃った時だけ本来の場所へ置き換える。
  # 途中で失敗しても、以前に撮れていた画像を失わない（撮り直しの経路で特に効く）。
  final_dir="$CAPTURED_ROOT/$side/$lang"
  out_dir="$CAPTURED_ROOT/$side/$lang.tmp"
  mkdir -p "$out_dir"
  find "$out_dir" -maxdepth 1 -type f -name 'p*.png' -delete
  rm -f "$DOCUMENTS_DIR/screenshot_ready.txt" "$DOCUMENTS_DIR/screenshot_ack.txt" "$DOCUMENTS_DIR/screenshot_done.txt"
  printf '%s\n1,2,3,4,5,6,7\n' "$lang" > "$DOCUMENTS_DIR/screenshot_autoplay.txt"
  xcrun simctl terminate "$DEVICE_UDID" "$APP_ID" 2>/dev/null || true
  xcrun simctl launch "$DEVICE_UDID" "$APP_ID" >/dev/null
  for page in 1 2 3 4 5 6 7; do
    if ! wait_ready "$lang p$page"; then
      echo "timeout waiting for $lang p$page ($side)" >&2
      return 1
    fi
    # 最初のフレーム描画後の通知なので、画像アセットの読み込みとページ遷移アニメーションの残りを待つ。
    sleep 1.5
    # この関数は `if capture_lang ...` の条件として呼ばれるため set -e が効かない。撮影・変換の失敗は
    # 明示的に 1 を返し、画像ができた後にだけ ACK を書く（失敗したまま次ページへ進ませない）。
    if ! xcrun simctl io "$DEVICE_UDID" screenshot --display="$display" "$out_dir/p$page.raw.png" >/dev/null; then
      echo "screenshot failed: $lang p$page ($side)" >&2
      return 1
    fi
    # simctl の PNG は alpha チャンネル付きで App Store Connect が拒否するため除去する。
    if ! magick "$out_dir/p$page.raw.png" -alpha remove -alpha off "$out_dir/p$page.png"; then
      echo "magick failed: $lang p$page ($side)" >&2
      return 1
    fi
    rm -f "$out_dir/p$page.raw.png"
    : > "$DOCUMENTS_DIR/screenshot_ack.txt"
  done
  if ! wait_done; then
    echo "timeout waiting for done ($lang $side)" >&2
    return 1
  fi
  mkdir -p "$final_dir"
  find "$final_dir" -maxdepth 1 -type f -name 'p*.png' -delete
  mv "$out_dir"/p*.png "$final_dir/"
  rmdir "$out_dir"
  return 0
}

# 全ページを終えた done ファイルを待つ（上限 10 秒）。
wait_done() {
  waited=0
  while [ "$waited" -lt 100 ]; do
    if [ -f "$DOCUMENTS_DIR/screenshot_done.txt" ]; then
      return 0
    fi
    sleep 0.1
    waited=$((waited + 1))
  done
  return 1
}

# 成功・失敗を問わず終了時に Simulator を元へ戻す。set -e で途中終了しても、時刻の固定が残らず、
# 依頼ファイルが残って次回の手動起動（ホストの ACK が無い）が待ち続けることもないようにする。
cleanup() {
  rm -f "$DOCUMENTS_DIR/screenshot_autoplay.txt"
  xcrun simctl status_bar "$DEVICE_UDID" clear >/dev/null 2>&1 || true
}
trap cleanup EXIT

# iOS 27.1 の iPhone Duo は、アプリがステータスバーを隠しても外側ディスプレイの右端の列と内側ディスプレイの
# 右上に時刻・Wi-Fi の表示を描き続ける（実測。bannzai/Pilll PR #1900 の「右端の余白は OS の配置によるもの」と同じ）。
# 画像から消せないため、全ページで同じ見た目になるよう 9:41・Wi-Fi 接続・満充電（充電中の稲妻を出さない）に固定する。
xcrun simctl status_bar "$DEVICE_UDID" override --time 9:41 --wifiMode active --wifiBars 3 --cellularMode notSupported --batteryState discharging --batteryLevel 100

# 3. 姿勢ごとに全言語を撮る（姿勢の切り替え回数を最小にするため、姿勢を外側のループにする）。
MAX_ATTEMPTS=3
for pose in $(printf '%s' "$POSES" | tr ',' ' '); do
  echo "set pose: $pose"
  set_pose "$pose"
  for lang in $(printf '%s' "$LANGS" | tr ',' ' '); do
    [ -z "$lang" ] && continue
    case "$lang" in
      *[!A-Za-z0-9_-]*) echo "invalid language code: $lang" >&2; exit 1 ;;
    esac
    ios_lang="$(ios_language_id "$lang")"
    echo "capture ($pose): $lang (device language: $ios_lang)"
    xcrun simctl spawn "$DEVICE_UDID" defaults write .GlobalPreferences AppleLanguages -array "$ios_lang"
    xcrun simctl spawn "$DEVICE_UDID" defaults write .GlobalPreferences AppleLocale -string "$(printf '%s' "$ios_lang" | tr '-' '_')"
    attempt=1
    while [ "$attempt" -le "$MAX_ATTEMPTS" ]; do
      if capture_lang "$pose" "$lang"; then
        break
      fi
      echo "capture failed: $lang $pose (attempt $attempt/$MAX_ATTEMPTS)" >&2
      attempt=$((attempt + 1))
    done
    if [ "$attempt" -gt "$MAX_ATTEMPTS" ]; then
      echo "撮影に失敗しました: $lang ($pose)" >&2
      exit 1
    fi
  done
done
# 依頼ファイルの削除と status_bar の解除は EXIT の trap（cleanup）が行う。
# 次回の起動と他の作業のために閉じた姿勢へ戻す。
set_pose closed

# 4. 寸法・alpha・枚数の検証。
echo ""
echo "verify:"
bad=0
verified=0
for pose in $(printf '%s' "$POSES" | tr ',' ' '); do
  case "$pose" in
    closed) side="outer"; want_w=1398; want_h=2034 ;;
    open) side="inner"; want_w=2853; want_h=2007 ;;
  esac
  for lang in $(printf '%s' "$LANGS" | tr ',' ' '); do
    for page in 1 2 3 4 5 6 7; do
      png="$CAPTURED_ROOT/$side/$lang/p$page.png"
      if [ ! -f "$png" ]; then
        echo "  NG (missing): $png" >&2
        bad=$((bad + 1))
        continue
      fi
      w="$(sips -g pixelWidth "$png" | awk '/pixelWidth/{print $2}')"
      h="$(sips -g pixelHeight "$png" | awk '/pixelHeight/{print $2}')"
      alpha="$(sips -g hasAlpha "$png" | awk '/hasAlpha/{print $2}')"
      if [ "$w" != "$want_w" ] || [ "$h" != "$want_h" ]; then
        echo "  NG ($w x $h): $png" >&2
        bad=$((bad + 1))
      fi
      if [ "$alpha" != "no" ]; then
        echo "  NG (hasAlpha=$alpha): $png" >&2
        bad=$((bad + 1))
      fi
      verified=$((verified + 1))
    done
  done
done
if [ "$bad" != "0" ]; then
  echo "寸法または alpha が条件を満たさない画像が $bad 枚あります。" >&2
  exit 1
fi
echo "  OK: $verified 枚"
echo ""
echo "撮影完了: $CAPTURED_ROOT 配下"
echo "次にロケール展開: dart run scripts/generate_screenshots/organize_duo_screenshots.dart"
