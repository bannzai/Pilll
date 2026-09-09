import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/utils/firebase.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  group('#initializeFirebase', () {
    final activations = <Map<dynamic, dynamic>>[];

    setUp(() {
      activations.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/firebase_app_check'),
        (methodCall) async {
          if (methodCall.method == 'FirebaseAppCheck#registerTokenListener') {
            return 'app-check-test-events';
          }
          if (methodCall.method == 'FirebaseAppCheck#activate') {
            // Firebase 初期化が完了する前に App Check を呼ぶ退行を検出する。
            expect(Firebase.app().name, '[DEFAULT]');
            activations.add(methodCall.arguments as Map<dynamic, dynamic>);
          }
          return null;
        },
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('app-check-test-events'),
        (methodCall) async => null,
      );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/firebase_app_check'),
        null,
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('app-check-test-events'),
        null,
      );
    });

    test('デバッグビルドでは両 OS のデバッグプロバイダを設定しトークン値を渡さない', () async {
      await initializeFirebase(isDebugMode: true);

      expect(activations, [
        {
          'appName': '[DEFAULT]',
          'androidProvider': 'debug',
          'appleProvider': 'debug'
        },
      ]);
    });

    test('配布ビルドでは Play Integrity と App Attest の DeviceCheck フォールバックを設定する',
        () async {
      await initializeFirebase(isDebugMode: false);

      expect(activations, [
        {
          'appName': '[DEFAULT]',
          'androidProvider': 'playIntegrity',
          'appleProvider': 'appAttestWithDeviceCheckFallback'
        },
      ]);
    });

    test('通知アクションで再初期化しても Firebase アプリを増やさず同じ設定を維持する', () async {
      await initializeFirebase(isDebugMode: false);
      await initializeFirebase(isDebugMode: false);

      expect(Firebase.apps, hasLength(1));
      expect(activations, hasLength(2));
      expect(activations.first, activations.last);
    });
  });
}
