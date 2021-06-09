#!/bin/bash
set -e
set -o pipefail

cat lib/api/secret.dart.sample | sed \
  -e "s|\[REVENUE_CAT_PUBLIC_API_KEY\]|$REVENUE_CAT_PUBLIC_API_KEY|g" \
> lib/api/secret.dart

