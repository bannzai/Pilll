import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/native/widget.dart';

void main() {
  // home_widget plugin の Dart 側が使う MethodChannel
  const homeWidgetChannel = MethodChannel('home_widget');

  group('#syncActivePillSheetValue', () {
    test(
      'ピルシートグループが無い時は、値が null のキーも data: null のまま plugin の saveWidgetData に渡す',
      () async {
        TestWidgetsFlutterBinding.ensureInitialized();
        final homeWidgetCalls = <MethodCall>[];
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(homeWidgetChannel, (call) async {
          homeWidgetCalls.add(call);
          return true;
        });
        addTearDown(
          () => TestDefaultBinaryMessengerBinding
              .instance.defaultBinaryMessenger
              .setMockMethodCallHandler(homeWidgetChannel, null),
        );

        await syncActivePillSheetValue(pillSheetGroup: null);

        // saveWidgetData に渡した id と data の対応
        final savedWidgetData = {
          for (final call in homeWidgetCalls.where(
            (call) => call.method == 'saveWidgetData',
          ))
            (call.arguments as Map)['id']: (call.arguments as Map)['data'],
        };
        expect(savedWidgetData, containsPair('pillSheetLastTakenDate', null));
        expect(savedWidgetData, containsPair('pillSheetTodayPillNumber', null));
        expect(
          savedWidgetData,
          containsPair('pillSheetGroupTodayPillNumber', null),
        );
        expect(
          savedWidgetData,
          containsPair('pillSheetEndDisplayPillNumber', null),
        );
        expect(
          savedWidgetData,
          containsPair('settingPillSheetAppearanceMode', null),
        );
        expect(
          savedWidgetData,
          containsPair('pillSheetGroupPillSheetAppearanceMode', null),
        );
      },
    );
  });

  group('#syncUserStatus', () {
    test('ユーザーが無い時は data: null のまま plugin の saveWidgetData に渡す', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final homeWidgetCalls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(homeWidgetChannel, (call) async {
        homeWidgetCalls.add(call);
        return true;
      });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(homeWidgetChannel, null),
      );

      await syncUserStatus(user: null);

      expect(
        homeWidgetCalls
            .where((call) => call.method == 'saveWidgetData')
            .single
            .arguments,
        {'id': 'userIsPremiumOrTrial', 'data': null},
      );
    });
  });
}
