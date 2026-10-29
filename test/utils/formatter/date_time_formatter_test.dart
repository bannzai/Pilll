import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  group('#abbreviatedMonth', () {
    test('ja では「10月」のように月を表す単位が付く', () {
      expect(
          DateTimeFormatter.abbreviatedMonth(DateTime(2025, 10, 1),
              localeName: 'ja_JP'),
          '10月');
    });
    test('en では数字だけではなく月名の省略形になる', () {
      expect(
          DateTimeFormatter.abbreviatedMonth(DateTime(2025, 10, 1),
              localeName: 'en_US'),
          'Oct');
    });
    test('de では数字だけではなく月名の省略形になる', () {
      expect(
          DateTimeFormatter.abbreviatedMonth(DateTime(2025, 10, 1),
              localeName: 'de_DE'),
          'Okt');
    });
    test('月名の長い 9 月でも省略形になる', () {
      expect(
          DateTimeFormatter.abbreviatedMonth(DateTime(2025, 9, 30),
              localeName: 'de_DE'),
          'Sep');
      expect(
          DateTimeFormatter.abbreviatedMonth(DateTime(2025, 9, 30),
              localeName: 'fr_FR'),
          'sept.');
    });
    test('年をまたぐ 12 月と 1 月も月名になる', () {
      expect(
          DateTimeFormatter.abbreviatedMonth(DateTime(2025, 12, 31),
              localeName: 'en_US'),
          'Dec');
      expect(
          DateTimeFormatter.abbreviatedMonth(DateTime(2026, 1, 1),
              localeName: 'en_US'),
          'Jan');
      expect(
          DateTimeFormatter.abbreviatedMonth(DateTime(2026, 1, 1),
              localeName: 'ja_JP'),
          '1月');
    });
  });
}
