import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  // Intl.defaultLocale はグローバルなので、各テストの後に元へ戻す
  void useDefaultLocale(String locale) {
    final originalDefaultLocale = Intl.defaultLocale;
    addTearDown(() => Intl.defaultLocale = originalDefaultLocale);
    Intl.defaultLocale = locale;
  }

  // 2026-10-05 は月曜日
  final date = DateTime(2026, 10, 5);

  group('#yearAndMonth', () {
    test('Intl.defaultLocale が ja の時は日本語の書式になる', () {
      useDefaultLocale('ja');
      expect(DateTimeFormatter.yearAndMonth(date), '2026年10月');
    });
    test('Intl.defaultLocale が en の時は英語の書式になる', () {
      useDefaultLocale('en');
      expect(DateTimeFormatter.yearAndMonth(date), 'Oct 2026');
    });
    test('Intl.defaultLocale が de の時はドイツ語の書式になる', () {
      useDefaultLocale('de');
      expect(DateTimeFormatter.yearAndMonth(date), 'Okt. 2026');
    });
  });

  group('#yearAndMonthAndDay', () {
    test('Intl.defaultLocale が ja の時は日本語の書式になる', () {
      useDefaultLocale('ja');
      expect(DateTimeFormatter.yearAndMonthAndDay(date), '2026年10月5日');
    });
    test('Intl.defaultLocale が en の時は英語の書式になる', () {
      useDefaultLocale('en');
      expect(DateTimeFormatter.yearAndMonthAndDay(date), 'Oct 5, 2026');
    });
    test('Intl.defaultLocale が de の時はドイツ語の書式になる', () {
      useDefaultLocale('de');
      expect(DateTimeFormatter.yearAndMonthAndDay(date), '5. Okt. 2026');
    });
  });

  group('#jaMonth', () {
    test('Intl.defaultLocale が ja の時は日本語の書式になる', () {
      useDefaultLocale('ja');
      expect(DateTimeFormatter.jaMonth(date), '10月');
    });
    test('Intl.defaultLocale が en の時は英語の書式になる', () {
      useDefaultLocale('en');
      expect(DateTimeFormatter.jaMonth(date), '10');
    });
    test('Intl.defaultLocale が de の時はドイツ語の書式になる', () {
      useDefaultLocale('de');
      expect(DateTimeFormatter.jaMonth(date), '10');
    });
  });

  group('#monthAndWeekday', () {
    test('Intl.defaultLocale が ja の時は日本語の書式になる', () {
      useDefaultLocale('ja');
      expect(DateTimeFormatter.monthAndWeekday(date), '10/5(月)');
    });
    test('Intl.defaultLocale が en の時は英語の書式になる', () {
      useDefaultLocale('en');
      expect(DateTimeFormatter.monthAndWeekday(date), 'Mon, 10/5');
    });
    test('Intl.defaultLocale が de の時はドイツ語の書式になる', () {
      useDefaultLocale('de');
      expect(DateTimeFormatter.monthAndWeekday(date), 'Mo., 5.10.');
    });
  });

  group('#shortWeekday', () {
    test('Intl.defaultLocale が ja の時は日本語の曜日になる', () {
      useDefaultLocale('ja');
      expect(DateTimeFormatter.shortWeekday(date), '月');
    });
    test('Intl.defaultLocale が en の時は英語の曜日になる', () {
      useDefaultLocale('en');
      expect(DateTimeFormatter.shortWeekday(date), 'Mon');
    });
    test('Intl.defaultLocale が de の時はドイツ語の曜日になる', () {
      useDefaultLocale('de');
      expect(DateTimeFormatter.shortWeekday(date), 'Mo');
    });
  });

  group('#shortWeekdays', () {
    test('Intl.defaultLocale が ja の時は日曜始まりの日本語の曜日になる', () {
      useDefaultLocale('ja');
      expect(DateTimeFormatter.shortWeekdays(),
          ['日', '月', '火', '水', '木', '金', '土']);
    });
    test('Intl.defaultLocale が en の時は日曜始まりの英語の曜日になる', () {
      useDefaultLocale('en');
      expect(DateTimeFormatter.shortWeekdays(),
          ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']);
    });
    test('Intl.defaultLocale が de の時は日曜始まりのドイツ語の曜日になる', () {
      useDefaultLocale('de');
      expect(DateTimeFormatter.shortWeekdays(),
          ['So.', 'Mo.', 'Di.', 'Mi.', 'Do.', 'Fr.', 'Sa.']);
    });
  });

  group('#slashYearAndMonthAndDay', () {
    test('Intl.defaultLocale が ja・en・de のどれでも yyyy/MM/dd になる', () {
      for (final locale in ['ja', 'en', 'de']) {
        useDefaultLocale(locale);
        expect(DateTimeFormatter.slashYearAndMonthAndDay(date), '2026/10/05',
            reason: locale);
      }
    });
  });

  group('#monthAndDay', () {
    test('Intl.defaultLocale に関わらず M/d になる', () {
      useDefaultLocale('de');
      expect(DateTimeFormatter.monthAndDay(date), '10/5');
    });
  });

  group('アプリの対応言語', () {
    // AppLocalizationResolver は Intl.defaultLocale に languageCode だけを設定するため、全対応言語の languageCode で例外にならないことを確かめる
    test('全対応言語の languageCode を Intl.defaultLocale にしても表示用のフォーマッタが例外にならない', () {
      for (final languageCode in AppLocalizations.supportedLocales
          .map((locale) => locale.languageCode)
          .toSet()) {
        useDefaultLocale(languageCode);
        expect(DateTimeFormatter.yearAndMonth(date), isNotEmpty,
            reason: languageCode);
        expect(DateTimeFormatter.yearAndMonthAndDay(date), isNotEmpty,
            reason: languageCode);
        expect(DateTimeFormatter.jaMonth(date), isNotEmpty,
            reason: languageCode);
        expect(DateTimeFormatter.monthAndWeekday(date), isNotEmpty,
            reason: languageCode);
        expect(DateTimeFormatter.slashYearAndMonthAndDay(date), isNotEmpty,
            reason: languageCode);
        expect(DateTimeFormatter.slashYearAndMonth(date), isNotEmpty,
            reason: languageCode);
        expect(DateTimeFormatter.slashMonthAndDay(date), isNotEmpty,
            reason: languageCode);
        expect(DateTimeFormatter.shortWeekday(date), isNotEmpty,
            reason: languageCode);
        expect(DateTimeFormatter.shortWeekdays(), hasLength(7),
            reason: languageCode);
      }
    });
  });
}
