#!/bin/bash
set -eu
set -o pipefail

CODEGEN_FILES=$(git grep --files-with-matches '@freezed')

echo "First"
for codegen_file in $CODEGEN_FILES; do
  if [[ $codegen_file == *.dart ]]; then
    codegen_file_without_file_extension=$(echo $codegen_file | awk -F'\.' '{print $1}')
    codegen_file_without_lib_package_and_file_extension=$(echo $codegen_file_without_file_extension | sed 's|lib/||')
    include_codegen_files=$(git grep $codegen_file_without_lib_package_and_file_extension | awk -F':' '{print $1}')

    for include_codegen_file in $include_codegen_files; do
      sed -i '' -e "s|$codegen_file_without_lib_package_and_file_extension.dart|$codegen_file_without_lib_package_and_file_extension.codegen.dart|" $include_codegen_file
    done
  fi
done

echo "Second"
for codegen_file in $CODEGEN_FILES; do
  if [[ $codegen_file == *.dart ]]; then
    codegen_file_without_file_extension=$(echo $codegen_file | awk -F'\.' '{print $1}')
    sed -i '' -E -e "s|part '(.+)\.freezed\.dart';|part '\1\.codegen\.freezed\.dart';|" $codegen_file
    sed -i '' -E -e "s|part '(.+)\.g\.dart';|part '\1\.codegen\.g\.dart';|" $codegen_file
    sed -i '' -r -e "s|part \"(.+)\.freezed\.dart\";|part \"\1\.codegen\.freezed\.dart\";|" $codegen_file
    sed -i '' -r -e "s|part \"(.+)\.g\.dart\";|part \"\1\.codegen\.g\.dart\";|" $codegen_file
  fi
done

echo "Third"
for codegen_file in $CODEGEN_FILES; do
  if [[ $codegen_file == *.dart ]]; then
    echo "codegen_file: $codegen_file"
    codegen_file_without_file_extension=$(echo $codegen_file | awk -F'\.' '{print $1}')
    echo $codegen_file_without_file_extension | xargs -I '{}' mv {}.dart {}.codegen.dart
  fi
done
