
.PHONY: secret
secret:
	echo $(FILE_FIREBASE_ANDROID_DEVELOPMENT) | base64 -d > android/app/src/development/google-services.json
	echo $(FILE_FIREBASE_ANDROID_PRODUCTION) | base64 -d > android/app/src/production/google-services.json
	echo $(FILE_FIREBASE_IOS_DEVELOPMENT) | base64 -d > ios/Firebase/GoogleService-Info-Development.plist
	echo $(FILE_FIREBASE_IOS_PRODUCTION) | base64 -d > ios/Firebase/GoogleService-Info-Production.plist
