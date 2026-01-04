import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../helper/mock.mocks.dart';

void main() {
  final mockNow = DateTime.parse("2022-07-24T19:02:00");
  late PillSheet previousPillSheet;
  late PillSheet activePillSheet;
  late PillSheet nextPillSheet;
  late PillSheetGroup pillSheetGroup;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(mockNow);
  });

  void prepare({required DateTime activePillSheetBeginDate, required DateTime? activePillSheetLastTakenDate}) {
    previousPillSheet = PillSheet.v1(
      id: "previous_pill_sheet_id",
      groupIndex: 0,
      typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
      beginingDate: activePillSheetBeginDate.subtract(const Duration(days: 28)),
      lastTakenDate: activePillSheetBeginDate.subtract(const Duration(days: 1)),
      createdAt: now(),
    );
    activePillSheet = PillSheet.v1(
      id: "active_pill_sheet_id",
      groupIndex: 1,
      typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
      beginingDate: activePillSheetBeginDate,
      lastTakenDate: activePillSheetLastTakenDate,
      createdAt: now(),
    );
    nextPillSheet = PillSheet.v1(
      id: "next_pill_sheet_id",
      groupIndex: 2,
      typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
      beginingDate: activePillSheetBeginDate.add(const Duration(days: 28)),
      lastTakenDate: null,
      createdAt: now(),
    );
  }

  group("#TakePill", () {
    final activePillSheetBeginDate = mockNow.date();

    setUp(() {
      prepare(activePillSheetBeginDate: activePillSheetBeginDate, activePillSheetLastTakenDate: null);
    });

    group("pillTakenCount = 1", () {
      group("one pill sheet", () {
        setUp(() {
          activePillSheet = activePillSheet.copyWith(groupIndex: 0);
          pillSheetGroup = PillSheetGroup(
            id: "group_id",
            pillSheetIDs: [activePillSheet.id!],
            pillSheets: [activePillSheet],
            createdAt: mockNow,
          );
        });

        test("take pill", () async {
          final takenDate = mockNow.add(const Duration(seconds: 1));

          final batchFactory = MockBatchFactory();
          final batch = MockWriteBatch();
          when(batchFactory.batch()).thenReturn(batch);

          final updatedActivePillSheet = activePillSheet.copyWith(lastTakenDate: takenDate);

          final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
          final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedActivePillSheet]);
          when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

          final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
          final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id,
            isQuickRecord: false,
            before: activePillSheet,
            after: updatedActivePillSheet,
            beforePillSheetGroup: pillSheetGroup,
            afterPillSheetGroup: updatedPillSheetGroup,
          );
          when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

          final takePill = TakePill(
            batchFactory: batchFactory,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
            batchSetPillSheetGroup: batchSetPillSheetGroup,
          );
          final result = await takePill(
            takenDate: takenDate,
            activePillSheet: activePillSheet,
            pillSheetGroup: pillSheetGroup,
            isQuickRecord: false,
          );

          verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
          verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);

          expect(result, updatedPillSheetGroup);
        });

        test("activePillSheet.todayPillIsAlreadyTaken", () async {
          final takenDate = mockNow.add(const Duration(seconds: 1));
          activePillSheet = activePillSheet.copyWith(lastTakenDate: takenDate);

          final batchFactory = MockBatchFactory();

          final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
          final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

          final takePill = TakePill(
            batchFactory: batchFactory,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
            batchSetPillSheetGroup: batchSetPillSheetGroup,
          );
          final result = await takePill(
            takenDate: takenDate,
            activePillSheet: activePillSheet,
            pillSheetGroup: pillSheetGroup,
            isQuickRecord: false,
          );

          expect(result, null);
        });
      });
    });

    group("pillTakenCount = 2", () {
      group("one pill sheet", () {
        test("1回目のtake pillでpillTakensに1つ追加される", () async {
          final takenDate = mockNow.add(const Duration(seconds: 1));

          const sheetType = PillSheetType.pillsheet_28_7;
          final activePillSheetV2 = PillSheet.v2(
            id: "active_pill_sheet_id",
            groupIndex: 0,
            typeInfo: sheetType.typeInfo,
            beginingDate: mockNow.date(),
            lastTakenDate: null,
            createdAt: now(),
            pillTakenCount: 2,
            pills: List.generate(
              sheetType.totalCount,
              (index) => Pill(
                index: index,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [],
              ),
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

          final updatedActivePillSheetV2 = activePillSheetV2.takenPillSheet(takenDate);

          final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
          final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(pillSheets: [updatedActivePillSheetV2]);
          when(batchSetPillSheetGroup(batch, updatedPillSheetGroupV2)).thenReturn(updatedPillSheetGroupV2);

          final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
          final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroupV2.id,
            isQuickRecord: false,
            before: activePillSheetV2,
            after: updatedActivePillSheetV2,
            beforePillSheetGroup: pillSheetGroupV2,
            afterPillSheetGroup: updatedPillSheetGroupV2,
          );
          when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

          final takePill = TakePill(
            batchFactory: batchFactory,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
            batchSetPillSheetGroup: batchSetPillSheetGroup,
          );
          final result = await takePill(
            takenDate: takenDate,
            activePillSheet: activePillSheetV2,
            pillSheetGroup: pillSheetGroupV2,
            isQuickRecord: false,
          );

          verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
          verify(batchSetPillSheetGroup(batch, updatedPillSheetGroupV2)).called(1);
          expect(result, updatedPillSheetGroupV2);

          // 1番目のピルのpillTakensに1つ追加されていることを確認
          final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
          expect(updatedPillSheet.pills[0].pillTakens.length, 1);
        });

        test("2回目のtake pillでpillTakensに2つ目が追加される", () async {
          final takenDate = mockNow.add(const Duration(seconds: 1));

          const sheetType = PillSheetType.pillsheet_28_7;
          // 1回目の服用済み状態
          final activePillSheetV2 = PillSheet.v2(
            id: "active_pill_sheet_id",
            groupIndex: 0,
            typeInfo: sheetType.typeInfo,
            beginingDate: mockNow.date(),
            lastTakenDate: mockNow,
            createdAt: now(),
            pillTakenCount: 2,
            pills: List.generate(
              sheetType.totalCount,
              (index) {
                if (index == 0) {
                  return Pill(
                    index: index,
                    createdDateTime: now(),
                    updatedDateTime: now(),
                    pillTakens: [
                      PillTaken(
                        recordedTakenDateTime: mockNow,
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

          final updatedActivePillSheetV2 = activePillSheetV2.takenPillSheet(takenDate);

          final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
          final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(pillSheets: [updatedActivePillSheetV2]);
          when(batchSetPillSheetGroup(batch, updatedPillSheetGroupV2)).thenReturn(updatedPillSheetGroupV2);

          final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
          final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroupV2.id,
            isQuickRecord: false,
            before: activePillSheetV2,
            after: updatedActivePillSheetV2,
            beforePillSheetGroup: pillSheetGroupV2,
            afterPillSheetGroup: updatedPillSheetGroupV2,
          );
          when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

          final takePill = TakePill(
            batchFactory: batchFactory,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
            batchSetPillSheetGroup: batchSetPillSheetGroup,
          );
          final result = await takePill(
            takenDate: takenDate,
            activePillSheet: activePillSheetV2,
            pillSheetGroup: pillSheetGroupV2,
            isQuickRecord: false,
          );

          verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
          verify(batchSetPillSheetGroup(batch, updatedPillSheetGroupV2)).called(1);
          expect(result, updatedPillSheetGroupV2);

          // 1番目のピルのpillTakensに2つ追加されていることを確認
          final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
          expect(updatedPillSheet.pills[0].pillTakens.length, 2);
        });

        test("2錠飲み終わった後のtake pillはnullを返す", () async {
          final takenDate = mockNow.add(const Duration(seconds: 1));

          const sheetType = PillSheetType.pillsheet_28_7;
          // 2回の服用済み状態
          final activePillSheetV2 = PillSheet.v2(
            id: "active_pill_sheet_id",
            groupIndex: 0,
            typeInfo: sheetType.typeInfo,
            beginingDate: mockNow.date(),
            lastTakenDate: mockNow,
            createdAt: now(),
            pillTakenCount: 2,
            pills: List.generate(
              sheetType.totalCount,
              (index) {
                if (index == 0) {
                  return Pill(
                    index: index,
                    createdDateTime: now(),
                    updatedDateTime: now(),
                    pillTakens: [
                      PillTaken(
                        recordedTakenDateTime: mockNow,
                        createdDateTime: now(),
                        updatedDateTime: now(),
                      ),
                      PillTaken(
                        recordedTakenDateTime: mockNow,
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
          final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
          final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();

          final takePill = TakePill(
            batchFactory: batchFactory,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
            batchSetPillSheetGroup: batchSetPillSheetGroup,
          );
          final result = await takePill(
            takenDate: takenDate,
            activePillSheet: activePillSheetV2,
            pillSheetGroup: pillSheetGroupV2,
            isQuickRecord: false,
          );

          // すでに全錠服用済みなのでnullを返す
          expect(result, null);
        });

        test("過去のピルを一括服用: 対象より前は全錠、最後は1錠記録", () async {
          // 3日目に服用 (1日目、2日目は未服用)
          final mockNowDay3 = DateTime.parse("2022-07-27T19:02:00");
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(mockNowDay3);

          final takenDate = mockNowDay3.add(const Duration(seconds: 1));

          const sheetType = PillSheetType.pillsheet_28_7;
          final activePillSheetV2 = PillSheet.v2(
            id: "active_pill_sheet_id",
            groupIndex: 0,
            typeInfo: sheetType.typeInfo,
            beginingDate: DateTime.parse("2022-07-24"),
            lastTakenDate: null,
            createdAt: now(),
            pillTakenCount: 2,
            pills: List.generate(
              sheetType.totalCount,
              (index) => Pill(
                index: index,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [],
              ),
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

          final updatedActivePillSheetV2 = activePillSheetV2.takenPillSheet(takenDate);

          final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
          final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(pillSheets: [updatedActivePillSheetV2]);
          when(batchSetPillSheetGroup(batch, updatedPillSheetGroupV2)).thenReturn(updatedPillSheetGroupV2);

          final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
          final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroupV2.id,
            isQuickRecord: false,
            before: activePillSheetV2,
            after: updatedActivePillSheetV2,
            beforePillSheetGroup: pillSheetGroupV2,
            afterPillSheetGroup: updatedPillSheetGroupV2,
          );
          when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

          final takePill = TakePill(
            batchFactory: batchFactory,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
            batchSetPillSheetGroup: batchSetPillSheetGroup,
          );
          final result = await takePill(
            takenDate: takenDate,
            activePillSheet: activePillSheetV2,
            pillSheetGroup: pillSheetGroupV2,
            isQuickRecord: false,
          );

          verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
          verify(batchSetPillSheetGroup(batch, updatedPillSheetGroupV2)).called(1);
          expect(result, updatedPillSheetGroupV2);

          // 1日目、2日目は全錠(2つ)、4日目は1錠
          final updatedPillSheet = result!.pillSheets[0] as PillSheetV2;
          expect(updatedPillSheet.pills[0].pillTakens.length, 2);
          expect(updatedPillSheet.pills[1].pillTakens.length, 2);
          expect(updatedPillSheet.pills[2].pillTakens.length, 2);
          expect(updatedPillSheet.pills[3].pillTakens.length, 1);
        });
      });
    });

    group("three pill sheet", () {
      test("take pill", () async {
        final takenDate = mockNow.add(const Duration(seconds: 1));
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activePillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activePillSheet, nextPillSheet],
          createdAt: mockNow,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedActivePillSheet = activePillSheet.copyWith(lastTakenDate: takenDate);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: pillSheetGroup.id,
          isQuickRecord: false,
          before: activePillSheet,
          after: updatedActivePillSheet,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activePillSheet: activePillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        expect(result, updatedPillSheetGroup);
      });

      test("activePillSheet.todayPillIsAlreadyTaken", () async {
        final takenDate = mockNow.add(const Duration(seconds: 1));
        activePillSheet = activePillSheet.copyWith(lastTakenDate: takenDate);
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activePillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activePillSheet, nextPillSheet],
          createdAt: mockNow,
        );

        final batchFactory = MockBatchFactory();

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activePillSheet: activePillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        expect(result, null);
      });

      test("bounday test. taken activePillSheet.estimatedEndTakenDate", () async {
        final takenDate = activePillSheet.estimatedEndTakenDate;
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activePillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activePillSheet, nextPillSheet],
          createdAt: mockNow,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedActivePillSheet = activePillSheet.copyWith(lastTakenDate: takenDate);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: pillSheetGroup.id,
          isQuickRecord: false,
          before: activePillSheet,
          after: updatedActivePillSheet,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activePillSheet: activePillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);

        expect(result, updatedPillSheetGroup);
      });
      test("bounday test. taken activePillSheet.estimatedEndTakenDate + 1.second. it is over active pill sheet range pattern", () async {
        final takenDate = activePillSheet.estimatedEndTakenDate.add(const Duration(seconds: 1));
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activePillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activePillSheet, nextPillSheet],
          createdAt: mockNow,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedActivePillSheet = activePillSheet.copyWith(lastTakenDate: activePillSheet.estimatedEndTakenDate);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: pillSheetGroup.id,
          isQuickRecord: false,
          before: activePillSheet,
          after: updatedActivePillSheet,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activePillSheet: activePillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);

        expect(result, updatedPillSheetGroup);
      });

      test(
          "bounday test. activePillSheet.lastTakenDate != null and taken activePillSheet.estimatedEndTakenDate + 1.second. it is over active pill sheet range pattern. ",
          () async {
        final takenDate = activePillSheet.estimatedEndTakenDate.add(const Duration(seconds: 1));
        final lastTakenDate = activePillSheet.estimatedEndTakenDate.subtract(const Duration(days: 10));
        activePillSheet = activePillSheet.copyWith(
          lastTakenDate: lastTakenDate,
        );
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activePillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activePillSheet, nextPillSheet],
          createdAt: mockNow,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedActivePillSheet = activePillSheet.copyWith(lastTakenDate: activePillSheet.estimatedEndTakenDate);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: pillSheetGroup.id,
          isQuickRecord: false,
          before: activePillSheet,
          after: updatedActivePillSheet,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activePillSheet: activePillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verifyNever(batchSetPillSheetModifiedHistory(batch, history));
        verifyNever(batchSetPillSheetGroup(batch, updatedPillSheetGroup));
        expect(result, isNull);
      });
      test("when previous pill sheet is not taken all.", () async {
        final takenDate = mockNow.add(const Duration(seconds: 1));
        final lastTakenDate = previousPillSheet.lastTakenDate!.subtract(const Duration(days: 1));
        previousPillSheet = previousPillSheet.copyWith(
          lastTakenDate: lastTakenDate,
        );
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activePillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activePillSheet, nextPillSheet],
          createdAt: mockNow,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedPreviousPillSheet = previousPillSheet.copyWith(lastTakenDate: previousPillSheet.estimatedEndTakenDate);
        final updatedActivePillSheet = activePillSheet.copyWith(lastTakenDate: takenDate);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: pillSheetGroup.id,
          isQuickRecord: false,
          before: previousPillSheet,
          after: updatedActivePillSheet,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activePillSheet: activePillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        expect(result, updatedPillSheetGroup);
      });
      test("when previous pill sheet is not taken all. and takenDate is previous pill sheet estimate last taken date", () async {
        final lastTakenDate = previousPillSheet.lastTakenDate!.subtract(const Duration(days: 1));
        previousPillSheet = previousPillSheet.copyWith(
          lastTakenDate: lastTakenDate,
        );
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activePillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activePillSheet, nextPillSheet],
          createdAt: mockNow,
        );
        final takenDate = previousPillSheet.estimatedEndTakenDate;

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedPreviousPillSheet = previousPillSheet.copyWith(lastTakenDate: previousPillSheet.estimatedEndTakenDate);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedPreviousPillSheet, activePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: pillSheetGroup.id,
          isQuickRecord: false,
          before: previousPillSheet,
          after: updatedPreviousPillSheet,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activePillSheet: activePillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        expect(result, updatedPillSheetGroup);
      });
      // Bugfix https://github.com/bannzai/Pilll/pull/651

      test(
          "when previous pill sheet is not taken all. And active pill sheet lastTakenDate equal beginDate minus 1 that means reverted taken first pill. And record previous pill sheet last taken date",
          () async {
        final previousPillSheetLastTakenDate = previousPillSheet.lastTakenDate!.subtract(const Duration(days: 1));
        previousPillSheet = previousPillSheet.copyWith(
          lastTakenDate: previousPillSheetLastTakenDate,
        );
        final activePillSheetLastTakenDate = activePillSheet.beginingDate.subtract(const Duration(days: 1));
        activePillSheet = activePillSheet.copyWith(
          lastTakenDate: activePillSheetLastTakenDate,
        );

        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activePillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activePillSheet, nextPillSheet],
          createdAt: mockNow,
        );
        final takenDate = previousPillSheet.estimatedEndTakenDate.subtract(const Duration(seconds: 1));

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedPreviousPillSheet = previousPillSheet.copyWith(lastTakenDate: takenDate);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedPreviousPillSheet, activePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: pillSheetGroup.id,
          isQuickRecord: false,
          before: previousPillSheet,
          after: updatedPreviousPillSheet,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activePillSheet: activePillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);

        expect(result, updatedPillSheetGroup);
      });

      test("Real case 1. Timesensitive pattern(takenDate(19:02:00) < beginingDate(19:02:21)) and with rest duration", () async {
        previousPillSheet = previousPillSheet.copyWith(
          beginingDate: DateTime.parse(
            "2022-06-22T19:02:21",
          ),
          lastTakenDate: DateTime.parse("2022-07-23T19:00:04"),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-07-14T18:25:41"),
              createdDate: DateTime.parse("2022-07-14T18:25:41"),
              endDate: DateTime.parse("2022-07-18T18:10:01"),
            )
          ],
        );

        activePillSheet = activePillSheet.copyWith(beginingDate: DateTime.parse("2022-07-24T19:02:21"));
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activePillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activePillSheet, nextPillSheet],
          createdAt: mockNow,
        );

        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activePillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activePillSheet, nextPillSheet],
          createdAt: mockNow,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final takenDate = DateTime.parse("2022-07-24T19:02:00");
        final updatedActivePillSheet = activePillSheet.copyWith(lastTakenDate: takenDate);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: pillSheetGroup.id,
          isQuickRecord: false,
          before: activePillSheet,
          after: updatedActivePillSheet,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activePillSheet: activePillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        expect(result, updatedPillSheetGroup);
      });
      test("Real case 2", () async {
        final mockToday = DateTime.parse("2022-08-11T19:06:00");
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);

        previousPillSheet = previousPillSheet
            .copyWith(beginingDate: DateTime.parse("2022-06-23T00:00:00"))
            .copyWith(lastTakenDate: DateTime.parse("2022-07-20T00:00:00"));
        activePillSheet =
            activePillSheet.copyWith(beginingDate: DateTime.parse("2022-07-21T00:00:00")).copyWith(lastTakenDate: DateTime.parse("2022-08-11"));
        activePillSheet = activePillSheet.copyWith(restDurations: [
          RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-08-04T08:19:04"),
              createdDate: DateTime.parse("2022-08-04T08:19:04"),
              endDate: DateTime.parse("2022-08-04T08:19:17")),
          RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-08-04T08:19:32"),
              createdDate: DateTime.parse("2022-08-04T08:19:32"),
              endDate: DateTime.parse("2022-08-07T10:48:19")),
          RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-08-07T10:48:22"),
              createdDate: DateTime.parse("2022-08-07T10:48:22"),
              endDate: DateTime.parse("2022-08-08T19:47:49"))
        ]);
        nextPillSheet = PillSheet.v1(
          id: "next_pill_sheet_id",
          groupIndex: 2,
          typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
          beginingDate: activePillSheetBeginDate.add(const Duration(days: 28)),
          lastTakenDate: null,
          createdAt: now(),
        );
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activePillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activePillSheet, nextPillSheet],
          createdAt: mockToday,
        );

        final takenDate = mockToday.add(const Duration(seconds: 1));
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activePillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activePillSheet, nextPillSheet],
          createdAt: mockToday,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedActivePillSheet = activePillSheet.copyWith(lastTakenDate: takenDate);

        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedActivePillSheet]);
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(pillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: pillSheetGroup.id,
          isQuickRecord: false,
          before: activePillSheet,
          after: updatedActivePillSheet,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activePillSheet: activePillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verifyNever(batchSetPillSheetModifiedHistory(batch, history));
        verifyNever(batchSetPillSheetGroup(batch, pillSheetGroup));
        expect(result, null);
      });
    });
  });
}
