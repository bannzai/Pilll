import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/settings/components/rows/first_weekday.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/fake.dart';

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
    // 保存する値は切り替えた後にしか決まらないため、タップの代わりに SwitchListTile の onChanged を呼んで検証する
    for (final (isFirstWeekdayMonday, scenario) in [
      (false, "スイッチが OFF の時に ON へ切り替えると、ON が保存されてスイッチが ON になる"),
      (true, "スイッチが ON の時に OFF へ切り替えると、OFF が保存されてスイッチが OFF になる"),
    ]) {
      testWidgets(scenario, (WidgetTester tester) async {
        analytics = FakeAnalytics();
        SharedPreferences.setMockInitialValues(
            {BoolKey.isFirstWeekdayMonday: isFirstWeekdayMonday});
        final sharedPreferences = await SharedPreferences.getInstance();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(sharedPreferences)
            ],
            child: const MaterialApp(home: Material(child: FirstWeekdayRow())),
          ),
        );

        tester
            .widget<SwitchListTile>(find.byType(SwitchListTile))
            .onChanged!(!isFirstWeekdayMonday);
        await tester.pump();

        expect(sharedPreferences.getBool(BoolKey.isFirstWeekdayMonday),
            !isFirstWeekdayMonday);
        expect(tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
            !isFirstWeekdayMonday);
      });
    }
  });
}
