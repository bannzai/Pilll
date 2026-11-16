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

  group('#abbreviatedMonth', () {
    test('Intl.defaultLocale が ja の時は「10月」のように月を表す単位が付く', () {
      useDefaultLocale('ja');
      expect(DateTimeFormatter.abbreviatedMonth(date), '10月');
    });
    test('Intl.defaultLocale が en の時は数字だけではなく月名の省略形になる', () {
      useDefaultLocale('en');
      expect(DateTimeFormatter.abbreviatedMonth(date), 'Oct');
    });
    test('Intl.defaultLocale が de の時は数字だけではなく月名の省略形になる', () {
      useDefaultLocale('de');
      expect(DateTimeFormatter.abbreviatedMonth(date), 'Okt');
    });
    test('月名の長い 9 月でも省略形になる', () {
      useDefaultLocale('de');
      expect(DateTimeFormatter.abbreviatedMonth(DateTime(2025, 9, 30)), 'Sep');
      useDefaultLocale('fr');
      expect(
          DateTimeFormatter.abbreviatedMonth(DateTime(2025, 9, 30)), 'sept.');
    });
    test('年をまたぐ 12 月と 1 月も月名になる', () {
      useDefaultLocale('en');
      expect(DateTimeFormatter.abbreviatedMonth(DateTime(2025, 12, 31)), 'Dec');
      expect(DateTimeFormatter.abbreviatedMonth(DateTime(2026, 1, 1)), 'Jan');
      useDefaultLocale('ja');
      expect(DateTimeFormatter.abbreviatedMonth(DateTime(2026, 1, 1)), '1月');
    });
  });

  group('#monthAndWeekday', () {
    // 2027-01-16 は土曜日。生理予定日カードで es が「sáb, 16/1」になっていた日付
    final date = DateTime(2027, 1, 16);

    test('ja は数字の書式のまま M/d(曜日)', () {
      useDefaultLocale('ja');
      expect(DateTimeFormatter.monthAndWeekday(date), '1/16(土)');
    });
    test('ja_JP のように国コード付きでも ja の書式', () {
      useDefaultLocale('ja_JP');
      expect(DateTimeFormatter.monthAndWeekday(date), '1/16(土)');
    });
    test('en は月名の省略形', () {
      useDefaultLocale('en');
      expect(DateTimeFormatter.monthAndWeekday(date), 'Sat, Jan 16');
    });
    test('es は月名の省略形', () {
      useDefaultLocale('es');
      expect(DateTimeFormatter.monthAndWeekday(date), 'sáb, 16 ene');
    });
    test('de は月名の省略形', () {
      useDefaultLocale('de');
      expect(DateTimeFormatter.monthAndWeekday(date), 'Sa., 16. Jan.');
    });
    test('fr は月名の省略形', () {
      useDefaultLocale('fr');
      expect(DateTimeFormatter.monthAndWeekday(date), 'sam. 16 janv.');
    });
    test('ko は月名の書式', () {
      useDefaultLocale('ko');
      expect(DateTimeFormatter.monthAndWeekday(date), '1월 16일 (토)');
    });
    test('zh は月名の書式', () {
      useDefaultLocale('zh');
      expect(DateTimeFormatter.monthAndWeekday(date), '1月16日周六');
    });
    test('pt は月名の省略形', () {
      useDefaultLocale('pt');
      expect(DateTimeFormatter.monthAndWeekday(date), 'sáb., 16 de jan.');
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
    // 2026-10-29 は木曜日。月 (10) と日 (29) を取り違えると分かる日付にする
    final date = DateTime(2026, 10, 29);

    test('ja は M/d', () {
      useDefaultLocale('ja');
      expect(DateTimeFormatter.monthAndDay(date), '10/29');
    });
    test('en は M/d', () {
      useDefaultLocale('en');
      expect(DateTimeFormatter.monthAndDay(date), '10/29');
    });
    test('es は d/M', () {
      useDefaultLocale('es');
      expect(DateTimeFormatter.monthAndDay(date), '29/10');
    });
    test('de は d.M.', () {
      useDefaultLocale('de');
      expect(DateTimeFormatter.monthAndDay(date), '29.10.');
    });
    test('fr は dd/MM', () {
      useDefaultLocale('fr');
      expect(DateTimeFormatter.monthAndDay(date), '29/10');
    });
    test('ko は M. d.', () {
      useDefaultLocale('ko');
      expect(DateTimeFormatter.monthAndDay(date), '10. 29.');
    });
    test('zh は M/d', () {
      useDefaultLocale('zh');
      expect(DateTimeFormatter.monthAndDay(date), '10/29');
    });
    test('pt は dd/MM', () {
      useDefaultLocale('pt');
      expect(DateTimeFormatter.monthAndDay(date), '29/10');
    });
    test('1 桁の月日でも ja は M/d', () {
      useDefaultLocale('ja');
      expect(DateTimeFormatter.monthAndDay(DateTime(2026, 1, 5)), '1/5');
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
        expect(DateTimeFormatter.abbreviatedMonth(date), isNotEmpty,
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
