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
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-07-24"),
          createdAt: now(),
          // //  pillTakenCount: 2,
          pills: List.generate(sheetType.totalCount, (index) {
            if (index <= 1) {
              return Pill(
                index: index,
                takenCount: 2,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-24",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-24",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            }
            return Pill(
              index: index,
              takenCount: 2,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            );
          }),
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
        final updatedActivePillSheetV2 = activePillSheetV2
            .revertedPillSheet(revertDate)
            .copyWith(restDurations: []);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(
          pillSheets: [updatedActivePillSheetV2],
        );
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).thenReturn(updatedPillSheetGroupV2);

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
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
        verify(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).called(1);
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
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-07-24"),
          createdAt: now(),
          // //  pillTakenCount: 2,
          pills: List.generate(sheetType.totalCount, (index) {
            if (index <= 2) {
              return Pill(
                index: index,
                takenCount: 2,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-24",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-24",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            }
            return Pill(
              index: index,
              takenCount: 2,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            );
          }),
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
        final updatedActivePillSheetV2 = activePillSheetV2
            .revertedPillSheet(revertDate)
            .copyWith(restDurations: []);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(
          pillSheets: [updatedActivePillSheetV2],
        );
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).thenReturn(updatedPillSheetGroupV2);

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
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
        verify(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).called(1);
        expect(result, updatedPillSheetGroupV2);

        // 1日目、2日目のpillTakensは維持され、3日目のpillTakensはクリアされる
        final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
        expect(updatedPillSheet.pills[0].pillTakens.length, 2);
        expect(updatedPillSheet.pills[1].pillTakens.length, 2);
        expect(updatedPillSheet.pills[2].pillTakens.length, 0);
      });
    });

    group("pillTakenCount = 1 (PillSheet.v1互換)", () {
      test("revert対象日以降のlastTakenDateが更新される", () async {
        // 3日目までのピルを飲んだ状態で、3日目をrevertする
        final mockNowDay3 = DateTime.parse("2022-07-26T19:02:00");
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowDay3);

        const sheetType = PillSheetType.pillsheet_28_7;
        final activePillSheetV1 = PillSheet.v1(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-07-24"),
          lastTakenDate: DateTime.parse("2022-07-26"),
          createdAt: now(),
        );
        final pillSheetGroupV1 = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [activePillSheetV1.id!],
          pillSheets: [activePillSheetV1],
          createdAt: mockNow,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        // targetRevertPillNumberIntoPillSheet = 3 (3番目のピルをrevert)
        // revertDate = 2022-07-25 (3番目のピルの1日前)
        final revertDate = DateTime.parse("2022-07-25");
        final updatedActivePillSheetV1 = (activePillSheetV1 as PillSheetV1)
            .copyWith(lastTakenDate: revertDate, restDurations: []);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroupV1 = pillSheetGroupV1.copyWith(
          pillSheets: [updatedActivePillSheetV1],
        );
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV1),
        ).thenReturn(updatedPillSheetGroupV1);

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
          beforePillSheetGroup: pillSheetGroupV1,
          afterPillSheetGroup: updatedPillSheetGroupV1,
        );
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final revertTakePill = RevertTakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await revertTakePill(
          pillSheetGroup: pillSheetGroupV1,
          pageIndex: 0,
          targetRevertPillNumberIntoPillSheet: 3,
        );

        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV1),
        ).called(1);
        expect(result, updatedPillSheetGroupV1);

        // V1ではlastTakenDateのみが更新される
        expect(result!.pillSheets[0].lastTakenDate, revertDate);
      });
    });

    group("異なるPillSheetTypeでのテスト", () {
      test("pillsheet_21でrevert対象日以降のpillTakensがクリアされる", () async {
        final mockNowDay2 = DateTime.parse("2022-07-25T19:02:00");
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowDay2);

        const sheetType = PillSheetType.pillsheet_21;
        final activePillSheetV2 = PillSheet.v2(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-07-24"),
          createdAt: now(),
          // //  pillTakenCount: 2,
          pills: List.generate(sheetType.totalCount, (index) {
            if (index <= 1) {
              return Pill(
                index: index,
                takenCount: 2,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-24",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-24",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            }
            return Pill(
              index: index,
              takenCount: 2,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            );
          }),
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

        final revertDate = DateTime.parse("2022-07-24");
        final updatedActivePillSheetV2 = activePillSheetV2
            .revertedPillSheet(revertDate)
            .copyWith(restDurations: []);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(
          pillSheets: [updatedActivePillSheetV2],
        );
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).thenReturn(updatedPillSheetGroupV2);

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
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
        verify(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).called(1);
        expect(result, updatedPillSheetGroupV2);

        final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
        expect(updatedPillSheet.pills[0].pillTakens.length, 2);
        expect(updatedPillSheet.pills[1].pillTakens.length, 0);
      });

      test("pillsheet_24_0でrevert対象日以降のpillTakensがクリアされる", () async {
        final mockNowDay2 = DateTime.parse("2022-07-25T19:02:00");
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowDay2);

        const sheetType = PillSheetType.pillsheet_24_0;
        final activePillSheetV2 = PillSheet.v2(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-07-24"),
          createdAt: now(),
          // //  pillTakenCount: 2,
          pills: List.generate(sheetType.totalCount, (index) {
            if (index <= 1) {
              return Pill(
                index: index,
                takenCount: 2,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-24",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-24",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            }
            return Pill(
              index: index,
              takenCount: 2,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            );
          }),
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

        final revertDate = DateTime.parse("2022-07-24");
        final updatedActivePillSheetV2 = activePillSheetV2
            .revertedPillSheet(revertDate)
            .copyWith(restDurations: []);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(
          pillSheets: [updatedActivePillSheetV2],
        );
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).thenReturn(updatedPillSheetGroupV2);

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
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
        verify(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).called(1);
        expect(result, updatedPillSheetGroupV2);

        final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
        expect(updatedPillSheet.pills[0].pillTakens.length, 2);
        expect(updatedPillSheet.pills[1].pillTakens.length, 0);
      });

      test("pillsheet_28_0でrevert対象日以降のpillTakensがクリアされる", () async {
        final mockNowDay2 = DateTime.parse("2022-07-25T19:02:00");
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowDay2);

        const sheetType = PillSheetType.pillsheet_28_0;
        final activePillSheetV2 = PillSheet.v2(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-07-24"),
          createdAt: now(),
          // //  pillTakenCount: 2,
          pills: List.generate(sheetType.totalCount, (index) {
            if (index <= 1) {
              return Pill(
                index: index,
                takenCount: 2,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-24",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-24",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            }
            return Pill(
              index: index,
              takenCount: 2,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            );
          }),
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

        final revertDate = DateTime.parse("2022-07-24");
        final updatedActivePillSheetV2 = activePillSheetV2
            .revertedPillSheet(revertDate)
            .copyWith(restDurations: []);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(
          pillSheets: [updatedActivePillSheetV2],
        );
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).thenReturn(updatedPillSheetGroupV2);

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
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
        verify(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).called(1);
        expect(result, updatedPillSheetGroupV2);

        final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
        expect(updatedPillSheet.pills[0].pillTakens.length, 2);
        expect(updatedPillSheet.pills[1].pillTakens.length, 0);
      });

      test("pillsheet_28_4でrevert対象日以降のpillTakensがクリアされる", () async {
        final mockNowDay2 = DateTime.parse("2022-07-25T19:02:00");
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowDay2);

        const sheetType = PillSheetType.pillsheet_28_4;
        final activePillSheetV2 = PillSheet.v2(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-07-24"),
          createdAt: now(),
          //  pillTakenCount: 2,
          pills: List.generate(sheetType.totalCount, (index) {
            if (index <= 1) {
              return Pill(
                index: index,
                takenCount: 2,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-24",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-24",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            }
            return Pill(
              index: index,
              takenCount: 2,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            );
          }),
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

        final revertDate = DateTime.parse("2022-07-24");
        final updatedActivePillSheetV2 = activePillSheetV2
            .revertedPillSheet(revertDate)
            .copyWith(restDurations: []);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(
          pillSheets: [updatedActivePillSheetV2],
        );
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).thenReturn(updatedPillSheetGroupV2);

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
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
        verify(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).called(1);
        expect(result, updatedPillSheetGroupV2);

        final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
        expect(updatedPillSheet.pills[0].pillTakens.length, 2);
        expect(updatedPillSheet.pills[1].pillTakens.length, 0);
      });
    });

    group("日付の境界値テスト", () {
      test("月をまたぐ日付（7/31 → 8/1）でのrevert", () async {
        // 8/1までのピルを飲んだ状態で、8/1をrevertする
        final mockNowAug1 = DateTime.parse("2022-08-01T19:02:00");
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowAug1);

        const sheetType = PillSheetType.pillsheet_28_7;
        final activePillSheetV2 = PillSheet.v2(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-07-31"),
          createdAt: now(),
          //  pillTakenCount: 2,
          pills: List.generate(sheetType.totalCount, (index) {
            if (index <= 1) {
              return Pill(
                index: index,
                takenCount: 2,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-31",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-07-31",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            }
            return Pill(
              index: index,
              takenCount: 2,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            );
          }),
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

        // 2日目（8/1）をrevert → revertDate = 7/31
        final revertDate = DateTime.parse("2022-07-31");
        final updatedActivePillSheetV2 = activePillSheetV2
            .revertedPillSheet(revertDate)
            .copyWith(restDurations: []);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(
          pillSheets: [updatedActivePillSheetV2],
        );
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).thenReturn(updatedPillSheetGroupV2);

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
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
        verify(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).called(1);
        expect(result, updatedPillSheetGroupV2);

        final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
        expect(updatedPillSheet.pills[0].pillTakens.length, 2);
        expect(updatedPillSheet.pills[1].pillTakens.length, 0);
      });

      test("年をまたぐ日付（12/31 → 1/1）でのrevert", () async {
        // 1/1までのピルを飲んだ状態で、1/1をrevertする
        final mockNowJan1 = DateTime.parse("2023-01-01T19:02:00");
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowJan1);

        const sheetType = PillSheetType.pillsheet_28_7;
        final activePillSheetV2 = PillSheet.v2(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-12-31"),
          createdAt: now(),
          //  pillTakenCount: 2,
          pills: List.generate(sheetType.totalCount, (index) {
            if (index <= 1) {
              return Pill(
                index: index,
                takenCount: 2,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-12-31",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2022-12-31",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            }
            return Pill(
              index: index,
              takenCount: 2,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            );
          }),
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

        // 2日目（1/1）をrevert → revertDate = 12/31
        final revertDate = DateTime.parse("2022-12-31");
        final updatedActivePillSheetV2 = activePillSheetV2
            .revertedPillSheet(revertDate)
            .copyWith(restDurations: []);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(
          pillSheets: [updatedActivePillSheetV2],
        );
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).thenReturn(updatedPillSheetGroupV2);

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
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
        verify(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).called(1);
        expect(result, updatedPillSheetGroupV2);

        final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
        expect(updatedPillSheet.pills[0].pillTakens.length, 2);
        expect(updatedPillSheet.pills[1].pillTakens.length, 0);
      });

      test("うるう年の2/29を含む日付でのrevert", () async {
        // 2/29までのピルを飲んだ状態で、2/29をrevertする（2024年はうるう年）
        final mockNowFeb29 = DateTime.parse("2024-02-29T19:02:00");
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowFeb29);

        const sheetType = PillSheetType.pillsheet_28_7;
        final activePillSheetV2 = PillSheet.v2(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2024-02-28"),
          createdAt: now(),
          //  pillTakenCount: 2,
          pills: List.generate(sheetType.totalCount, (index) {
            if (index <= 1) {
              return Pill(
                index: index,
                takenCount: 2,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2024-02-28",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2024-02-28",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            }
            return Pill(
              index: index,
              takenCount: 2,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            );
          }),
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

        // 2日目（2/29）をrevert → revertDate = 2/28
        final revertDate = DateTime.parse("2024-02-28");
        final updatedActivePillSheetV2 = activePillSheetV2
            .revertedPillSheet(revertDate)
            .copyWith(restDurations: []);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(
          pillSheets: [updatedActivePillSheetV2],
        );
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).thenReturn(updatedPillSheetGroupV2);

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
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
        verify(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).called(1);
        expect(result, updatedPillSheetGroupV2);

        final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
        expect(updatedPillSheet.pills[0].pillTakens.length, 2);
        expect(updatedPillSheet.pills[1].pillTakens.length, 0);
      });

      test("うるう年でない年の2月末日でのrevert", () async {
        // 3/1までのピルを飲んだ状態で、3/1をrevertする（2023年はうるう年でない）
        final mockNowMar1 = DateTime.parse("2023-03-01T19:02:00");
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowMar1);

        const sheetType = PillSheetType.pillsheet_28_7;
        final activePillSheetV2 = PillSheet.v2(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2023-02-28"),
          createdAt: now(),
          //  pillTakenCount: 2,
          pills: List.generate(sheetType.totalCount, (index) {
            if (index <= 1) {
              return Pill(
                index: index,
                takenCount: 2,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2023-02-28",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse(
                      "2023-02-28",
                    ).add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            }
            return Pill(
              index: index,
              takenCount: 2,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            );
          }),
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

        // 2日目（3/1）をrevert → revertDate = 2/28
        final revertDate = DateTime.parse("2023-02-28");
        final updatedActivePillSheetV2 = activePillSheetV2
            .revertedPillSheet(revertDate)
            .copyWith(restDurations: []);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(
          pillSheets: [updatedActivePillSheetV2],
        );
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).thenReturn(updatedPillSheetGroupV2);

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
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
        verify(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV2),
        ).called(1);
        expect(result, updatedPillSheetGroupV2);

        final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
        expect(updatedPillSheet.pills[0].pillTakens.length, 2);
        expect(updatedPillSheet.pills[1].pillTakens.length, 0);
      });
    });

    group("服用お休み中", () {
      // 3日目までのピルを飲んだ後、2022-07-26 に服用お休みを開始した状態で 3日目をrevertする
      final mockNowDay4 = DateTime.parse("2022-07-27T19:02:00");
      const sheetType = PillSheetType.pillsheet_28_7;

      test("服用お休みが継続中(endDateがnull)の場合はv1で例外を投げて書き込まない", () async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowDay4);

        final activePillSheetV1 = PillSheet.v1(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-07-24"),
          lastTakenDate: DateTime.parse("2022-07-26"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-07-26"),
              createdDate: DateTime.parse("2022-07-26"),
            ),
          ],
        );
        final pillSheetGroupV1 = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [activePillSheetV1.id!],
          pillSheets: [activePillSheetV1],
          createdAt: mockNow,
        );
        final batchFactory = MockBatchFactory();
        final revertTakePill = RevertTakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: MockBatchSetPillSheetModifiedHistory(),
          batchSetPillSheetGroup: MockBatchSetPillSheetGroup(),
        );

        await expectLater(
          revertTakePill(
            pillSheetGroup: pillSheetGroupV1,
            pageIndex: 0,
            targetRevertPillNumberIntoPillSheet: 3,
          ),
          throwsA(isA<FormatException>()),
        );
        verifyNever(batchFactory.batch());
      });

      test("服用お休みが継続中(endDateがnull)の場合はv2で例外を投げて書き込まない", () async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowDay4);

        final activePillSheetV2 = PillSheet.v2(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-07-24"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-07-26"),
              createdDate: DateTime.parse("2022-07-26"),
            ),
          ],
          pills: Pill.testGenerateAndIterateTo(
            pillSheetType: sheetType,
            fromDate: DateTime.parse("2022-07-24"),
            lastTakenDate: DateTime.parse("2022-07-26"),
            pillTakenCount: 1,
          ),
        );
        final pillSheetGroupV2 = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [activePillSheetV2.id!],
          pillSheets: [activePillSheetV2],
          createdAt: mockNow,
        );
        final batchFactory = MockBatchFactory();
        final revertTakePill = RevertTakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: MockBatchSetPillSheetModifiedHistory(),
          batchSetPillSheetGroup: MockBatchSetPillSheetGroup(),
        );

        await expectLater(
          revertTakePill(
            pillSheetGroup: pillSheetGroupV2,
            pageIndex: 0,
            targetRevertPillNumberIntoPillSheet: 3,
          ),
          throwsA(isA<FormatException>()),
        );
        verifyNever(batchFactory.batch());
      });

      test("服用再開予定日(endDate)が明日の場合は服用お休み中として例外を投げる", () async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowDay4);

        final activePillSheetV1 = PillSheet.v1(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-07-24"),
          lastTakenDate: DateTime.parse("2022-07-26"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-07-26"),
              createdDate: DateTime.parse("2022-07-26"),
              endDate: DateTime.parse("2022-07-28"),
            ),
          ],
        );
        final pillSheetGroupV1 = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [activePillSheetV1.id!],
          pillSheets: [activePillSheetV1],
          createdAt: mockNow,
        );
        final batchFactory = MockBatchFactory();
        final revertTakePill = RevertTakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: MockBatchSetPillSheetModifiedHistory(),
          batchSetPillSheetGroup: MockBatchSetPillSheetGroup(),
        );

        await expectLater(
          revertTakePill(
            pillSheetGroup: pillSheetGroupV1,
            pageIndex: 0,
            targetRevertPillNumberIntoPillSheet: 3,
          ),
          throwsA(isA<FormatException>()),
        );
        verifyNever(batchFactory.batch());
      });

      test("服用再開予定日(endDate)が今日の場合は服用お休みが終わっているため例外を投げずにrevertする", () async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNowDay4);

        final activePillSheetV1 = PillSheet.v1(
          id: "active_pill_sheet_id",
          groupIndex: 0,
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-07-24"),
          lastTakenDate: DateTime.parse("2022-07-26"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-07-26"),
              createdDate: DateTime.parse("2022-07-26"),
              endDate: DateTime.parse("2022-07-27"),
            ),
          ],
        );
        final pillSheetGroupV1 = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [activePillSheetV1.id!],
          pillSheets: [activePillSheetV1],
          createdAt: mockNow,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        // targetRevertPillNumberIntoPillSheet = 3 (3番目のピルをrevert)
        // 服用お休み(2022-07-26〜2022-07-27)の1日分だけ3番目のピルの服用予定日が2022-07-27にずれるため、revertDate = 2022-07-26 (その1日前)
        // 服用お休みの開始日(2022-07-26)がrevertDateより後ろにならないため服用お休みのデータは消える
        final revertDate = DateTime.parse("2022-07-26");
        final updatedPillSheetGroupV1 = pillSheetGroupV1.copyWith(
          pillSheets: [
            (activePillSheetV1 as PillSheetV1).copyWith(lastTakenDate: revertDate, restDurations: []),
          ],
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroupV1),
        ).thenReturn(updatedPillSheetGroupV1);
        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          beforePillSheetGroup: pillSheetGroupV1,
          afterPillSheetGroup: updatedPillSheetGroupV1,
        );
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final revertTakePill = RevertTakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await revertTakePill(
          pillSheetGroup: pillSheetGroupV1,
          pageIndex: 0,
          targetRevertPillNumberIntoPillSheet: 3,
        );

        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroupV1)).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        expect(result, updatedPillSheetGroupV1);
      });
    });
  });
}
