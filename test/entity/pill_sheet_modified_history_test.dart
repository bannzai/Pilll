import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';

void main() {
  group('#enumActionType', () {
    // 各 PillSheetModifiedActionType に対して正しく変換されるかテスト
    for (final actionType in PillSheetModifiedActionType.values) {
      test('actionType が ${actionType.name} の場合は $actionType を返す', () {
        final history = PillSheetModifiedHistory(
          id: 'test_id',
          actionType: actionType.name,
          estimatedEventCausingDate: DateTime.parse('2020-09-28'),
          createdAt: DateTime.parse('2020-09-28'),
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

        // switch で網羅性を担保
        switch (actionType) {
          case PillSheetModifiedActionType.createdPillSheet:
            expect(history.enumActionType, PillSheetModifiedActionType.createdPillSheet);
          case PillSheetModifiedActionType.automaticallyRecordedLastTakenDate:
            expect(history.enumActionType, PillSheetModifiedActionType.automaticallyRecordedLastTakenDate);
          case PillSheetModifiedActionType.deletedPillSheet:
            expect(history.enumActionType, PillSheetModifiedActionType.deletedPillSheet);
          case PillSheetModifiedActionType.takenPill:
            expect(history.enumActionType, PillSheetModifiedActionType.takenPill);
          case PillSheetModifiedActionType.revertTakenPill:
            expect(history.enumActionType, PillSheetModifiedActionType.revertTakenPill);
          case PillSheetModifiedActionType.changedPillNumber:
            expect(history.enumActionType, PillSheetModifiedActionType.changedPillNumber);
          case PillSheetModifiedActionType.endedPillSheet:
            expect(history.enumActionType, PillSheetModifiedActionType.endedPillSheet);
          case PillSheetModifiedActionType.beganRestDuration:
            expect(history.enumActionType, PillSheetModifiedActionType.beganRestDuration);
          case PillSheetModifiedActionType.endedRestDuration:
            expect(history.enumActionType, PillSheetModifiedActionType.endedRestDuration);
          case PillSheetModifiedActionType.changedRestDurationBeginDate:
            expect(history.enumActionType, PillSheetModifiedActionType.changedRestDurationBeginDate);
          case PillSheetModifiedActionType.changedRestDuration:
            expect(history.enumActionType, PillSheetModifiedActionType.changedRestDuration);
          case PillSheetModifiedActionType.changedBeginDisplayNumber:
            expect(history.enumActionType, PillSheetModifiedActionType.changedBeginDisplayNumber);
          case PillSheetModifiedActionType.changedEndDisplayNumber:
            expect(history.enumActionType, PillSheetModifiedActionType.changedEndDisplayNumber);
        }
      });
    }

    test('actionType が存在しない文字列の場合は null を返す', () {
      final history = PillSheetModifiedHistory(
        id: 'test_id',
        actionType: 'unknownActionType',
        estimatedEventCausingDate: DateTime.parse('2020-09-28'),
        createdAt: DateTime.parse('2020-09-28'),
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

      expect(history.enumActionType, isNull);
    });

    test('actionType が空文字の場合は null を返す', () {
      final history = PillSheetModifiedHistory(
        id: 'test_id',
        actionType: '',
        estimatedEventCausingDate: DateTime.parse('2020-09-28'),
        createdAt: DateTime.parse('2020-09-28'),
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

      expect(history.enumActionType, isNull);
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
  });
}
