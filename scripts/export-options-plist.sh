#!/bin/bash
set -e
set -o pipefail

echo $(FILE_EXPORT_OPTIONS_PLIST_DEVELOPMENT) | base64 -D > ios/Runner/ExportOptions.dev.plist
echo $(FILE_EXPORT_OPTIONS_PLIST_PRODUCTION) | base64 -D > ios/Runner/ExportOptions.prod.plist
