import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

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

    test("履歴が降順で渡された場合でも正しくソートされて処理される", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      // 降順（新しいものから古いもの）で履歴を作成
      final histories = [
        PillSheetModifiedHistory(
          id: 'history_3',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 1)),
          createdAt: baseDate.subtract(const Duration(days: 1)),
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
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 5日前から今日までの5日間のうち、3日分の服用記録があるので2日の飲み忘れ
      expect(result, 2);
    });

    test("時刻が23:59:59と00:00:00で日付が正しく区別される", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        // 3日前の23:59:59に服用
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 3)).add(const Duration(hours: 23, minutes: 59, seconds: 59)),
          createdAt: baseDate.subtract(const Duration(days: 3)).add(const Duration(hours: 23, minutes: 59, seconds: 59)),
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
        // 2日前の00:00:00に服用
        PillSheetModifiedHistory(
          id: 'history_2',
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
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 3日前から今日までの3日間のうち、2日分の服用記録（3日前と2日前）があるので1日の飲み忘れ
      expect(result, 1);
    });

    test("服用お休み開始と終了が同じ日の場合は0日間としてカウント", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        // 3日前に服用
        PillSheetModifiedHistory(
          id: 'history_1',
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
        // 2日前に服用お休み開始と終了（同日）
        PillSheetModifiedHistory(
          id: 'history_2',
          actionType: PillSheetModifiedActionType.beganRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 2)).add(const Duration(hours: 8)),
          createdAt: baseDate.subtract(const Duration(days: 2)).add(const Duration(hours: 8)),
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
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 2)).add(const Duration(hours: 18)),
          createdAt: baseDate.subtract(const Duration(days: 2)).add(const Duration(hours: 18)),
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

      // 3日前から今日までの3日間のうち、1日分の服用記録（3日前）があり
      // 同日開始・終了のお休み期間は0日としてカウント
      // 結果：2日の飲み忘れ
      expect(result, 2);
    });

    test("revertTakenPillアクションタイプは服用記録としてカウントされない", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        // 3日前に服用
        PillSheetModifiedHistory(
          id: 'history_1',
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
        // 2日前にrevertTakenPill
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

      // 3日前から今日までの3日間のうち、1日分の服用記録（3日前）のみ
      // revertTakenPillは服用記録としてカウントされないので2日の飲み忘れ
      expect(result, 2);
    });

    test("createdPillSheetやdeletedPillSheetアクションタイプは服用記録としてカウントされない", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        // 5日前にピルシート作成
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.createdPillSheet.name,
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
        // 3日前に服用
        PillSheetModifiedHistory(
          id: 'history_2',
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
        // 1日前にピルシート削除
        PillSheetModifiedHistory(
          id: 'history_3',
          actionType: PillSheetModifiedActionType.deletedPillSheet.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 1)),
          createdAt: baseDate.subtract(const Duration(days: 1)),
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

      // 5日前から今日までの5日間のうち、1日分の服用記録（3日前）のみ
      // createdPillSheet, deletedPillSheetは服用記録としてカウントされないので4日の飲み忘れ
      expect(result, 4);
    });

    test("minDateとmaxDateが同じ日で服用記録がある場合は0日", () {
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

      // minDateとmaxDateが同じ日で服用記録があるので0日
      expect(result, 0);
    });

    test("minDateとmaxDateが同じ日で服用記録がない場合（他のアクションタイプのみ）は0日", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.changedPillNumber.name,
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

      // minDateとmaxDateが同じ日だが、changedPillNumberは服用記録ではないので
      // daysBetweenが0になり、allDatesも空になるため結果は0日
      expect(result, 0);
    });

    test("服用記録とお休み開始が同じ日の場合は服用記録がカウントされる", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      final histories = [
        // 5日前に服用し、同日にお休み開始
        PillSheetModifiedHistory(
          id: 'history_1',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 5)).add(const Duration(hours: 8)),
          createdAt: baseDate.subtract(const Duration(days: 5)).add(const Duration(hours: 8)),
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
          actionType: PillSheetModifiedActionType.beganRestDuration.name,
          estimatedEventCausingDate: baseDate.subtract(const Duration(days: 5)).add(const Duration(hours: 20)),
          createdAt: baseDate.subtract(const Duration(days: 5)).add(const Duration(hours: 20)),
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
        // 2日前にお休み終了
        PillSheetModifiedHistory(
          id: 'history_3',
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
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 5日前から今日までの5日間のうち：
      // - 服用記録: 1日（5日前）
      // - 服用お休み: 3日間（5日前〜2日前まで）※5日前はお休み開始日でもあるが既に服用記録がある
      // - 飲み忘れ: 2日間（1日前、今日）
      // 注: お休み期間は5日前〜2日前の3日間だが、allDatesから除外される日数は3日
      // 実際の計算: allDates(5日分) - takenDates(1日) - restDurationDates(3日) = 1日
      // しかし、5日前は服用記録があるのでrestDurationDatesから除外される可能性あり
      // ロジックを確認すると、restDurationDatesは5日前、4日前、3日前の3日間
      // allDatesは5日前〜今日の5日間（daysBetween(minDate, maxDate) = 5）
      // takenDatesは5日前の1日
      // 5 - 1 - 3 = 1? いや違う。Set.differenceの計算方法を考える。
      // allDates = {5日前, 4日前, 3日前, 2日前, 1日前} (今日は含まれない。daysBetweenの挙動確認)
      // takenDates = {5日前}
      // restDurationDates = {5日前, 4日前, 3日前}
      // allDates.difference(takenDates) = {4日前, 3日前, 2日前, 1日前}
      // {4日前, 3日前, 2日前, 1日前}.difference(restDurationDates) = {2日前, 1日前}
      // 結果: 2日間の飲み忘れ
      expect(result, 2);
    });

    test("changedPillNumber, endedPillSheet, changedRestDurationBeginDate等のアクションタイプは服用記録としてカウントされない", () {
      final today = DateTime.parse("2020-09-28");
      final baseDate = DateTime(today.year, today.month, today.day);

      // takenPill または automaticallyRecordedLastTakenDate 以外のアクションタイプのみ
      final actionTypesToTest = [
        PillSheetModifiedActionType.changedPillNumber,
        PillSheetModifiedActionType.endedPillSheet,
        PillSheetModifiedActionType.changedRestDurationBeginDate,
        PillSheetModifiedActionType.changedRestDuration,
        PillSheetModifiedActionType.changedBeginDisplayNumber,
        PillSheetModifiedActionType.changedEndDisplayNumber,
      ];

      for (final actionType in actionTypesToTest) {
        final histories = [
          // 3日前に服用
          PillSheetModifiedHistory(
            id: 'history_1',
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
          // 2日前に対象のアクションタイプ
          PillSheetModifiedHistory(
            id: 'history_2',
            actionType: actionType.name,
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

        // 3日前から今日までの3日間のうち、1日分の服用記録（3日前）のみ
        // actionTypeは服用記録としてカウントされないので2日の飲み忘れ
        expect(result, 2, reason: '${actionType.name}は服用記録としてカウントされるべきではない');
      }
    });

    test("お休み期間中に別のアクションが発生しても正しく処理される", () {
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
        // 9日前にお休み開始
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
        // 7日前にchangedPillNumber（お休み中）
        PillSheetModifiedHistory(
          id: 'history_3',
          actionType: PillSheetModifiedActionType.changedPillNumber.name,
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
        // 5日前にお休み終了
        PillSheetModifiedHistory(
          id: 'history_4',
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
      ];

      final result = missedPillDays(
        histories: histories,
        maxDate: today,
      );

      // 10日前から今日までの10日間のうち：
      // - 服用記録: 1日（10日前）
      // - 服用お休み: 9日前〜7日前の2日間（changedPillNumberが来た時点で中断される）
      //   実際の挙動：beganRestDuration後、changedPillNumberが来た時点で9日前〜7日前（daysBetween=2）の
      //   2日間（9日前、8日前）をお休みとして処理し、historyBeginRestDurationDateがnullになる
      //   その後のendedRestDurationはbeganRestDurationがないため無視される
      // - 飲み忘れ: 7日間（7日前〜1日前）
      // allDates = {10日前, 9日前, 8日前, 7日前, 6日前, 5日前, 4日前, 3日前, 2日前, 1日前}
      // takenDates = {10日前}
      // restDurationDates = {9日前, 8日前}
      // allDates - takenDates - restDurationDates = 10 - 1 - 2 = 7
      expect(result, 7);
    });
  });

  group('#createTakenPillAction', () {
    // テスト用ヘルパー: PillSheetを生成する
    PillSheet createPillSheet({
      required String id,
      required PillSheetType type,
      required DateTime beginingDate,
      DateTime? lastTakenDate,
      int groupIndex = 0,
    }) {
      return PillSheet(
        id: id,
        typeInfo: type.typeInfo,
        beginingDate: beginingDate,
        lastTakenDate: lastTakenDate,
        createdAt: beginingDate,
        groupIndex: groupIndex,
      );
    }

    // テスト用ヘルパー: PillSheetGroupを生成する
    PillSheetGroup createPillSheetGroup({
      required String id,
      required List<PillSheet> pillSheets,
    }) {
      return PillSheetGroup(
        id: id,
        pillSheetIDs: pillSheets.map((e) => e.id!).toList(),
        pillSheets: pillSheets,
        createdAt: DateTime.parse('2020-09-01'),
      );
    }

    group('正常系', () {
      test('1錠目を服用した場合、TakenPillValueの各プロパティが正しく設定される', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final takenDate = DateTime.parse('2020-09-01');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: takenDate,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.enumActionType, PillSheetModifiedActionType.takenPill);
        expect(history.value.takenPill, isNotNull);
        expect(history.value.takenPill!.afterLastTakenDate, takenDate);
        expect(history.value.takenPill!.afterLastTakenPillNumber, 1);
        expect(history.value.takenPill!.beforeLastTakenDate, isNull);
        expect(history.value.takenPill!.beforeLastTakenPillNumber, 0);
        expect(history.value.takenPill!.isQuickRecord, false);
      });

      test('isQuickRecord が true の場合、TakenPillValue.isQuickRecord が true になる', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final takenDate = DateTime.parse('2020-09-01');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: takenDate,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: true,
        );

        expect(history.value.takenPill!.isQuickRecord, true);
      });

      test('10錠目から11錠目への服用の場合、beforeとafterのピル番号が正しく設定される', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeTakenDate = DateTime.parse('2020-09-10');
        final afterTakenDate = DateTime.parse('2020-09-11');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: beforeTakenDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: afterTakenDate,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.value.takenPill!.afterLastTakenDate, afterTakenDate);
        expect(history.value.takenPill!.afterLastTakenPillNumber, 11);
        expect(history.value.takenPill!.beforeLastTakenDate, beforeTakenDate);
        expect(history.value.takenPill!.beforeLastTakenPillNumber, 10);
      });

      test('28錠タイプの最後のピル（28錠目）を服用した場合', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeTakenDate = DateTime.parse('2020-09-27');
        final afterTakenDate = DateTime.parse('2020-09-28');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: beforeTakenDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: afterTakenDate,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.value.takenPill!.afterLastTakenPillNumber, 28);
        expect(history.value.takenPill!.beforeLastTakenPillNumber, 27);
      });

      test('21錠+休薬7日タイプ（pillsheet_21）で21錠目を服用した場合', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeTakenDate = DateTime.parse('2020-09-20');
        final afterTakenDate = DateTime.parse('2020-09-21');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_21,
          beginingDate: beginingDate,
          lastTakenDate: beforeTakenDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_21,
          beginingDate: beginingDate,
          lastTakenDate: afterTakenDate,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.value.takenPill!.afterLastTakenPillNumber, 21);
        expect(history.value.takenPill!.beforeLastTakenPillNumber, 20);
      });

      test('actionType が takenPill として設定される', () {
        final beginingDate = DateTime.parse('2020-09-01');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: beginingDate,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.actionType, 'takenPill');
        expect(history.enumActionType, PillSheetModifiedActionType.takenPill);
      });

      test('複数のピルシートがあるグループで2枚目のシートのピルを服用した場合', () {
        final beginingDate1 = DateTime.parse('2020-09-01');
        final beginingDate2 = DateTime.parse('2020-09-29');
        final afterTakenDate = DateTime.parse('2020-09-29');

        final sheet1 = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate1,
          lastTakenDate: DateTime.parse('2020-09-28'),
          groupIndex: 0,
        );

        final beforeSheet2 = createPillSheet(
          id: 'sheet_2',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate2,
          lastTakenDate: null,
          groupIndex: 1,
        );

        final afterSheet2 = createPillSheet(
          id: 'sheet_2',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate2,
          lastTakenDate: afterTakenDate,
          groupIndex: 1,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [sheet1, beforeSheet2],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [sheet1, afterSheet2],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: beforeSheet2,
          after: afterSheet2,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        // 2枚目のシートの1錠目
        expect(history.value.takenPill!.afterLastTakenPillNumber, 1);
        expect(history.value.takenPill!.beforeLastTakenPillNumber, 0);
        expect(history.afterPillSheetID, 'sheet_2');
        expect(history.beforePillSheetID, 'sheet_2');
      });

      test('before と after のPillSheetGroup が正しく設定される', () {
        final beginingDate = DateTime.parse('2020-09-01');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: beginingDate,
        );

        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
        expect(history.before, before);
        expect(history.after, after);
        expect(history.pillSheetGroupID, 'group_1');
      });
    });

    group('異常系', () {
      test('after.id が null の場合、FormatException がスローされる', () {
        final beginingDate = DateTime.parse('2020-09-01');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );

        // id が null の PillSheet を作成
        final after = PillSheet(
          id: null,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: beginingDate,
          createdAt: beginingDate,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: 'group_1',
            before: before,
            after: after,
            beforePillSheetGroup: pillSheetGroup,
            afterPillSheetGroup: pillSheetGroup,
            isQuickRecord: false,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('after.lastTakenDate が null の場合、FormatException がスローされる', () {
        final beginingDate = DateTime.parse('2020-09-01');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );

        // lastTakenDate が null の PillSheet
        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        // after.lastTakenDateがnullのままcreateを呼ぶとFormatExceptionが発生する
        // なぜなら、服用記録アクションでは服用後の日付が必須だから
        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: 'group_1',
            before: before,
            after: after,
            beforePillSheetGroup: pillSheetGroup,
            afterPillSheetGroup: pillSheetGroup,
            isQuickRecord: false,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('after.id と after.lastTakenDate の両方が null の場合、FormatException がスローされる', () {
        final beginingDate = DateTime.parse('2020-09-01');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );

        // 両方 null
        final after = PillSheet(
          id: null,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: null,
          createdAt: beginingDate,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: 'group_1',
            before: before,
            after: after,
            beforePillSheetGroup: pillSheetGroup,
            afterPillSheetGroup: pillSheetGroup,
            isQuickRecord: false,
          ),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('PillSheetType別のテスト', () {
      test('24錠+4日偽薬タイプ（pillsheet_28_4）で24錠目を服用した場合', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeTakenDate = DateTime.parse('2020-09-23');
        final afterTakenDate = DateTime.parse('2020-09-24');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_4,
          beginingDate: beginingDate,
          lastTakenDate: beforeTakenDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_4,
          beginingDate: beginingDate,
          lastTakenDate: afterTakenDate,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.value.takenPill!.afterLastTakenPillNumber, 24);
        expect(history.value.takenPill!.beforeLastTakenPillNumber, 23);
      });

      test('24錠タイプ（pillsheet_24_0）で24錠目を服用した場合', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeTakenDate = DateTime.parse('2020-09-23');
        final afterTakenDate = DateTime.parse('2020-09-24');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_24_0,
          beginingDate: beginingDate,
          lastTakenDate: beforeTakenDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_24_0,
          beginingDate: beginingDate,
          lastTakenDate: afterTakenDate,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.value.takenPill!.afterLastTakenPillNumber, 24);
        expect(history.value.takenPill!.beforeLastTakenPillNumber, 23);
      });

      test('21錠タイプ（pillsheet_21_0）で21錠目を服用した場合', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeTakenDate = DateTime.parse('2020-09-20');
        final afterTakenDate = DateTime.parse('2020-09-21');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_21_0,
          beginingDate: beginingDate,
          lastTakenDate: beforeTakenDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_21_0,
          beginingDate: beginingDate,
          lastTakenDate: afterTakenDate,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
          isQuickRecord: false,
        );

        expect(history.value.takenPill!.afterLastTakenPillNumber, 21);
        expect(history.value.takenPill!.beforeLastTakenPillNumber, 20);
      });
    });
  });

  group('#createRevertTakenPillAction', () {
    // テスト用ヘルパー: PillSheetを生成する
    PillSheet createPillSheet({
      required String id,
      required PillSheetType type,
      required DateTime beginingDate,
      DateTime? lastTakenDate,
      int groupIndex = 0,
    }) {
      return PillSheet(
        id: id,
        typeInfo: type.typeInfo,
        beginingDate: beginingDate,
        lastTakenDate: lastTakenDate,
        createdAt: beginingDate,
        groupIndex: groupIndex,
      );
    }

    // テスト用ヘルパー: PillSheetGroupを生成する
    PillSheetGroup createPillSheetGroup({
      required String id,
      required List<PillSheet> pillSheets,
    }) {
      return PillSheetGroup(
        id: id,
        pillSheetIDs: pillSheets.map((e) => e.id!).toList(),
        pillSheets: pillSheets,
        createdAt: DateTime.parse('2020-09-01'),
      );
    }

    group('正常系', () {
      test('2錠目を服用後に1錠目へリバートした場合、RevertTakenPillValueの各プロパティが正しく設定される', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeLastTakenDate = DateTime.parse('2020-09-02'); // 2錠目まで服用
        final afterLastTakenDate = DateTime.parse('2020-09-01'); // 1錠目へリバート

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: beforeLastTakenDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: afterLastTakenDate,
        );

        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.enumActionType, PillSheetModifiedActionType.revertTakenPill);
        expect(history.value.revertTakenPill, isNotNull);
        expect(history.value.revertTakenPill!.afterLastTakenDate, afterLastTakenDate);
        expect(history.value.revertTakenPill!.afterLastTakenPillNumber, 1);
        expect(history.value.revertTakenPill!.beforeLastTakenDate, beforeLastTakenDate);
        expect(history.value.revertTakenPill!.beforeLastTakenPillNumber, 2);
      });

      test('1錠目を服用後に全てリバートした場合、afterLastTakenDateがnullになる', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeLastTakenDate = DateTime.parse('2020-09-01'); // 1錠目まで服用

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: beforeLastTakenDate,
        );

        // afterLastTakenDateがnull（全てリバート）
        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );

        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.enumActionType, PillSheetModifiedActionType.revertTakenPill);
        expect(history.value.revertTakenPill!.afterLastTakenDate, isNull);
        expect(history.value.revertTakenPill!.afterLastTakenPillNumber, 0);
        expect(history.value.revertTakenPill!.beforeLastTakenDate, beforeLastTakenDate);
        expect(history.value.revertTakenPill!.beforeLastTakenPillNumber, 1);
      });

      test('11錠目から10錠目へリバートした場合、beforeとafterのピル番号が正しく設定される', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeLastTakenDate = DateTime.parse('2020-09-11'); // 11錠目まで服用
        final afterLastTakenDate = DateTime.parse('2020-09-10'); // 10錠目へリバート

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: beforeLastTakenDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: afterLastTakenDate,
        );

        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.revertTakenPill!.afterLastTakenDate, afterLastTakenDate);
        expect(history.value.revertTakenPill!.afterLastTakenPillNumber, 10);
        expect(history.value.revertTakenPill!.beforeLastTakenDate, beforeLastTakenDate);
        expect(history.value.revertTakenPill!.beforeLastTakenPillNumber, 11);
      });

      test('28錠タイプの最後のピル（28錠目）から27錠目へリバートした場合', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeLastTakenDate = DateTime.parse('2020-09-28'); // 28錠目まで服用
        final afterLastTakenDate = DateTime.parse('2020-09-27'); // 27錠目へリバート

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: beforeLastTakenDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: afterLastTakenDate,
        );

        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.revertTakenPill!.afterLastTakenPillNumber, 27);
        expect(history.value.revertTakenPill!.beforeLastTakenPillNumber, 28);
      });

      test('actionType が revertTakenPill として設定される', () {
        final beginingDate = DateTime.parse('2020-09-01');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: DateTime.parse('2020-09-02'),
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: beginingDate,
        );

        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.actionType, 'revertTakenPill');
        expect(history.enumActionType, PillSheetModifiedActionType.revertTakenPill);
      });

      test('複数のピルシートがあるグループで2枚目のシートのピルをリバートした場合', () {
        final beginingDate1 = DateTime.parse('2020-09-01');
        final beginingDate2 = DateTime.parse('2020-09-29');
        final beforeLastTakenDate = DateTime.parse('2020-09-30'); // 2枚目の2錠目
        final afterLastTakenDate = DateTime.parse('2020-09-29'); // 2枚目の1錠目へリバート

        final sheet1 = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate1,
          lastTakenDate: DateTime.parse('2020-09-28'),
          groupIndex: 0,
        );

        final beforeSheet2 = createPillSheet(
          id: 'sheet_2',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate2,
          lastTakenDate: beforeLastTakenDate,
          groupIndex: 1,
        );

        final afterSheet2 = createPillSheet(
          id: 'sheet_2',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate2,
          lastTakenDate: afterLastTakenDate,
          groupIndex: 1,
        );

        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [sheet1, beforeSheet2],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [sheet1, afterSheet2],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: beforeSheet2,
          after: afterSheet2,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        // 2枚目のシートの2錠目から1錠目へリバート
        expect(history.value.revertTakenPill!.afterLastTakenPillNumber, 1);
        expect(history.value.revertTakenPill!.beforeLastTakenPillNumber, 2);
        expect(history.afterPillSheetID, 'sheet_2');
        expect(history.beforePillSheetID, 'sheet_2');
      });

      test('before と after のPillSheetGroup が正しく設定される', () {
        final beginingDate = DateTime.parse('2020-09-01');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: DateTime.parse('2020-09-02'),
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: beginingDate,
        );

        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.beforePillSheetGroup, beforePillSheetGroup);
        expect(history.afterPillSheetGroup, afterPillSheetGroup);
        expect(history.before, before);
        expect(history.after, after);
        expect(history.pillSheetGroupID, 'group_1');
      });
    });

    group('異常系', () {
      test('after.id が null の場合、FormatException がスローされる', () {
        final beginingDate = DateTime.parse('2020-09-01');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: DateTime.parse('2020-09-02'),
        );

        // id が null の PillSheet を作成
        final after = PillSheet(
          id: null,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: beginingDate,
          createdAt: beginingDate,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        // after.idがnullのためFormatExceptionが発生する
        // なぜなら、リバートアクションでは変更後のピルシートのIDが必須だから
        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
            pillSheetGroupID: 'group_1',
            before: before,
            after: after,
            beforePillSheetGroup: pillSheetGroup,
            afterPillSheetGroup: pillSheetGroup,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('before.id が null の場合、FormatException がスローされる', () {
        final beginingDate = DateTime.parse('2020-09-01');

        // id が null の PillSheet を作成
        final before = PillSheet(
          id: null,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: DateTime.parse('2020-09-02'),
          createdAt: beginingDate,
        );

        final after = PillSheet(
          id: 'sheet_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: beginingDate,
          createdAt: beginingDate,
        );

        final pillSheetGroup = PillSheetGroup(
          id: 'group_1',
          pillSheetIDs: ['sheet_1'],
          pillSheets: [after],
          createdAt: DateTime.parse('2020-09-01'),
        );

        // before.idがnullのためFormatExceptionが発生する
        // なぜなら、リバートアクションでは変更前のピルシートのIDが必須だから
        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
            pillSheetGroupID: 'group_1',
            before: before,
            after: after,
            beforePillSheetGroup: pillSheetGroup,
            afterPillSheetGroup: pillSheetGroup,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('before.lastTakenDate が null の場合、FormatException がスローされる', () {
        final beginingDate = DateTime.parse('2020-09-01');

        // lastTakenDate が null のPillSheet（服用記録がない状態からはリバートできない）
        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        // before.lastTakenDateがnullのためFormatExceptionが発生する
        // なぜなら、服用記録がない状態からはリバートすることができないから
        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
            pillSheetGroupID: 'group_1',
            before: before,
            after: after,
            beforePillSheetGroup: pillSheetGroup,
            afterPillSheetGroup: pillSheetGroup,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('before.id と before.lastTakenDate の両方が null の場合、FormatException がスローされる', () {
        final beginingDate = DateTime.parse('2020-09-01');

        // 両方 null
        final before = PillSheet(
          id: null,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: null,
          createdAt: beginingDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_0,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );

        final pillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        expect(
          () => PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
            pillSheetGroupID: 'group_1',
            before: before,
            after: after,
            beforePillSheetGroup: pillSheetGroup,
            afterPillSheetGroup: pillSheetGroup,
          ),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('PillSheetType別のテスト', () {
      test('21錠+休薬7日タイプ（pillsheet_21）で21錠目から20錠目へリバートした場合', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeLastTakenDate = DateTime.parse('2020-09-21');
        final afterLastTakenDate = DateTime.parse('2020-09-20');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_21,
          beginingDate: beginingDate,
          lastTakenDate: beforeLastTakenDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_21,
          beginingDate: beginingDate,
          lastTakenDate: afterLastTakenDate,
        );

        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.revertTakenPill!.afterLastTakenPillNumber, 20);
        expect(history.value.revertTakenPill!.beforeLastTakenPillNumber, 21);
      });

      test('24錠+4日偽薬タイプ（pillsheet_28_4）で24錠目から23錠目へリバートした場合', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeLastTakenDate = DateTime.parse('2020-09-24');
        final afterLastTakenDate = DateTime.parse('2020-09-23');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_4,
          beginingDate: beginingDate,
          lastTakenDate: beforeLastTakenDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_28_4,
          beginingDate: beginingDate,
          lastTakenDate: afterLastTakenDate,
        );

        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.revertTakenPill!.afterLastTakenPillNumber, 23);
        expect(history.value.revertTakenPill!.beforeLastTakenPillNumber, 24);
      });

      test('24錠タイプ（pillsheet_24_0）で24錠目から23錠目へリバートした場合', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeLastTakenDate = DateTime.parse('2020-09-24');
        final afterLastTakenDate = DateTime.parse('2020-09-23');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_24_0,
          beginingDate: beginingDate,
          lastTakenDate: beforeLastTakenDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_24_0,
          beginingDate: beginingDate,
          lastTakenDate: afterLastTakenDate,
        );

        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.revertTakenPill!.afterLastTakenPillNumber, 23);
        expect(history.value.revertTakenPill!.beforeLastTakenPillNumber, 24);
      });

      test('21錠タイプ（pillsheet_21_0）で21錠目から20錠目へリバートした場合', () {
        final beginingDate = DateTime.parse('2020-09-01');
        final beforeLastTakenDate = DateTime.parse('2020-09-21');
        final afterLastTakenDate = DateTime.parse('2020-09-20');

        final before = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_21_0,
          beginingDate: beginingDate,
          lastTakenDate: beforeLastTakenDate,
        );

        final after = createPillSheet(
          id: 'sheet_1',
          type: PillSheetType.pillsheet_21_0,
          beginingDate: beginingDate,
          lastTakenDate: afterLastTakenDate,
        );

        final beforePillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [before],
        );

        final afterPillSheetGroup = createPillSheetGroup(
          id: 'group_1',
          pillSheets: [after],
        );

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: 'group_1',
          before: before,
          after: after,
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
        );

        expect(history.value.revertTakenPill!.afterLastTakenPillNumber, 20);
        expect(history.value.revertTakenPill!.beforeLastTakenPillNumber, 21);
      });
    });
  });
}
