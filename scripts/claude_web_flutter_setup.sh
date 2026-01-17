#!/usr/bin/env bash
set -euo pipefail

# Move to project root (safe)
if [ -n "${CLAUDE_PROJECT_DIR:-}" ] && [ -d "${CLAUDE_PROJECT_DIR}" ]; then
  cd "${CLAUDE_PROJECT_DIR}"
fi

# Require jq
if ! command -v jq >/dev/null 2>&1; then
  echo "[flutter-setup] ERROR: jq is not installed in this environment."
  echo "[flutter-setup] Please ensure jq is available, then retry."
  exit 1
fi

INSTALL_DIR="${HOME}/.flutter-sdk"
FLUTTER_BIN="${INSTALL_DIR}/bin/flutter"
RELEASES_JSON_URL="https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json"

echo "[flutter-setup] start"

# Install Flutter SDK (idempotent)
if [ ! -x "${FLUTTER_BIN}" ]; then
  echo "[flutter-setup] fetching Flutter stable bundle info..."

  releases_json="$(curl -fsSL "${RELEASES_JSON_URL}")"

  base_url="$(printf '%s' "${releases_json}" | jq -r '.base_url')"
  stable_hash="$(printf '%s' "${releases_json}" | jq -r '.current_release.stable')"
  archive="$(printf '%s' "${releases_json}" | jq -r --arg h "${stable_hash}" '.releases[] | select(.hash == $h) | .archive' | head -n 1)"

  if [ -z "${archive}" ] || [ "${archive}" = "null" ]; then
    echo "[flutter-setup] ERROR: Could not resolve stable archive from releases JSON."
    exit 1
  fi

  if [[ "${archive}" =~ ^https?:// ]]; then
    tar_url="${archive}"
  else
    tar_url="${base_url%/}/${archive#/}"
  fi

  echo "[flutter-setup] bundle: ${tar_url}"

  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT

  curl -fsSL "${tar_url}" -o "${tmp_dir}/flutter.tar.xz"

  rm -rf "${INSTALL_DIR}"
  mkdir -p "${INSTALL_DIR}"
  tar -xJf "${tmp_dir}/flutter.tar.xz" -C "${INSTALL_DIR}" --strip-components=1

  echo "[flutter-setup] Flutter SDK extracted to ${INSTALL_DIR}"
else
  echo "[flutter-setup] Flutter already installed: ${FLUTTER_BIN}"
fi

# Make flutter available now
export FLUTTER_HOME="${INSTALL_DIR}"
export PATH="${PATH}:${INSTALL_DIR}/bin"

# Persist PATH for subsequent commands in the session, if Claude provides an env file
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  {
    echo "export FLUTTER_HOME=\"${INSTALL_DIR}\""
    echo "export PATH=\"\$PATH:${INSTALL_DIR}/bin\""
  } >> "${CLAUDE_ENV_FILE}"
else
  # Fallback: persist to ~/.bashrc (guarded)
  marker="# >>> claude-web-flutter >>>"
  if ! grep -qF "${marker}" "${HOME}/.bashrc" 2>/dev/null; then
    {
      echo "${marker}"
      echo "export FLUTTER_HOME=\"${INSTALL_DIR}\""
      echo "export PATH=\"\$PATH:${INSTALL_DIR}/bin\""
      echo "# <<< claude-web-flutter <<<"
    } >> "${HOME}/.bashrc"
  fi
fi

# Avoid analytics prompts
flutter config --no-analytics >/dev/null 2>&1 || true

echo "[flutter-setup] flutter --version"
flutter --version

# Smoke test: web build (Android SDK / Xcode 不要)
if [ -f "pubspec.yaml" ]; then
  echo "[flutter-setup] flutter pub get"
  flutter pub get

  echo "[flutter-setup] flutter build web"
  flutter build web
else
  echo "[flutter-setup] NOTE: pubspec.yaml not found. Skipping build."
fi

echo "[flutter-setup] done"

