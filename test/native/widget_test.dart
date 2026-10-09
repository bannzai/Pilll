import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/native/channel.dart';
import 'package:pilll/native/widget.dart';

void main() {
  // home_widget plugin の Dart 側が使う MethodChannel
  const homeWidgetChannel = MethodChannel('home_widget');

  group('#saveWidgetDataOrRemove', () {
    late List<MethodCall> homeWidgetCalls;
    late List<MethodCall> appChannelCalls;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      homeWidgetCalls = [];
      appChannelCalls = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(homeWidgetChannel, (call) async {
        homeWidgetCalls.add(call);
        return true;
      });
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, (call) async {
        appChannelCalls.add(call);
        return {'result': 'success'};
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(homeWidgetChannel, null);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, null);
      debugDefaultTargetPlatformOverride = null;
    });

    test('iOS で値が null の時は plugin を呼ばず removeWidgetData でキーを削除する', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      await saveWidgetDataOrRemove(key: 'pillSheetLastTakenDate', value: null);

      expect(homeWidgetCalls, isEmpty);
      expect(appChannelCalls.single.method, 'removeWidgetData');
      expect(
          appChannelCalls.single.arguments, {'key': 'pillSheetLastTakenDate'});
    });

    test('iOS で値がある時は plugin の saveWidgetData に渡す', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      await saveWidgetDataOrRemove(key: 'pillSheetTodayPillNumber', value: 3);

      expect(appChannelCalls, isEmpty);
      expect(homeWidgetCalls.single.method, 'saveWidgetData');
      expect(homeWidgetCalls.single.arguments,
          {'id': 'pillSheetTodayPillNumber', 'data': 3});
    });

    test('Android では値が null でも従来どおり plugin の saveWidgetData に渡す', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      await saveWidgetDataOrRemove(key: 'pillSheetLastTakenDate', value: null);

      expect(appChannelCalls, isEmpty);
      expect(homeWidgetCalls.single.method, 'saveWidgetData');
      expect(homeWidgetCalls.single.arguments,
          {'id': 'pillSheetLastTakenDate', 'data': null});
    });
  });
}
