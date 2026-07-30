#!/bin/sh
# App Store スクリーンショット生成の共通設定。
#
# 各スクリプトから `. "$(dirname "$0")/appstore_screenshot_env.sh"` で読み込む。
#
# SSOT について:
# - 「どの言語を生成し、どの fastlane ロケール名で出力するか」の対応表(arb→ASC)は
#   Dart 側 lib/features/appstore_screenshot/screenshot_locale.dart が SSOT。
#   シェル側はこの対応表を複製しない。生成物のディレクトリ名は Dart が決め、
#   apply_variant.sh は生成済みディレクトリ名を辿って fastlane へ配置する。
# - バリアント（CPP 別のページ並び順）の定義は Dart 側 screenshot_variant.dart が SSOT。
#   generate_appstore_screenshots.sh はこのファイルからバリアント名一覧を読んで検証する。
# - 言語・ページを絞りたい場合は generate_appstore_screenshots.sh の -l / -n で指定する。

set -eu

# バリアント名の既定値。apply_variant.sh の対象や artifacts の格納先に使う。
SCREENSHOT_VARIANT_DEFAULT="main"

# このスクリプト群が置かれているディレクトリ(scripts/generate_screenshots)。
SCREENSHOT_SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Flutter プロジェクトルート(scripts/generate_screenshots の 2 つ上)。
SCREENSHOT_PROJECT_ROOT="$(cd "$SCREENSHOT_SCRIPT_DIR/../.." && pwd)"

# フォント・生成物の配置先。いずれも .gitignore 対象。
SCREENSHOT_FONT_DIR="$SCREENSHOT_SCRIPT_DIR/fonts"
SCREENSHOT_ARTIFACT_DIR="$SCREENSHOT_SCRIPT_DIR/artifacts"

# 撮影ハーネスのテストファイル。
SCREENSHOT_TEST_FILE="test/appstore_screenshot/generate_screenshots_test.dart"

# バリアント（CPP 別ページ並び順）定義の SSOT。バリアント名の検証に使う。
SCREENSHOT_VARIANT_FILE="$SCREENSHOT_PROJECT_ROOT/lib/features/appstore_screenshot/screenshot_variant.dart"
