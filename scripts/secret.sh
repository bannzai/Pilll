#!/bin/bash
set -e
set -o pipefail

cat lib/secret/secret.dart.sample | sed \
  -e "s|\[REVENUE_CAT_PUBLIC_API_KEY\]|$REVENUE_CAT_PUBLIC_API_KEY|g" \
  -e "s|\[IOS_ADMOB_NATIVE_ADVANCE_IDENTIFIER\]|$IOS_ADMOB_NATIVE_ADVANCE_IDENTIFIER|g" \
  -e "s|\[ANDROID_ADMOB_NATIVE_ADVANCE_IDENTIFIER\]|$ANDROID_ADMOB_NATIVE_ADVANCE_IDENTIFIER|g" \
> lib/secret/secret.dart

