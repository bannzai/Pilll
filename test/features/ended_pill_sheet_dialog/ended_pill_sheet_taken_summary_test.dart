import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/ended_pill_sheet_taken_summary.dart';

PillSheetModifiedHistory _history({required String actionType, required DateTime date}) {
  return PillSheetModifiedHistory(
    id: 'test_id',
    actionType: actionType,
    estimatedEventCausingDate: date,
    createdAt: date,
    value: const PillSheetModifiedHistoryValue(),
    beforePillSheetGroup: null,
    afterPillSheetGroup: null,
  );
}

void main() {
  group('#endedPillSheetTakenSummary', () {
    test('履歴が空の場合は recordedDays/missedDays ともに0', () {
      final result = endedPillSheetTakenSummary(histories: [], maxDate: DateTime.parse('2020-09-28'));
      expect(result.recordedDays, 0);
      expect(result.missedDays, 0);
    });

    test('履歴期間すべてに服用記録がある場合、recordedDays=服用予定日数 / missedDays=0', () {
      final today = DateTime.parse('2020-09-28');
      final baseDate = DateTime(today.year, today.month, today.day);
      final histories = [
        for (int i = 0; i < 30; i++)
          _history(
            actionType: PillSheetModifiedActionType.takenPill.name,
            date: baseDate.subtract(Duration(days: i + 1)),
          ),
      ];
      final result = endedPillSheetTakenSummary(histories: histories, maxDate: today);
      expect(result.recordedDays, 30);
      expect(result.missedDays, 0);
    });

    test('15日前に1日だけ服用記録がある場合、recordedDays=1 / missedDays=14', () {
      final today = DateTime.parse('2020-09-28');
      final baseDate = DateTime(today.year, today.month, today.day);
      final histories = [
        _history(
          actionType: PillSheetModifiedActionType.takenPill.name,
          date: baseDate.subtract(const Duration(days: 15)),
        ),
      ];
      final result = endedPillSheetTakenSummary(histories: histories, maxDate: today);
      expect(result.recordedDays, 1);
      expect(result.missedDays, 14);
    });

    test('服用お休み期間中の日数は recordedDays にも missedDays にも含まれない', () {
      // 4日前に休薬開始・2日前に休薬終了、今日服用記録。休薬2日分(4日前,3日前)は服用予定から除外される
      final today = DateTime.parse('2020-09-28');
      final baseDate = DateTime(today.year, today.month, today.day);
      final histories = [
        _history(actionType: PillSheetModifiedActionType.beganRestDuration.name, date: baseDate.subtract(const Duration(days: 4))),
        _history(actionType: PillSheetModifiedActionType.endedRestDuration.name, date: baseDate.subtract(const Duration(days: 2))),
        _history(actionType: PillSheetModifiedActionType.takenPill.name, date: baseDate),
      ];
      final result = endedPillSheetTakenSummary(histories: histories, maxDate: today);
      // recordedDays + missedDays は服用予定日数（休薬日を除いた日数）に一致する
      expect(result.recordedDays + result.missedDays, scheduledPillDays(histories: histories, maxDate: today));
    });
  });
}
