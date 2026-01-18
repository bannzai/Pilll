import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_function.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/utils/datetime/date_range.dart';

void main() {
  group('#bandLength', () {
    test('週内での生理期間のバンド長計算', () {
      // 同じ週内での3日間の生理期間
      final menstruation = Menstruation(
        beginDate: DateTime(2025, 1, 13), // 月曜日
        endDate: DateTime(2025, 1, 15), // 水曜日
        createdAt: DateTime(2025, 1, 13),
      );
      final model = CalendarMenstruationBandModel(menstruation);
      final weekRange = DateRange(
        DateTime(2025, 1, 12),
        DateTime(2025, 1, 18),
      ); // 日曜日から土曜日

      final length = bandLength(weekRange, model, false);
      expect(length, 3); // 13, 14, 15の3日間
    });

    test('週をまたぐ生理期間のバンド長計算（前半）', () {
      // 週をまたぐ13日間の生理期間
      final menstruation = Menstruation(
        beginDate: DateTime(2025, 1, 10), // 金曜日
        endDate: DateTime(2025, 1, 22), // 水曜日（13日間）
        createdAt: DateTime(2025, 1, 10),
      );
      final model = CalendarMenstruationBandModel(menstruation);

      // 第1週: 1/5-1/11
      final week1Range = DateRange(DateTime(2025, 1, 5), DateTime(2025, 1, 11));
      final week1Length = bandLength(week1Range, model, false);
      expect(week1Length, 2); // 10, 11の2日間

      // 第2週: 1/12-1/18（この週が表示されない問題）
      final week2Range = DateRange(
        DateTime(2025, 1, 12),
        DateTime(2025, 1, 18),
      );
      final week2Length = bandLength(
        week2Range,
        model,
        true,
      ); // isLineBreak = true
      expect(week2Length, 7); // 12-18の7日間すべて

      // 第3週: 1/19-1/25
      final week3Range = DateRange(
        DateTime(2025, 1, 19),
        DateTime(2025, 1, 25),
      );
      final week3Length = bandLength(
        week3Range,
        model,
        true,
      ); // isLineBreak = true
      expect(week3Length, 4); // 19-22の4日間
    });
  });

  group('#isNecessaryLineBreak', () {
    test('週の開始日から始まる場合はlineBreak不要', () {
      final weekRange = DateRange(DateTime(2025, 1, 12), DateTime(2025, 1, 18));
      final result = isNecessaryLineBreak(DateTime(2025, 1, 12), weekRange);
      expect(result, false);
    });

    test('週の途中から始まる場合はlineBreak不要', () {
      final weekRange = DateRange(DateTime(2025, 1, 12), DateTime(2025, 1, 18));
      final result = isNecessaryLineBreak(DateTime(2025, 1, 14), weekRange);
      expect(result, false);
    });

    test('週の範囲外から始まる場合はlineBreak必要', () {
      final weekRange = DateRange(DateTime(2025, 1, 12), DateTime(2025, 1, 18));
      final result = isNecessaryLineBreak(DateTime(2025, 1, 10), weekRange);
      expect(result, true);
    });
  });

  group('#offsetForStartPositionAtLine', () {
    test('週の開始日から始まる場合のoffset', () {
      final weekRange = DateRange(DateTime(2025, 1, 12), DateTime(2025, 1, 18));
      final offset = offsetForStartPositionAtLine(
        DateTime(2025, 1, 12),
        weekRange,
      );
      expect(offset, 0);
    });

    test('週の途中から始まる場合のoffset', () {
      final weekRange = DateRange(DateTime(2025, 1, 12), DateTime(2025, 1, 18));
      final offset = offsetForStartPositionAtLine(
        DateTime(2025, 1, 14),
        weekRange,
      );
      expect(offset, 2); // 12日から14日まで2日間
    });

    test('週の範囲外から始まる場合のoffset', () {
      final weekRange = DateRange(DateTime(2025, 1, 12), DateTime(2025, 1, 18));
      final offset = offsetForStartPositionAtLine(
        DateTime(2025, 1, 10),
        weekRange,
      );
      expect(offset, 0); // lineBreakの場合は0
    });
  });
}
