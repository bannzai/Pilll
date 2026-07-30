#!/bin/sh
set -eu

cd "$(git rev-parse --show-toplevel)"
flutter_bin="$(command -v flutter)"
dart_bin="$(dirname "$flutter_bin")/cache/dart-sdk/bin/dart"
CI=true DART_SUPPRESS_ANALYTICS=true "$dart_bin" run scripts/metadata_check/check_all_metadata.dart
