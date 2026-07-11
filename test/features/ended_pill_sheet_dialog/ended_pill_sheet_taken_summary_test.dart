import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/ended_pill_sheet_taken_summary.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../helper/mock.mocks.dart';

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

  group('#endedPillSheetTakenSummaryAvailable', () {
    PillSheetModifiedHistory historyWithGroup({required String groupID, required DateTime date}) {
      return PillSheetModifiedHistory(
        id: 'taken_$date',
        actionType: PillSheetModifiedActionType.takenPill.name,
        estimatedEventCausingDate: date,
        createdAt: date,
        value: const PillSheetModifiedHistoryValue(takenPill: TakenPillValue()),
        beforePillSheetGroup: null,
        afterPillSheetGroup: PillSheetGroup(
          id: groupID,
          pillSheetIDs: ['pill_sheet_id_1'],
          pillSheets: [
            PillSheet.v1(
              id: 'pill_sheet_id_1',
              typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
              beginDate: DateTime(2020, 9, 1),
              lastTakenDate: date,
              createdAt: DateTime(2020, 9, 1),
            ),
          ],
          createdAt: DateTime(2020, 9, 1),
        ),
      );
    }

    test('集計開始日が履歴TTL(180日)の窓内で対象グループの履歴がある場合はtrue', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-10-01'));

      final result = endedPillSheetTakenSummaryAvailable(
        pillSheetGroup: _pillSheetGroup(
          pillSheetType: PillSheetType.pillsheet_28_0,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
        ),
        histories: [historyWithGroup(groupID: 'group_id', date: DateTime(2020, 9, 1, 10))],
      );
      expect(result, true);
    });

    test('集計開始日が履歴TTL(180日)の窓外の場合、履歴があってもfalse', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2021-06-01'));

      final result = endedPillSheetTakenSummaryAvailable(
        pillSheetGroup: _pillSheetGroup(
          pillSheetType: PillSheetType.pillsheet_28_0,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
        ),
        histories: [historyWithGroup(groupID: 'group_id', date: DateTime(2020, 9, 20, 10))],
      );
      expect(result, false);
    });

    test('境界値: 集計開始日がちょうど180日前の場合、初日の履歴のTTL切れを保証できないためfalse', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      // 2020-09-01 + 180日 = 2021-02-28
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2021-02-28'));

      final result = endedPillSheetTakenSummaryAvailable(
        pillSheetGroup: _pillSheetGroup(
          pillSheetType: PillSheetType.pillsheet_28_0,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
        ),
        histories: [historyWithGroup(groupID: 'group_id', date: DateTime(2020, 9, 20, 10))],
      );
      expect(result, false);
    });

    test('境界値: 集計開始日が179日前の場合はtrue', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      // 2021-02-27 - 180日 = 2020-08-31 < beginDate(2020-09-01)
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2021-02-27'));

      final result = endedPillSheetTakenSummaryAvailable(
        pillSheetGroup: _pillSheetGroup(
          pillSheetType: PillSheetType.pillsheet_28_0,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
        ),
        histories: [historyWithGroup(groupID: 'group_id', date: DateTime(2020, 9, 20, 10))],
      );
      expect(result, true);
    });

    test('対象グループの履歴が無い場合（別グループの履歴のみ）はfalse', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-10-01'));

      final result = endedPillSheetTakenSummaryAvailable(
        pillSheetGroup: _pillSheetGroup(
          pillSheetType: PillSheetType.pillsheet_28_0,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
        ),
        histories: [historyWithGroup(groupID: 'other_group_id', date: DateTime(2020, 9, 1, 10))],
      );
      expect(result, false);
    });

    test('履歴が空の場合はfalse', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-10-01'));

      final result = endedPillSheetTakenSummaryAvailable(
        pillSheetGroup: _pillSheetGroup(
          pillSheetType: PillSheetType.pillsheet_28_0,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
        ),
        histories: [],
      );
      expect(result, false);
    });
  });
}
