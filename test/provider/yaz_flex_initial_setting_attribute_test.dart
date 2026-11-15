import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/provider/yaz_flex_initial_setting_attribute.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/error_log.dart';

/// Firebase Analytics を呼ばず、setUserProperties に渡された名前と値を呼ばれた順に記録する
class _RecordingAnalytics extends Fake implements Analytics {
  /// setUserProperties に渡された (名前, 値)。呼ばれた順に並ぶ
  final userProperties = <(String, dynamic)>[];

  @override
  void setUserProperties(String name, value) {
    userProperties.add((name, value));
  }
}

/// setUserProperties が例外を投げる Analytics
class _ThrowingAnalytics extends Fake implements Analytics {
  @override
  void setUserProperties(String name, value) {
    throw StateError('analytics is not available');
  }
}

/// Crashlytics を呼ばず、recordError に渡された例外を呼ばれた順に記録する
class _RecordingErrorLogger extends Fake implements ErrorLogger {
  /// recordError に渡された例外。呼ばれた順に並ぶ
  final recordedExceptions = <dynamic>[];

  @override
  void recordError(exception, StackTrace? stack) {
    recordedExceptions.add(exception);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // purchases_flutter が RevenueCat のネイティブ SDK を呼ぶチャンネル
  const purchasesChannel = MethodChannel('purchases_flutter');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(purchasesChannel, null);
  });

  group("#SetYazFlexInitialSettingAttribute", () {
    test("属性の名前は Firebase Analytics のユーザープロパティ名の上限の 24 文字以内", () {
      expect(yazFlexInitialSettingAttributeName, 'yaz_flex_initial_setting');
      expect(yazFlexInitialSettingAttributeName.length, lessThanOrEqualTo(24));
    });

    test(
        "isYazFlex が true の場合は Firebase Analytics と RevenueCat の両方に 'true' を載せる",
        () async {
      final recordingAnalytics = _RecordingAnalytics();
      analytics = recordingAnalytics;
      final recordingErrorLogger = _RecordingErrorLogger();
      errorLogger = recordingErrorLogger;
      final purchasesMethodCalls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(purchasesChannel, (methodCall) async {
        purchasesMethodCalls.add(methodCall);
        return null;
      });

      await SetYazFlexInitialSettingAttribute()(isYazFlex: true);

      expect(recordingAnalytics.userProperties, [
        ('yaz_flex_initial_setting', 'true'),
      ]);
      expect(purchasesMethodCalls.map((e) => e.method), ['setAttributes']);
      expect(purchasesMethodCalls.single.arguments, {
        'attributes': {'yaz_flex_initial_setting': 'true'},
      });
      expect(recordingErrorLogger.recordedExceptions, isEmpty);
    });

    test(
        "isYazFlex が false の場合は Firebase Analytics と RevenueCat の両方に 'false' を載せる",
        () async {
      final recordingAnalytics = _RecordingAnalytics();
      analytics = recordingAnalytics;
      errorLogger = _RecordingErrorLogger();
      final purchasesMethodCalls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(purchasesChannel, (methodCall) async {
        purchasesMethodCalls.add(methodCall);
        return null;
      });

      await SetYazFlexInitialSettingAttribute()(isYazFlex: false);

      expect(recordingAnalytics.userProperties, [
        ('yaz_flex_initial_setting', 'false'),
      ]);
      expect(purchasesMethodCalls.single.arguments, {
        'attributes': {'yaz_flex_initial_setting': 'false'},
      });
    });

    test("RevenueCat への書き込みが失敗した場合は例外を投げず、エラーを記録する", () async {
      final recordingAnalytics = _RecordingAnalytics();
      analytics = recordingAnalytics;
      final recordingErrorLogger = _RecordingErrorLogger();
      errorLogger = recordingErrorLogger;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(purchasesChannel, (methodCall) async {
        throw PlatformException(code: '10', message: 'network error');
      });

      await SetYazFlexInitialSettingAttribute()(isYazFlex: true);

      expect(recordingAnalytics.userProperties, [
        ('yaz_flex_initial_setting', 'true'),
      ]);
      expect(recordingErrorLogger.recordedExceptions.length, 1);
      expect(
        recordingErrorLogger.recordedExceptions.single,
        isA<PlatformException>(),
      );
    });

    test(
        "Firebase Analytics への書き込みが例外を投げた場合は例外を投げず、エラーを記録して RevenueCat には載せる",
        () async {
      analytics = _ThrowingAnalytics();
      final recordingErrorLogger = _RecordingErrorLogger();
      errorLogger = recordingErrorLogger;
      final purchasesMethodCalls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(purchasesChannel, (methodCall) async {
        purchasesMethodCalls.add(methodCall);
        return null;
      });

      await SetYazFlexInitialSettingAttribute()(isYazFlex: true);

      expect(purchasesMethodCalls.single.arguments, {
        'attributes': {'yaz_flex_initial_setting': 'true'},
      });
      expect(recordingErrorLogger.recordedExceptions.length, 1);
      expect(recordingErrorLogger.recordedExceptions.single, isA<StateError>());
    });
  });
}
