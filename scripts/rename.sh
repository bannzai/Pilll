#!/bin/bash
set -eu
set -o pipefail

CODEGEN_FILES=$(git grep --files-with-matches '@freezed')

for codegen_file in $CODEGEN_FILES; do 
  if [[ $codegen_file == *.dart ]]; then
    codegen_file_without_file_extension=$(echo $codegen_file | awk -F'\.' '{print $1}')
    echo $codegen_file_without_file_extension | xargs -I '{}' mv {}.dart {}.codegen.dart

    codegen_file_without_lib_package_and_file_extension=$(echo $codegen_file_without_file_extension | sed 's|lib/||')
    include_codegen_file=$(git grep $codegen_file_without_lib_package_and_file_extension | awk -F':' '{print $1}')
    sed -i '' -e "s|$codegen_file_without_lib_package_and_file_extension.dart|$codegen_file_without_lib_package_and_file_extension.codegen.dart|" $include_codegen_file
  fi
done
