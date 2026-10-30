import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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
}
