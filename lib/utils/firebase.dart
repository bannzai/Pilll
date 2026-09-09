import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';

/// 通常起動と通知アクションで、Firebase サービスの使用前に App Check を設定する。
Future<void> initializeFirebase({required bool isDebugMode}) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  // flavor ではなくビルド種別で分離し、dev の配布ビルドでも実機の認証を使う。
  await FirebaseAppCheck.instance.activate(
    providerAndroid: isDebugMode ? const AndroidDebugProvider() : const AndroidPlayIntegrityProvider(),
    providerApple: isDebugMode ? const AppleDebugProvider() : const AppleAppAttestWithDeviceCheckFallbackProvider(),
  );
}
