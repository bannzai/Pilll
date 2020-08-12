#! /bin/sh

if [[ $CONFIGURATION == *"Development" ]]; then
    cp $PRODUCT_NAME/Firebase/GoogleService-Info-Development.plist $PRODUCT_NAME/GoogleService-Info.plist
elif [[ $CONFIGURATION == "Debug"* ]]; then
    cp $PRODUCT_NAME/Firebase/GoogleService-Info-Development.plist $PRODUCT_NAME/GoogleService-Info.plist
elif [[ $CONFIGURATION == *"Production" ]]; then
    cp $PRODUCT_NAME/Firebase/GoogleService-Info-Production.plist $PRODUCT_NAME/GoogleService-Info.plist
elif [[ $CONFIGURATION == "Release"* ]]; then
    cp $PRODUCT_NAME/Firebase/GoogleService-Info-Production.plist $PRODUCT_NAME/GoogleService-Info.plist
else
    echo "configuration didn't match to Development, Production"
    echo $CONFIGURATION
    exit 1
fi
