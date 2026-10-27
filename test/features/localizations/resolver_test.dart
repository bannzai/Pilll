import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/localizations/resolver.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('#debugAppLocale', () {
    test('保存が無い場合は ja', () {
      expect(debugAppLocale(savedLanguageCode: null), const Locale('ja'));
    });
    test('対象言語の de が保存されている場合は de', () {
      expect(debugAppLocale(savedLanguageCode: 'de'), const Locale('de'));
    });
    test('対象言語に無い言語コードが保存されている場合は ja', () {
      expect(debugAppLocale(savedLanguageCode: 'xx'), const Locale('ja'));
    });
  });

  group('#AppLocalizationResolver', () {
    // flutter test は kDebugMode が true のため、debug ビルドの分岐を通る
    Future<SharedPreferences> pumpAppLocalizationResolver(
      WidgetTester tester, {
      required Map<String, Object> initialSharedPreferencesValues,
    }) async {
      SharedPreferences.setMockInitialValues(initialSharedPreferencesValues);
      final sharedPreferences = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          ],
          child: MaterialApp(
            home: AppLocalizationResolver(
              builder: (_) => const SizedBox.shrink(),
            ),
          ),
        ),
      );
      return sharedPreferences;
    }

    testWidgets('表示言語の保存が無い場合は ja の文言と日付書式になる', (tester) async {
      await pumpAppLocalizationResolver(tester,
          initialSharedPreferencesValues: {});
      expect(L.localeName, 'ja');
      expect(Intl.defaultLocale, 'ja');
    });

    testWidgets('表示言語に de が保存されている場合は de の文言と日付書式になる', (tester) async {
      await pumpAppLocalizationResolver(
        tester,
        initialSharedPreferencesValues: {StringKey.debugAppLanguageCode: 'de'},
      );
      expect(L.localeName, 'de');
      expect(Intl.defaultLocale, 'de');
    });

    testWidgets('表示言語を de に保存すると、再起動を待たずに de に切り替わる', (tester) async {
      final sharedPreferences = await pumpAppLocalizationResolver(tester,
          initialSharedPreferencesValues: {});
      expect(L.localeName, 'ja');

      final container = ProviderScope.containerOf(
          tester.element(find.byType(AppLocalizationResolver)));
      await container
          .read(stringSharedPreferencesProvider(StringKey.debugAppLanguageCode)
              .notifier)
          .set('de');
      await tester.pump();

      expect(L.localeName, 'de');
      expect(Intl.defaultLocale, 'de');
      // 再起動後も同じ言語になるよう SharedPreferences に保存されている
      expect(sharedPreferences.getString(StringKey.debugAppLanguageCode), 'de');
    });
  });
}
