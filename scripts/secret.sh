#!/bin/bash
set -e
set -o pipefail

cat lib/secret/secret.dart.sample | sed \
  -e "s|\[REVENUE_CAT_PUBLIC_API_KEY\]|$REVENUE_CAT_PUBLIC_API_KEY|g" \
> lib/secret/secret.dart

