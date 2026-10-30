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

  group('#resolveDeviceAppLocale', () {
    test('端末の言語が ja_JP の場合は ja', () {
      expect(
          resolveDeviceAppLocale(preferredLocales: const [Locale('ja', 'JP')]),
          const Locale('ja'));
    });
    test('端末の言語が en_US の場合は en', () {
      expect(
          resolveDeviceAppLocale(preferredLocales: const [Locale('en', 'US')]),
          const Locale('en'));
    });
    test('端末の言語が de_DE の場合は de', () {
      expect(
          resolveDeviceAppLocale(preferredLocales: const [Locale('de', 'DE')]),
          const Locale('de'));
    });
    test('端末の第一言語が対象言語に無く、第二言語が en の場合は en', () {
      expect(
          resolveDeviceAppLocale(
              preferredLocales: const [Locale('ga', 'IE'), Locale('en', 'US')]),
          const Locale('en'));
    });
    // MaterialApp が同じ規則で解決するため、アプリを開いた時と同じく対象言語の先頭の af になる
    test('端末の言語がどれも対象言語に無い場合は、アプリを開いた時と同じく対象言語の先頭の af', () {
      expect(
          resolveDeviceAppLocale(preferredLocales: const [Locale('ga', 'IE')]),
          const Locale('af'));
    });
  });

  group('#AppLocalizationResolver', () {
    // flutter test は kDebugMode が true のため、debug ビルドの分岐を通る
    /// [initialSharedPreferencesValues] を SharedPreferences の初期値にして AppLocalizationResolver を描画し、
    /// 使った SharedPreferences を返す
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

    testWidgets('表示言語を変えると、配下の State を保ったまま新しい言語で描画し直される', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          ],
          child: MaterialApp(
            home: AppLocalizationResolver(
              builder: (_) => const _LocaleNameProbe(),
            ),
          ),
        ),
      );
      final stateBeforeChange =
          tester.state<_LocaleNameProbeState>(find.byType(_LocaleNameProbe));
      expect(stateBeforeChange.builtLocaleName, 'ja');

      final container = ProviderScope.containerOf(
          tester.element(find.byType(AppLocalizationResolver)));
      await container
          .read(stringSharedPreferencesProvider(StringKey.debugAppLanguageCode)
              .notifier)
          .set('de');
      await tester.pump();

      // タブの位置のような State が初期化されないよう、同じ State のまま build し直される
      final stateAfterChange =
          tester.state<_LocaleNameProbeState>(find.byType(_LocaleNameProbe));
      expect(identical(stateAfterChange, stateBeforeChange), isTrue);
      expect(stateAfterChange.builtLocaleName, 'de');
    });
  });
}

/// const で生成され、親の build だけでは描画し直されない子を表す。最後の build で読んだ [L] の言語を記録する
class _LocaleNameProbe extends StatefulWidget {
  const _LocaleNameProbe();

  @override
  State<_LocaleNameProbe> createState() => _LocaleNameProbeState();
}

class _LocaleNameProbeState extends State<_LocaleNameProbe> {
  /// 最後の build で読んだ [L] の言語コード
  String? builtLocaleName;

  @override
  Widget build(BuildContext context) {
    builtLocaleName = L.localeName;
    return const SizedBox.shrink();
  }
}
