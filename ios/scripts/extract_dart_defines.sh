#!/bin/sh

# ref: https://github.com/flutter/flutter/issues/142976#issuecomment-1949602247
# dart-define-from-filesに渡すjsonの内容をDart-Defines.xcconfig用意している。これをほとんどの場合はInfo.plistで宣言し直してアプリ内で必要に応じて使用する

# Specifies the file path to which the Dart define is written.
# We will create a file named `Dart-Defines.xcconfig`.
OUTPUT_FILE="${SRCROOT}/Flutter/Dart-Defines.xcconfig"
# The file is initially emptied so that the old properties do not remain when the contents of the Dart define are changed.
: > $OUTPUT_FILE

# This function decodes the Dart define.
function decode_url() { echo "${*}" | base64 --decode; }

IFS=',' read -r -a define_items <<<"$DART_DEFINES"

for index in "${!define_items[@]}"
do
    item=$(decode_url "${define_items[$index]}")
    # Dart definitions also include items that are automatically defined on the Flutter side. 
    # However, if we export those definitions, we will not be able to build due to errors, # so we do not output items that start with flutter or FLUTTER.
    lowercase_item=$(echo "$item" | tr '[:upper:]' '[:lower:]')
    if [[ $lowercase_item != flutter* ]]; then
        echo "$item" >> "$OUTPUT_FILE"
    fi
done

