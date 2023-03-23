#! /bin/sh

CWD=$(dirname $0)
DIR=$CWD/../Firebase
cp -f ${DIR}/GoogleService-Info-${FLAVOR}.plist ${DIR}/GoogleService-Info.plist

