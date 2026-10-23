#!/usr/bin/env bash
# maestro-e2e workflow の runner 側処理 (maestro-e2e-actions skill が生成)。
# 実行対象の flow は repo にコミット済みの .maestro/ 配下だけに限定する。
# --resolve-only は flows input の検証だけを行い、Simulator に触れず終了する (skill のテスト用)。
set -euo pipefail

FLOWS="${FLOWS:-all}"
DEVICE="${DEVICE:-iPhone 17}"
APP_DIR="${APP_DIR:-build-app}"
APP_NAME="${APP_NAME:-}"
ARTIFACT_DIR="${ARTIFACT_DIR:-maestro-artifacts}"
RECORD_VIDEO="${RECORD_VIDEO:-true}"
SUMMARY="${GITHUB_STEP_SUMMARY:-/dev/null}"
# maestro を入れる時のバージョンと、そのリリースの maestro.zip の sha256。
# 更新は https://github.com/mobile-dev-inc/maestro/releases の checksums_sha256.txt から取る。
MAESTRO_VERSION="${MAESTRO_VERSION:-2.8.0}"
MAESTRO_SHA256="${MAESTRO_SHA256:-b3e561161904fb391875ca5834d5b22cf0b01c052dd1b408ad83e30d8f8951b3}"

RESOLVE_ONLY=false
if [ "${1:-}" = "--resolve-only" ]; then
  RESOLVE_ONLY=true
fi

fail() {
  echo "::error::$1" >&2
  exit 1
}

# dispatch の input を受けても実行対象がコミット済みファイルの範囲を出ないようにする
resolve_flows() {
  local target
  case "$FLOWS" in
    all) target=".maestro/flows" ;;
    *..*) fail "flows に .. は使えない: ${FLOWS}" ;;
    /*) fail "flows に絶対パスは使えない: ${FLOWS}" ;;
    .maestro/*) target="$FLOWS" ;;
    *) fail "flows は all か .maestro/ 配下のパスのみ指定できる: ${FLOWS}" ;;
  esac
  [ -e "$target" ] || fail "flow が repo に存在しない: ${target}"
  printf '%s\n' "$target"
}

TARGET="$(resolve_flows)"
echo "flows=${TARGET}"
if [ "$RESOLVE_ONLY" = true ]; then
  exit 0
fi

UDID="$(xcrun simctl list devices available -j \
  | jq -r --arg name "$DEVICE" '.devices | to_entries[] | .value[] | select(.name == $name) | .udid' \
  | head -1)"
[ -n "$UDID" ] || fail "デバイスが見つからない: ${DEVICE} (xcrun simctl list devices available で確認)"
echo "udid=${UDID}"

xcrun simctl boot "$UDID" || true
xcrun simctl bootstatus "$UDID" -b

# build job は upload-artifact の権限欠落 (download 後は全て 0644 になる) を避けるため
# 成果物を tar で固めている。展開して .app の実行権限を復元する
for t in "$APP_DIR"/*.tar; do
  [ -e "$t" ] || continue
  tar -xf "$t" -C "$APP_DIR"
done

if [ -n "$APP_NAME" ]; then
  APP_PATH="$(find "$APP_DIR" -maxdepth 3 -name "${APP_NAME}.app" -print -quit)"
else
  APP_PATH="$(find "$APP_DIR" -maxdepth 3 -name '*.app' -print -quit)"
fi
[ -n "$APP_PATH" ] || fail "${APP_DIR} 配下に .app が無い (build job の upload-artifact の path を確認)"
echo "app=${APP_PATH}"
xcrun simctl install "$UDID" "$APP_PATH"

mkdir -p "$ARTIFACT_DIR"

# maestro は JVM で動く (Java 17+ 必須)。runner の既定 JAVA_HOME が古い場合に備えて新しい方へ向ける
for v in 21 17; do
  var="JAVA_HOME_${v}_arm64"
  if [ -n "${!var:-}" ]; then
    export JAVA_HOME="${!var}"
    break
  fi
done
java -version

export MAESTRO_CLI_NO_ANALYTICS=1
export MAESTRO_DRIVER_STARTUP_TIMEOUT=120000
# runner には maestro が入っていないためインストールする (ローカル再現時は既存の maestro を使う)。
# get.maestro.mobile.dev のインストーラーは常に最新版を入れるため、リリース成果物を
# バージョン固定で取得し、sha256 が想定と一致することを確認してから使う。
# 録画の開始前に済ませる (インストールの失敗で録画プロセスが取り残されないようにする)。
if ! command -v maestro > /dev/null 2>&1; then
  WORK="${RUNNER_TEMP:-/tmp}"
  mkdir -p "$WORK"
  INSTALL_DIR="${WORK}/maestro-cli"
  ZIP="${WORK}/maestro.zip"
  curl -fsSL -o "$ZIP" "https://github.com/mobile-dev-inc/maestro/releases/download/cli-${MAESTRO_VERSION}/maestro.zip"
  echo "${MAESTRO_SHA256}  ${ZIP}" | shasum -a 256 -c -
  unzip -q -o "$ZIP" -d "$INSTALL_DIR"
  export PATH="${PATH}:${INSTALL_DIR}/maestro/bin"
fi
maestro --version

REC_PID=""
if [ "$RECORD_VIDEO" = "true" ]; then
  xcrun simctl io "$UDID" recordVideo --codec=h264 -f "${ARTIFACT_DIR}/session.mp4" &
  REC_PID=$!
fi

STATUS=0
maestro --udid "$UDID" test \
  --format junit \
  --output "${ARTIFACT_DIR}/report.xml" \
  --debug-output "${ARTIFACT_DIR}/debug" \
  "$TARGET" || STATUS=$?

# recordVideo は SIGINT で終了させないと mp4 が壊れる
if [ -n "$REC_PID" ]; then
  kill -INT "$REC_PID" 2>/dev/null || true
  wait "$REC_PID" 2>/dev/null || true
fi

{
  echo "## Maestro E2E"
  echo ""
  echo "- flows: \`${TARGET}\`"
  echo "- device: ${DEVICE} (\`${UDID}\`)"
  echo "- app: \`${APP_PATH}\`"
  if [ "$STATUS" -eq 0 ]; then
    echo "- 結果: 成功"
  else
    echo "- 結果: 失敗 (exit ${STATUS})。artifact \`maestro-e2e-artifacts\` の report.xml / debug / session.mp4 を参照"
  fi
} >> "$SUMMARY"

exit "$STATUS"
