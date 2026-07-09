import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
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

PillSheetGroup _pillSheetGroup(
    {required PillSheetType pillSheetType,
    required DateTime beginDate,
    required DateTime? lastTakenDate}) {
  return PillSheetGroup(
    id: 'group_id',
    pillSheetIDs: ['pill_sheet_id_1'],
    pillSheets: [
      PillSheet.v1(
        id: 'pill_sheet_id_1',
        typeInfo: pillSheetType.typeInfo,
        beginDate: beginDate,
        lastTakenDate: lastTakenDate,
        createdAt: beginDate,
      ),
    ],
    createdAt: beginDate,
  );
}

void main() {
  group('#endedPillSheetTakenSummary', () {
    test('履歴が空の場合、実薬の全日が記録漏れになる（28錠すべて実薬）', () {
      final result = endedPillSheetTakenSummary(
        pillSheetGroup: _pillSheetGroup(
          pillSheetType: PillSheetType.pillsheet_28_0,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: null,
        ),
        histories: [],
      );
      expect(result.recordedDays, 0);
      expect(result.missedDays, 28);
    });

    test('実薬期間を全日服用した場合、recordedDays=実薬日数 / missedDays=0（時刻付き履歴でも日付正規化される）',
        () {
      final begin = DateTime(2020, 9, 1);
      final result = endedPillSheetTakenSummary(
        pillSheetGroup: _pillSheetGroup(
          pillSheetType: PillSheetType.pillsheet_28_0,
          beginDate: begin,
          lastTakenDate: DateTime(2020, 9, 28),
        ),
        histories: [
          for (int i = 0; i < 28; i++)
            // 実データと同様に時刻付きの estimatedEventCausingDate を持たせる
            _history(
              actionType: PillSheetModifiedActionType.takenPill.name,
              date: begin.add(Duration(days: i, hours: 18, minutes: 56)),
            ),
        ],
      );
      expect(result.recordedDays, 28);
      expect(result.missedDays, 0);
    });

    test('pillsheet_21（21実薬+7休薬）で実薬21日を全て記録した場合、休薬7日は記録漏れに含まれない', () {
      final begin = DateTime(2020, 9, 1);
      final result = endedPillSheetTakenSummary(
        pillSheetGroup: _pillSheetGroup(
          pillSheetType: PillSheetType.pillsheet_21,
          beginDate: begin,
          lastTakenDate: DateTime(2020, 9, 21),
        ),
        histories: [
          for (int i = 0; i < 21; i++)
            _history(
              actionType: PillSheetModifiedActionType.takenPill.name,
              date: begin.add(Duration(days: i)),
            ),
        ],
      );
      expect(result.recordedDays, 21);
      expect(result.missedDays, 0);
    });

    test('開始日から数日後に初回記録した場合、開始日〜初回記録前の未記録日が記録漏れに含まれる', () {
      final begin = DateTime(2020, 9, 1);
      final result = endedPillSheetTakenSummary(
        pillSheetGroup: _pillSheetGroup(
          pillSheetType: PillSheetType.pillsheet_28_0,
          beginDate: begin,
          lastTakenDate: DateTime(2020, 9, 28),
        ),
        // 9/5〜9/28 の24日を服用（9/1〜9/4 の4日は未記録）
        histories: [
          for (int i = 4; i < 28; i++)
            _history(
              actionType: PillSheetModifiedActionType.takenPill.name,
              date: begin.add(Duration(days: i)),
            ),
        ],
      );
      expect(result.recordedDays, 24);
      expect(result.missedDays, 4);
    });

    test('服用記録を取り消してそのままの日は記録漏れに含まれる', () {
      final begin = DateTime(2020, 9, 1);
      // 9/1〜9/3 を服用後、9/3 の記録を取り消してそのまま
      final beforeRevertPillSheetGroup = _pillSheetGroup(
        pillSheetType: PillSheetType.pillsheet_28_0,
        beginDate: begin,
        lastTakenDate: DateTime(2020, 9, 3),
      );
      final afterRevertPillSheetGroup = _pillSheetGroup(
        pillSheetType: PillSheetType.pillsheet_28_0,
        beginDate: begin,
        lastTakenDate: DateTime(2020, 9, 2),
      );
      final result = endedPillSheetTakenSummary(
        pillSheetGroup: beforeRevertPillSheetGroup,
        histories: [
          for (int i = 0; i < 3; i++)
            _history(
              actionType: PillSheetModifiedActionType.takenPill.name,
              date: begin.add(Duration(days: i)),
            ),
          PillSheetModifiedHistory(
            id: 'revert',
            actionType: PillSheetModifiedActionType.revertTakenPill.name,
            estimatedEventCausingDate: DateTime(2020, 9, 3, 20),
            createdAt: DateTime(2020, 9, 3, 20),
            value: const PillSheetModifiedHistoryValue(
                revertTakenPill: RevertTakenPillValue()),
            beforePillSheetGroup: beforeRevertPillSheetGroup,
            afterPillSheetGroup: afterRevertPillSheetGroup,
          ),
        ],
      );
      // 9/1・9/2 の2日が記録済み。9/3 は取り消されたので記録漏れ側に入る
      expect(result.recordedDays, 2);
      expect(result.missedDays, 26);
    });
  });
}
