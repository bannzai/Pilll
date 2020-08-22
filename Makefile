
.PHONY: secret
secret:
	echo $(FILE_FIREBASE_ANDROID_DEVELOPMENT) | base64 -D > android/app/src/development/google-services.json
	echo $(FILE_FIREBASE_ANDROID_PRODUCTION) | base64 -D > android/app/src/production/google-services.json
	echo $(FILE_FIREBASE_IOS_DEVELOPMENT) | base64 -D > ios/Firebase/GoogleService-Info-Development.plist
	echo $(FILE_FIREBASE_IOS_PRODUCTION) | base64 -D > ios/Firebase/GoogleService-Info-Production.plist

secret-backup:
	mv android/app/src/development/google-services.json android/app/src/development/_google-services.json
	mv android/app/src/production/google-services.json android/app/src/production/_google-services.json
	mv ios/Firebase/GoogleService-Info-Development.plist ios/Firebase/_GoogleService-Info-Development.plist
	mv ios/Firebase/GoogleService-Info-Production.plist ios/Firebase/_GoogleService-Info-Production.plist
	mv android/key.properties android/_key.properties

