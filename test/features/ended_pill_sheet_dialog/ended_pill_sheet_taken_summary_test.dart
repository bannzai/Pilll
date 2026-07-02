import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/ended_pill_sheet_taken_summary.dart';

PillSheetModifiedHistory _history(
    {required String actionType, required DateTime date}) {
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
    test('履歴が空でも beginDate〜endDate の全日が記録漏れになる', () {
      final result = endedPillSheetTakenSummary(
        histories: [],
        beginDate: DateTime(2020, 9, 1),
        endDate: DateTime(2020, 9, 28),
      );
      // 9/1〜9/28 の28日すべてが記録漏れ
      expect(result.recordedDays, 0);
      expect(result.missedDays, 28);
    });

    test('開始日〜終了日を全日服用した場合、recordedDays=全日数 / missedDays=0（時刻付き履歴でも日付正規化される）',
        () {
      final begin = DateTime(2020, 9, 1);
      final end = DateTime(2020, 9, 28);
      final histories = [
        for (int i = 0; i < 28; i++)
          // 実データと同様に時刻付きの estimatedEventCausingDate を持たせる
          _history(
            actionType: PillSheetModifiedActionType.takenPill.name,
            date: begin.add(Duration(days: i, hours: 18, minutes: 56)),
          ),
      ];
      final result = endedPillSheetTakenSummary(
          histories: histories, beginDate: begin, endDate: end);
      expect(result.recordedDays, 28);
      expect(result.missedDays, 0);
    });

    test('開始日から数日後に初回記録した場合、開始日〜初回記録前の未記録日が記録漏れに含まれる', () {
      final begin = DateTime(2020, 9, 1);
      final end = DateTime(2020, 9, 28);
      // 9/5〜9/28 の24日を服用（9/1〜9/4 の4日は未記録）
      final histories = [
        for (int i = 4; i < 28; i++)
          _history(
            actionType: PillSheetModifiedActionType.takenPill.name,
            date: begin.add(Duration(days: i)),
          ),
      ];
      final result = endedPillSheetTakenSummary(
          histories: histories, beginDate: begin, endDate: end);
      expect(result.recordedDays, 24);
      expect(result.missedDays, 4);
    });

    test('服用お休み期間中の日数は recordedDays にも missedDays にも含まれない', () {
      final begin = DateTime(2020, 9, 1);
      final end = DateTime(2020, 9, 28);
      final histories = [
        // 9/1〜9/4 服用
        for (int i = 0; i < 4; i++)
          _history(
              actionType: PillSheetModifiedActionType.takenPill.name,
              date: begin.add(Duration(days: i))),
        // 9/5 休薬開始、9/8 休薬終了（9/5・9/6・9/7 の3日が休薬）
        _history(
            actionType: PillSheetModifiedActionType.beganRestDuration.name,
            date: DateTime(2020, 9, 5)),
        _history(
            actionType: PillSheetModifiedActionType.endedRestDuration.name,
            date: DateTime(2020, 9, 8)),
        // 9/8〜9/28 服用
        for (int i = 7; i < 28; i++)
          _history(
              actionType: PillSheetModifiedActionType.takenPill.name,
              date: begin.add(Duration(days: i))),
      ];
      final result = endedPillSheetTakenSummary(
          histories: histories, beginDate: begin, endDate: end);
      // 28日 − 休薬3日 = 服用予定25日。全て服用済み → recorded=25, missed=0
      expect(result.recordedDays, 25);
      expect(result.missedDays, 0);
    });
  });
}
