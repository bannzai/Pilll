import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/provider/first_weekday.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group("#firstWeekdayProvider", () {
    test("設定を一度も切り替えていない端末は日曜日", () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer(overrides: [
        sharedPreferencesProvider
            .overrideWithValue(await SharedPreferences.getInstance())
      ]);
      addTearDown(container.dispose);

      expect(container.read(firstWeekdayProvider), Weekday.Sunday);
    });
    test("週の始まりを月曜日にする設定が ON で保存されている端末は月曜日", () async {
      SharedPreferences.setMockInitialValues(
          {BoolKey.isFirstWeekdayMonday: true});
      final container = ProviderContainer(overrides: [
        sharedPreferencesProvider
            .overrideWithValue(await SharedPreferences.getInstance())
      ]);
      addTearDown(container.dispose);

      expect(container.read(firstWeekdayProvider), Weekday.Monday);
    });
    test("週の始まりを月曜日にする設定が OFF で保存されている端末は日曜日", () async {
      SharedPreferences.setMockInitialValues(
          {BoolKey.isFirstWeekdayMonday: false});
      final container = ProviderContainer(overrides: [
        sharedPreferencesProvider
            .overrideWithValue(await SharedPreferences.getInstance())
      ]);
      addTearDown(container.dispose);

      expect(container.read(firstWeekdayProvider), Weekday.Sunday);
    });
    test("設定を ON に切り替えると月曜日になり、OFF に戻すと日曜日になる", () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer(overrides: [
        sharedPreferencesProvider
            .overrideWithValue(await SharedPreferences.getInstance())
      ]);
      addTearDown(container.dispose);

      await container
          .read(boolSharedPreferencesProvider(BoolKey.isFirstWeekdayMonday)
              .notifier)
          .set(true);
      expect(container.read(firstWeekdayProvider), Weekday.Monday);

      await container
          .read(boolSharedPreferencesProvider(BoolKey.isFirstWeekdayMonday)
              .notifier)
          .set(false);
      expect(container.read(firstWeekdayProvider), Weekday.Sunday);
    });
  });
}
