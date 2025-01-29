#!/bin/sh
set -eu
set -o pipefail

DATE=$(date '+%Y%m.%d.%H%M%S')
git fetch origin
git switch -c release/$DATE origin/main

sed -E -i "" "s/^version: (.+)/version: $DATE/" pubspec.yaml

git add pubspec.yaml
git commit -m ":up: to $DATE"

git push origin $(git rev-parse --abbrev-ref HEAD)
gh pr create --fill --base main --head $(git rev-parse --abbrev-ref HEAD)

# NOTE: --merge option will be create merge commit
gh pr merge --merge --delete-branch

git fetch origin
git switch -d origin/main

git tag $DATE
git tag release-ios-v$DATE
git tag release-android-v$DATE
git push origin --tags

gh release create $DATE --generate-notes
