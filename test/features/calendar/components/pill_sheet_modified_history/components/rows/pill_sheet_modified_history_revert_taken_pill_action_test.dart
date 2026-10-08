import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_revert_taken_pill_action.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../../../../../helper/mock.mocks.dart';

void main() {
  group('#PillSheetModifiedHistoryRevertTakenPillAction', () {
    group('表示モードが cyclicSequential の場合', () {
      testWidgets(
          'lastTakenDate が服用終了予定日より2日以上後ろのピルシート(28錠)を含むスナップショットでも、例外を投げずにピル番号が表示される',
          (tester) async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse('2020-10-10'));

        // 28錠のピルシートは 2020-09-01 開始で 2020-09-28 に服用終了予定。lastTakenDate から計算するピル番号は 9/29 で29、9/30 で30 になり、錠数を超える
        PillSheetGroup pillSheetGroup({required DateTime lastTakenDate}) =>
            PillSheetGroup(
              id: 'group_id',
              pillSheetIDs: ['pill_sheet_id_1'],
              pillSheets: [
                PillSheet.v1(
                  id: 'pill_sheet_id_1',
                  typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
                  beginDate: DateTime(2020, 9, 1),
                  lastTakenDate: lastTakenDate,
                  createdAt: DateTime(2020, 9, 1),
                ),
              ],
              createdAt: DateTime(2020, 9, 1),
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            );
        final history = PillSheetModifiedHistory(
          id: 'revert_taken_pill_history_id',
          actionType: PillSheetModifiedActionType.revertTakenPill.name,
          estimatedEventCausingDate: DateTime(2020, 9, 30, 10),
          createdAt: DateTime(2020, 9, 30, 10),
          value: const PillSheetModifiedHistoryValue(
              revertTakenPill: RevertTakenPillValue()),
          beforePillSheetGroup:
              pillSheetGroup(lastTakenDate: DateTime(2020, 9, 30)),
          afterPillSheetGroup:
              pillSheetGroup(lastTakenDate: DateTime(2020, 9, 29)),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: PillSheetModifiedHistoryRevertTakenPillAction(
                estimatedEventCausingDate: history.estimatedEventCausingDate,
                history: history,
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(RowLayout), findsOneWidget);
        expect(find.byType(PillNumber), findsOneWidget);
        // before / after のどちらもピルシートの最後の番号 28 に収まり、存在しない 29 番を含む「28-29日目」にならない
        expect(find.text('28日目'), findsOneWidget);
      });
    });

    group('表示モードが cyclicSequential で開始番号が 10 の場合', () {
      // 全て取り消した後の after は表示番号 0 ではなく開始番号の 1 つ前 (9) として扱われ、最初の 1 錠の取り消し記録が「10-1日目」にならない

      /// 開始番号 10 の cyclicSequential 表示のグループを、指定したピルシート 1 枚で作る
      PillSheetGroup pillSheetGroup({required PillSheet pillSheet}) =>
          PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id_1'],
            pillSheets: [pillSheet],
            createdAt: DateTime(2020, 9, 1),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            displayNumberSetting:
                const PillSheetGroupDisplayNumberSetting(beginPillNumber: 10),
          );

      testWidgets('v1 (1錠飲み) の最初の 1 錠の取り消し記録は「10日目」と表示される', (tester) async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse('2020-09-01'));

        /// 2020-09-01 開始の 21 錠 v1 ピルシートを、指定した最終服用日で作る
        PillSheet pillSheet({required DateTime? lastTakenDate}) => PillSheet.v1(
              id: 'pill_sheet_id_1',
              typeInfo: PillSheetType.pillsheet_21.typeInfo,
              beginDate: DateTime(2020, 9, 1),
              lastTakenDate: lastTakenDate,
              createdAt: DateTime(2020, 9, 1),
            );
        final history = PillSheetModifiedHistory(
          id: 'revert_taken_pill_history_id',
          actionType: PillSheetModifiedActionType.revertTakenPill.name,
          estimatedEventCausingDate: DateTime(2020, 9, 1, 10),
          createdAt: DateTime(2020, 9, 1, 10),
          value: const PillSheetModifiedHistoryValue(
              revertTakenPill: RevertTakenPillValue()),
          beforePillSheetGroup: pillSheetGroup(
              pillSheet: pillSheet(lastTakenDate: DateTime(2020, 9, 1))),
          afterPillSheetGroup:
              pillSheetGroup(pillSheet: pillSheet(lastTakenDate: null)),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: PillSheetModifiedHistoryRevertTakenPillAction(
                estimatedEventCausingDate: history.estimatedEventCausingDate,
                history: history,
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(PillNumber), findsOneWidget);
        expect(find.text('10日目'), findsOneWidget);
      });

      testWidgets('v2 (2錠飲み) の最初のピルの取り消し記録は「10日目」と表示される', (tester) async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse('2020-09-01'));

        /// 2020-09-01 開始の 21 錠 v2 (2錠飲み) ピルシートを、指定した最終服用日まで服用済みで作る
        PillSheet pillSheet({required DateTime? lastTakenDate}) =>
            PillSheet.create(
              PillSheetType.pillsheet_21,
              beginDate: DateTime(2020, 9, 1),
              lastTakenDate: lastTakenDate,
              pillTakenCount: 2,
            );
        final history = PillSheetModifiedHistory(
          id: 'revert_taken_pill_history_id',
          actionType: PillSheetModifiedActionType.revertTakenPill.name,
          estimatedEventCausingDate: DateTime(2020, 9, 1, 10),
          createdAt: DateTime(2020, 9, 1, 10),
          value: const PillSheetModifiedHistoryValue(
              revertTakenPill: RevertTakenPillValue()),
          beforePillSheetGroup: pillSheetGroup(
              pillSheet: pillSheet(lastTakenDate: DateTime(2020, 9, 1))),
          afterPillSheetGroup:
              pillSheetGroup(pillSheet: pillSheet(lastTakenDate: null)),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: PillSheetModifiedHistoryRevertTakenPillAction(
                estimatedEventCausingDate: history.estimatedEventCausingDate,
                history: history,
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(PillNumber), findsOneWidget);
        expect(find.text('10日目'), findsOneWidget);
      });
    });
  });
}
