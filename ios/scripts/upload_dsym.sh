#!/bin/bash
set -e
set -o pipefail

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"
IOS_PROJECT_DIR="$(cd $SCRIPT_DIR && cd .. && pwd -P)"
FLUTTER_PROJECT_DIR="$(cd $IOS_PROJECT_DIR && cd .. && pwd -P)"

flutter build ipa --release --flavor production --target lib/main.prod.dart --no-sound-null-safety

$IOS_PROJECT_DIR/Pods/FirebaseCrashlytics/upload-symbols -gsp $IOS_PROJECT_DIR/Firebase/GoogleService-Info-prod.plist -p ios $FLUTTER_PROJECT_DIR/build/ios/archive/Runner.xcarchive/dSYMs/Runner.app.dSYM

