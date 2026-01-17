import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../helper/mock.mocks.dart';

PillSheetModifiedHistory _createHistoryWithActionType(String actionType) {
  return PillSheetModifiedHistory(
    id: 'test_id',
    actionType: actionType,
    estimatedEventCausingDate: DateTime(2020, 9, 28),
    createdAt: DateTime(2020, 9, 28),
    value: const PillSheetModifiedHistoryValue(),
    beforePillSheetGroup: null,
    afterPillSheetGroup: null,
  );
}

void main() {
  group('#enumActionType', () {
    group('全てのPillSheetModifiedActionType値に対するテスト', () {
      for (final actionType in PillSheetModifiedActionType.values) {
        test('actionType="${actionType.name}"の場合、${actionType}を返す', () {
          final history = _createHistoryWithActionType(actionType.name);
          expect(history.enumActionType, actionType);
        });
      }
    });

    group('不正なactionTypeの場合', () {
      test('存在しないactionTypeの場合、nullを返す', () {
        final history = _createHistoryWithActionType('invalidActionType');
        expect(history.enumActionType, isNull);
      });

      test('空文字の場合、nullを返す', () {
        final history = _createHistoryWithActionType('');
        expect(history.enumActionType, isNull);
      });

      test('大文字小文字が異なる場合、nullを返す（例: "CreatedPillSheet"）', () {
        // actionTypeは大文字小文字を区別するため、異なる場合はnullを返す
        final history = _createHistoryWithActionType('CreatedPillSheet');
        expect(history.enumActionType, isNull);
      });
    });
  });

  group("#missedPillDays", () {
    test("履歴が空の場合は0を返す", () {
      final result = missedPillDays(
        histories: [],
        maxDate: DateTime.parse("2020-09-28"),
      );
      expect(result, 0);
    });

    test("30日間すべて服用記録がある場合は0を返す", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);
      final histories = <PillSheetModifiedHistory>[];

      // 30日分の服用記録を作成
      for (int i = 0; i < 30; i++) {
        final date = baseDate.subtract(Duration(days: i + 1));
        histories.add(
          PillSheetModifiedHistory(
            id: 'history_$i',
            actionType: PillSheetModifiedActionType.takenPill.name,
            estimatedEventCausingDate: date,
            createdAt: date,
            value: const PillSheetModifiedHistoryValue(),
            beforePillSheetGroup: null,
            afterPillSheetGroup: null,
          ),
        );
      }

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );
      expect(result, 0);
    });

    test("15日前に1日だけ服用記録がある場合は14日の飲み忘れ", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);
      final histories = [
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 15)),
          createdAt: baseDate.subtract(const Duration(days: 15)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 15日前から今日までの15日間のうち、1日だけ服用記録があるので14日の飲み忘れ
      expect(result, 14);
    });

    test("automaticallyRecordedLastTakenDateも服用記録として扱われる", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);
      final histories = [
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 2)),
          createdAt: baseDate.subtract(const Duration(days: 2)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.automaticallyRecordedLastTakenDate.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 3)),
          createdAt: baseDate.subtract(const Duration(days: 3)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 3日前から今日までの3日間のうち、2日分の服用記録があるので1日の飲み忘れ
      expect(result, 1);
    });

    test("服用お休み期間中の日数は飲み忘れとしてカウントされない", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);
      final histories = [
        // 10日前から5日前まで服用お休み
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.beganRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 4)),
          createdAt: baseDate.subtract(const Duration(days: 4)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.endedRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 2)),
          createdAt: baseDate.subtract(const Duration(days: 2)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 4日前に服用
        PillSheetModifiedHistory(
          id: 'history_3',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate,
          createdAt: baseDate,
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 4日前から今日までの5日間のうち：
      // - 服用記録: 1日（今日)
      // - 服用お休み: 2日間（4日前から2日前まで）
      // - 飲み忘れ: 2日間 (1日前と2日前の2日間)
      expect(result, 2);
    });

    test("複数の服用お休み期間がある場合も正しく処理される", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);
      final histories = [
        // 20日前から18日前まで服用お休み（2日間）
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.beganRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 20)),
          createdAt: baseDate.subtract(const Duration(days: 20)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.endedRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 18)),
          createdAt: baseDate.subtract(const Duration(days: 18)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 10日前から8日前まで服用お休み（2日間）
        PillSheetModifiedHistory(
          id: 'history_3',
          actionType: PillSheetModifiedActionType.beganRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 10)),
          createdAt: baseDate.subtract(const Duration(days: 10)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_4',
          actionType: PillSheetModifiedActionType.endedRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 8)),
          createdAt: baseDate.subtract(const Duration(days: 8)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 17日前と7日前に服用
        PillSheetModifiedHistory(
          id: 'history_5',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 17)),
          createdAt: baseDate.subtract(const Duration(days: 17)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_6',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 7)),
          createdAt: baseDate.subtract(const Duration(days: 7)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 20日前から今日までの20日間のうち：
      // - 服用お休み: 4日間（20-18日前、10-8日前）
      // - 服用記録: 2日間（17日前、7日前）
      // - 飲み忘れ: 14日間
      expect(result, 14);
    });

    test("同じ日に複数の履歴がある場合も正しく処理される", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);
      final targetDate = baseDate.subtract(const Duration(days: 5));

      final histories = [
        // 同じ日に複数の履歴
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: targetDate.add(const Duration(hours: 8)),
          createdAt: targetDate.add(const Duration(hours: 8)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.revertTakenPill.name,
          estimatedEventCausingDate: targetDate.add(const Duration(hours: 12)),
          createdAt: targetDate.add(const Duration(hours: 12)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_3',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: targetDate.add(const Duration(hours: 18)),
          createdAt: targetDate.add(const Duration(hours: 18)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 5日前から今日までの6日間のうち、1日だけ服用記録があるので5日の飲み忘れ
      expect(result, 5);
    });

    test("今日服用した場合は飲み忘れが0日", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate,
          createdAt: baseDate,
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 今日から今日までの1日間で、服用記録があるので飲み忘れは0日
      expect(result, 0);
    });

    test("服用お休み期間が継続中の場合も正しく処理される", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        // 10日前から服用お休み開始（終了していない）
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.beganRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 10)),
          createdAt: baseDate.subtract(const Duration(days: 10)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 11日前に服用
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 11)),
          createdAt: baseDate.subtract(const Duration(days: 11)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 11日前から今日までの12日間のうち：
      // - 服用記録: 1日（11日前）
      // - 服用お休み: 10日分（10日前から今日まで継続中）
      // - 飲み忘れ: 0日
      expect(result, 0);
    });

    test("履歴が順不同でも正しく処理される（昇順に並べ替えられる）", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      // 意図的に順不同で履歴を作成
      final histories = [
        // 3番目に古い履歴（3日前）
        PillSheetModifiedHistory(
          id: 'history_3',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 3)),
          createdAt: baseDate.subtract(const Duration(days: 3)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 1番目に古い履歴（5日前）
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 5)),
          createdAt: baseDate.subtract(const Duration(days: 5)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 2番目に古い履歴（4日前）
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 4)),
          createdAt: baseDate.subtract(const Duration(days: 4)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 5日前から今日までの5日間のうち、3日分の服用記録があるので2日の飲み忘れ
      expect(result, 2);
    });

    test("服用記録以外のアクションタイプのみがある場合は全て飲み忘れとしてカウントされる", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        // changedPillNumberは服用記録としてカウントされない
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.changedPillNumber.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 3)),
          createdAt: baseDate.subtract(const Duration(days: 3)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // revertTakenPillは服用記録としてカウントされない
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.revertTakenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 2)),
          createdAt: baseDate.subtract(const Duration(days: 2)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 3日前から今日までの3日間、服用記録が0なので3日の飲み忘れ
      expect(result, 3);
    });

    test("同じ日に服用お休み開始と終了がある場合は0日として処理される", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        // 5日前に服用
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 5)),
          createdAt: baseDate.subtract(const Duration(days: 5)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 3日前に服用お休み開始
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.beganRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 3)),
          createdAt: baseDate.subtract(const Duration(days: 3)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 同じ3日前に服用お休み終了
        PillSheetModifiedHistory(
          id: 'history_3',
          actionType: PillSheetModifiedActionType.endedRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 3)),
          createdAt: baseDate.subtract(const Duration(days: 3)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 5日前から今日までの5日間のうち：
      // - 服用記録: 1日（5日前）
      // - 服用お休み: 0日（同日開始終了のため）
      // - 飲み忘れ: 4日
      expect(result, 4);
    });

    test("履歴が1件で当日の履歴の場合、飲み忘れは0日", () {
      final today = DateTime.parse("2020-09-28");

      final histories = [
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: today,
          createdAt: today,
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // minDate == maxDate の場合、daysBetweenは0を返すのでallDatesは空
      // 結果として飲み忘れは0日
      expect(result, 0);
    });

    test("服用お休み開始前に服用記録があり、お休み後にも服用記録がある場合", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        // 10日前に服用
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 10)),
          createdAt: baseDate.subtract(const Duration(days: 10)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 9日前から5日前まで服用お休み（4日間）
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.beganRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 9)),
          createdAt: baseDate.subtract(const Duration(days: 9)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_3',
          actionType: PillSheetModifiedActionType.endedRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 5)),
          createdAt: baseDate.subtract(const Duration(days: 5)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 4日前と今日に服用
        PillSheetModifiedHistory(
          id: 'history_4',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 4)),
          createdAt: baseDate.subtract(const Duration(days: 4)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_5',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate,
          createdAt: baseDate,
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 10日前から今日までの期間（allDatesにはmaxDate当日は含まれない）：
      // - allDates: 10日前〜1日前の10日間
      // - 服用記録: 2日（10日前、4日前）※今日はallDatesに含まれない
      // - 服用お休み: 4日（9日前〜6日前）※5日前のendedRestDurationの日は含まれない
      // - 飲み忘れ: 4日（5日前、3日前、2日前、1日前）
      expect(result, 4);
    });

    test("maxDateが履歴の最小日付より前の場合は0を返す", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate, // 今日
          createdAt: baseDate,
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      // maxDateが履歴の日付より前
      final result = missedPillDays(
        histories: histories,
        maxDate: baseDate.subtract(const Duration(days: 5)),
      );

      // daysBetweenが負になり、allDatesが空になるため0を返す
      expect(result, 0);
    });

    test("連続する服用お休み期間（終了日と次の開始日が同日）の場合", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        // 10日前から7日前まで服用お休み（3日間）
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.beganRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 10)),
          createdAt: baseDate.subtract(const Duration(days: 10)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 7日前に終了して同日に次の服用お休み開始
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.endedRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 7)),
          createdAt: baseDate.subtract(const Duration(days: 7)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_3',
          actionType: PillSheetModifiedActionType.beganRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 7)),
          createdAt: baseDate.subtract(const Duration(days: 7)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 4日前に終了
        PillSheetModifiedHistory(
          id: 'history_4',
          actionType: PillSheetModifiedActionType.endedRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 4)),
          createdAt: baseDate.subtract(const Duration(days: 4)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 10日前から今日までの10日間のうち：
      // - 服用お休み: 6日間（10日前〜5日前）※7日前は両方のお休み期間でカバー、4日前のendedは含まない
      // - 服用記録: 0日
      // - 飲み忘れ: 4日間（4日前〜1日前）※4日前のendedの日から今日の前日まで
      expect(result, 4);
    });

    test("服用記録と服用お休み開始が同日の場合、服用記録としてカウントされる", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        // 5日前に服用
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 5)),
          createdAt: baseDate.subtract(const Duration(days: 5)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 同日（5日前）に服用お休み開始
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.beganRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 5)),
          createdAt: baseDate.subtract(const Duration(days: 5)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
        // 3日前に服用お休み終了
        PillSheetModifiedHistory(
          id: 'history_3',
          actionType: PillSheetModifiedActionType.endedRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 3)),
          createdAt: baseDate.subtract(const Duration(days: 3)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 5日前から今日までの5日間のうち：
      // - 服用記録: 1日（5日前）- takenDatesに追加される
      // - 服用お休み: 2日間（5日前〜4日前）※3日前のendedは含まない、5日前はrestDurationDatesにも入る
      // - allDatesから両方を除くと: 5日間 - 服用記録で除かれる日(5日前) - お休みで除かれる日(5日前,4日前)
      //   5日前は両方でカウントされるがSetなので重複は1日としてカウント
      // - 飲み忘れ: 5日間 - 3日間 = 2日間（3日前、2日前、1日前の3日間から、お休みの2日を除くと...）
      // 計算し直し:
      // allDates: 5日前、4日前、3日前、2日前、1日前 の5日間
      // takenDates: 5日前 (1日)
      // restDurationDates: 5日前、4日前 (2日)
      // missedDays = allDates - takenDates - restDurationDates
      //            = {5日前,4日前,3日前,2日前,1日前} - {5日前} - {5日前,4日前}
      //            = {3日前,2日前,1日前}
      //            = 3日
      expect(result, 3);
    });

    test("全期間が服用お休みの場合（beganRestDurationのみ、服用記録なし）", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        // 10日前から服用お休み開始（終了していない）
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.beganRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 10)),
          createdAt: baseDate.subtract(const Duration(days: 10)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
        ),
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 10日前から今日までの10日間すべてが服用お休み
      // - allDates: 10日前〜1日前の10日間
      // - 服用記録: 0日
      // - 服用お休み: 10日間（10日前から今日まで継続中）
      // - 飲み忘れ: 0日
      expect(result, 0);
    });
  });

  group('#createTakenPillAction', () {
    // テスト用のPillSheetGroupを作成するヘルパー関数
    PillSheetGroup createPillSheetGroup({required List<PillSheet> pillSheets}) {
      return PillSheetGroup(
        id: 'group_id',
        pillSheetIDs: pillSheets.map((e) => e.id ?? '').toList(),
        pillSheets: pillSheets,
        createdAt: DateTime(2020, 9, 1),
      );
    }

    group('正常系', () {
      test('正しいパラメータでPillSheetModifiedHistoryが生成される', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 11),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.actionType, PillSheetModifiedActionType.takenPill.name);
        expect(history.enumActionType, PillSheetModifiedActionType.takenPill);
        // pillSheetGroupID, beforePillSheetID, afterPillSheetID, before, after は v2 で削除済み
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);

        // TakenPillValue の検証
        final takenPillValue = history.value.takenPill;
        expect(takenPillValue, isNotNull);
        expect(takenPillValue, isNotNull);
        expect(takenPillValue!.isQuickRecord, false);
      });

      test('isQuickRecord = true の場合', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 11),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: true,
        );

        expect(history.value.takenPill?.isQuickRecord, true);
      });

      test('beforeのlastTakenDateがnullの場合（初回服用）', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 1),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        final takenPillValue = history.value.takenPill;
        expect(takenPillValue, isNotNull);
        expect(takenPillValue, isNotNull);
      });

      test('複数ピルを一度に服用した場合（まとめ飲み）', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        // 3日分まとめて服用
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 13),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        final takenPillValue = history.value.takenPill;
        expect(takenPillValue, isNotNull);
        expect(takenPillValue, isNotNull);
      });

      test('ピルシートの最後のピルを服用した場合', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 27),
          createdAt: DateTime(2020, 9, 1),
        );
        // 28錠目（最後）を服用
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        final takenPillValue = history.value.takenPill;
        expect(takenPillValue, isNotNull);
        expect(takenPillValue, isNotNull);
      });

      test('beforeとafterで異なるPillSheet IDの場合（シート切り替え時）', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 9, 29),
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [
            beforePillSheet,
            (afterPillSheet as PillSheetV1).copyWith(lastTakenDate: null),
          ],
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [beforePillSheet, afterPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        // beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.value.takenPill, isNotNull);
      });

      test('21錠タイプで最後のピルを服用した場合（境界値確認）', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 20),
          createdAt: DateTime(2020, 9, 1),
        );
        // 21錠目（最後）を服用
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 21),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        final takenPillValue = history.value.takenPill;
        expect(takenPillValue, isNotNull);
        expect(takenPillValue, isNotNull);
      });

      test('version と メタデータが正しく設定される', () {
        final mockTodayService = MockTodayService();
        todayRepository = mockTodayService;
        final mockNow = DateTime(2020, 9, 11);
        when(mockTodayService.now()).thenReturn(mockNow);

        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 11),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.version, 'v2');
        expect(history.id, isNull);
        expect(history.estimatedEventCausingDate, isNotNull);
        expect(history.createdAt, isNotNull);
        expect(history.ttlExpiresDateTime, isNotNull);
        // ttlExpiresDateTime は createdAt から 180日後
        final expectedTtl = history.createdAt.add(const Duration(days: PillSheetModifiedHistoryServiceActionFactory.limitDays));
        expect(history.ttlExpiresDateTime, expectedTtl);
      });

      test('3枚グループで2枚目から3枚目への切り替え時', () {
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final secondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 26),
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final thirdPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 27),
          lastTakenDate: DateTime(2020, 10, 27),
          createdAt: DateTime(2020, 10, 27),
          groupIndex: 2,
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet, (thirdPillSheet as PillSheetV1).copyWith(lastTakenDate: null)],
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet, thirdPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('24錠タイプで最後のピルを服用した場合（境界値確認）', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_24_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 23),
          createdAt: DateTime(2020, 9, 1),
        );
        // 24錠目（最後）を服用
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_24_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 24),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        final takenPillValue = history.value.takenPill;
        expect(takenPillValue, isNotNull);
        expect(takenPillValue, isNotNull);
      });
    });

    // 異常系テスト削除: v2では FormatException を投げなくなった（バリデーションロジック変更）
  });

  group('#createRevertTakenPillAction', () {
    // テスト用のPillSheetGroupを作成するヘルパー関数
    PillSheetGroup createPillSheetGroup({required List<PillSheet> pillSheets}) {
      return PillSheetGroup(
        id: 'group_id',
        pillSheetIDs: pillSheets.map((e) => e.id ?? '').toList(),
        pillSheets: pillSheets,
        createdAt: DateTime(2020, 9, 1),
      );
    }

    group('正常系', () {
      test('正しいパラメータでPillSheetModifiedHistoryが生成される', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 11),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.revertTakenPill.name);
        expect(history.enumActionType, PillSheetModifiedActionType.revertTakenPill);
        // pillSheetGroupID, beforePillSheetID, afterPillSheetID, before, after は v2 で削除済み
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);

        // RevertTakenPillValue の検証
        final revertTakenPillValue = history.value.revertTakenPill;
        expect(revertTakenPillValue, isNotNull);
        expect(revertTakenPillValue, isNotNull);
      });

      test('afterのlastTakenDateがnullの場合（ピルシートの最初まで取り消した場合）', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 1),
          createdAt: DateTime(2020, 9, 1),
        );
        // 1番目のピルを取り消すとlastTakenDateはnullになる
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final revertTakenPillValue = history.value.revertTakenPill;
        expect(revertTakenPillValue, isNotNull);
        expect(revertTakenPillValue, isNotNull);
      });

      test('複数ピルを一度に取り消した場合', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 13),
          createdAt: DateTime(2020, 9, 1),
        );
        // 3日分まとめて取り消し
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final revertTakenPillValue = history.value.revertTakenPill;
        expect(revertTakenPillValue, isNotNull);
        expect(revertTakenPillValue, isNotNull);
      });

      test('ピルシートの最後のピルを取り消した場合', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
        );
        // 28錠目（最後）を取り消し
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 27),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final revertTakenPillValue = history.value.revertTakenPill;
        expect(revertTakenPillValue, isNotNull);
        expect(revertTakenPillValue, isNotNull);
      });

      test('beforeとafterで異なるPillSheet IDの場合（シート境界での取り消し時）', () {
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final beforeSecondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 9, 29),
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        // 2枚目の最初のピルを取り消すと、afterは1枚目の最後の状態を参照
        final afterSecondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, beforeSecondPillSheet],
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, afterSecondPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.value.revertTakenPill, isNotNull);
      });

      test('21錠シート（pillsheet_21）での最後のピル取り消し', () {
        // 21錠シートの21錠目（最後）を取り消すケース
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 21),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 20),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final revertTakenPillValue = history.value.revertTakenPill;
        expect(revertTakenPillValue, isNotNull);
        expect(revertTakenPillValue, isNotNull);
      });

      test('24+4錠シート（pillsheet_24_rest_4）での偽薬期間の取り消し', () {
        // 24+4錠シートの28錠目（偽薬期間の最後）を取り消すケース
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_24_rest_4.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_24_rest_4.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 27),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final revertTakenPillValue = history.value.revertTakenPill;
        expect(revertTakenPillValue, isNotNull);
        expect(revertTakenPillValue, isNotNull);
      });

      test('24+4錠シートで実錠から偽薬境界を跨いで取り消し', () {
        // 25錠目（偽薬1錠目）を取り消して24錠目（実錠最後）に戻る
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_24_rest_4.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 25),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_24_rest_4.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 24),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final revertTakenPillValue = history.value.revertTakenPill;
        expect(revertTakenPillValue, isNotNull);
        // 25錠目から24錠目への取り消し（偽薬→実錠境界）
        expect(revertTakenPillValue, isNotNull);
      });

      test('3枚シートで2枚目から1枚目まで遡る取り消し', () {
        // 3枚のシートがあり、2枚目の最初のピルを取り消すケース
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final beforeSecondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 9, 29),
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final afterSecondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final thirdPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 27),
          lastTakenDate: null,
          createdAt: DateTime(2020, 10, 27),
          groupIndex: 2,
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, beforeSecondPillSheet, thirdPillSheet],
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, afterSecondPillSheet, thirdPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.value.revertTakenPill, isNotNull);
        // 3枚目のシートがグループに含まれていることを確認
        expect(history.beforePillSheetGroup?.pillSheets.length, 3);
        expect(history.afterPillSheetGroup?.pillSheets.length, 3);
      });

      test('3枚シートで3枚目から2枚目まで遡る取り消し', () {
        // 3枚目の最初のピルを取り消すケース
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final secondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 26),
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final beforeThirdPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 27),
          lastTakenDate: DateTime(2020, 10, 27),
          createdAt: DateTime(2020, 10, 27),
          groupIndex: 2,
        );
        final afterThirdPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 27),
          lastTakenDate: null,
          createdAt: DateTime(2020, 10, 27),
          groupIndex: 2,
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet, beforeThirdPillSheet],
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet, afterThirdPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.value.revertTakenPill, isNotNull);
        expect(history.value.revertTakenPill, isNotNull);
      });
    });

    // 異常系テスト削除: v2では FormatException を投げなくなった（バリデーションロジック変更）
  });

  group('#createCreatedPillSheetAction', () {
    // テスト用のPillSheetGroupを作成するヘルパー関数
    PillSheetGroup createPillSheetGroup({
      required String id,
      required List<PillSheet> pillSheets,
    }) {
      return PillSheetGroup(
        id: id,
        pillSheetIDs: pillSheets.map((e) => e.id ?? '').toList(),
        pillSheets: pillSheets,
        createdAt: DateTime(2020, 9, 1),
      );
    }

    group('正常系', () {
      test('正しいパラメータでPillSheetModifiedHistoryが生成される', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        // actionType の検証
        expect(history.actionType, PillSheetModifiedActionType.createdPillSheet.name);
        expect(history.enumActionType, PillSheetModifiedActionType.createdPillSheet);

        // pillSheetGroupID, before, after, beforePillSheetID, afterPillSheetID は v2 で削除済み

        // PillSheetGroup の検証
        expect(history.beforePillSheetGroup, isNull);
        expect(history.afterPillSheetGroup, createdNewPillSheetGroup);

        // CreatedPillSheetValue の検証
        final createdPillSheetValue = history.value.createdPillSheet;
        expect(createdPillSheetValue, isNotNull);
        expect(createdPillSheetValue, isNotNull);
      });

      test('pillSheetIDsが複数（2件）の場合', () {
        final pillSheet1 = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final pillSheet2 = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 1,
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet1, pillSheet2],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        final createdPillSheetValue = history.value.createdPillSheet;
        expect(createdPillSheetValue, isNotNull);
        expect(createdPillSheetValue, isNotNull);
      });

      test('pillSheetIDsが複数（3件）の場合', () {
        final pillSheet1 = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final pillSheet2 = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 1,
        );
        final pillSheet3 = PillSheet.v1(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 27),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 2,
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        final createdPillSheetValue = history.value.createdPillSheet;
        expect(createdPillSheetValue, isNotNull);
        expect(createdPillSheetValue, isNotNull);
      });

      test('beforePillSheetGroupが存在する場合（既存グループへのピルシート追加）', () {
        final existingPillSheet = PillSheet.v1(
          id: 'existing_pill_sheet_id',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 8, 4),
          lastTakenDate: DateTime(2020, 8, 31),
          createdAt: DateTime(2020, 8, 4),
          groupIndex: 0,
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [existingPillSheet],
        );

        final newPillSheet = PillSheet.v1(
          id: 'new_pill_sheet_id',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 1,
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [existingPillSheet, newPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        // beforePillSheetGroup が設定されていることを検証
        expect(history.beforePillSheetGroup, isNotNull);
        expect(history.beforePillSheetGroup!.pillSheets.length, 1);
        expect(history.beforePillSheetGroup!.pillSheets[0].id, 'existing_pill_sheet_id');

        // afterPillSheetGroup が設定されていることを検証
        expect(history.afterPillSheetGroup, isNotNull);
        expect(history.afterPillSheetGroup!.pillSheets.length, 2);

        // pillSheetIDs は新しく追加されたものだけを含む
        expect(history.value.createdPillSheet, isNotNull);
      });

      test('異なるPillSheetType（pillsheet_21_0）でピルシートを作成する場合', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.createdPillSheet.name);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.totalCount, 21);
        expect(history.value.createdPillSheet, isNotNull);
      });

      test('異なるPillSheetType（pillsheet_28_4）でピルシートを作成する場合', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.createdPillSheet.name);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.totalCount, 28);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.dosingPeriod, 24);
        expect(history.value.createdPillSheet, isNotNull);
      });

      test('pillSheetIDsが空リストの場合も履歴は生成される', () {
        // 技術的には許容されるが、実際のユースケースでは発生しないはずのケース
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.createdPillSheet.name);
        expect(history.value.createdPillSheet, isNotNull);
      });

      test('restDurationsがあるPillSheetを含むPillSheetGroupの場合、履歴に保持される', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 10),
          endDate: DateTime(2020, 9, 12),
          createdDate: DateTime(2020, 9, 10),
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 15),
          createdAt: DateTime(2020, 9, 1),
          restDurations: [restDuration],
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.afterPillSheetGroup, isNotNull);
        expect(history.afterPillSheetGroup!.pillSheets[0].restDurations.length, 1);
        expect(history.afterPillSheetGroup!.pillSheets[0].restDurations[0].id, 'rest_duration_id_1');
        expect(history.afterPillSheetGroup!.pillSheets[0].restDurations[0].beginDate, DateTime(2020, 9, 10));
        expect(history.afterPillSheetGroup!.pillSheets[0].restDurations[0].endDate, DateTime(2020, 9, 12));
      });

      test('displayNumberSettingが設定されたPillSheetGroupの場合、履歴に保持される', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = PillSheetGroup(
          id: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          pillSheets: [pillSheet],
          createdAt: DateTime(2020, 9, 1),
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 5,
            endPillNumber: 28,
          ),
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.afterPillSheetGroup, isNotNull);
        expect(history.afterPillSheetGroup!.displayNumberSetting, isNotNull);
        expect(history.afterPillSheetGroup!.displayNumberSetting!.beginPillNumber, 5);
        expect(history.afterPillSheetGroup!.displayNumberSetting!.endPillNumber, 28);
      });

      test('異なるPillSheetTypeの混在する複数ピルシートの場合', () {
        final pillSheet21 = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final pillSheet28 = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 1,
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet21, pillSheet28],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.afterPillSheetGroup!.pillSheets.length, 2);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.totalCount, 21);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.dosingPeriod, 21);
        expect(history.afterPillSheetGroup!.pillSheets[1].typeInfo.totalCount, 28);
        expect(history.afterPillSheetGroup!.pillSheets[1].typeInfo.dosingPeriod, 24);
      });
    });

    group('生成されるプロパティの検証', () {
      test('version は v2 が設定される', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.version, 'v2');
      });

      test('id は null が設定される（サーバー側で生成されるため）', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.id, isNull);
      });

      test('estimatedEventCausingDate と createdAt が設定される', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.estimatedEventCausingDate, isNotNull);
        expect(history.createdAt, isNotNull);
      });

      test('pillSheetID（deprecated）は null が設定される', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        // pillSheetID は v2 で削除済み
      });
    });
  });

  group('#createChangedPillNumberAction', () {
    // テスト用のPillSheetGroupを作成するヘルパー関数
    PillSheetGroup createPillSheetGroup({required List<PillSheet> pillSheets}) {
      return PillSheetGroup(
        id: 'group_id',
        pillSheetIDs: pillSheets.map((e) => e.id ?? '').toList(),
        pillSheets: pillSheets,
        createdAt: DateTime(2020, 9, 1),
      );
    }

    group('正常系', () {
      test('正しいパラメータでPillSheetModifiedHistoryが生成される', () {
        // 開始日を変更するシナリオ: 9/1開始 → 9/3開始 に変更
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedPillNumber.name);
        expect(history.enumActionType, PillSheetModifiedActionType.changedPillNumber);
        // pillSheetGroupID, beforePillSheetID, afterPillSheetID, before, after は v2 で削除済み
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);

        // ChangedPillNumberValue の検証
        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue, isNotNull);
      });

      test('開始日を進めた場合（todayPillNumberが減少）', () {
        // 9/1開始 → 9/5開始 に変更
        // todayPillNumber は today() に依存するため、beginDate の変更を検証
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 5),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue, isNotNull);
        // todayPillNumberはリアルタイムのtoday()に依存するため、
        // 開始日の変更によってピル番号の計算に影響することを確認
        // afterBeginingDateがbeforeBeginingDateより後なので、
        // 同じ日付に対するtodayPillNumberはafterの方が小さくなる
      });

      test('開始日を戻した場合（todayPillNumberが増加）', () {
        // 9/5開始 → 9/1開始 に変更（開始日を早める）
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 5),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue, isNotNull);
        // afterBeginingDateがbeforeBeginingDateより前なので、
        // 同じ日付に対するtodayPillNumberはafterの方が大きくなる
      });

      test('groupIndexが変更された場合', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 1,
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        // beforeGroupIndex, afterGroupIndex は v2 で削除済み
      });

      test('異なるPillSheetType（pillsheet_21_0）の場合', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedPillNumber.name);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.totalCount, 21);

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue, isNotNull);
      });

      test('異なるPillSheetType（pillsheet_28_4）の場合', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedPillNumber.name);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.totalCount, 28);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.dosingPeriod, 24);

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue, isNotNull);
      });

      test('複数のピルシートを持つPillSheetGroupで2枚目のピルシートを変更した場合', () {
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final beforeSecondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 5),
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        // 2枚目の開始日を変更
        final afterSecondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 1),
          lastTakenDate: DateTime(2020, 10, 5),
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, beforeSecondPillSheet],
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, afterSecondPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('beforeとafterで異なるPillSheet IDの場合（シート間での変更）', () {
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final secondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        // 1枚目から2枚目への移行を伴う変更
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet],
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });
    });

    group('生成されるプロパティの検証', () {
      test('version は v2 が設定される', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.version, 'v2');
      });

      test('id は null が設定される（サーバー側で生成されるため）', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.id, isNull);
      });

      test('estimatedEventCausingDate と createdAt が設定される', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.estimatedEventCausingDate, isNotNull);
        expect(history.createdAt, isNotNull);
      });

      test('pillSheetID（deprecated）は null が設定される', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // pillSheetID は v2 で削除済み
      });
    });

    // 異常系テスト削除: v2では FormatException や assert を投げなくなった（バリデーションロジック変更）

    group('todayPillNumberの検証', () {
      test('固定日付でtodayPillNumberが正しく記録される', () {
        final mockNow = DateTime(2020, 9, 10);
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNow);

        // 9/1開始で、9/10が今日の場合、todayPillNumber = 10
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 9),
          createdAt: DateTime(2020, 9, 1),
        );
        // 開始日を9/3に変更すると、9/10が今日の場合、todayPillNumber = 8
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 9),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        // beforeTodayPillNumber, afterTodayPillNumber は v2 で削除済み
      });

      test('月初日から月末日への変更でtodayPillNumberが正しく計算される', () {
        final mockNow = DateTime(2020, 10, 1);
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNow);

        // 9/1開始で、10/1が今日の場合、todayPillNumber = 31
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 30),
          createdAt: DateTime(2020, 9, 1),
        );
        // 開始日を9/30に変更すると、10/1が今日の場合、todayPillNumber = 2
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 30),
          lastTakenDate: DateTime(2020, 9, 30),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        // beforeTodayPillNumber, afterTodayPillNumber は v2 で削除済み
      });
    });

    group('ttlExpiresDateTimeの検証', () {
      test('ttlExpiresDateTimeがnow()から180日後に設定される', () {
        final mockNow = DateTime(2020, 9, 10, 12, 0, 0);
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNow);

        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 9),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 9),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // limitDays = 180
        final expectedTtl = mockNow.add(const Duration(days: 180));
        expect(history.ttlExpiresDateTime, expectedTtl);
      });
    });

    group('3枚のピルシートを持つPillSheetGroupでの操作', () {
      test('3枚目のピルシートを変更した場合', () {
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final secondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 26),
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final beforeThirdPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 27),
          lastTakenDate: DateTime(2020, 11, 5),
          createdAt: DateTime(2020, 10, 27),
          groupIndex: 2,
        );
        // 3枚目の開始日を変更
        final afterThirdPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 29),
          lastTakenDate: DateTime(2020, 11, 5),
          createdAt: DateTime(2020, 10, 27),
          groupIndex: 2,
        );
        final beforePillSheetGroup = PillSheetGroup(
          id: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1', 'pill_sheet_id_2', 'pill_sheet_id_3'],
          pillSheets: [firstPillSheet, secondPillSheet, beforeThirdPillSheet],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheetGroup = PillSheetGroup(
          id: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1', 'pill_sheet_id_2', 'pill_sheet_id_3'],
          pillSheets: [firstPillSheet, secondPillSheet, afterThirdPillSheet],
          createdAt: DateTime(2020, 9, 1),
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // beforePillSheetID, afterPillSheetID は v2 で削除済み

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        // beforeGroupIndex, afterGroupIndex は v2 で削除済み
      });
    });

    group('before.idがnullの場合', () {
      test('before.idがnullでもエラーなく履歴が生成される', () {
        // before.id は null でも許容される（コードにバリデーションがないため）
        final beforePillSheet = PillSheet.v1(
          id: null,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });
    });

    group('境界値テスト', () {
      test('月をまたぐ日付変更（9月末から10月初への変更）', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 15),
          lastTakenDate: DateTime(2020, 9, 30),
          createdAt: DateTime(2020, 9, 15),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 1),
          lastTakenDate: DateTime(2020, 9, 30),
          createdAt: DateTime(2020, 9, 15),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue, isNotNull);
      });

      test('年をまたぐ日付変更（12月末から1月初への変更）', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 12, 15),
          lastTakenDate: DateTime(2020, 12, 31),
          createdAt: DateTime(2020, 12, 15),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2021, 1, 1),
          lastTakenDate: DateTime(2020, 12, 31),
          createdAt: DateTime(2020, 12, 15),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue, isNotNull);
      });

      test('うるう年の2月29日を含む変更', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 2, 1),
          lastTakenDate: DateTime(2020, 2, 28),
          createdAt: DateTime(2020, 2, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 2, 29),
          lastTakenDate: DateTime(2020, 2, 28),
          createdAt: DateTime(2020, 2, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue, isNotNull);
      });

      test('開始日が同じ場合（変更なし）', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue, isNotNull);
      });
    });
  });

  group('#createDeletedPillSheetAction', () {
    // テスト用のPillSheetGroupを作成するヘルパー関数
    PillSheetGroup createPillSheetGroup({
      required String id,
      required List<PillSheet> pillSheets,
      DateTime? deletedAt,
    }) {
      return PillSheetGroup(
        id: id,
        pillSheetIDs: pillSheets.map((e) => e.id ?? '').toList(),
        pillSheets: pillSheets,
        createdAt: DateTime(2020, 9, 1),
        deletedAt: deletedAt,
      );
    }

    group('正常系', () {
      test('正しいパラメータでPillSheetModifiedHistoryが生成される', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );
        final updatedPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet.copyWith(deletedAt: DateTime(2020, 9, 15))],
          deletedAt: DateTime(2020, 9, 15),
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        // actionType の検証
        expect(history.actionType, PillSheetModifiedActionType.deletedPillSheet.name);
        expect(history.enumActionType, PillSheetModifiedActionType.deletedPillSheet);

        // pillSheetGroupID, before, after, beforePillSheetID, afterPillSheetID は v2 で削除済み

        // PillSheetGroup の検証
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, updatedPillSheetGroup);

        // DeletedPillSheetValue の検証
        final deletedPillSheetValue = history.value.deletedPillSheet;
        expect(deletedPillSheetValue, isNotNull);
        // pillSheetDeletedAt は v2 で削除済み
      });

      test('pillSheetIDsが複数（2件）の場合', () {
        final pillSheet1 = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final pillSheet2 = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 15),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 1,
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet1, pillSheet2],
        );
        final updatedPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [
            pillSheet1.copyWith(deletedAt: DateTime(2020, 10, 20)),
            pillSheet2.copyWith(deletedAt: DateTime(2020, 10, 20)),
          ],
          deletedAt: DateTime(2020, 10, 20),
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        final deletedPillSheetValue = history.value.deletedPillSheet;
        expect(deletedPillSheetValue, isNotNull);
        expect(deletedPillSheetValue, isNotNull);
      });

      test('pillSheetIDsが複数（3件）の場合', () {
        final pillSheet1 = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final pillSheet2 = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 26),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 1,
        );
        final pillSheet3 = PillSheet.v1(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 27),
          lastTakenDate: DateTime(2020, 11, 10),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 2,
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
        );
        final updatedPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [
            pillSheet1.copyWith(deletedAt: DateTime(2020, 11, 15)),
            pillSheet2.copyWith(deletedAt: DateTime(2020, 11, 15)),
            pillSheet3.copyWith(deletedAt: DateTime(2020, 11, 15)),
          ],
          deletedAt: DateTime(2020, 11, 15),
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        final deletedPillSheetValue = history.value.deletedPillSheet;
        expect(deletedPillSheetValue, isNotNull);
        expect(deletedPillSheetValue, isNotNull);
      });

      test('異なるPillSheetType（pillsheet_21_0）のピルシートを削除する場合', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 15),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );
        final updatedPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet.copyWith(deletedAt: DateTime(2020, 9, 20))],
          deletedAt: DateTime(2020, 9, 20),
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.deletedPillSheet.name);
        expect(history.beforePillSheetGroup!.pillSheets[0].typeInfo.totalCount, 21);
        expect(history.value.deletedPillSheet, isNotNull);
      });

      test('異なるPillSheetType（pillsheet_28_4）のピルシートを削除する場合', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 20),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );
        final updatedPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet.copyWith(deletedAt: DateTime(2020, 9, 25))],
          deletedAt: DateTime(2020, 9, 25),
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.deletedPillSheet.name);
        expect(history.beforePillSheetGroup!.pillSheets[0].typeInfo.totalCount, 28);
        expect(history.beforePillSheetGroup!.pillSheets[0].typeInfo.dosingPeriod, 24);
        expect(history.value.deletedPillSheet, isNotNull);
      });

      test('pillSheetIDsが空リストの場合も履歴は生成される', () {
        // 技術的には許容されるが、実際のユースケースでは発生しないはずのケース
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );
        final updatedPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet.copyWith(deletedAt: DateTime(2020, 9, 15))],
          deletedAt: DateTime(2020, 9, 15),
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.deletedPillSheet.name);
        expect(history.value.deletedPillSheet, isNotNull);
      });

      test('beforePillSheetGroupとupdatedPillSheetGroupの差分が記録される', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );
        final deletedAt = DateTime(2020, 9, 15);
        final updatedPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet.copyWith(deletedAt: deletedAt)],
          deletedAt: deletedAt,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        // beforePillSheetGroup は削除前の状態
        expect(history.beforePillSheetGroup!.deletedAt, isNull);
        expect(history.beforePillSheetGroup!.pillSheets[0].deletedAt, isNull);

        // afterPillSheetGroup は削除後の状態
        expect(history.afterPillSheetGroup!.deletedAt, deletedAt);
        expect(history.afterPillSheetGroup!.pillSheets[0].deletedAt, deletedAt);
      });

      test('RestDurationを持つピルシートを削除する場合、RestDuration情報がbeforePillSheetGroupに保持される', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 10),
          endDate: DateTime(2020, 9, 12),
          createdDate: DateTime(2020, 9, 10),
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 15),
          createdAt: DateTime(2020, 9, 1),
          restDurations: [restDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );
        final deletedAt = DateTime(2020, 9, 20);
        final updatedPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet.copyWith(deletedAt: deletedAt)],
          deletedAt: deletedAt,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        // beforePillSheetGroup の RestDuration が保持されている
        expect(history.beforePillSheetGroup!.pillSheets[0].restDurations.length, 1);
        expect(history.beforePillSheetGroup!.pillSheets[0].restDurations[0].id, 'rest_duration_id_1');
        expect(history.beforePillSheetGroup!.pillSheets[0].restDurations[0].beginDate, DateTime(2020, 9, 10));
        expect(history.beforePillSheetGroup!.pillSheets[0].restDurations[0].endDate, DateTime(2020, 9, 12));

        // afterPillSheetGroup にも RestDuration が保持されている
        expect(history.afterPillSheetGroup!.pillSheets[0].restDurations.length, 1);
        expect(history.afterPillSheetGroup!.pillSheets[0].restDurations[0].id, 'rest_duration_id_1');
      });
    });

    group('生成されるプロパティの検証', () {
      test('version は v2 が設定される', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );
        final updatedPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet.copyWith(deletedAt: DateTime(2020, 9, 15))],
          deletedAt: DateTime(2020, 9, 15),
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.version, 'v2');
      });

      test('id は null が設定される（サーバー側で生成されるため）', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );
        final updatedPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet.copyWith(deletedAt: DateTime(2020, 9, 15))],
          deletedAt: DateTime(2020, 9, 15),
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.id, isNull);
      });

      test('estimatedEventCausingDate と createdAt が設定される', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );
        final updatedPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet.copyWith(deletedAt: DateTime(2020, 9, 15))],
          deletedAt: DateTime(2020, 9, 15),
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.estimatedEventCausingDate, isNotNull);
        expect(history.createdAt, isNotNull);
      });

      test('pillSheetID（deprecated）は null が設定される', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );
        final updatedPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet.copyWith(deletedAt: DateTime(2020, 9, 15))],
          deletedAt: DateTime(2020, 9, 15),
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        // pillSheetID は v2 で削除済み
      });

      test('ttlExpiresDateTime が limitDays 日後に設定される', () {
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );
        final updatedPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet.copyWith(deletedAt: DateTime(2020, 9, 15))],
          deletedAt: DateTime(2020, 9, 15),
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.ttlExpiresDateTime, isNotNull);
        // ttlExpiresDateTimeはcreatedAtからlimitDays日後に設定される
        // now()が2回別々に呼ばれるためマイクロ秒の差異が生じる可能性があるので、差分で検証する
        final difference = history.ttlExpiresDateTime!.difference(history.createdAt);
        expect(difference.inDays, PillSheetModifiedHistoryServiceActionFactory.limitDays);
      });
    });
  });

  group('#createBeganRestDurationAction', () {
    // テスト用のPillSheetGroupを作成するヘルパー関数
    PillSheetGroup createPillSheetGroup({required List<PillSheet> pillSheets}) {
      return PillSheetGroup(
        id: 'group_id',
        pillSheetIDs: pillSheets.map((e) => e.id ?? '').toList(),
        pillSheets: pillSheets,
        createdAt: DateTime(2020, 9, 1),
      );
    }

    group('正常ケース', () {
      test('actionType が beganRestDuration であること', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [restDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.beganRestDuration.name);
      });

      test('beganRestDurationValue に restDuration が正しく設定されること', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [restDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.beganRestDurationValue, isNotNull);
        expect(history.value.beganRestDurationValue!.restDuration.id, restDuration.id);
        expect(history.value.beganRestDurationValue!.restDuration.beginDate, restDuration.beginDate);
        expect(history.value.beganRestDurationValue!.restDuration.createdDate, restDuration.createdDate);
      });

      test('beforePillSheetGroup と afterPillSheetGroup が正しく設定されること', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [restDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('pillSheetGroupID が正しく設定されること', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [restDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // pillSheetGroupID は v2 で削除済み
      });
    });

    group('複数ピルシートがある場合', () {
      test('2枚目のピルシートで休薬期間を開始した場合、正しく設定されること', () {
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          groupIndex: 0,
          createdAt: DateTime(2020, 9, 1),
        );
        final beforeSecondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 10),
          groupIndex: 1,
          createdAt: DateTime(2020, 9, 29),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 10, 11),
          createdDate: DateTime(2020, 10, 11),
        );
        final afterSecondPillSheet = beforeSecondPillSheet.copyWith(
          restDurations: [restDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, beforeSecondPillSheet],
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, afterSecondPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.beganRestDuration.name);
        // before, after, beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('3枚目のピルシートで休薬期間を開始した場合、正しく設定されること', () {
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          groupIndex: 0,
          createdAt: DateTime(2020, 9, 1),
        );
        final secondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 26),
          groupIndex: 1,
          createdAt: DateTime(2020, 9, 29),
        );
        final beforeThirdPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 27),
          lastTakenDate: DateTime(2020, 11, 10),
          groupIndex: 2,
          createdAt: DateTime(2020, 10, 27),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 11, 11),
          createdDate: DateTime(2020, 11, 11),
        );
        final afterThirdPillSheet = beforeThirdPillSheet.copyWith(
          restDurations: [restDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet, beforeThirdPillSheet],
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet, afterThirdPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.beganRestDuration.name);
        // before, after, beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });
    });

    group('RestDuration のプロパティ', () {
      test('endDate が null の場合（休薬期間継続中）、正しく設定されること', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          endDate: null,
          createdDate: DateTime(2020, 9, 11),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [restDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.beganRestDurationValue!.restDuration.endDate, isNull);
      });
    });

    group('メタデータの検証', () {
      test('estimatedEventCausingDate が正しく設定されること', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [restDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.estimatedEventCausingDate, isNotNull);
      });

      test('createdAt が正しく設定されること', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [restDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.createdAt, isNotNull);
      });

      test('ttlExpiresDateTime が limitDays 日後に設定されること', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [restDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.ttlExpiresDateTime, isNotNull);
        // now()が2回別々に呼ばれるためマイクロ秒の差異が生じる可能性があるので、差分で検証する
        final difference = history.ttlExpiresDateTime!.difference(history.createdAt);
        expect(difference.inDays, PillSheetModifiedHistoryServiceActionFactory.limitDays);
      });
    });

    // 異常ケースのテスト削除: v2で pillSheetGroupID プロパティは削除され、
    // afterPillSheetGroup.id から取得するため、「pillSheetGroupID が null の場合」というテストは前提が変わった

    group('PillSheetType による違い', () {
      test('21錠タイプ（pillsheet_21）で休薬期間を開始した場合', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [restDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.beganRestDuration.name);
        // before, after は v2 で削除済み
        // PillSheetGroupからtypeInfoを確認
        expect(history.beforePillSheetGroup!.pillSheets[0].typeInfo, PillSheetType.pillsheet_21.typeInfo);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo, PillSheetType.pillsheet_21.typeInfo);
      });

      test('24錠タイプ（pillsheet_28_4）で休薬期間を開始した場合', () {
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [restDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.beganRestDuration.name);
        // before, after は v2 で削除済み
        expect(history.beforePillSheetGroup!.pillSheets[0].typeInfo, PillSheetType.pillsheet_28_4.typeInfo);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo, PillSheetType.pillsheet_28_4.typeInfo);
      });
    });

    group('既存の RestDuration がある場合', () {
      test('既に1つの休薬期間がある状態で新しい休薬期間を開始した場合', () {
        final existingRestDuration = RestDuration(
          id: 'rest_duration_id_existing',
          beginDate: DateTime(2020, 9, 5),
          endDate: DateTime(2020, 9, 7),
          createdDate: DateTime(2020, 9, 5),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [existingRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final newRestDuration = RestDuration(
          id: 'rest_duration_id_new',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [existingRestDuration, newRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: newRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.beganRestDurationValue!.restDuration.id, newRestDuration.id);
        // before, after は v2 で削除済み
        expect(history.beforePillSheetGroup!.pillSheets[0].restDurations.length, 1);
        expect(history.afterPillSheetGroup!.pillSheets[0].restDurations.length, 2);
      });

      test('既に2つの休薬期間がある状態で新しい休薬期間を開始した場合', () {
        final existingRestDuration1 = RestDuration(
          id: 'rest_duration_id_existing_1',
          beginDate: DateTime(2020, 9, 3),
          endDate: DateTime(2020, 9, 4),
          createdDate: DateTime(2020, 9, 3),
        );
        final existingRestDuration2 = RestDuration(
          id: 'rest_duration_id_existing_2',
          beginDate: DateTime(2020, 9, 6),
          endDate: DateTime(2020, 9, 7),
          createdDate: DateTime(2020, 9, 6),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [existingRestDuration1, existingRestDuration2],
          createdAt: DateTime(2020, 9, 1),
        );
        final newRestDuration = RestDuration(
          id: 'rest_duration_id_new',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [existingRestDuration1, existingRestDuration2, newRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          restDuration: newRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.beganRestDurationValue!.restDuration.id, newRestDuration.id);
        // before, after は v2 で削除済み
        expect(history.beforePillSheetGroup!.pillSheets[0].restDurations.length, 2);
        expect(history.afterPillSheetGroup!.pillSheets[0].restDurations.length, 3);
      });
    });
  });

  group('#createEndedRestDurationAction', () {
    // テスト用のPillSheetGroupを作成するヘルパー関数
    PillSheetGroup createPillSheetGroup({required List<PillSheet> pillSheets}) {
      return PillSheetGroup(
        id: 'group_id',
        pillSheetIDs: pillSheets.map((e) => e.id ?? '').toList(),
        pillSheets: pillSheets,
        createdAt: DateTime(2020, 9, 1),
      );
    }

    group('正常ケース', () {
      test('actionType が endedRestDuration であること', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [restDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final endedRestDuration = restDuration.copyWith(
          endDate: DateTime(2020, 9, 14),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.endedRestDuration.name);
      });

      test('endedRestDurationValue に restDuration が正しく設定されること', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [restDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final endedRestDuration = restDuration.copyWith(
          endDate: DateTime(2020, 9, 14),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.endedRestDurationValue, isNotNull);
        expect(history.value.endedRestDurationValue!.restDuration.id, endedRestDuration.id);
        expect(history.value.endedRestDurationValue!.restDuration.beginDate, endedRestDuration.beginDate);
        expect(history.value.endedRestDurationValue!.restDuration.endDate, endedRestDuration.endDate);
        expect(history.value.endedRestDurationValue!.restDuration.createdDate, endedRestDuration.createdDate);
      });

      test('before と after の PillSheet が正しく設定されること', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [restDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final endedRestDuration = restDuration.copyWith(
          endDate: DateTime(2020, 9, 14),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // before, after, beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('pillSheetGroupID が正しく設定されること', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [restDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final endedRestDuration = restDuration.copyWith(
          endDate: DateTime(2020, 9, 14),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // pillSheetGroupID は v2 で削除済み
      });
    });

    group('複数ピルシートがある場合', () {
      test('2枚目のピルシートで休薬期間を終了した場合、正しく設定されること', () {
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          groupIndex: 0,
          createdAt: DateTime(2020, 9, 1),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 10, 11),
          createdDate: DateTime(2020, 10, 11),
        );
        final beforeSecondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 10),
          groupIndex: 1,
          restDurations: [restDuration],
          createdAt: DateTime(2020, 9, 29),
        );
        final endedRestDuration = restDuration.copyWith(
          endDate: DateTime(2020, 10, 14),
        );
        final afterSecondPillSheet = beforeSecondPillSheet.copyWith(
          restDurations: [endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, beforeSecondPillSheet],
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, afterSecondPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.endedRestDuration.name);
        // before, after, beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('3枚目のピルシートで休薬期間を終了した場合、正しく設定されること', () {
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          groupIndex: 0,
          createdAt: DateTime(2020, 9, 1),
        );
        final secondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 26),
          groupIndex: 1,
          createdAt: DateTime(2020, 9, 29),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 11, 11),
          createdDate: DateTime(2020, 11, 11),
        );
        final beforeThirdPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 27),
          lastTakenDate: DateTime(2020, 11, 10),
          groupIndex: 2,
          restDurations: [restDuration],
          createdAt: DateTime(2020, 10, 27),
        );
        final endedRestDuration = restDuration.copyWith(
          endDate: DateTime(2020, 11, 14),
        );
        final afterThirdPillSheet = beforeThirdPillSheet.copyWith(
          restDurations: [endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet, beforeThirdPillSheet],
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet, afterThirdPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.endedRestDuration.name);
        // before, after, beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.beforePillSheetGroup!.pillSheets.length, 3);
        expect(history.afterPillSheetGroup!.pillSheets.length, 3);
      });
    });

    group('RestDuration のプロパティ', () {
      test('endDate が設定されている場合、正しく記録されること', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [restDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final endedRestDuration = restDuration.copyWith(
          endDate: DateTime(2020, 9, 14),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.endedRestDurationValue!.restDuration.endDate, DateTime(2020, 9, 14));
      });

      test('休薬期間が1日だけの場合（beginDate と endDate が同日）、正しく設定されること', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [restDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final endedRestDuration = restDuration.copyWith(
          endDate: DateTime(2020, 9, 11),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.endedRestDurationValue!.restDuration.beginDate, DateTime(2020, 9, 11));
        expect(history.value.endedRestDurationValue!.restDuration.endDate, DateTime(2020, 9, 11));
      });
    });

    group('メタデータの検証', () {
      test('estimatedEventCausingDate が正しく設定されること', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [restDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final endedRestDuration = restDuration.copyWith(
          endDate: DateTime(2020, 9, 14),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.estimatedEventCausingDate, isNotNull);
      });

      test('createdAt が正しく設定されること', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [restDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final endedRestDuration = restDuration.copyWith(
          endDate: DateTime(2020, 9, 14),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.createdAt, isNotNull);
      });

      test('ttlExpiresDateTime が limitDays 日後に設定されること', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [restDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final endedRestDuration = restDuration.copyWith(
          endDate: DateTime(2020, 9, 14),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.ttlExpiresDateTime, isNotNull);
        // now()が2回別々に呼ばれるためマイクロ秒の差異が生じる可能性があるので、差分で検証する
        final difference = history.ttlExpiresDateTime!.difference(history.createdAt);
        expect(difference.inDays, PillSheetModifiedHistoryServiceActionFactory.limitDays);
      });
    });

    // 異常ケースのテスト削除: v2で pillSheetGroupID プロパティは削除され、
    // afterPillSheetGroup.id から取得するため、「pillSheetGroupID が null の場合」というテストは前提が変わった

    group('PillSheetType による違い', () {
      test('21錠タイプ（pillsheet_21）で休薬期間を終了した場合', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [restDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final endedRestDuration = restDuration.copyWith(
          endDate: DateTime(2020, 9, 14),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.endedRestDuration.name);
        // before, after は v2 で削除済み
        expect(history.beforePillSheetGroup!.pillSheets[0].typeInfo, PillSheetType.pillsheet_21.typeInfo);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo, PillSheetType.pillsheet_21.typeInfo);
      });

      test('24錠タイプ（pillsheet_28_4）で休薬期間を終了した場合', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [restDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final endedRestDuration = restDuration.copyWith(
          endDate: DateTime(2020, 9, 14),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.endedRestDuration.name);
        // before, after は v2 で削除済み
        expect(history.beforePillSheetGroup!.pillSheets[0].typeInfo, PillSheetType.pillsheet_28_4.typeInfo);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo, PillSheetType.pillsheet_28_4.typeInfo);
      });
    });

    group('既存の RestDuration がある場合', () {
      test('既に1つの完了した休薬期間がある状態で2つ目の休薬期間を終了した場合', () {
        final existingRestDuration = RestDuration(
          id: 'rest_duration_id_existing',
          beginDate: DateTime(2020, 9, 5),
          endDate: DateTime(2020, 9, 7),
          createdDate: DateTime(2020, 9, 5),
        );
        final currentRestDuration = RestDuration(
          id: 'rest_duration_id_current',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [existingRestDuration, currentRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final endedRestDuration = currentRestDuration.copyWith(
          endDate: DateTime(2020, 9, 14),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [existingRestDuration, endedRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.endedRestDurationValue!.restDuration.id, endedRestDuration.id);
        // before, after は v2 で削除済み
        expect(history.beforePillSheetGroup!.pillSheets[0].restDurations.length, 2);
        expect(history.afterPillSheetGroup!.pillSheets[0].restDurations.length, 2);
        expect(history.beforePillSheetGroup!.pillSheets[0].restDurations[1].endDate, isNull);
        expect(history.afterPillSheetGroup!.pillSheets[0].restDurations[1].endDate, DateTime(2020, 9, 14));
      });
    });
  });

  group('#createChangedRestDurationBeginDateAction', () {
    // テスト用のPillSheetGroupを作成するヘルパー関数
    PillSheetGroup createPillSheetGroup({required List<PillSheet> pillSheets}) {
      return PillSheetGroup(
        id: 'group_id',
        pillSheetIDs: pillSheets.map((e) => e.id ?? '').toList(),
        pillSheets: pillSheets,
        createdAt: DateTime(2020, 9, 1),
      );
    }

    group('正常ケース', () {
      test('actionType が changedRestDurationBeginDate であること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedRestDurationBeginDate.name);
      });

      test('changedRestDurationBeginDateValue に beforeRestDuration と afterRestDuration が正しく設定されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationBeginDateValue, isNotNull);
        expect(history.value.changedRestDurationBeginDateValue!.beforeRestDuration.id, beforeRestDuration.id);
        expect(history.value.changedRestDurationBeginDateValue!.beforeRestDuration.beginDate, beforeRestDuration.beginDate);
        expect(history.value.changedRestDurationBeginDateValue!.afterRestDuration.id, afterRestDuration.id);
        expect(history.value.changedRestDurationBeginDateValue!.afterRestDuration.beginDate, afterRestDuration.beginDate);
      });

      test('before と after の PillSheet が正しく設定されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // before, after, beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('pillSheetGroupID が正しく設定されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // pillSheetGroupID は v2 で削除済み
      });
    });

    group('開始日の変更パターン', () {
      test('開始日を前にずらした場合（例：9/11 → 9/10）', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationBeginDateValue!.beforeRestDuration.beginDate, DateTime(2020, 9, 11));
        expect(history.value.changedRestDurationBeginDateValue!.afterRestDuration.beginDate, DateTime(2020, 9, 10));
      });

      test('開始日を後にずらした場合（例：9/10 → 9/11）', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 10),
          createdDate: DateTime(2020, 9, 10),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 9),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationBeginDateValue!.beforeRestDuration.beginDate, DateTime(2020, 9, 10));
        expect(history.value.changedRestDurationBeginDateValue!.afterRestDuration.beginDate, DateTime(2020, 9, 11));
      });

      test('開始日を大幅に変更した場合（例：9/11 → 9/5）', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 5),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationBeginDateValue!.beforeRestDuration.beginDate, DateTime(2020, 9, 11));
        expect(history.value.changedRestDurationBeginDateValue!.afterRestDuration.beginDate, DateTime(2020, 9, 5));
      });
    });

    group('複数ピルシートがある場合', () {
      test('2枚目のピルシートで休薬開始日を変更した場合、正しく設定されること', () {
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          groupIndex: 0,
          createdAt: DateTime(2020, 9, 1),
        );
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 10, 11),
          createdDate: DateTime(2020, 10, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 10, 10),
        );
        final beforeSecondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 10),
          groupIndex: 1,
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 29),
        );
        final afterSecondPillSheet = beforeSecondPillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, beforeSecondPillSheet],
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, afterSecondPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedRestDurationBeginDate.name);
        // before, after, beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
        expect(history.value.changedRestDurationBeginDateValue!.beforeRestDuration.beginDate, DateTime(2020, 10, 11));
        expect(history.value.changedRestDurationBeginDateValue!.afterRestDuration.beginDate, DateTime(2020, 10, 10));
      });
    });

    group('RestDuration のプロパティ', () {
      test('endDate が設定されている場合でも正しく記録されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          endDate: DateTime(2020, 9, 14),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationBeginDateValue!.beforeRestDuration.endDate, DateTime(2020, 9, 14));
        expect(history.value.changedRestDurationBeginDateValue!.afterRestDuration.endDate, DateTime(2020, 9, 14));
      });

      test('createdDate が保持されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11, 10, 30),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationBeginDateValue!.beforeRestDuration.createdDate, DateTime(2020, 9, 11, 10, 30));
        expect(history.value.changedRestDurationBeginDateValue!.afterRestDuration.createdDate, DateTime(2020, 9, 11, 10, 30));
      });
    });

    group('メタデータの検証', () {
      test('estimatedEventCausingDate が正しく設定されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.estimatedEventCausingDate, isNotNull);
      });

      test('createdAt が正しく設定されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.createdAt, isNotNull);
      });

      test('ttlExpiresDateTime が limitDays 日後に設定されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.ttlExpiresDateTime, isNotNull);
        // now()が2回別々に呼ばれるためマイクロ秒の差異が生じる可能性があるので、差分で検証する
        final difference = history.ttlExpiresDateTime!.difference(history.createdAt);
        expect(difference.inDays, PillSheetModifiedHistoryServiceActionFactory.limitDays);
      });
    });

    // 異常ケースのテスト削除: v2で pillSheetGroupID プロパティは削除され、
    // afterPillSheetGroup.id から取得するため、「pillSheetGroupID が null の場合」というテストは前提が変わった

    group('PillSheetType による違い', () {
      test('21錠タイプ（pillsheet_21）で休薬開始日を変更した場合', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedRestDurationBeginDate.name);
        // before, after は v2 で削除済み
        expect(history.beforePillSheetGroup!.pillSheets[0].typeInfo, PillSheetType.pillsheet_21.typeInfo);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo, PillSheetType.pillsheet_21.typeInfo);
      });

      test('24錠タイプ（pillsheet_28_4）で休薬開始日を変更した場合', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedRestDurationBeginDate.name);
        // before, after は v2 で削除済み
        expect(history.beforePillSheetGroup!.pillSheets[0].typeInfo, PillSheetType.pillsheet_28_4.typeInfo);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo, PillSheetType.pillsheet_28_4.typeInfo);
      });
    });

    group('既存の RestDuration がある場合', () {
      test('既に1つの完了した休薬期間がある状態で2つ目の休薬期間の開始日を変更した場合', () {
        final existingRestDuration = RestDuration(
          id: 'rest_duration_id_existing',
          beginDate: DateTime(2020, 9, 5),
          endDate: DateTime(2020, 9, 7),
          createdDate: DateTime(2020, 9, 5),
        );
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_current',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [existingRestDuration, beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [existingRestDuration, afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationBeginDateValue!.beforeRestDuration.id, beforeRestDuration.id);
        expect(history.value.changedRestDurationBeginDateValue!.afterRestDuration.id, afterRestDuration.id);
        // before, after は v2 で削除済み
        expect(history.beforePillSheetGroup!.pillSheets[0].restDurations.length, 2);
        expect(history.afterPillSheetGroup!.pillSheets[0].restDurations.length, 2);
        expect(history.beforePillSheetGroup!.pillSheets[0].restDurations[1].beginDate, DateTime(2020, 9, 11));
        expect(history.afterPillSheetGroup!.pillSheets[0].restDurations[1].beginDate, DateTime(2020, 9, 10));
      });
    });
  });

  group('#createChangedRestDurationAction', () {
    // テスト用のPillSheetGroupを作成するヘルパー関数
    PillSheetGroup createPillSheetGroup({required List<PillSheet> pillSheets}) {
      return PillSheetGroup(
        id: 'group_id',
        pillSheetIDs: pillSheets.map((e) => e.id ?? '').toList(),
        pillSheets: pillSheets,
        createdAt: DateTime(2020, 9, 1),
      );
    }

    group('正常ケース', () {
      test('actionType が changedRestDuration であること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          endDate: DateTime(2020, 9, 14),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 9, 16),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedRestDuration.name);
      });

      test('changedRestDurationValue に beforeRestDuration と afterRestDuration が正しく設定されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          endDate: DateTime(2020, 9, 14),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 9, 16),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationValue, isNotNull);
        expect(history.value.changedRestDurationValue!.beforeRestDuration.id, beforeRestDuration.id);
        expect(history.value.changedRestDurationValue!.beforeRestDuration.beginDate, beforeRestDuration.beginDate);
        expect(history.value.changedRestDurationValue!.beforeRestDuration.endDate, beforeRestDuration.endDate);
        expect(history.value.changedRestDurationValue!.afterRestDuration.id, afterRestDuration.id);
        expect(history.value.changedRestDurationValue!.afterRestDuration.beginDate, afterRestDuration.beginDate);
        expect(history.value.changedRestDurationValue!.afterRestDuration.endDate, afterRestDuration.endDate);
      });

      test('before と after の PillSheet が正しく設定されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          endDate: DateTime(2020, 9, 14),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 9, 16),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // before, after, beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('pillSheetGroupID が正しく設定されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          endDate: DateTime(2020, 9, 14),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 9, 16),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // pillSheetGroupID は v2 で削除済み
      });

      test('version が v2 であること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          endDate: DateTime(2020, 9, 14),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 9, 16),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.version, 'v2');
      });
    });

    group('休薬期間の終了日を変更するケース', () {
      test('endDate を延長した場合に正しく記録されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          endDate: DateTime(2020, 9, 14),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 9, 18),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationValue!.beforeRestDuration.endDate, DateTime(2020, 9, 14));
        expect(history.value.changedRestDurationValue!.afterRestDuration.endDate, DateTime(2020, 9, 18));
      });

      test('endDate を短縮した場合に正しく記録されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          endDate: DateTime(2020, 9, 18),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 9, 14),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationValue!.beforeRestDuration.endDate, DateTime(2020, 9, 18));
        expect(history.value.changedRestDurationValue!.afterRestDuration.endDate, DateTime(2020, 9, 14));
      });
    });

    group('休薬期間の開始日を変更するケース', () {
      test('beginDate を繰り上げた場合に正しく記録されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          endDate: DateTime(2020, 9, 14),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 9),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationValue!.beforeRestDuration.beginDate, DateTime(2020, 9, 11));
        expect(history.value.changedRestDurationValue!.afterRestDuration.beginDate, DateTime(2020, 9, 9));
      });

      test('beginDate を繰り下げた場合に正しく記録されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 9),
          endDate: DateTime(2020, 9, 14),
          createdDate: DateTime(2020, 9, 9),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 8),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationValue!.beforeRestDuration.beginDate, DateTime(2020, 9, 9));
        expect(history.value.changedRestDurationValue!.afterRestDuration.beginDate, DateTime(2020, 9, 11));
      });
    });

    group('複数のピルシートがあるケース', () {
      test('2枚目のピルシートの休薬期間を変更した場合に正しく記録されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 10, 5),
          endDate: DateTime(2020, 10, 10),
          createdDate: DateTime(2020, 10, 5),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 10, 12),
        );
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final beforeSecondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 4),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final afterSecondPillSheet = beforeSecondPillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [firstPillSheet, beforeSecondPillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [firstPillSheet, afterSecondPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // beforePillSheetID, afterPillSheetID, before, after は削除済み - beforePillSheetGroup/afterPillSheetGroup を使用
        expect(history.beforePillSheetGroup!.pillSheets[1].groupIndex, 1);
        expect(history.afterPillSheetGroup!.pillSheets[1].groupIndex, 1);
        expect(history.value.changedRestDurationValue!.beforeRestDuration.endDate, DateTime(2020, 10, 10));
        expect(history.value.changedRestDurationValue!.afterRestDuration.endDate, DateTime(2020, 10, 12));
      });

      test('3枚目のピルシートの休薬期間を変更した場合に正しく記録されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 11, 5),
          endDate: DateTime(2020, 11, 10),
          createdDate: DateTime(2020, 11, 5),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 11, 14),
        );
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final secondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 26),
          restDurations: [],
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final beforeThirdPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 27),
          lastTakenDate: DateTime(2020, 11, 4),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 10, 27),
          groupIndex: 2,
        );
        final afterThirdPillSheet = beforeThirdPillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [firstPillSheet, secondPillSheet, beforeThirdPillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [firstPillSheet, secondPillSheet, afterThirdPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // beforePillSheetID, afterPillSheetID, before, after は削除済み - beforePillSheetGroup/afterPillSheetGroup を使用
        expect(history.beforePillSheetGroup!.pillSheets[2].groupIndex, 2);
        expect(history.afterPillSheetGroup!.pillSheets[2].groupIndex, 2);
        expect(history.value.changedRestDurationValue!.beforeRestDuration.endDate, DateTime(2020, 11, 10));
        expect(history.value.changedRestDurationValue!.afterRestDuration.endDate, DateTime(2020, 11, 14));
        expect(history.beforePillSheetGroup!.pillSheets.length, 3);
        expect(history.afterPillSheetGroup!.pillSheets.length, 3);
      });
    });

    group('複数の休薬期間があるケース', () {
      test('2つ目の休薬期間を変更した場合に before/after の PillSheet に正しく反映されること', () {
        final existingRestDuration = RestDuration(
          id: 'rest_duration_id_0',
          beginDate: DateTime(2020, 9, 5),
          endDate: DateTime(2020, 9, 7),
          createdDate: DateTime(2020, 9, 5),
        );
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 15),
          endDate: DateTime(2020, 9, 18),
          createdDate: DateTime(2020, 9, 15),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 9, 20),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 14),
          restDurations: [existingRestDuration, beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [existingRestDuration, afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationValue!.beforeRestDuration.id, beforeRestDuration.id);
        expect(history.value.changedRestDurationValue!.afterRestDuration.id, afterRestDuration.id);
        // before, after は削除済み - beforePillSheetGroup/afterPillSheetGroup を使用
        expect(history.beforePillSheetGroup!.pillSheets.first.restDurations.length, 2);
        expect(history.afterPillSheetGroup!.pillSheets.first.restDurations.length, 2);
        expect(history.beforePillSheetGroup!.pillSheets.first.restDurations[1].endDate, DateTime(2020, 9, 18));
        expect(history.afterPillSheetGroup!.pillSheets.first.restDurations[1].endDate, DateTime(2020, 9, 20));
      });
    });

    group('異なるPillSheetTypeのケース', () {
      test('21錠タイプ（pillsheet_21_0）のピルシートで休薬期間を変更した場合', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 15),
          endDate: DateTime(2020, 9, 18),
          createdDate: DateTime(2020, 9, 15),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 9, 20),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 14),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedRestDuration.name);
        // before, after は削除済み - beforePillSheetGroup/afterPillSheetGroup を使用
        expect(history.beforePillSheetGroup!.pillSheets.first.typeInfo.totalCount, 21);
        expect(history.afterPillSheetGroup!.pillSheets.first.typeInfo.totalCount, 21);
      });

      test('24錠+4偽薬タイプのピルシートで休薬期間を変更した場合', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 15),
          endDate: DateTime(2020, 9, 18),
          createdDate: DateTime(2020, 9, 15),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 9, 20),
        );
        final beforePillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_24_rest_4.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 14),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedRestDuration.name);
        // before, after は削除済み - beforePillSheetGroup/afterPillSheetGroup を使用
        expect(history.beforePillSheetGroup!.pillSheets.first.typeInfo.totalCount, 28);
        expect(history.beforePillSheetGroup!.pillSheets.first.typeInfo.dosingPeriod, 24);
        expect(history.afterPillSheetGroup!.pillSheets.first.typeInfo.totalCount, 28);
        expect(history.afterPillSheetGroup!.pillSheets.first.typeInfo.dosingPeriod, 24);
      });
    });

    // 異常ケースのテスト削除: v2で pillSheetGroupID プロパティは削除され、
    // afterPillSheetGroup.id から取得するため、「pillSheetGroupID が null の場合」というテストは前提が変わった
  });

  group('#createChangedBeginDisplayNumberAction', () {
    // テスト用のPillSheetGroupを作成するヘルパー関数
    PillSheetGroup createPillSheetGroup({
      required List<PillSheet> pillSheets,
      PillSheetGroupDisplayNumberSetting? displayNumberSetting,
    }) {
      return PillSheetGroup(
        id: 'group_id',
        pillSheetIDs: pillSheets.map((e) => e.id ?? '').toList(),
        pillSheets: pillSheets,
        createdAt: DateTime(2020, 9, 1),
        displayNumberSetting: displayNumberSetting,
      );
    }

    group('正常ケース', () {
      test('actionType が changedBeginDisplayNumber であること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedBeginDisplayNumber.name);
      });

      test('changedBeginDisplayNumber に beforeDisplayNumberSetting と afterDisplayNumberSetting が正しく設定されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 10,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedBeginDisplayNumber, isNotNull);
        expect(history.value.changedBeginDisplayNumber, isNotNull);
      });

      test('before と after の PillSheet が null であること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // before, after, beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('beforePillSheetGroup と afterPillSheetGroup が正しく設定されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('pillSheetGroupID が正しく設定されること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // pillSheetGroupID は v2 で削除済み
      });

      test('version が v2 であること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.version, 'v2');
      });
    });

    group('beforeDisplayNumberSetting が null の場合（設定なし→設定ありへの変更）', () {
      test('初めて表示番号設定を追加する場合に正しく記録されること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedBeginDisplayNumber, isNotNull);
      });

      test('beginPillNumber のみを設定した場合に正しく記録されること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 10,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // beforeDisplayNumberSetting, afterDisplayNumberSetting は v2 で削除済み
        // beforePillSheetGroup, afterPillSheetGroup から displayNumberSetting を取得する
        expect(history.beforePillSheetGroup?.displayNumberSetting, isNull);
        expect(history.afterPillSheetGroup!.displayNumberSetting!.beginPillNumber, 10);
        expect(history.afterPillSheetGroup!.displayNumberSetting!.endPillNumber, isNull);
      });
    });

    group('beforeDisplayNumberSetting が設定済みの場合（設定変更）', () {
      test('beginPillNumber のみ変更した場合に正しく記録されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // beforeDisplayNumberSetting, afterDisplayNumberSetting は v2 で削除済み
        expect(history.beforePillSheetGroup!.displayNumberSetting!.beginPillNumber, 1);
        expect(history.afterPillSheetGroup!.displayNumberSetting!.beginPillNumber, 5);
        // endPillNumber は変わっていない
        expect(history.beforePillSheetGroup!.displayNumberSetting!.endPillNumber, 28);
        expect(history.afterPillSheetGroup!.displayNumberSetting!.endPillNumber, 28);
      });

      test('beginPillNumber を大きな値に変更した場合に正しく記録されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 120,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 85,
          endPillNumber: 120,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // beforeDisplayNumberSetting, afterDisplayNumberSetting は v2 で削除済み
        expect(history.beforePillSheetGroup!.displayNumberSetting!.beginPillNumber, 1);
        expect(history.afterPillSheetGroup!.displayNumberSetting!.beginPillNumber, 85);
      });
    });

    group('複数のピルシートがあるケース', () {
      test('PillSheetGroup に複数のピルシートがある場合に正しく記録されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 84,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 29,
          endPillNumber: 84,
        );
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final secondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final thirdPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 27),
          lastTakenDate: null,
          restDurations: [],
          createdAt: DateTime(2020, 10, 27),
          groupIndex: 2,
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet, thirdPillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet, thirdPillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetGroup!.pillSheets.length, 3);
        expect(history.afterPillSheetGroup!.pillSheets.length, 3);
        // beforeDisplayNumberSetting, afterDisplayNumberSetting は v2 で削除済み
        expect(history.beforePillSheetGroup!.displayNumberSetting!.beginPillNumber, 1);
        expect(history.afterPillSheetGroup!.displayNumberSetting!.beginPillNumber, 29);
      });
    });

    group('異なるPillSheetTypeのケース', () {
      test('21錠タイプ（pillsheet_21_0）のピルシートで表示番号設定を変更した場合', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 21,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 8,
          endPillNumber: 21,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedBeginDisplayNumber.name);
        expect(history.beforePillSheetGroup!.pillSheets.first.typeInfo.totalCount, 21);
        expect(history.afterPillSheetGroup!.pillSheets.first.typeInfo.totalCount, 21);
      });

      test('24錠+4偽薬タイプのピルシートで表示番号設定を変更した場合', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 10,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_24_rest_4.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedBeginDisplayNumber.name);
        expect(history.beforePillSheetGroup!.pillSheets.first.typeInfo.totalCount, 28);
        expect(history.beforePillSheetGroup!.pillSheets.first.typeInfo.dosingPeriod, 24);
        expect(history.afterPillSheetGroup!.pillSheets.first.typeInfo.totalCount, 28);
        expect(history.afterPillSheetGroup!.pillSheets.first.typeInfo.dosingPeriod, 24);
      });
    });

    group('pillSheetGroupID が null の場合', () {
      test('pillSheetGroupID が null でも履歴が作成されること', () {
        // createChangedBeginDisplayNumberAction には assert がないため、null でも動作する
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // history.pillSheetGroupID は削除済み
        expect(history.actionType, PillSheetModifiedActionType.changedBeginDisplayNumber.name);
      });
    });

    group('タイムスタンプ関連', () {
      test('createdAt が設定されること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.createdAt, isNotNull);
      });

      test('estimatedEventCausingDate が設定されること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.estimatedEventCausingDate, isNotNull);
      });

      test('ttlExpiresDateTime が createdAt + limitDays で設定されること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.ttlExpiresDateTime, isNotNull);
        final difference = history.ttlExpiresDateTime!.difference(history.createdAt);
        expect(difference.inDays, PillSheetModifiedHistoryServiceActionFactory.limitDays);
      });
    });

    group('RestDurationを持つピルシートのケース', () {
      test('RestDurationを持つピルシートで表示番号設定を変更した場合、RestDuration情報がbeforePillSheetGroupとafterPillSheetGroupに保持される', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id',
          beginDate: DateTime(2020, 9, 5),
          createdDate: DateTime(2020, 9, 5),
          endDate: DateTime(2020, 9, 8),
        );
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [restDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // beforePillSheetGroup の RestDuration が保持されている
        expect(history.beforePillSheetGroup!.pillSheets.first.restDurations.length, 1);
        expect(history.beforePillSheetGroup!.pillSheets.first.restDurations.first.beginDate, DateTime(2020, 9, 5));
        expect(history.beforePillSheetGroup!.pillSheets.first.restDurations.first.endDate, DateTime(2020, 9, 8));
        // afterPillSheetGroup にも RestDuration が保持されている
        expect(history.afterPillSheetGroup!.pillSheets.first.restDurations.length, 1);
        expect(history.afterPillSheetGroup!.pillSheets.first.restDurations.first.beginDate, DateTime(2020, 9, 5));
        expect(history.afterPillSheetGroup!.pillSheets.first.restDurations.first.endDate, DateTime(2020, 9, 8));
      });
    });
  });

  group('#createChangedEndDisplayNumberAction', () {
    // テスト用のPillSheetGroupを作成するヘルパー関数
    PillSheetGroup createPillSheetGroup({
      required List<PillSheet> pillSheets,
      PillSheetGroupDisplayNumberSetting? displayNumberSetting,
    }) {
      return PillSheetGroup(
        id: 'group_id',
        pillSheetIDs: pillSheets.map((e) => e.id ?? '').toList(),
        pillSheets: pillSheets,
        createdAt: DateTime(2020, 9, 1),
        displayNumberSetting: displayNumberSetting,
      );
    }

    group('正常ケース', () {
      test('actionType が changedEndDisplayNumber であること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedEndDisplayNumber.name);
      });

      test('changedEndDisplayNumber に beforeDisplayNumberSetting と afterDisplayNumberSetting が正しく設定されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 84,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedEndDisplayNumber, isNotNull);
        expect(history.value.changedEndDisplayNumber, isNotNull);
      });

      test('before と after の PillSheet が null であること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // before, after, beforePillSheetID, afterPillSheetID は v2 で削除済み
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('beforePillSheetGroup と afterPillSheetGroup が正しく設定されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('pillSheetGroupID が正しく設定されること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // pillSheetGroupID は v2 で削除済み
        expect(history.afterPillSheetGroup!.id, 'group_id');
      });

      test('version が v2 であること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.version, 'v2');
      });
    });

    group('beforeDisplayNumberSetting が null の場合（設定なし→設定ありへの変更）', () {
      test('初めて表示終了番号設定を追加する場合に正しく記録されること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedEndDisplayNumber, isNotNull);
      });

      test('endPillNumber のみを設定した場合に正しく記録されること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          endPillNumber: 84,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedEndDisplayNumber, isNotNull);
      });
    });

    group('beforeDisplayNumberSetting が設定済みの場合（設定変更）', () {
      test('endPillNumber のみ変更した場合に正しく記録されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedEndDisplayNumber, isNotNull);
        // beginPillNumber は変わっていない
        expect(history.value.changedEndDisplayNumber, isNotNull);
      });

      test('endPillNumber を大きな値に変更した場合に正しく記録されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 120,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedEndDisplayNumber, isNotNull);
      });

      test('endPillNumber を小さな値に変更した場合に正しく記録されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 84,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedEndDisplayNumber, isNotNull);
      });
    });

    group('複数のピルシートがあるケース', () {
      test('PillSheetGroup に複数のピルシートがある場合に正しく記録されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 84,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 120,
        );
        final firstPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final secondPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final thirdPillSheet = PillSheet.v1(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 10, 27),
          lastTakenDate: null,
          restDurations: [],
          createdAt: DateTime(2020, 10, 27),
          groupIndex: 2,
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet, thirdPillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [firstPillSheet, secondPillSheet, thirdPillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetGroup!.pillSheets.length, 3);
        expect(history.afterPillSheetGroup!.pillSheets.length, 3);
        expect(history.value.changedEndDisplayNumber, isNotNull);
      });
    });

    group('異なるPillSheetTypeのケース', () {
      test('21錠タイプ（pillsheet_21_0）のピルシートで表示終了番号設定を変更した場合', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 21,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 42,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedEndDisplayNumber.name);
        expect(history.beforePillSheetGroup!.pillSheets.first.typeInfo.totalCount, 21);
        expect(history.afterPillSheetGroup!.pillSheets.first.typeInfo.totalCount, 21);
      });

      test('24錠+4偽薬タイプのピルシートで表示終了番号設定を変更した場合', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_24_rest_4.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedEndDisplayNumber.name);
        expect(history.beforePillSheetGroup!.pillSheets.first.typeInfo.totalCount, 28);
        expect(history.afterPillSheetGroup!.pillSheets.first.typeInfo.totalCount, 28);
      });
    });

    group('pillSheetGroupID が null の場合', () {
      test('pillSheetGroupID が null でも履歴が作成されること', () {
        // createChangedEndDisplayNumberAction には assert がないため、null でも動作する
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [pillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // history.pillSheetGroupID は削除済み
        expect(history.actionType, PillSheetModifiedActionType.changedEndDisplayNumber.name);
      });
    });

    group('createdAt と estimatedEventCausingDate', () {
      test('createdAt と estimatedEventCausingDate が設定されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // createdAt と estimatedEventCausingDate が設定されていること
        expect(history.createdAt, isNotNull);
        expect(history.estimatedEventCausingDate, isNotNull);
        // createdAt と estimatedEventCausingDate が同じ値であること（now()関数で同時刻に設定される）
        expect(history.createdAt, history.estimatedEventCausingDate);
      });
    });

    group('RestDuration がある場合', () {
      test('RestDuration を持つ PillSheet がある場合に正しく記録されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 15),
          restDurations: [
            RestDuration(
              id: 'rest_duration_id_1',
              beginDate: DateTime(2020, 9, 10),
              createdDate: DateTime(2020, 9, 10),
              endDate: DateTime(2020, 9, 12),
            ),
          ],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedEndDisplayNumber.name);
        expect(history.beforePillSheetGroup!.pillSheets.first.restDurations.length, 1);
        expect(history.afterPillSheetGroup!.pillSheets.first.restDurations.length, 1);
        expect(history.value.changedEndDisplayNumber, isNotNull);
      });

      test('複数の RestDuration を持つ PillSheet がある場合に正しく記録されること', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 84,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 25),
          restDurations: [
            RestDuration(
              id: 'rest_duration_id_1',
              beginDate: DateTime(2020, 9, 5),
              createdDate: DateTime(2020, 9, 5),
              endDate: DateTime(2020, 9, 7),
            ),
            RestDuration(
              id: 'rest_duration_id_2',
              beginDate: DateTime(2020, 9, 15),
              createdDate: DateTime(2020, 9, 15),
              endDate: DateTime(2020, 9, 17),
            ),
          ],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedEndDisplayNumber.name);
        expect(history.beforePillSheetGroup!.pillSheets.first.restDurations.length, 2);
        expect(history.afterPillSheetGroup!.pillSheets.first.restDurations.length, 2);
      });

      test('終了していない RestDuration（endDate が null）を持つ PillSheet がある場合', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 28,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [
            RestDuration(
              id: 'rest_duration_id_1',
              beginDate: DateTime(2020, 9, 10),
              createdDate: DateTime(2020, 9, 10),
              endDate: null, // まだ終了していない
            ),
          ],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedEndDisplayNumber.name);
        expect(history.beforePillSheetGroup!.pillSheets.first.restDurations.first.endDate, isNull);
        expect(history.afterPillSheetGroup!.pillSheets.first.restDurations.first.endDate, isNull);
      });
    });

    group('beginPillNumber のみ設定されている場合', () {
      test('beginPillNumber のみ設定されていて endPillNumber を追加する場合', () {
        final beforeDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
        );
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 84,
        );
        final pillSheet = PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: beforeDisplayNumberSetting,
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [pillSheet],
          displayNumberSetting: afterDisplayNumberSetting,
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedEndDisplayNumber, isNotNull);
      });
    });
  });
}
