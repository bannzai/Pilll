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
    pillSheetID: null,
    pillSheetGroupID: null,
    beforePillSheetID: null,
    afterPillSheetID: null,
    before: null,
    after: null,
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
            pillSheetID: null,
            pillSheetGroupID: null,
            beforePillSheetID: null,
            afterPillSheetID: null,
            before: null,
            after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.automaticallyRecordedLastTakenDate.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 3)),
          createdAt: baseDate.subtract(const Duration(days: 3)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.endedRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 2)),
          createdAt: baseDate.subtract(const Duration(days: 2)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.endedRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 18)),
          createdAt: baseDate.subtract(const Duration(days: 18)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_4',
          actionType: PillSheetModifiedActionType.endedRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 8)),
          createdAt: baseDate.subtract(const Duration(days: 8)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_6',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 7)),
          createdAt: baseDate.subtract(const Duration(days: 7)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.revertTakenPill.name,
          estimatedEventCausingDate: targetDate.add(const Duration(hours: 12)),
          createdAt: targetDate.add(const Duration(hours: 12)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_3',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: targetDate.add(const Duration(hours: 18)),
          createdAt: targetDate.add(const Duration(hours: 18)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_3',
          actionType: PillSheetModifiedActionType.endedRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 5)),
          createdAt: baseDate.subtract(const Duration(days: 5)),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
        ),
        PillSheetModifiedHistory(
          id: 'history_5',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate,
          createdAt: baseDate,
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 11),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.actionType, PillSheetModifiedActionType.takenPill.name);
        expect(history.enumActionType, PillSheetModifiedActionType.takenPill);
        expect(history.pillSheetGroupID, 'group_id');
        expect(history.beforePillSheetID, 'pill_sheet_id_1');
        expect(history.afterPillSheetID, 'pill_sheet_id_1');
        expect(history.before, beforePillSheet);
        expect(history.after, afterPillSheet);
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);

        // TakenPillValue の検証
        final takenPillValue = history.value.takenPill;
        expect(takenPillValue, isNotNull);
        expect(takenPillValue!.afterLastTakenDate, DateTime(2020, 9, 11));
        expect(takenPillValue.afterLastTakenPillNumber, 11);
        expect(takenPillValue.beforeLastTakenDate, DateTime(2020, 9, 10));
        expect(takenPillValue.beforeLastTakenPillNumber, 10);
        expect(takenPillValue.isQuickRecord, false);
      });

      test('isQuickRecord = true の場合', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 11),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: true,
        );

        expect(history.value.takenPill?.isQuickRecord, true);
      });

      test('beforeのlastTakenDateがnullの場合（初回服用）', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 1),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        final takenPillValue = history.value.takenPill;
        expect(takenPillValue, isNotNull);
        expect(takenPillValue!.beforeLastTakenDate, isNull);
        expect(takenPillValue.beforeLastTakenPillNumber, 0);
        expect(takenPillValue.afterLastTakenDate, DateTime(2020, 9, 1));
        expect(takenPillValue.afterLastTakenPillNumber, 1);
      });

      test('複数ピルを一度に服用した場合（まとめ飲み）', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        // 3日分まとめて服用
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 13),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        final takenPillValue = history.value.takenPill;
        expect(takenPillValue, isNotNull);
        expect(takenPillValue!.beforeLastTakenPillNumber, 10);
        expect(takenPillValue.afterLastTakenPillNumber, 13);
      });

      test('ピルシートの最後のピルを服用した場合', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 27),
          createdAt: DateTime(2020, 9, 1),
        );
        // 28錠目（最後）を服用
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        final takenPillValue = history.value.takenPill;
        expect(takenPillValue, isNotNull);
        expect(takenPillValue!.beforeLastTakenPillNumber, 27);
        expect(takenPillValue.afterLastTakenPillNumber, 28);
      });

      test('beforeとafterで異なるPillSheet IDの場合（シート切り替え時）', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 9, 29),
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final beforePillSheetGroup = createPillSheetGroup(
          pillSheets: [
            beforePillSheet,
            afterPillSheet.copyWith(lastTakenDate: null),
          ],
        );
        final afterPillSheetGroup = createPillSheetGroup(
          pillSheets: [beforePillSheet, afterPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.beforePillSheetID, 'pill_sheet_id_1');
        expect(history.afterPillSheetID, 'pill_sheet_id_2');
        expect(history.value.takenPill?.beforeLastTakenPillNumber, 28);
        expect(history.value.takenPill?.afterLastTakenPillNumber, 1);
      });
    });

    group('異常系', () {
      test('after.idがnullの場合、FormatExceptionがスローされる', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        // idがnull
        final afterPillSheet = PillSheet(
          id: null,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 11),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: 'group_id',
            before: beforePillSheet,
            after: afterPillSheet,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
            isQuickRecord: false,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('after.lastTakenDateがnullの場合、FormatExceptionがスローされる', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        // lastTakenDateがnull - これは服用アクションとしては不整合
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: 'group_id',
            before: beforePillSheet,
            after: afterPillSheet,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
            isQuickRecord: false,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('after.idとafter.lastTakenDateの両方がnullの場合、FormatExceptionがスローされる', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        // idとlastTakenDateの両方がnull
        final afterPillSheet = PillSheet(
          id: null,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: 'group_id',
            before: beforePillSheet,
            after: afterPillSheet,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
            isQuickRecord: false,
          ),
          throwsA(isA<FormatException>()),
        );
      });
    });
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 11),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.revertTakenPill.name);
        expect(history.enumActionType, PillSheetModifiedActionType.revertTakenPill);
        expect(history.pillSheetGroupID, 'group_id');
        expect(history.beforePillSheetID, 'pill_sheet_id_1');
        expect(history.afterPillSheetID, 'pill_sheet_id_1');
        expect(history.before, beforePillSheet);
        expect(history.after, afterPillSheet);
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);

        // RevertTakenPillValue の検証
        final revertTakenPillValue = history.value.revertTakenPill;
        expect(revertTakenPillValue, isNotNull);
        expect(revertTakenPillValue!.beforeLastTakenDate, DateTime(2020, 9, 11));
        expect(revertTakenPillValue.beforeLastTakenPillNumber, 11);
        expect(revertTakenPillValue.afterLastTakenDate, DateTime(2020, 9, 10));
        expect(revertTakenPillValue.afterLastTakenPillNumber, 10);
      });

      test('afterのlastTakenDateがnullの場合（ピルシートの最初まで取り消した場合）', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 1),
          createdAt: DateTime(2020, 9, 1),
        );
        // 1番目のピルを取り消すとlastTakenDateはnullになる
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final revertTakenPillValue = history.value.revertTakenPill;
        expect(revertTakenPillValue, isNotNull);
        expect(revertTakenPillValue!.beforeLastTakenDate, DateTime(2020, 9, 1));
        expect(revertTakenPillValue.beforeLastTakenPillNumber, 1);
        expect(revertTakenPillValue.afterLastTakenDate, isNull);
        expect(revertTakenPillValue.afterLastTakenPillNumber, 0);
      });

      test('複数ピルを一度に取り消した場合', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 13),
          createdAt: DateTime(2020, 9, 1),
        );
        // 3日分まとめて取り消し
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final revertTakenPillValue = history.value.revertTakenPill;
        expect(revertTakenPillValue, isNotNull);
        expect(revertTakenPillValue!.beforeLastTakenPillNumber, 13);
        expect(revertTakenPillValue.afterLastTakenPillNumber, 10);
      });

      test('ピルシートの最後のピルを取り消した場合', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
        );
        // 28錠目（最後）を取り消し
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 27),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final revertTakenPillValue = history.value.revertTakenPill;
        expect(revertTakenPillValue, isNotNull);
        expect(revertTakenPillValue!.beforeLastTakenPillNumber, 28);
        expect(revertTakenPillValue.afterLastTakenPillNumber, 27);
      });

      test('beforeとafterで異なるPillSheet IDの場合（シート境界での取り消し時）', () {
        final firstPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final beforeSecondPillSheet = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 9, 29),
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        // 2枚目の最初のピルを取り消すと、afterは1枚目の最後の状態を参照
        final afterSecondPillSheet = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
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
          pillSheetGroupID: 'group_id',
          before: beforeSecondPillSheet,
          after: afterSecondPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetID, 'pill_sheet_id_2');
        expect(history.afterPillSheetID, 'pill_sheet_id_2');
        expect(history.value.revertTakenPill?.beforeLastTakenPillNumber, 1);
        expect(history.value.revertTakenPill?.afterLastTakenPillNumber, 0);
        expect(history.value.revertTakenPill?.afterLastTakenDate, isNull);
      });
    });

    group('異常系', () {
      test('after.idがnullの場合、FormatExceptionがスローされる', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 11),
          createdAt: DateTime(2020, 9, 1),
        );
        // idがnull
        final afterPillSheet = PillSheet(
          id: null,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
            pillSheetGroupID: 'group_id',
            before: beforePillSheet,
            after: afterPillSheet,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('before.idがnullの場合、FormatExceptionがスローされる', () {
        // idがnull
        final beforePillSheet = PillSheet(
          id: null,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 11),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
            pillSheetGroupID: 'group_id',
            before: beforePillSheet,
            after: afterPillSheet,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('before.lastTakenDateがnullの場合、FormatExceptionがスローされる', () {
        // lastTakenDateがnull - 取り消しアクションとしては不整合（取り消す対象がない）
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
            pillSheetGroupID: 'group_id',
            before: beforePillSheet,
            after: afterPillSheet,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('before.idとbefore.lastTakenDateの両方がnullの場合、FormatExceptionがスローされる', () {
        // idとlastTakenDateの両方がnull
        final beforePillSheet = PillSheet(
          id: null,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
            pillSheetGroupID: 'group_id',
            before: beforePillSheet,
            after: afterPillSheet,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
          ),
          throwsA(isA<FormatException>()),
        );
      });
    });
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        // actionType の検証
        expect(history.actionType, PillSheetModifiedActionType.createdPillSheet.name);
        expect(history.enumActionType, PillSheetModifiedActionType.createdPillSheet);

        // pillSheetGroupID の検証
        expect(history.pillSheetGroupID, 'group_id');

        // before, after 関連のプロパティは全てnull
        expect(history.before, isNull);
        expect(history.after, isNull);
        expect(history.beforePillSheetID, isNull);
        expect(history.afterPillSheetID, isNull);

        // PillSheetGroup の検証
        expect(history.beforePillSheetGroup, isNull);
        expect(history.afterPillSheetGroup, createdNewPillSheetGroup);

        // CreatedPillSheetValue の検証
        final createdPillSheetValue = history.value.createdPillSheet;
        expect(createdPillSheetValue, isNotNull);
        expect(createdPillSheetValue!.pillSheetIDs, ['pill_sheet_id_1']);
        // pillSheetCreatedAt は now() を使用しているため、null でないことを確認
        expect(createdPillSheetValue.pillSheetCreatedAt, isNotNull);
      });

      test('pillSheetIDsが複数（2件）の場合', () {
        final pillSheet1 = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final pillSheet2 = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 1,
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet1, pillSheet2],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1', 'pill_sheet_id_2'],
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        final createdPillSheetValue = history.value.createdPillSheet;
        expect(createdPillSheetValue, isNotNull);
        expect(createdPillSheetValue!.pillSheetIDs, ['pill_sheet_id_1', 'pill_sheet_id_2']);
        expect(createdPillSheetValue.pillSheetIDs.length, 2);
      });

      test('pillSheetIDsが複数（3件）の場合', () {
        final pillSheet1 = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final pillSheet2 = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 1,
        );
        final pillSheet3 = PillSheet(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 10, 27),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 2,
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1', 'pill_sheet_id_2', 'pill_sheet_id_3'],
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        final createdPillSheetValue = history.value.createdPillSheet;
        expect(createdPillSheetValue, isNotNull);
        expect(createdPillSheetValue!.pillSheetIDs, ['pill_sheet_id_1', 'pill_sheet_id_2', 'pill_sheet_id_3']);
        expect(createdPillSheetValue.pillSheetIDs.length, 3);
      });

      test('beforePillSheetGroupが存在する場合（既存グループへのピルシート追加）', () {
        final existingPillSheet = PillSheet(
          id: 'existing_pill_sheet_id',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 8, 4),
          lastTakenDate: DateTime(2020, 8, 31),
          createdAt: DateTime(2020, 8, 4),
          groupIndex: 0,
        );
        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [existingPillSheet],
        );

        final newPillSheet = PillSheet(
          id: 'new_pill_sheet_id',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 1,
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [existingPillSheet, newPillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['new_pill_sheet_id'],
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
        expect(history.value.createdPillSheet!.pillSheetIDs, ['new_pill_sheet_id']);
      });

      test('異なるPillSheetType（pillsheet_21_0）でピルシートを作成する場合', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.createdPillSheet.name);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.totalCount, 21);
        expect(history.value.createdPillSheet!.pillSheetIDs, ['pill_sheet_id_1']);
      });

      test('異なるPillSheetType（pillsheet_28_4）でピルシートを作成する場合', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.createdPillSheet.name);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.totalCount, 28);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.dosingPeriod, 24);
        expect(history.value.createdPillSheet!.pillSheetIDs, ['pill_sheet_id_1']);
      });

      test('pillSheetIDsが空リストの場合も履歴は生成される', () {
        // 技術的には許容されるが、実際のユースケースでは発生しないはずのケース
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: 'group_id',
          pillSheetIDs: [],
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.createdPillSheet.name);
        expect(history.value.createdPillSheet!.pillSheetIDs, isEmpty);
      });
    });

    group('生成されるプロパティの検証', () {
      test('version は v2 が設定される', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.version, 'v2');
      });

      test('id は null が設定される（サーバー側で生成されるため）', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.id, isNull);
      });

      test('estimatedEventCausingDate と createdAt が設定される', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.estimatedEventCausingDate, isNotNull);
        expect(history.createdAt, isNotNull);
      });

      test('pillSheetID（deprecated）は null が設定される', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
          createdAt: DateTime(2020, 9, 1),
        );
        final createdNewPillSheetGroup = createPillSheetGroup(
          id: 'group_id',
          pillSheets: [pillSheet],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: null,
          createdNewPillSheetGroup: createdNewPillSheetGroup,
        );

        expect(history.pillSheetID, isNull);
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedPillNumber.name);
        expect(history.enumActionType, PillSheetModifiedActionType.changedPillNumber);
        expect(history.pillSheetGroupID, 'group_id');
        expect(history.beforePillSheetID, 'pill_sheet_id_1');
        expect(history.afterPillSheetID, 'pill_sheet_id_1');
        expect(history.before, beforePillSheet);
        expect(history.after, afterPillSheet);
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);

        // ChangedPillNumberValue の検証
        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue!.beforeBeginingDate, DateTime(2020, 9, 1));
        expect(changedPillNumberValue.afterBeginingDate, DateTime(2020, 9, 3));
      });

      test('開始日を進めた場合（todayPillNumberが減少）', () {
        // 9/1開始 → 9/5開始 に変更
        // todayPillNumber は today() に依存するため、beginingDate の変更を検証
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 5),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue!.beforeBeginingDate, DateTime(2020, 9, 1));
        expect(changedPillNumberValue.afterBeginingDate, DateTime(2020, 9, 5));
        // todayPillNumberはリアルタイムのtoday()に依存するため、
        // 開始日の変更によってピル番号の計算に影響することを確認
        // afterBeginingDateがbeforeBeginingDateより後なので、
        // 同じ日付に対するtodayPillNumberはafterの方が小さくなる
      });

      test('開始日を戻した場合（todayPillNumberが増加）', () {
        // 9/5開始 → 9/1開始 に変更（開始日を早める）
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 5),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue!.beforeBeginingDate, DateTime(2020, 9, 5));
        expect(changedPillNumberValue.afterBeginingDate, DateTime(2020, 9, 1));
        // afterBeginingDateがbeforeBeginingDateより前なので、
        // 同じ日付に対するtodayPillNumberはafterの方が大きくなる
      });

      test('groupIndexが変更された場合', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 1,
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue!.beforeGroupIndex, 0);
        expect(changedPillNumberValue.afterGroupIndex, 1);
      });

      test('異なるPillSheetType（pillsheet_21_0）の場合', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginingDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedPillNumber.name);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.totalCount, 21);

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue!.beforeBeginingDate, DateTime(2020, 9, 1));
        expect(changedPillNumberValue.afterBeginingDate, DateTime(2020, 9, 3));
      });

      test('異なるPillSheetType（pillsheet_28_4）の場合', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginingDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedPillNumber.name);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.totalCount, 28);
        expect(history.afterPillSheetGroup!.pillSheets[0].typeInfo.dosingPeriod, 24);

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue!.beforeBeginingDate, DateTime(2020, 9, 1));
        expect(changedPillNumberValue.afterBeginingDate, DateTime(2020, 9, 3));
      });

      test('複数のピルシートを持つPillSheetGroupで2枚目のピルシートを変更した場合', () {
        final firstPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final beforeSecondPillSheet = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 5),
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        // 2枚目の開始日を変更
        final afterSecondPillSheet = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 10, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforeSecondPillSheet,
          after: afterSecondPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetID, 'pill_sheet_id_2');
        expect(history.afterPillSheetID, 'pill_sheet_id_2');

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue!.beforeBeginingDate, DateTime(2020, 9, 29));
        expect(changedPillNumberValue.afterBeginingDate, DateTime(2020, 10, 1));
        expect(changedPillNumberValue.beforeGroupIndex, 1);
        expect(changedPillNumberValue.afterGroupIndex, 1);
      });

      test('beforeとafterで異なるPillSheet IDの場合（シート間での変更）', () {
        final firstPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final secondPillSheet = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
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
          pillSheetGroupID: 'group_id',
          before: firstPillSheet,
          after: secondPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetID, 'pill_sheet_id_1');
        expect(history.afterPillSheetID, 'pill_sheet_id_2');

        final changedPillNumberValue = history.value.changedPillNumber;
        expect(changedPillNumberValue, isNotNull);
        expect(changedPillNumberValue!.beforeGroupIndex, 0);
        expect(changedPillNumberValue.afterGroupIndex, 1);
      });
    });

    group('生成されるプロパティの検証', () {
      test('version は v2 が設定される', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.version, 'v2');
      });

      test('id は null が設定される（サーバー側で生成されるため）', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.id, isNull);
      });

      test('estimatedEventCausingDate と createdAt が設定される', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.estimatedEventCausingDate, isNotNull);
        expect(history.createdAt, isNotNull);
      });

      test('pillSheetID（deprecated）は null が設定される', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.pillSheetID, isNull);
      });
    });

    group('異常系', () {
      test('after.idがnullの場合、FormatExceptionがスローされる', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        // idがnull
        final afterPillSheet = PillSheet(
          id: null,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
            pillSheetGroupID: 'group_id',
            before: beforePillSheet,
            after: afterPillSheet,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('pillSheetGroupIDがnullの場合、例外がスローされる', () {
        // pillSheetGroupIDがnullの場合はassertで先に検証される（デバッグモード）
        // プロダクションモードではFormatExceptionがスローされる
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
            pillSheetGroupID: null,
            before: beforePillSheet,
            after: afterPillSheet,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
          ),
          throwsA(anything),
        );
      });

      test('after.idとpillSheetGroupIDの両方がnullの場合、例外がスローされる', () {
        // pillSheetGroupIDがnullの場合はassertで先に検証される（デバッグモード）
        // プロダクションモードではFormatExceptionがスローされる
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        // idがnull
        final afterPillSheet = PillSheet(
          id: null,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 3),
          lastTakenDate: DateTime(2020, 9, 10),
          createdAt: DateTime(2020, 9, 1),
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
            pillSheetGroupID: null,
            before: beforePillSheet,
            after: afterPillSheet,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
          ),
          throwsA(anything),
        );
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        // actionType の検証
        expect(history.actionType, PillSheetModifiedActionType.deletedPillSheet.name);
        expect(history.enumActionType, PillSheetModifiedActionType.deletedPillSheet);

        // pillSheetGroupID の検証
        expect(history.pillSheetGroupID, 'group_id');

        // before, after 関連のプロパティは全てnull
        expect(history.before, isNull);
        expect(history.after, isNull);
        expect(history.beforePillSheetID, isNull);
        expect(history.afterPillSheetID, isNull);

        // PillSheetGroup の検証
        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, updatedPillSheetGroup);

        // DeletedPillSheetValue の検証
        final deletedPillSheetValue = history.value.deletedPillSheet;
        expect(deletedPillSheetValue, isNotNull);
        expect(deletedPillSheetValue!.pillSheetIDs, ['pill_sheet_id_1']);
        // pillSheetDeletedAt は now() を使用しているため、null でないことを確認
        expect(deletedPillSheetValue.pillSheetDeletedAt, isNotNull);
      });

      test('pillSheetIDsが複数（2件）の場合', () {
        final pillSheet1 = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final pillSheet2 = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
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
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1', 'pill_sheet_id_2'],
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        final deletedPillSheetValue = history.value.deletedPillSheet;
        expect(deletedPillSheetValue, isNotNull);
        expect(deletedPillSheetValue!.pillSheetIDs, ['pill_sheet_id_1', 'pill_sheet_id_2']);
        expect(deletedPillSheetValue.pillSheetIDs.length, 2);
      });

      test('pillSheetIDsが複数（3件）の場合', () {
        final pillSheet1 = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final pillSheet2 = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 26),
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 1,
        );
        final pillSheet3 = PillSheet(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 10, 27),
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
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1', 'pill_sheet_id_2', 'pill_sheet_id_3'],
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        final deletedPillSheetValue = history.value.deletedPillSheet;
        expect(deletedPillSheetValue, isNotNull);
        expect(deletedPillSheetValue!.pillSheetIDs, ['pill_sheet_id_1', 'pill_sheet_id_2', 'pill_sheet_id_3']);
        expect(deletedPillSheetValue.pillSheetIDs.length, 3);
      });

      test('異なるPillSheetType（pillsheet_21_0）のピルシートを削除する場合', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.deletedPillSheet.name);
        expect(history.beforePillSheetGroup!.pillSheets[0].typeInfo.totalCount, 21);
        expect(history.value.deletedPillSheet!.pillSheetIDs, ['pill_sheet_id_1']);
      });

      test('異なるPillSheetType（pillsheet_28_4）のピルシートを削除する場合', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.deletedPillSheet.name);
        expect(history.beforePillSheetGroup!.pillSheets[0].typeInfo.totalCount, 28);
        expect(history.beforePillSheetGroup!.pillSheets[0].typeInfo.dosingPeriod, 24);
        expect(history.value.deletedPillSheet!.pillSheetIDs, ['pill_sheet_id_1']);
      });

      test('pillSheetIDsが空リストの場合も履歴は生成される', () {
        // 技術的には許容されるが、実際のユースケースでは発生しないはずのケース
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          pillSheetIDs: [],
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.deletedPillSheet.name);
        expect(history.value.deletedPillSheet!.pillSheetIDs, isEmpty);
      });

      test('beforePillSheetGroupとupdatedPillSheetGroupの差分が記録される', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
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
    });

    group('生成されるプロパティの検証', () {
      test('version は v2 が設定される', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.version, 'v2');
      });

      test('id は null が設定される（サーバー側で生成されるため）', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.id, isNull);
      });

      test('estimatedEventCausingDate と createdAt が設定される', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.estimatedEventCausingDate, isNotNull);
        expect(history.createdAt, isNotNull);
      });

      test('pillSheetID（deprecated）は null が設定される', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          beforePillSheetGroup: beforePillSheetGroup,
          updatedPillSheetGroup: updatedPillSheetGroup,
        );

        expect(history.pillSheetID, isNull);
      });

      test('ttlExpiresDateTime が limitDays 日後に設定される', () {
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.beganRestDuration.name);
      });

      test('beganRestDurationValue に restDuration が正しく設定されること', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.beganRestDurationValue, isNotNull);
        expect(history.value.beganRestDurationValue!.restDuration.id, restDuration.id);
        expect(history.value.beganRestDurationValue!.restDuration.beginDate, restDuration.beginDate);
        expect(history.value.beganRestDurationValue!.restDuration.createdDate, restDuration.createdDate);
      });

      test('before と after の PillSheet が正しく設定されること', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.before, beforePillSheet);
        expect(history.after, afterPillSheet);
        expect(history.beforePillSheetID, beforePillSheet.id);
        expect(history.afterPillSheetID, afterPillSheet.id);
      });

      test('beforePillSheetGroup と afterPillSheetGroup が正しく設定されること', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('pillSheetGroupID が正しく設定されること', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.pillSheetGroupID, 'group_id');
      });
    });

    group('複数ピルシートがある場合', () {
      test('2枚目のピルシートで休薬期間を開始した場合、正しく設定されること', () {
        final firstPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          groupIndex: 0,
          createdAt: DateTime(2020, 9, 1),
        );
        final beforeSecondPillSheet = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
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
          pillSheetGroupID: 'group_id',
          before: beforeSecondPillSheet,
          after: afterSecondPillSheet,
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.beganRestDuration.name);
        expect(history.before, beforeSecondPillSheet);
        expect(history.after, afterSecondPillSheet);
        expect(history.beforePillSheetID, beforeSecondPillSheet.id);
        expect(history.afterPillSheetID, afterSecondPillSheet.id);
      });
    });

    group('RestDuration のプロパティ', () {
      test('endDate が null の場合（休薬期間継続中）、正しく設定されること', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.beganRestDurationValue!.restDuration.endDate, isNull);
      });
    });

    group('メタデータの検証', () {
      test('estimatedEventCausingDate が正しく設定されること', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.estimatedEventCausingDate, isNotNull);
      });

      test('createdAt が正しく設定されること', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.createdAt, isNotNull);
      });

      test('ttlExpiresDateTime が limitDays 日後に設定されること', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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

    group('異常ケース', () {
      test('pillSheetGroupID が null の場合、例外が発生すること', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
            pillSheetGroupID: null,
            before: beforePillSheet,
            after: afterPillSheet,
            restDuration: restDuration,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('PillSheetType による違い', () {
      test('21錠タイプ（pillsheet_21）で休薬期間を開始した場合', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.beganRestDuration.name);
        expect(history.before!.typeInfo, PillSheetType.pillsheet_21.typeInfo);
        expect(history.after!.typeInfo, PillSheetType.pillsheet_21.typeInfo);
      });

      test('24錠タイプ（pillsheet_28_4）で休薬期間を開始した場合', () {
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: restDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.beganRestDuration.name);
        expect(history.before!.typeInfo, PillSheetType.pillsheet_28_4.typeInfo);
        expect(history.after!.typeInfo, PillSheetType.pillsheet_28_4.typeInfo);
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: newRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.beganRestDurationValue!.restDuration.id, newRestDuration.id);
        expect(history.before!.restDurations.length, 1);
        expect(history.after!.restDurations.length, 2);
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.before, beforePillSheet);
        expect(history.after, afterPillSheet);
        expect(history.beforePillSheetID, beforePillSheet.id);
        expect(history.afterPillSheetID, afterPillSheet.id);
      });

      test('beforePillSheetGroup と afterPillSheetGroup が正しく設定されること', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
      });

      test('pillSheetGroupID が正しく設定されること', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.pillSheetGroupID, 'group_id');
      });
    });

    group('複数ピルシートがある場合', () {
      test('2枚目のピルシートで休薬期間を終了した場合、正しく設定されること', () {
        final firstPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          groupIndex: 0,
          createdAt: DateTime(2020, 9, 1),
        );
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 10, 11),
          createdDate: DateTime(2020, 10, 11),
        );
        final beforeSecondPillSheet = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
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
          pillSheetGroupID: 'group_id',
          before: beforeSecondPillSheet,
          after: afterSecondPillSheet,
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.endedRestDuration.name);
        expect(history.before, beforeSecondPillSheet);
        expect(history.after, afterSecondPillSheet);
        expect(history.beforePillSheetID, beforeSecondPillSheet.id);
        expect(history.afterPillSheetID, afterSecondPillSheet.id);
      });
    });

    group('RestDuration のプロパティ', () {
      test('endDate が設定されている場合、正しく記録されること', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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

    group('異常ケース', () {
      test('pillSheetGroupID が null の場合、例外が発生すること', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
            pillSheetGroupID: null,
            before: beforePillSheet,
            after: afterPillSheet,
            restDuration: endedRestDuration,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('PillSheetType による違い', () {
      test('21錠タイプ（pillsheet_21）で休薬期間を終了した場合', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.endedRestDuration.name);
        expect(history.before!.typeInfo, PillSheetType.pillsheet_21.typeInfo);
        expect(history.after!.typeInfo, PillSheetType.pillsheet_21.typeInfo);
      });

      test('24錠タイプ（pillsheet_28_4）で休薬期間を終了した場合', () {
        final restDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.endedRestDuration.name);
        expect(history.before!.typeInfo, PillSheetType.pillsheet_28_4.typeInfo);
        expect(history.after!.typeInfo, PillSheetType.pillsheet_28_4.typeInfo);
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          restDuration: endedRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.endedRestDurationValue!.restDuration.id, endedRestDuration.id);
        expect(history.before!.restDurations.length, 2);
        expect(history.after!.restDurations.length, 2);
        expect(history.before!.restDurations[1].endDate, isNull);
        expect(history.after!.restDurations[1].endDate, DateTime(2020, 9, 14));
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.before, beforePillSheet);
        expect(history.after, afterPillSheet);
        expect(history.beforePillSheetID, beforePillSheet.id);
        expect(history.afterPillSheetID, afterPillSheet.id);
      });

      test('beforePillSheetGroup と afterPillSheetGroup が正しく設定されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.pillSheetGroupID, 'group_id');
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final firstPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
        final beforeSecondPillSheet = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
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
          pillSheetGroupID: 'group_id',
          before: beforeSecondPillSheet,
          after: afterSecondPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedRestDurationBeginDate.name);
        expect(history.before, beforeSecondPillSheet);
        expect(history.after, afterSecondPillSheet);
        expect(history.beforePillSheetID, beforeSecondPillSheet.id);
        expect(history.afterPillSheetID, afterSecondPillSheet.id);
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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

    group('異常ケース', () {
      test('pillSheetGroupID が null の場合、例外が発生すること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          beginDate: DateTime(2020, 9, 10),
        );
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
            pillSheetGroupID: null,
            before: beforePillSheet,
            after: afterPillSheet,
            beforeRestDuration: beforeRestDuration,
            afterRestDuration: afterRestDuration,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedRestDurationBeginDate.name);
        expect(history.before!.typeInfo, PillSheetType.pillsheet_21.typeInfo);
        expect(history.after!.typeInfo, PillSheetType.pillsheet_21.typeInfo);
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedRestDurationBeginDate.name);
        expect(history.before!.typeInfo, PillSheetType.pillsheet_28_4.typeInfo);
        expect(history.after!.typeInfo, PillSheetType.pillsheet_28_4.typeInfo);
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationBeginDateValue!.beforeRestDuration.id, beforeRestDuration.id);
        expect(history.value.changedRestDurationBeginDateValue!.afterRestDuration.id, afterRestDuration.id);
        expect(history.before!.restDurations.length, 2);
        expect(history.after!.restDurations.length, 2);
        expect(history.before!.restDurations[1].beginDate, DateTime(2020, 9, 11));
        expect(history.after!.restDurations[1].beginDate, DateTime(2020, 9, 10));
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.before, beforePillSheet);
        expect(history.after, afterPillSheet);
        expect(history.beforePillSheetID, beforePillSheet.id);
        expect(history.afterPillSheetID, afterPillSheet.id);
      });

      test('beforePillSheetGroup と afterPillSheetGroup が正しく設定されること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          endDate: DateTime(2020, 9, 14),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 9, 16),
        );
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.pillSheetGroupID, 'group_id');
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationValue!.beforeRestDuration.endDate, DateTime(2020, 9, 18));
        expect(history.value.changedRestDurationValue!.afterRestDuration.endDate, DateTime(2020, 9, 14));
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
        final firstPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final beforeSecondPillSheet = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
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
          pillSheetGroupID: 'group_id',
          before: beforeSecondPillSheet,
          after: afterSecondPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetID, 'pill_sheet_id_2');
        expect(history.afterPillSheetID, 'pill_sheet_id_2');
        expect(history.before!.groupIndex, 1);
        expect(history.after!.groupIndex, 1);
        expect(history.value.changedRestDurationValue!.beforeRestDuration.endDate, DateTime(2020, 10, 10));
        expect(history.value.changedRestDurationValue!.afterRestDuration.endDate, DateTime(2020, 10, 12));
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedRestDurationValue!.beforeRestDuration.id, beforeRestDuration.id);
        expect(history.value.changedRestDurationValue!.afterRestDuration.id, afterRestDuration.id);
        expect(history.before!.restDurations.length, 2);
        expect(history.after!.restDurations.length, 2);
        expect(history.before!.restDurations[1].endDate, DateTime(2020, 9, 18));
        expect(history.after!.restDurations[1].endDate, DateTime(2020, 9, 20));
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedRestDuration.name);
        expect(history.before!.typeInfo.totalCount, 21);
        expect(history.after!.typeInfo.totalCount, 21);
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
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_24_rest_4.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheet,
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, PillSheetModifiedActionType.changedRestDuration.name);
        expect(history.before!.typeInfo.totalCount, 28);
        expect(history.before!.typeInfo.dosingPeriod, 24);
        expect(history.after!.typeInfo.totalCount, 28);
        expect(history.after!.typeInfo.dosingPeriod, 24);
      });
    });

    group('異常ケース', () {
      test('pillSheetGroupID が null の場合に assertion エラーが発生すること', () {
        final beforeRestDuration = RestDuration(
          id: 'rest_duration_id_1',
          beginDate: DateTime(2020, 9, 11),
          endDate: DateTime(2020, 9, 14),
          createdDate: DateTime(2020, 9, 11),
        );
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime(2020, 9, 16),
        );
        final beforePillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 10),
          restDurations: [beforeRestDuration],
          createdAt: DateTime(2020, 9, 1),
        );
        final afterPillSheet = beforePillSheet.copyWith(
          restDurations: [afterRestDuration],
        );
        final beforePillSheetGroup = createPillSheetGroup(pillSheets: [beforePillSheet]);
        final afterPillSheetGroup = createPillSheetGroup(pillSheets: [afterPillSheet]);

        // pillSheetGroupID が null の場合、assert エラーが発生する
        // assert はデバッグモードでのみ有効なため、AssertionError をチェック
        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
            pillSheetGroupID: null,
            before: beforePillSheet,
            after: afterPillSheet,
            beforeRestDuration: beforeRestDuration,
            afterRestDuration: afterRestDuration,
            beforePillSheetGroup: beforePillSheetGroup,
            afterPillSheetGroup: afterPillSheetGroup,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedBeginDisplayNumber, isNotNull);
        expect(history.value.changedBeginDisplayNumber!.beforeDisplayNumberSetting?.beginPillNumber, 1);
        expect(history.value.changedBeginDisplayNumber!.beforeDisplayNumberSetting?.endPillNumber, 28);
        expect(history.value.changedBeginDisplayNumber!.afterDisplayNumberSetting.beginPillNumber, 10);
        expect(history.value.changedBeginDisplayNumber!.afterDisplayNumberSetting.endPillNumber, 28);
      });

      test('before と after の PillSheet が null であること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: null,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.before, isNull);
        expect(history.after, isNull);
        expect(history.beforePillSheetID, isNull);
        expect(history.afterPillSheetID, isNull);
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: null,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.pillSheetGroupID, 'group_id');
      });

      test('version が v2 であること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 5,
          endPillNumber: 28,
        );
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: null,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: null,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedBeginDisplayNumber!.beforeDisplayNumberSetting, isNull);
        expect(history.value.changedBeginDisplayNumber!.afterDisplayNumberSetting.beginPillNumber, 5);
        expect(history.value.changedBeginDisplayNumber!.afterDisplayNumberSetting.endPillNumber, 28);
      });

      test('beginPillNumber のみを設定した場合に正しく記録されること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 10,
        );
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: null,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedBeginDisplayNumber!.beforeDisplayNumberSetting, isNull);
        expect(history.value.changedBeginDisplayNumber!.afterDisplayNumberSetting.beginPillNumber, 10);
        expect(history.value.changedBeginDisplayNumber!.afterDisplayNumberSetting.endPillNumber, isNull);
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedBeginDisplayNumber!.beforeDisplayNumberSetting!.beginPillNumber, 1);
        expect(history.value.changedBeginDisplayNumber!.afterDisplayNumberSetting.beginPillNumber, 5);
        // endPillNumber は変わっていない
        expect(history.value.changedBeginDisplayNumber!.beforeDisplayNumberSetting!.endPillNumber, 28);
        expect(history.value.changedBeginDisplayNumber!.afterDisplayNumberSetting.endPillNumber, 28);
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedBeginDisplayNumber!.beforeDisplayNumberSetting!.beginPillNumber, 1);
        expect(history.value.changedBeginDisplayNumber!.afterDisplayNumberSetting.beginPillNumber, 85);
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
        final firstPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final secondPillSheet = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final thirdPillSheet = PillSheet(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 10, 27),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetGroup!.pillSheets.length, 3);
        expect(history.afterPillSheetGroup!.pillSheets.length, 3);
        expect(history.value.changedBeginDisplayNumber!.beforeDisplayNumberSetting!.beginPillNumber, 1);
        expect(history.value.changedBeginDisplayNumber!.afterDisplayNumberSetting.beginPillNumber, 29);
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_24_rest_4.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: null,
          beforeDisplayNumberSetting: null,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.pillSheetGroupID, isNull);
        expect(history.actionType, PillSheetModifiedActionType.changedBeginDisplayNumber.name);
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedEndDisplayNumber, isNotNull);
        expect(history.value.changedEndDisplayNumber!.beforeDisplayNumberSetting?.beginPillNumber, 1);
        expect(history.value.changedEndDisplayNumber!.beforeDisplayNumberSetting?.endPillNumber, 28);
        expect(history.value.changedEndDisplayNumber!.afterDisplayNumberSetting.beginPillNumber, 1);
        expect(history.value.changedEndDisplayNumber!.afterDisplayNumberSetting.endPillNumber, 84);
      });

      test('before と after の PillSheet が null であること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: null,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.before, isNull);
        expect(history.after, isNull);
        expect(history.beforePillSheetID, isNull);
        expect(history.afterPillSheetID, isNull);
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: null,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.pillSheetGroupID, 'group_id');
      });

      test('version が v2 であること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 56,
        );
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: null,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: null,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedEndDisplayNumber!.beforeDisplayNumberSetting, isNull);
        expect(history.value.changedEndDisplayNumber!.afterDisplayNumberSetting.beginPillNumber, 1);
        expect(history.value.changedEndDisplayNumber!.afterDisplayNumberSetting.endPillNumber, 56);
      });

      test('endPillNumber のみを設定した場合に正しく記録されること', () {
        final afterDisplayNumberSetting = const PillSheetGroupDisplayNumberSetting(
          endPillNumber: 84,
        );
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: null,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedEndDisplayNumber!.beforeDisplayNumberSetting, isNull);
        expect(history.value.changedEndDisplayNumber!.afterDisplayNumberSetting.beginPillNumber, isNull);
        expect(history.value.changedEndDisplayNumber!.afterDisplayNumberSetting.endPillNumber, 84);
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedEndDisplayNumber!.beforeDisplayNumberSetting!.endPillNumber, 28);
        expect(history.value.changedEndDisplayNumber!.afterDisplayNumberSetting.endPillNumber, 56);
        // beginPillNumber は変わっていない
        expect(history.value.changedEndDisplayNumber!.beforeDisplayNumberSetting!.beginPillNumber, 1);
        expect(history.value.changedEndDisplayNumber!.afterDisplayNumberSetting.beginPillNumber, 1);
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedEndDisplayNumber!.beforeDisplayNumberSetting!.endPillNumber, 28);
        expect(history.value.changedEndDisplayNumber!.afterDisplayNumberSetting.endPillNumber, 120);
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.changedEndDisplayNumber!.beforeDisplayNumberSetting!.endPillNumber, 84);
        expect(history.value.changedEndDisplayNumber!.afterDisplayNumberSetting.endPillNumber, 28);
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
        final firstPillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          restDurations: [],
          createdAt: DateTime(2020, 9, 1),
          groupIndex: 0,
        );
        final secondPillSheet = PillSheet(
          id: 'pill_sheet_id_2',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 29),
          lastTakenDate: DateTime(2020, 10, 10),
          restDurations: [],
          createdAt: DateTime(2020, 9, 29),
          groupIndex: 1,
        );
        final thirdPillSheet = PillSheet(
          id: 'pill_sheet_id_3',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 10, 27),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetGroup!.pillSheets.length, 3);
        expect(history.afterPillSheetGroup!.pillSheets.length, 3);
        expect(history.value.changedEndDisplayNumber!.beforeDisplayNumberSetting!.endPillNumber, 84);
        expect(history.value.changedEndDisplayNumber!.afterDisplayNumberSetting.endPillNumber, 120);
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_24_rest_4.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: 'group_id',
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
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
        final pillSheet = PillSheet(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: DateTime(2020, 9, 1),
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
          pillSheetGroupID: null,
          beforeDisplayNumberSetting: null,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.pillSheetGroupID, isNull);
        expect(history.actionType, PillSheetModifiedActionType.changedEndDisplayNumber.name);
      });
    });
  });

  group('#afterActivePillSheet', () {
    late MockTodayService mockTodayService;

    setUp(() {
      mockTodayService = MockTodayService();
      todayRepository = mockTodayService;
    });

    tearDown(() {
      todayRepository = TodayService();
    });

    group('afterPillSheetGroupがnullの場合', () {
      test('nullを返す', () {
        final history = PillSheetModifiedHistory(
          id: 'test_id',
          actionType: PillSheetModifiedActionType.createdPillSheet.name,
          estimatedEventCausingDate: DateTime(2020, 9, 1),
          createdAt: DateTime(2020, 9, 1),
          value: const PillSheetModifiedHistoryValue(),
          beforePillSheetGroup: null,
          afterPillSheetGroup: null,
          pillSheetID: null,
          pillSheetGroupID: null,
          beforePillSheetID: null,
          afterPillSheetID: null,
          before: null,
          after: null,
        );

        expect(history.afterActivePillSheet, isNull);
      });
    });

    group('afterPillSheetGroupが存在する場合', () {
      group('PillSheetType.pillsheet_21の場合', () {
        test('now()がピルシートの有効期間内の場合、そのピルシートを返す', () {
          when(mockTodayService.now()).thenReturn(DateTime(2020, 9, 10));

          final pillSheet = PillSheet(
            id: 'pill_sheet_id',
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2020, 9, 1),
            lastTakenDate: DateTime(2020, 9, 10),
            restDurations: [],
            createdAt: DateTime(2020, 9, 1),
          );
          final afterPillSheetGroup = PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id'],
            pillSheets: [pillSheet],
            createdAt: DateTime(2020, 9, 1),
          );

          final history = PillSheetModifiedHistory(
            id: 'test_id',
            actionType: PillSheetModifiedActionType.takenPill.name,
            estimatedEventCausingDate: DateTime(2020, 9, 10),
            createdAt: DateTime(2020, 9, 10),
            value: const PillSheetModifiedHistoryValue(),
            beforePillSheetGroup: null,
            afterPillSheetGroup: afterPillSheetGroup,
            pillSheetID: null,
            pillSheetGroupID: 'group_id',
            beforePillSheetID: null,
            afterPillSheetID: 'pill_sheet_id',
            before: null,
            after: null,
          );

          expect(history.afterActivePillSheet, pillSheet);
        });

        test('now()がピルシートの開始日の場合、そのピルシートを返す（境界値）', () {
          when(mockTodayService.now()).thenReturn(DateTime(2020, 9, 1));

          final pillSheet = PillSheet(
            id: 'pill_sheet_id',
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2020, 9, 1),
            lastTakenDate: null,
            restDurations: [],
            createdAt: DateTime(2020, 9, 1),
          );
          final afterPillSheetGroup = PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id'],
            pillSheets: [pillSheet],
            createdAt: DateTime(2020, 9, 1),
          );

          final history = PillSheetModifiedHistory(
            id: 'test_id',
            actionType: PillSheetModifiedActionType.createdPillSheet.name,
            estimatedEventCausingDate: DateTime(2020, 9, 1),
            createdAt: DateTime(2020, 9, 1),
            value: const PillSheetModifiedHistoryValue(),
            beforePillSheetGroup: null,
            afterPillSheetGroup: afterPillSheetGroup,
            pillSheetID: null,
            pillSheetGroupID: 'group_id',
            beforePillSheetID: null,
            afterPillSheetID: 'pill_sheet_id',
            before: null,
            after: null,
          );

          expect(history.afterActivePillSheet, pillSheet);
        });

        test('now()がピルシートの最終日の場合、そのピルシートを返す（境界値）', () {
          // 21日タイプのピルシートの最終日は開始日から20日後
          when(mockTodayService.now()).thenReturn(DateTime(2020, 9, 21));

          final pillSheet = PillSheet(
            id: 'pill_sheet_id',
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2020, 9, 1),
            lastTakenDate: DateTime(2020, 9, 21),
            restDurations: [],
            createdAt: DateTime(2020, 9, 1),
          );
          final afterPillSheetGroup = PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id'],
            pillSheets: [pillSheet],
            createdAt: DateTime(2020, 9, 1),
          );

          final history = PillSheetModifiedHistory(
            id: 'test_id',
            actionType: PillSheetModifiedActionType.takenPill.name,
            estimatedEventCausingDate: DateTime(2020, 9, 21),
            createdAt: DateTime(2020, 9, 21),
            value: const PillSheetModifiedHistoryValue(),
            beforePillSheetGroup: null,
            afterPillSheetGroup: afterPillSheetGroup,
            pillSheetID: null,
            pillSheetGroupID: 'group_id',
            beforePillSheetID: null,
            afterPillSheetID: 'pill_sheet_id',
            before: null,
            after: null,
          );

          expect(history.afterActivePillSheet, pillSheet);
        });

        test('now()がピルシートの有効期間外（終了後）の場合、nullを返す', () {
          // pillsheet_21のtotalCountは28なので、9/1から始まると9/28まで有効、9/29で終了後
          when(mockTodayService.now()).thenReturn(DateTime(2020, 9, 29));

          final pillSheet = PillSheet(
            id: 'pill_sheet_id',
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2020, 9, 1),
            lastTakenDate: DateTime(2020, 9, 21),
            restDurations: [],
            createdAt: DateTime(2020, 9, 1),
          );
          final afterPillSheetGroup = PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id'],
            pillSheets: [pillSheet],
            createdAt: DateTime(2020, 9, 1),
          );

          final history = PillSheetModifiedHistory(
            id: 'test_id',
            actionType: PillSheetModifiedActionType.takenPill.name,
            estimatedEventCausingDate: DateTime(2020, 9, 21),
            createdAt: DateTime(2020, 9, 21),
            value: const PillSheetModifiedHistoryValue(),
            beforePillSheetGroup: null,
            afterPillSheetGroup: afterPillSheetGroup,
            pillSheetID: null,
            pillSheetGroupID: 'group_id',
            beforePillSheetID: null,
            afterPillSheetID: 'pill_sheet_id',
            before: null,
            after: null,
          );

          expect(history.afterActivePillSheet, isNull);
        });

        test('now()がピルシートの有効期間外（開始前）の場合、nullを返す', () {
          when(mockTodayService.now()).thenReturn(DateTime(2020, 8, 31));

          final pillSheet = PillSheet(
            id: 'pill_sheet_id',
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2020, 9, 1),
            lastTakenDate: null,
            restDurations: [],
            createdAt: DateTime(2020, 9, 1),
          );
          final afterPillSheetGroup = PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id'],
            pillSheets: [pillSheet],
            createdAt: DateTime(2020, 9, 1),
          );

          final history = PillSheetModifiedHistory(
            id: 'test_id',
            actionType: PillSheetModifiedActionType.createdPillSheet.name,
            estimatedEventCausingDate: DateTime(2020, 9, 1),
            createdAt: DateTime(2020, 9, 1),
            value: const PillSheetModifiedHistoryValue(),
            beforePillSheetGroup: null,
            afterPillSheetGroup: afterPillSheetGroup,
            pillSheetID: null,
            pillSheetGroupID: 'group_id',
            beforePillSheetID: null,
            afterPillSheetID: 'pill_sheet_id',
            before: null,
            after: null,
          );

          expect(history.afterActivePillSheet, isNull);
        });
      });

      group('PillSheetType.pillsheet_28_4の場合', () {
        test('now()がピルシートの有効期間内の場合、そのピルシートを返す', () {
          when(mockTodayService.now()).thenReturn(DateTime(2020, 9, 15));

          final pillSheet = PillSheet(
            id: 'pill_sheet_id',
            typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
            beginingDate: DateTime(2020, 9, 1),
            lastTakenDate: DateTime(2020, 9, 15),
            restDurations: [],
            createdAt: DateTime(2020, 9, 1),
          );
          final afterPillSheetGroup = PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id'],
            pillSheets: [pillSheet],
            createdAt: DateTime(2020, 9, 1),
          );

          final history = PillSheetModifiedHistory(
            id: 'test_id',
            actionType: PillSheetModifiedActionType.takenPill.name,
            estimatedEventCausingDate: DateTime(2020, 9, 15),
            createdAt: DateTime(2020, 9, 15),
            value: const PillSheetModifiedHistoryValue(),
            beforePillSheetGroup: null,
            afterPillSheetGroup: afterPillSheetGroup,
            pillSheetID: null,
            pillSheetGroupID: 'group_id',
            beforePillSheetID: null,
            afterPillSheetID: 'pill_sheet_id',
            before: null,
            after: null,
          );

          expect(history.afterActivePillSheet, pillSheet);
        });

        test('now()がピルシートの最終日（28日目）の場合、そのピルシートを返す（境界値）', () {
          when(mockTodayService.now()).thenReturn(DateTime(2020, 9, 28));

          final pillSheet = PillSheet(
            id: 'pill_sheet_id',
            typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
            beginingDate: DateTime(2020, 9, 1),
            lastTakenDate: DateTime(2020, 9, 28),
            restDurations: [],
            createdAt: DateTime(2020, 9, 1),
          );
          final afterPillSheetGroup = PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id'],
            pillSheets: [pillSheet],
            createdAt: DateTime(2020, 9, 1),
          );

          final history = PillSheetModifiedHistory(
            id: 'test_id',
            actionType: PillSheetModifiedActionType.takenPill.name,
            estimatedEventCausingDate: DateTime(2020, 9, 28),
            createdAt: DateTime(2020, 9, 28),
            value: const PillSheetModifiedHistoryValue(),
            beforePillSheetGroup: null,
            afterPillSheetGroup: afterPillSheetGroup,
            pillSheetID: null,
            pillSheetGroupID: 'group_id',
            beforePillSheetID: null,
            afterPillSheetID: 'pill_sheet_id',
            before: null,
            after: null,
          );

          expect(history.afterActivePillSheet, pillSheet);
        });

        test('now()がピルシートの有効期間外（29日目）の場合、nullを返す', () {
          when(mockTodayService.now()).thenReturn(DateTime(2020, 9, 29));

          final pillSheet = PillSheet(
            id: 'pill_sheet_id',
            typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
            beginingDate: DateTime(2020, 9, 1),
            lastTakenDate: DateTime(2020, 9, 28),
            restDurations: [],
            createdAt: DateTime(2020, 9, 1),
          );
          final afterPillSheetGroup = PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id'],
            pillSheets: [pillSheet],
            createdAt: DateTime(2020, 9, 1),
          );

          final history = PillSheetModifiedHistory(
            id: 'test_id',
            actionType: PillSheetModifiedActionType.takenPill.name,
            estimatedEventCausingDate: DateTime(2020, 9, 28),
            createdAt: DateTime(2020, 9, 28),
            value: const PillSheetModifiedHistoryValue(),
            beforePillSheetGroup: null,
            afterPillSheetGroup: afterPillSheetGroup,
            pillSheetID: null,
            pillSheetGroupID: 'group_id',
            beforePillSheetID: null,
            afterPillSheetID: 'pill_sheet_id',
            before: null,
            after: null,
          );

          expect(history.afterActivePillSheet, isNull);
        });
      });

      group('複数のピルシートがある場合', () {
        test('now()が1枚目のピルシートの最終日の場合、1枚目を返す（境界値）', () {
          // pillsheet_21のtotalCountは28なので、9/1から始まると9/28が最終日
          when(mockTodayService.now()).thenReturn(DateTime(2020, 9, 28));

          final pillSheet1 = PillSheet(
            id: 'pill_sheet_id_1',
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2020, 9, 1),
            lastTakenDate: DateTime(2020, 9, 21),
            restDurations: [],
            createdAt: DateTime(2020, 9, 1),
          );
          final pillSheet2 = PillSheet(
            id: 'pill_sheet_id_2',
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2020, 9, 29),
            lastTakenDate: null,
            restDurations: [],
            createdAt: DateTime(2020, 9, 29),
          );
          final afterPillSheetGroup = PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id_1', 'pill_sheet_id_2'],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: DateTime(2020, 9, 1),
          );

          final history = PillSheetModifiedHistory(
            id: 'test_id',
            actionType: PillSheetModifiedActionType.takenPill.name,
            estimatedEventCausingDate: DateTime(2020, 9, 28),
            createdAt: DateTime(2020, 9, 28),
            value: const PillSheetModifiedHistoryValue(),
            beforePillSheetGroup: null,
            afterPillSheetGroup: afterPillSheetGroup,
            pillSheetID: null,
            pillSheetGroupID: 'group_id',
            beforePillSheetID: null,
            afterPillSheetID: 'pill_sheet_id_1',
            before: null,
            after: null,
          );

          expect(history.afterActivePillSheet, pillSheet1);
        });

        test('now()が2枚目のピルシートの開始日の場合、2枚目を返す（境界値）', () {
          // 1枚目が9/28で終了、2枚目が9/29から開始
          when(mockTodayService.now()).thenReturn(DateTime(2020, 9, 29));

          final pillSheet1 = PillSheet(
            id: 'pill_sheet_id_1',
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2020, 9, 1),
            lastTakenDate: DateTime(2020, 9, 21),
            restDurations: [],
            createdAt: DateTime(2020, 9, 1),
          );
          final pillSheet2 = PillSheet(
            id: 'pill_sheet_id_2',
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2020, 9, 29),
            lastTakenDate: null,
            restDurations: [],
            createdAt: DateTime(2020, 9, 29),
          );
          final afterPillSheetGroup = PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id_1', 'pill_sheet_id_2'],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: DateTime(2020, 9, 1),
          );

          final history = PillSheetModifiedHistory(
            id: 'test_id',
            actionType: PillSheetModifiedActionType.createdPillSheet.name,
            estimatedEventCausingDate: DateTime(2020, 9, 29),
            createdAt: DateTime(2020, 9, 29),
            value: const PillSheetModifiedHistoryValue(),
            beforePillSheetGroup: null,
            afterPillSheetGroup: afterPillSheetGroup,
            pillSheetID: null,
            pillSheetGroupID: 'group_id',
            beforePillSheetID: null,
            afterPillSheetID: 'pill_sheet_id_2',
            before: null,
            after: null,
          );

          expect(history.afterActivePillSheet, pillSheet2);
        });
      });

      group('RestDurationがある場合', () {
        test('休薬期間分だけ有効期間が延長される', () {
          // pillsheet_21のtotalCountは28なので:
          // 開始日9/1 + 27日 = 9/28
          // 休薬期間9/10〜9/12はdaysBetween(9/10, 9/12) = 2日
          // 最終日: 9/28 + 2 = 9/30
          when(mockTodayService.now()).thenReturn(DateTime(2020, 9, 30));

          final pillSheet = PillSheet(
            id: 'pill_sheet_id',
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2020, 9, 1),
            lastTakenDate: DateTime(2020, 9, 21),
            restDurations: [
              RestDuration(
                id: 'rest_duration_id',
                beginDate: DateTime(2020, 9, 10),
                endDate: DateTime(2020, 9, 12),
                createdDate: DateTime(2020, 9, 10),
              ),
            ],
            createdAt: DateTime(2020, 9, 1),
          );
          final afterPillSheetGroup = PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id'],
            pillSheets: [pillSheet],
            createdAt: DateTime(2020, 9, 1),
          );

          final history = PillSheetModifiedHistory(
            id: 'test_id',
            actionType: PillSheetModifiedActionType.takenPill.name,
            estimatedEventCausingDate: DateTime(2020, 9, 21),
            createdAt: DateTime(2020, 9, 21),
            value: const PillSheetModifiedHistoryValue(),
            beforePillSheetGroup: null,
            afterPillSheetGroup: afterPillSheetGroup,
            pillSheetID: null,
            pillSheetGroupID: 'group_id',
            beforePillSheetID: null,
            afterPillSheetID: 'pill_sheet_id',
            before: null,
            after: null,
          );

          expect(history.afterActivePillSheet, pillSheet);
        });

        test('休薬期間分だけ延長された有効期間の翌日はnullを返す', () {
          // pillsheet_21のtotalCountは28なので:
          // 開始日9/1 + 27日 = 9/28
          // 休薬期間9/10〜9/12はdaysBetween(9/10, 9/12) = 2日
          // 最終日: 9/28 + 2 = 9/30、翌日: 10/1
          when(mockTodayService.now()).thenReturn(DateTime(2020, 10, 1));

          final pillSheet = PillSheet(
            id: 'pill_sheet_id',
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2020, 9, 1),
            lastTakenDate: DateTime(2020, 9, 21),
            restDurations: [
              RestDuration(
                id: 'rest_duration_id',
                beginDate: DateTime(2020, 9, 10),
                endDate: DateTime(2020, 9, 12),
                createdDate: DateTime(2020, 9, 10),
              ),
            ],
            createdAt: DateTime(2020, 9, 1),
          );
          final afterPillSheetGroup = PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id'],
            pillSheets: [pillSheet],
            createdAt: DateTime(2020, 9, 1),
          );

          final history = PillSheetModifiedHistory(
            id: 'test_id',
            actionType: PillSheetModifiedActionType.takenPill.name,
            estimatedEventCausingDate: DateTime(2020, 9, 21),
            createdAt: DateTime(2020, 9, 21),
            value: const PillSheetModifiedHistoryValue(),
            beforePillSheetGroup: null,
            afterPillSheetGroup: afterPillSheetGroup,
            pillSheetID: null,
            pillSheetGroupID: 'group_id',
            beforePillSheetID: null,
            afterPillSheetID: 'pill_sheet_id',
            before: null,
            after: null,
          );

          expect(history.afterActivePillSheet, isNull);
        });
      });
    });
  });
}
