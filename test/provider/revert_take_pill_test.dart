import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/revert_take_pill.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../helper/mock.mocks.dart';

void main() {
  final mockNow = DateTime.parse("2022-07-24T19:02:00");

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(mockNow);
  });

  group("#RevertTakePill", () {
    group("pillTakenCount = 2", () {
      test("revert対象日以降のpillTakensがクリアされる", () async {
        // 2日目までのピルを全錠(2錠)飲んだ状態で、2日目をrevertする
        final mockNowDay2 = DateTime.parse("2022-07-25T19:02:00");
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowDay2);

        const sheetType = PillSheetType.pillsheet_28_7;
        final activePillSheetV2 = PillSheet.v2(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          typeInfo: sheetType.typeInfo,
          beginingDate: DateTime.parse("2022-07-24"),
          lastTakenDate: DateTime.parse("2022-07-25"),
          createdAt: now(),
          pillTakenCount: 2,
          pills: List.generate(
            sheetType.totalCount,
            (index) {
              if (index <= 1) {
                return Pill(
                  index: index,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(
                      recordedTakenDateTime: DateTime.parse("2022-07-24").add(Duration(days: index)),
                      createdDateTime: now(),
                      updatedDateTime: now(),
                    ),
                    PillTaken(
                      recordedTakenDateTime: DateTime.parse("2022-07-24").add(Duration(days: index)),
                      createdDateTime: now(),
                      updatedDateTime: now(),
                    ),
                  ],
                );
              }
              return Pill(
                index: index,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [],
              );
            },
          ),
        );
        final pillSheetGroupV2 = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [activePillSheetV2.id!],
          pillSheets: [activePillSheetV2],
          createdAt: mockNow,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        // targetRevertPillNumberIntoPillSheet = 2 (2番目のピルをrevert)
        // revertDate = 2022-07-24 (2番目のピルの1日前)
        final revertDate = DateTime.parse("2022-07-24");
        final updatedActivePillSheetV2 = activePillSheetV2.revertedPillSheet(revertDate).copyWith(restDurations: []);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(pillSheets: [updatedActivePillSheetV2]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroupV2)).thenReturn(updatedPillSheetGroupV2);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: pillSheetGroupV2.id,
          before: activePillSheetV2,
          after: updatedActivePillSheetV2,
          beforePillSheetGroup: pillSheetGroupV2,
          afterPillSheetGroup: updatedPillSheetGroupV2,
        );
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final revertTakePill = RevertTakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await revertTakePill(
          pillSheetGroup: pillSheetGroupV2,
          pageIndex: 0,
          targetRevertPillNumberIntoPillSheet: 2,
        );

        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroupV2)).called(1);
        expect(result, updatedPillSheetGroupV2);

        // 1日目のpillTakensは維持され、2日目のpillTakensはクリアされる
        final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
        expect(updatedPillSheet.pills[0].pillTakens.length, 2);
        expect(updatedPillSheet.pills[1].pillTakens.length, 0);
      });

      test("revert対象日より前のpillTakensは維持される", () async {
        // 3日目までのピルを全錠(2錠)飲んだ状態で、3日目をrevertする
        final mockNowDay3 = DateTime.parse("2022-07-26T19:02:00");
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowDay3);

        const sheetType = PillSheetType.pillsheet_28_7;
        final activePillSheetV2 = PillSheet.v2(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          typeInfo: sheetType.typeInfo,
          beginingDate: DateTime.parse("2022-07-24"),
          lastTakenDate: DateTime.parse("2022-07-26"),
          createdAt: now(),
          pillTakenCount: 2,
          pills: List.generate(
            sheetType.totalCount,
            (index) {
              if (index <= 2) {
                return Pill(
                  index: index,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(
                      recordedTakenDateTime: DateTime.parse("2022-07-24").add(Duration(days: index)),
                      createdDateTime: now(),
                      updatedDateTime: now(),
                    ),
                    PillTaken(
                      recordedTakenDateTime: DateTime.parse("2022-07-24").add(Duration(days: index)),
                      createdDateTime: now(),
                      updatedDateTime: now(),
                    ),
                  ],
                );
              }
              return Pill(
                index: index,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [],
              );
            },
          ),
        );
        final pillSheetGroupV2 = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [activePillSheetV2.id!],
          pillSheets: [activePillSheetV2],
          createdAt: mockNow,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        // targetRevertPillNumberIntoPillSheet = 3 (3番目のピルをrevert)
        // revertDate = 2022-07-25 (3番目のピルの1日前)
        final revertDate = DateTime.parse("2022-07-25");
        final updatedActivePillSheetV2 = activePillSheetV2.revertedPillSheet(revertDate).copyWith(restDurations: []);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(pillSheets: [updatedActivePillSheetV2]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroupV2)).thenReturn(updatedPillSheetGroupV2);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: pillSheetGroupV2.id,
          before: activePillSheetV2,
          after: updatedActivePillSheetV2,
          beforePillSheetGroup: pillSheetGroupV2,
          afterPillSheetGroup: updatedPillSheetGroupV2,
        );
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final revertTakePill = RevertTakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await revertTakePill(
          pillSheetGroup: pillSheetGroupV2,
          pageIndex: 0,
          targetRevertPillNumberIntoPillSheet: 3,
        );

        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroupV2)).called(1);
        expect(result, updatedPillSheetGroupV2);

        // 1日目、2日目のpillTakensは維持され、3日目のpillTakensはクリアされる
        final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
        expect(updatedPillSheet.pills[0].pillTakens.length, 2);
        expect(updatedPillSheet.pills[1].pillTakens.length, 2);
        expect(updatedPillSheet.pills[2].pillTakens.length, 0);
      });
    });
  });
}
