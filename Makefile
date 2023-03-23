
# Workarround for specify pub https://github.com/bannzai/Pilll/pull/23#discussion_r481963119
.PHONY: prepare
prepare:
	cd ios; rm -rf ./Pods; pod install;

.PHONY: secret
secret:
	echo $(FILE_FIREBASE_ANDROID_DEVELOPMENT) | base64 -D > android/app/src/development/google-services.json
	echo $(FILE_FIREBASE_ANDROID_PRODUCTION) | base64 -D > android/app/src/production/google-services.json
	echo $(FILE_FIREBASE_IOS_DEVELOPMENT) | base64 -D > ios/Firebase/GoogleService-Info-dev.plist
	echo $(FILE_FIREBASE_IOS_PRODUCTION) | base64 -D > ios/Firebase/GoogleService-Info-prod.plist
	echo $(XCCONFIG_SECRET_DEVELOPMENT) | base64 -D > ios/Flutter/Development-Secret.xcconfig
	echo $(XCCONFIG_SECRET_PRODUCTION) | base64 -D > ios/Flutter/Production-Secret.xcconfig
	echo $(STOREKIT_TESTING_CONFIGURATION_PUBLIC_CERT) | base64 -D > ios/Runner/StoreKitTestCertificate.cer
	echo $(DART_DEFINE_FROM_FILE_DEV) | base64 -D > environment/dev.json
	echo $(DART_DEFINE_FROM_FILE_PROD) | base64 -D > environment/prod.json
	./scripts/secret.sh
	./android/scripts/key_properties.sh

.PHONY: secret-backup
secret-backup:
	mv android/app/src/development/google-services.json android/app/src/development/_google-services.json
	mv android/app/src/production/google-services.json android/app/src/production/_google-services.json
	mv ios/Firebase/GoogleService-Info-dev.plist ios/Firebase/_GoogleService-Info-Development.plist
	mv ios/Firebase/GoogleService-Info-prod.plist ios/Firebase/_GoogleService-Info-prod.plist
	mv ios/Flutter/Development-Secret.xcconfig ios/Flutter/_Development-Secret.xcconfig
	mv ios/Flutter/Production-Secret.xcconfig ios/Flutter/_Production-Secret.xcconfig
	mv ios/Runner/StoreKitTestCertificate.cer ios/Runner/_StoreKitTestCertificate.cer
	mv lib/app/secret.dart lib/app/_secret.dart
	mv android/key.properties android/_key.properties

