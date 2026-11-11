import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/settings/components/rows/first_weekday.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group("SwitchListTile", () {
    testWidgets("設定を一度も切り替えていない端末はスイッチが OFF", (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider
                .overrideWithValue(await SharedPreferences.getInstance())
          ],
          child: const MaterialApp(home: Material(child: FirstWeekdayRow())),
        ),
      );

      expect(tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
          isFalse);
    });
    testWidgets("週の始まりを月曜日にする設定が ON で保存されている端末はスイッチが ON",
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues(
          {BoolKey.isFirstWeekdayMonday: true});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider
                .overrideWithValue(await SharedPreferences.getInstance())
          ],
          child: const MaterialApp(home: Material(child: FirstWeekdayRow())),
        ),
      );

      expect(tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
          isTrue);
    });
    testWidgets("週の始まりを月曜日にする設定が OFF で保存されている端末はスイッチが OFF",
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues(
          {BoolKey.isFirstWeekdayMonday: false});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider
                .overrideWithValue(await SharedPreferences.getInstance())
          ],
          child: const MaterialApp(home: Material(child: FirstWeekdayRow())),
        ),
      );

      expect(tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
          isFalse);
    });
  });
}
