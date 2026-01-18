import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';

void main() {
  group('DateRange.inRange テスト', () {
    test('13日間の生理期間と各週の関係', () {
      // 13日間の生理期間（金曜日から開始）
      final menstruation = Menstruation(
        beginDate: DateTime(2025, 1, 10), // 金曜日
        endDate: DateTime(2025, 1, 22), // 水曜日（13日間）
        createdAt: DateTime(2025, 1, 10),
      );
      final model = CalendarMenstruationBandModel(menstruation);

      // 第1週: 1/5(日) - 1/11(土)
      final week1 = DateRange(DateTime(2025, 1, 5), DateTime(2025, 1, 11));
      // 第1週: ${week1.begin} - ${week1.end}
      // 生理期間: ${model.begin} - ${model.end}
      // week1.inRange(model.begin): ${week1.inRange(model.begin)} // 1/10は週1に含まれる
      // week1.inRange(model.end): ${week1.inRange(model.end)}     // 1/22は週1に含まれない

      expect(week1.inRange(model.begin), true); // 1/10は第1週に含まれる
      expect(week1.inRange(model.end), false); // 1/22は第1週に含まれない

      // 第2週: 1/12(日) - 1/18(土)
      final week2 = DateRange(DateTime(2025, 1, 12), DateTime(2025, 1, 18));
      // 第2週: ${week2.begin} - ${week2.end}
      // week2.inRange(model.begin): ${week2.inRange(model.begin)} // 1/10は週2に含まれない
      // week2.inRange(model.end): ${week2.inRange(model.end)}     // 1/22は週2に含まれない

      expect(week2.inRange(model.begin), false); // 1/10は第2週に含まれない
      expect(week2.inRange(model.end), false); // 1/22は第2週に含まれない

      // 第3週: 1/19(日) - 1/25(土)
      final week3 = DateRange(DateTime(2025, 1, 19), DateTime(2025, 1, 25));
      // 第3週: ${week3.begin} - ${week3.end}
      // week3.inRange(model.begin): ${week3.inRange(model.begin)} // 1/10は週3に含まれない
      // week3.inRange(model.end): ${week3.inRange(model.end)}     // 1/22は週3に含まれる

      expect(week3.inRange(model.begin), false); // 1/10は第3週に含まれない
      expect(week3.inRange(model.end), true); // 1/22は第3週に含まれる

      // _containsメソッドのロジックを再現
      // _containsメソッドのロジック確認:

      // 第1週での判定
      final week1Contains =
          week1.inRange(model.begin) || week1.inRange(model.end);
      // 第1週contains: $week1Contains // true
      expect(week1Contains, true);

      // 第2週での判定（ここが問題！）
      final week2Contains =
          week2.inRange(model.begin) || week2.inRange(model.end);
      // 第2週contains: $week2Contains // false！
      expect(week2Contains, false); // これが問題の原因

      // 第3週での判定
      final week3Contains =
          week3.inRange(model.begin) || week3.inRange(model.end);
      // 第3週contains: $week3Contains // true
      expect(week3Contains, true);
    });

    test('正しい判定ロジックの提案', () {
      final menstruation = Menstruation(
        beginDate: DateTime(2025, 1, 10),
        endDate: DateTime(2025, 1, 22),
        createdAt: DateTime(2025, 1, 10),
      );
      final model = CalendarMenstruationBandModel(menstruation);
      final week2 = DateRange(DateTime(2025, 1, 12), DateTime(2025, 1, 18));

      // 現在のロジック：生理期間の開始日または終了日が週に含まれるか
      final currentLogic =
          week2.inRange(model.begin) || week2.inRange(model.end);
      expect(currentLogic, false); // 問題：第2週は判定されない

      // 提案するロジック：週の期間と生理期間が重なるか
      final proposedLogic = _periodsOverlap(
        week2,
        DateRange(model.begin, model.end),
      );
      expect(proposedLogic, true); // 正しく第2週も判定される
    });
  });
}

// 2つの期間が重なるかどうかを判定
bool _periodsOverlap(DateRange range1, DateRange range2) {
  // range1の開始が range2の終了より前 かつ range1の終了が range2の開始より後
  return range1.begin.isBefore(range2.end.add(const Duration(days: 1))) &&
      range1.end.isAfter(range2.begin.subtract(const Duration(days: 1)));
}
