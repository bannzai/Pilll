#!/bin/sh
set -eu
set -o pipefail

set +e
git b -d main
set -e

DATE=$(date '+%Y%m.%d.%H%M%S')
git fetch origin
git switch -c release/$DATE origin/main

sed -E -i "" "s/MARKETING_VERSION = (.+);/MARKETING_VERSION = $DATE;/" *.xcodeproj/project.pbxproj

git add *.xcodeproj/project.pbxproj
git commit -m ":up: to $DATE"

gh pr create --title "Release $DATE"

# NOTE: --merge option will be create merge commit
gh pr merge --merge --delete-branch

git fetch origin
git switch -d origin/main

git tag $DATE
git tag release-ios-v$DATE
git tag release-android-v$DATE
git push origin --tags

gh release create $DATE --generate-notes

git b -d main

