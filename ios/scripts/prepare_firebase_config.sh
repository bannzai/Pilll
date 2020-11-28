#! /bin/sh

CWD=$(dirname $0)
DIR=$CWD/../Firebase
echo "Replacing for $CONFIGURATION"
if [[ $CONFIGURATION == *"Development" ]]; then
    cp $DIR/GoogleService-Info-Development.plist $DIR/GoogleService-Info.plist
elif [[ $CONFIGURATION == *"Production" ]]; then
    cp $DIR/GoogleService-Info-Production.plist $DIR/GoogleService-Info.plist
elif [[ $CONFIGURATION == "Debug"* ]]; then
    cp $DIR/GoogleService-Info-Development.plist $DIR/GoogleService-Info.plist
elif [[ $CONFIGURATION == "Release"* ]]; then
    cp $DIR/GoogleService-Info-Production.plist $DIR/GoogleService-Info.plist
else
    echo "configuration didn't match to Development, Production"
    echo $CONFIGURATION
    exit 1
fi
