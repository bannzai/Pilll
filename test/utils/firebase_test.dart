import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/utils/firebase.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  group('#initializeFirebase', () {
    final activations = <List<Object?>>[];
    const activationChannel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.firebase_app_check_platform_interface.FirebaseAppCheckHostApi.activate',
      StandardMessageCodec(),
    );

    setUp(() {
      activations.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockDecodedMessageHandler<Object?>(activationChannel,
              (arguments) async {
        // Firebase 初期化が完了する前に App Check を呼ぶ退行を検出する。
        expect(Firebase.app().name, '[DEFAULT]');
        activations.add(arguments as List<Object?>);
        return <Object?>[null];
      });
    });

    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockDecodedMessageHandler<Object?>(activationChannel, null);
    });

    test('デバッグビルドでは両 OS のデバッグプロバイダを設定しトークン値を渡さない', () async {
      for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
        debugDefaultTargetPlatformOverride = platform;
        await initializeFirebase(isDebugMode: true);
      }

      expect(activations, [
        ['[DEFAULT]', 'debug', 'debug', null, null],
        ['[DEFAULT]', 'debug', 'debug', null, null],
      ]);
    });

    test('配布ビルドでは Play Integrity と App Attest の DeviceCheck フォールバックを設定する',
        () async {
      await initializeFirebase(isDebugMode: false);

      expect(activations, [
        [
          '[DEFAULT]',
          'playIntegrity',
          'appAttestWithDeviceCheckFallback',
          null,
          null
        ],
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
