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
      beginDate: activePillSheetBeginDate.subtract(const Duration(days: 28)),
      lastTakenDate: activePillSheetBeginDate.subtract(const Duration(days: 1)),
      createdAt: now(),
    );
    activePillSheet = PillSheet.v1(
      id: "active_pill_sheet_id",
      groupIndex: 1,
      typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
      beginDate: activePillSheetBeginDate,
      lastTakenDate: activePillSheetLastTakenDate,
      createdAt: now(),
    );
    nextPillSheet = PillSheet.v1(
      id: "next_pill_sheet_id",
      groupIndex: 2,
      typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
      beginDate: activePillSheetBeginDate.add(const Duration(days: 28)),
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

          final updatedActivePillSheet = (activePillSheet as PillSheetV1).copyWith(lastTakenDate: takenDate);

          final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
          final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedActivePillSheet]);
          when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

          final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
          final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            isQuickRecord: false,
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
          activePillSheet = (activePillSheet as PillSheetV1).copyWith(lastTakenDate: takenDate);

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
            restDurations: [],
            typeInfo: sheetType.typeInfo,
            beginDate: mockNow.date(),
            createdAt: now(),
            //  pillTakenCount: 2,
            pills: List.generate(
              sheetType.totalCount,
              (index) => Pill(
                index: index,
                takenCount: 2,
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
            isQuickRecord: false,
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
            restDurations: [],
            typeInfo: sheetType.typeInfo,
            beginDate: mockNow.date(),
            createdAt: now(),
            //  pillTakenCount: 2,
            pills: List.generate(
              sheetType.totalCount,
              (index) {
                if (index == 0) {
                  return Pill(
                    index: index,
                    takenCount: 2,
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
                  takenCount: 2,
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
            isQuickRecord: false,
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
            restDurations: [],
            typeInfo: sheetType.typeInfo,
            beginDate: mockNow.date(),
            createdAt: now(),
            //  pillTakenCount: 2,
            pills: List.generate(
              sheetType.totalCount,
              (index) {
                if (index == 0) {
                  return Pill(
                    index: index,
                    takenCount: 2,
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
                  takenCount: 2,
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

        test("前日が未服用でも当日を記録すると前日までのピルも一括で記録される", () async {
          // 4日目に服用 (1,2,3日目は未服用)
          final mockNowDay4 = DateTime.parse("2022-07-27T19:02:00");
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(mockNowDay4);

          final takenDate = mockNowDay4.add(const Duration(seconds: 1));

          const sheetType = PillSheetType.pillsheet_28_7;
          final activePillSheetV2 = PillSheet.v2(
            id: "active_pill_sheet_id",
            groupIndex: 0,
            restDurations: [],
            typeInfo: sheetType.typeInfo,
            beginDate: DateTime.parse("2022-07-24"),
            createdAt: now(),
            pills: List.generate(
              sheetType.totalCount,
              (index) => Pill(
                index: index,
                takenCount: 2,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [],
              ),
            ),
          );

          // 4日目をタップすると1-3日目は完了、4日目は1回記録される
          final result = activePillSheetV2.takenPillSheet(takenDate) as PillSheetV2;

          // 1日目(index=0): 2回完了
          expect(result.pills[0].pillTakens.length, 2);
          // 2日目(index=1): 2回完了
          expect(result.pills[1].pillTakens.length, 2);
          // 3日目(index=2): 2回完了
          expect(result.pills[2].pillTakens.length, 2);
          // 4日目(index=3): 1回記録
          expect(result.pills[3].pillTakens.length, 1);
          // 5日目以降: 未記録
          expect(result.pills[4].pillTakens.length, 0);
        });
      });

      group("two pill sheets", () {
        test("2枚目のピルシートをタップ時、1枚目の最終日に2錠分の飲み残しがあっても全て完了する", () async {
          // 1枚目のピルシート: 最終日（28日目）に2錠分の飲み残しがある
          // 2枚目のピルシート: 1日目をタップ
          // 期待: 1枚目の最終日も全て完了（チェックマーク表示）

          final mockNowDay1 = DateTime.parse("2022-08-21T19:02:00");
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(mockNowDay1);

          const sheetType = PillSheetType.pillsheet_28_7;
          final previousBeginDate = DateTime.parse("2022-07-24");
          final activeBeginDate = DateTime.parse("2022-08-21");

          // 1枚目のピルシート: 27日目まで完了、28日目（最終日）は未服用
          final previousPillSheetV2 = PillSheet.v2(
            id: "previous_pill_sheet_id",
            groupIndex: 0,
            restDurations: [],
            typeInfo: sheetType.typeInfo,
            beginDate: previousBeginDate,
            createdAt: now(),
            pills: List.generate(
              sheetType.totalCount,
              (index) {
                if (index < 27) {
                  // 27日目まで完了
                  return Pill(
                    index: index,
                    takenCount: 2,
                    createdDateTime: now(),
                    updatedDateTime: now(),
                    pillTakens: [
                      PillTaken(
                        recordedTakenDateTime: previousBeginDate.add(Duration(days: index)),
                        createdDateTime: now(),
                        updatedDateTime: now(),
                      ),
                      PillTaken(
                        recordedTakenDateTime: previousBeginDate.add(Duration(days: index)),
                        createdDateTime: now(),
                        updatedDateTime: now(),
                      ),
                    ],
                  );
                }
                // 28日目（index=27）は未服用
                return Pill(
                  index: index,
                  takenCount: 2,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [],
                );
              },
            ),
          );

          // 2枚目のピルシート: 未服用
          final activePillSheetV2 = PillSheet.v2(
            id: "active_pill_sheet_id",
            groupIndex: 1,
            restDurations: [],
            typeInfo: sheetType.typeInfo,
            beginDate: activeBeginDate,
            createdAt: now(),
            pills: List.generate(
              sheetType.totalCount,
              (index) => Pill(
                index: index,
                takenCount: 2,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [],
              ),
            ),
          );

          final pillSheetGroupV2 = PillSheetGroup(
            id: "group_id",
            pillSheetIDs: [previousPillSheetV2.id!, activePillSheetV2.id!],
            pillSheets: [previousPillSheetV2, activePillSheetV2],
            createdAt: mockNowDay1,
          );

          final takenDate = mockNowDay1.add(const Duration(seconds: 1));

          final batchFactory = MockBatchFactory();
          final batch = MockWriteBatch();
          when(batchFactory.batch()).thenReturn(batch);

          // 1枚目は completeAllPills: true で全て完了
          final updatedPreviousPillSheetV2 = previousPillSheetV2.takenPillSheet(previousPillSheetV2.estimatedEndTakenDate, completeAllPills: true);
          // 2枚目は通常の服用記録
          final updatedActivePillSheetV2 = activePillSheetV2.takenPillSheet(takenDate);

          final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
          final updatedPillSheetGroupV2 = pillSheetGroupV2.copyWith(pillSheets: [updatedPreviousPillSheetV2, updatedActivePillSheetV2]);
          when(batchSetPillSheetGroup(batch, updatedPillSheetGroupV2)).thenReturn(updatedPillSheetGroupV2);

          final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
          final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            isQuickRecord: false,
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

          // 1枚目の最終日（28日目、index=27）が全て完了していることを確認
          final updatedPreviousPillSheet = result!.pillSheets[0] as PillSheetV2;
          expect(updatedPreviousPillSheet.pills[27].pillTakens.length, 2);
          expect(updatedPreviousPillSheet.pills[27].isCompleted, true);

          // 2枚目の1日目（index=0）に1回の記録があることを確認
          final updatedActivePillSheet = result.pillSheets[1] as PillSheetV2;
          expect(updatedActivePillSheet.pills[0].pillTakens.length, 1);
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

        final updatedActivePillSheet = (activePillSheet as PillSheetV1).copyWith(lastTakenDate: takenDate);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          isQuickRecord: false,
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
        activePillSheet = (activePillSheet as PillSheetV1).copyWith(lastTakenDate: takenDate);
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

        final updatedActivePillSheet = (activePillSheet as PillSheetV1).copyWith(lastTakenDate: takenDate);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          isQuickRecord: false,
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

        final updatedActivePillSheet = (activePillSheet as PillSheetV1).copyWith(lastTakenDate: activePillSheet.estimatedEndTakenDate);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          isQuickRecord: false,
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
        activePillSheet = (activePillSheet as PillSheetV1).copyWith(
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

        final updatedActivePillSheet = (activePillSheet as PillSheetV1).copyWith(lastTakenDate: activePillSheet.estimatedEndTakenDate);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          isQuickRecord: false,
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
        previousPillSheet = (previousPillSheet as PillSheetV1).copyWith(
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

        final updatedPreviousPillSheet = (previousPillSheet as PillSheetV1).copyWith(lastTakenDate: previousPillSheet.estimatedEndTakenDate);
        final updatedActivePillSheet = (activePillSheet as PillSheetV1).copyWith(lastTakenDate: takenDate);

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
        previousPillSheet = (previousPillSheet as PillSheetV1).copyWith(
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

        final updatedPreviousPillSheet = (previousPillSheet as PillSheetV1).copyWith(lastTakenDate: previousPillSheet.estimatedEndTakenDate);

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
        previousPillSheet = (previousPillSheet as PillSheetV1).copyWith(
          lastTakenDate: previousPillSheetLastTakenDate,
        );
        final activePillSheetLastTakenDate = activePillSheet.beginDate.subtract(const Duration(days: 1));
        activePillSheet = (activePillSheet as PillSheetV1).copyWith(
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

        final updatedPreviousPillSheet = (previousPillSheet as PillSheetV1).copyWith(lastTakenDate: takenDate);

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

      test("Real case 1. Timesensitive pattern(takenDate(19:02:00) < beginDate(19:02:21)) and with rest duration", () async {
        previousPillSheet = (previousPillSheet as PillSheetV1).copyWith(
          beginDate: DateTime.parse(
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

        activePillSheet = activePillSheet.copyWith(beginDate: DateTime.parse("2022-07-24T19:02:21"));
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
        final updatedActivePillSheet = (activePillSheet as PillSheetV1).copyWith(lastTakenDate: takenDate);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          isQuickRecord: false,
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

        previousPillSheet = (previousPillSheet.copyWith(beginDate: DateTime.parse("2022-06-23T00:00:00")) as PillSheetV1)
            .copyWith(lastTakenDate: DateTime.parse("2022-07-20T00:00:00"));
        activePillSheet = (activePillSheet.copyWith(beginDate: DateTime.parse("2022-07-21T00:00:00")) as PillSheetV1)
            .copyWith(lastTakenDate: DateTime.parse("2022-08-11"));
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
          beginDate: activePillSheetBeginDate.add(const Duration(days: 28)),
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

        final updatedActivePillSheet = (activePillSheet as PillSheetV1).copyWith(lastTakenDate: takenDate);

        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedActivePillSheet]);
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(pillSheetGroup);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          isQuickRecord: false,
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

  group("#TakenPillSheet extension", () {
    group("v2 前日のピルが未完了の場合の挙動", () {
      test("前日が部分的に服用済み（未完了）でも今日を記録すると前日も完了する", () {
        final mockTodayRepository = MockTodayService();
        final mockNow = DateTime.parse("2022-07-25");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNow);

        const sheetType = PillSheetType.pillsheet_28_7;
        // 1日目(7/24): 1回のみ服用（未完了）
        // 2日目(7/25): 今日、未服用
        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          beginDate: DateTime.parse("2022-07-24"),
          createdAt: now(),
          groupIndex: 0,
          restDurations: [],
          pills: List.generate(
            sheetType.totalCount,
            (index) {
              if (index == 0) {
                // 1日目: 1回のみ服用（未完了）
                return Pill(
                  index: index,
                  takenCount: 2,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(recordedTakenDateTime: DateTime.parse("2022-07-24"), createdDateTime: now(), updatedDateTime: now()),
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
            },
          ),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );

        // 今日（2日目）を記録すると、1日目も完了し、2日目は1回記録される
        final result = pillSheet.takenPillSheet(DateTime.parse("2022-07-25")) as PillSheetV2;

        // 1日目(index=0): 既存の1回 + 追加の1回 = 2回で完了
        expect(result.pills[0].pillTakens.length, 2);
        // 2日目(index=1): 1回記録
        expect(result.pills[1].pillTakens.length, 1);
        expect(result.lastTakenDate, DateTime.parse("2022-07-25"));
      });

      test("前日のピルが完了済みなら正常に服用記録を追加できる", () {
        final mockTodayRepository = MockTodayService();
        final mockNow = DateTime.parse("2022-07-25");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNow);

        const sheetType = PillSheetType.pillsheet_28_7;
        // 1日目(7/24): 2回服用完了
        // 2日目(7/25): 今日、未服用
        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          beginDate: DateTime.parse("2022-07-24"),
          createdAt: now(),
          groupIndex: 0,
          restDurations: [],
          //  pillTakenCount: 2,
          pills: List.generate(
            sheetType.totalCount,
            (index) {
              if (index == 0) {
                // 1日目: 2回服用完了
                return Pill(
                  index: index,
                  takenCount: 2,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(recordedTakenDateTime: DateTime.parse("2022-07-24"), createdDateTime: now(), updatedDateTime: now()),
                    PillTaken(recordedTakenDateTime: DateTime.parse("2022-07-24"), createdDateTime: now(), updatedDateTime: now()),
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
            },
          ),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );

        // 今日（2日目）の服用記録を追加
        final result = pillSheet.takenPillSheet(DateTime.parse("2022-07-25"));

        final resultV2 = result as PillSheetV2;
        expect(resultV2.pills[1].pillTakens.length, 1);
        expect(resultV2.lastTakenDate, DateTime.parse("2022-07-25"));
      });

      test("lastTakenDateが過去日で巻き戻らない", () {
        final mockTodayRepository = MockTodayService();
        final mockNow = DateTime.parse("2022-07-26");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNow);

        const sheetType = PillSheetType.pillsheet_28_7;
        // 1日目(7/24): 2回服用完了
        // 2日目(7/25): 2回服用完了
        // 3日目(7/26): 1回服用済み（今日の1回目）
        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          beginDate: DateTime.parse("2022-07-24"),
          createdAt: now(),
          groupIndex: 0,
          restDurations: [],
          //  pillTakenCount: 2,
          pills: List.generate(
            sheetType.totalCount,
            (index) {
              if (index <= 1) {
                // 1日目、2日目: 2回服用完了
                return Pill(
                  index: index,
                  takenCount: 2,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(
                        recordedTakenDateTime: DateTime.parse("2022-07-24").add(Duration(days: index)),
                        createdDateTime: now(),
                        updatedDateTime: now()),
                    PillTaken(
                        recordedTakenDateTime: DateTime.parse("2022-07-24").add(Duration(days: index)),
                        createdDateTime: now(),
                        updatedDateTime: now()),
                  ],
                );
              }
              if (index == 2) {
                // 3日目: 1回服用済み
                return Pill(
                  index: index,
                  takenCount: 2,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(recordedTakenDateTime: DateTime.parse("2022-07-26"), createdDateTime: now(), updatedDateTime: now()),
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
            },
          ),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );

        // 2日目の2回目を後から記録（takenDateは昨日7/25）
        final result = pillSheet.takenPillSheet(DateTime.parse("2022-07-25"));

        final resultV2 = result as PillSheetV2;
        // lastTakenDateは7/26のまま、7/25に巻き戻らない
        expect(resultV2.lastTakenDate, DateTime.parse("2022-07-26"));
        // 2日目の服用記録が追加されている
        expect(resultV2.pills[1].pillTakens.length, 2);
      });
    });

    group("v2 各PillSheetTypeでの境界値テスト", () {
      // 各PillSheetTypeでの境界値を検証するヘルパー
      void testPillSheetTypeBoundary(PillSheetType sheetType) {
        final mockTodayRepository = MockTodayService();
        final beginDate = DateTime.parse("2022-07-24");
        // estimatedEndTakenDate相当の日を今日としてセット
        final mockNow = beginDate.add(Duration(days: sheetType.totalCount - 1));
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNow);

        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          beginDate: beginDate,
          createdAt: now(),
          groupIndex: 0,
          restDurations: [],
          //  pillTakenCount: 2,
          pills: List.generate(
            sheetType.totalCount,
            (index) {
              if (index < sheetType.totalCount - 1) {
                // 最後のピル以外は完了済み
                return Pill(
                  index: index,
                  takenCount: 2,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(recordedTakenDateTime: beginDate.add(Duration(days: index)), createdDateTime: now(), updatedDateTime: now()),
                    PillTaken(recordedTakenDateTime: beginDate.add(Duration(days: index)), createdDateTime: now(), updatedDateTime: now()),
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
            },
          ),
          typeInfo: sheetType.typeInfo,
        );

        // pills.lengthとtypeInfo.totalCountの一致を検証
        expect((pillSheet as PillSheetV2).pills.length, sheetType.totalCount);

        // 最後のピル（estimatedEndTakenDate）の服用を記録
        final result = pillSheet.takenPillSheet(mockNow);

        final resultV2 = result as PillSheetV2;
        // 最後のピルに服用記録が追加されている
        expect(resultV2.pills[sheetType.totalCount - 1].pillTakens.length, 1);
        // 配列範囲外アクセスが発生していないことを確認
        expect(resultV2.pills.length, sheetType.totalCount);
      }

      test("pillsheet_21 (21錠+休薬7日) の境界値テスト", () {
        testPillSheetTypeBoundary(PillSheetType.pillsheet_21);
      });

      test("pillsheet_28_4 (24錠+偽薬4日) の境界値テスト", () {
        testPillSheetTypeBoundary(PillSheetType.pillsheet_28_4);
      });

      test("pillsheet_28_0 (全実薬28錠) の境界値テスト", () {
        testPillSheetTypeBoundary(PillSheetType.pillsheet_28_0);
      });

      test("pillsheet_24_rest_4 (24錠+休薬4日) の境界値テスト", () {
        testPillSheetTypeBoundary(PillSheetType.pillsheet_24_rest_4);
      });

      test("pillsheet_24_0 (全実薬24錠) の境界値テスト", () {
        testPillSheetTypeBoundary(PillSheetType.pillsheet_24_0);
      });

      test("pillsheet_21_0 (全実薬21錠) の境界値テスト", () {
        testPillSheetTypeBoundary(PillSheetType.pillsheet_21_0);
      });
    });

    group("v2 RestDurationのケース別テスト", () {
      test("RestDurationなしの場合のピル番号計算", () {
        final mockTodayRepository = MockTodayService();
        final mockNow = DateTime.parse("2022-07-27");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNow);

        const sheetType = PillSheetType.pillsheet_28_7;
        final beginDate = DateTime.parse("2022-07-24");
        // 3日目(7/26)まで完了、今日4日目
        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          beginDate: beginDate,
          createdAt: now(),
          groupIndex: 0,
          //  pillTakenCount: 2,
          restDurations: [],
          pills: List.generate(
            sheetType.totalCount,
            (index) {
              if (index <= 2) {
                return Pill(
                  index: index,
                  takenCount: 2,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(recordedTakenDateTime: beginDate.add(Duration(days: index)), createdDateTime: now(), updatedDateTime: now()),
                    PillTaken(recordedTakenDateTime: beginDate.add(Duration(days: index)), createdDateTime: now(), updatedDateTime: now()),
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
            },
          ),
          typeInfo: sheetType.typeInfo,
        );

        // todayPillNumberは4
        expect(pillSheet.todayPillNumber, 4);

        // 4日目を服用
        final result = pillSheet.takenPillSheet(mockNow);
        final resultV2 = result as PillSheetV2;
        expect(resultV2.pills[3].pillTakens.length, 1);
      });

      test("RestDuration完了済みの場合のピル番号計算", () {
        final mockTodayRepository = MockTodayService();
        final mockNow = DateTime.parse("2022-07-30");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNow);

        const sheetType = PillSheetType.pillsheet_28_7;
        final beginDate = DateTime.parse("2022-07-24");
        // 3日間の休薬期間あり (7/26-7/28)
        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          beginDate: beginDate,
          createdAt: now(),
          groupIndex: 0,
          //  pillTakenCount: 2,
          restDurations: [
            RestDuration(
              id: "rest_1",
              beginDate: DateTime.parse("2022-07-26"),
              endDate: DateTime.parse("2022-07-29"),
              createdDate: DateTime.parse("2022-07-26"),
            ),
          ],
          pills: List.generate(
            sheetType.totalCount,
            (index) {
              if (index <= 2) {
                return Pill(
                  index: index,
                  takenCount: 2,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(recordedTakenDateTime: beginDate.add(Duration(days: index)), createdDateTime: now(), updatedDateTime: now()),
                    PillTaken(recordedTakenDateTime: beginDate.add(Duration(days: index)), createdDateTime: now(), updatedDateTime: now()),
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
            },
          ),
          typeInfo: sheetType.typeInfo,
        );

        // 休薬期間を考慮したピル番号
        // 7/30 は beginDate(7/24) から6日経過、休薬3日なので 6 - 3 + 1 = 4番目
        expect(pillSheet.todayPillNumber, 4);
      });

      test("複数のRestDurationがある場合のピル番号計算", () {
        final mockTodayRepository = MockTodayService();
        final mockNow = DateTime.parse("2022-08-05");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockNow);

        const sheetType = PillSheetType.pillsheet_28_7;
        final beginDate = DateTime.parse("2022-07-24");
        // 複数の休薬期間: 7/26-7/27 (1日) と 7/30-8/01 (2日)
        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          beginDate: beginDate,
          createdAt: now(),
          groupIndex: 0,
          //  pillTakenCount: 2,
          restDurations: [
            RestDuration(
              id: "rest_1",
              beginDate: DateTime.parse("2022-07-26"),
              endDate: DateTime.parse("2022-07-27"),
              createdDate: DateTime.parse("2022-07-26"),
            ),
            RestDuration(
              id: "rest_2",
              beginDate: DateTime.parse("2022-07-30"),
              endDate: DateTime.parse("2022-08-01"),
              createdDate: DateTime.parse("2022-07-30"),
            ),
          ],
          pills: List.generate(
            sheetType.totalCount,
            (index) {
              if (index <= 8) {
                return Pill(
                  index: index,
                  takenCount: 2,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(recordedTakenDateTime: now(), createdDateTime: now(), updatedDateTime: now()),
                    PillTaken(recordedTakenDateTime: now(), createdDateTime: now(), updatedDateTime: now()),
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
            },
          ),
          typeInfo: sheetType.typeInfo,
        );

        // 8/5 は beginDate(7/24) から12日経過、休薬合計3日なので 12 - 3 + 1 = 10番目
        expect(pillSheet.todayPillNumber, 10);

        // 10日目を服用
        final result = pillSheet.takenPillSheet(mockNow);
        final resultV2 = result as PillSheetV2;
        expect(resultV2.pills[9].pillTakens.length, 1);
      });
    });

    group("v2 境界値テスト - finalTakenPillIndex の範囲チェック", () {
      test("pillsが空リストの場合、RangeErrorが発生せず元のシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-07-25"));

        final emptyPillSheet = PillSheet.v2(
          id: "sheet_id",
          beginDate: DateTime.parse("2022-07-24"),
          createdAt: now(),
          groupIndex: 0,
          restDurations: [],
          typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
          pills: [], // 空リスト
        );

        // beginDate の日付で記録を試みる
        final result = emptyPillSheet.takenPillSheet(DateTime.parse("2022-07-24"));

        // 例外が発生せず、元のシートが返されることを確認
        expect(result.lastTakenDate, isNull);
        expect((result as PillSheetV2).pills, isEmpty);
      });

      test("takenDateがbeginDateより前の日付の場合、finalTakenPillIndexが0以下になり適切に処理される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-07-22"));

        const sheetType = PillSheetType.pillsheet_28_7;
        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          beginDate: DateTime.parse("2022-07-24"),
          createdAt: now(),
          groupIndex: 0,
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          pills: List.generate(
            sheetType.totalCount,
            (index) => Pill(
              index: index,
              takenCount: 2,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            ),
          ),
        );

        // beginDate(7/24)より2日前の日付(7/22)で記録を試みる
        // pillNumberForは最小で1を返すので、finalTakenPillIndex = 0
        final result = pillSheet.takenPillSheet(DateTime.parse("2022-07-22"));

        // RangeErrorが発生しないことを確認
        // 1番目のピルに1回の服用記録が追加される
        final resultV2 = result as PillSheetV2;
        expect(resultV2.pills[0].pillTakens.length, 1);
      });

      test("takenDateがestimatedEndTakenDateより後の場合、finalTakenPillIndexがクランプされて最後のピルが記録される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-08-15"));

        const sheetType = PillSheetType.pillsheet_21;
        // 全てのピルを完了済みにする（最後のピル以外）
        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          beginDate: DateTime.parse("2022-07-01"),
          createdAt: now(),
          groupIndex: 0,
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          pills: List.generate(
            sheetType.totalCount,
            (index) {
              if (index < sheetType.totalCount - 1) {
                // 最後のピル以外は完了済み
                return Pill(
                  index: index,
                  takenCount: 2,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(
                        recordedTakenDateTime: DateTime.parse("2022-07-01").add(Duration(days: index)),
                        createdDateTime: now(),
                        updatedDateTime: now()),
                    PillTaken(
                        recordedTakenDateTime: DateTime.parse("2022-07-01").add(Duration(days: index)),
                        createdDateTime: now(),
                        updatedDateTime: now()),
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
            },
          ),
        );

        // シート終了日(7/21)より遥か後の日付(8/15)で記録を試みる
        // finalTakenPillIndexはクランプされて最後のピル(index 20)が対象になる
        final farFutureDate = DateTime.parse("2022-08-15");
        final result = pillSheet.takenPillSheet(farFutureDate);

        // RangeErrorが発生せず、最後のピルに記録が追加されることを確認
        final resultV2 = result as PillSheetV2;
        expect(resultV2.pills.last.pillTakens.length, 1);
      });

      test("finalTakenPillIndexがpills.length - 1（最後のピル）の場合、正常に記録される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final beginDate = DateTime.parse("2022-07-01");

        // pillsheet_21_0は21錠のみ（偽薬なし）
        const sheetType = PillSheetType.pillsheet_21_0;
        when(mockTodayRepository.now()).thenReturn(beginDate.add(Duration(days: sheetType.totalCount - 1)));

        // すべての前日のピルを完了済みにする（最後のピル以外）
        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          beginDate: beginDate,
          createdAt: now(),
          groupIndex: 0,
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          pills: List.generate(
            sheetType.totalCount,
            (index) {
              // 最後のピル以外は完了済み
              if (index < sheetType.totalCount - 1) {
                return Pill(
                  index: index,
                  takenCount: 2,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(recordedTakenDateTime: beginDate.add(Duration(days: index)), createdDateTime: now(), updatedDateTime: now()),
                    PillTaken(recordedTakenDateTime: beginDate.add(Duration(days: index)), createdDateTime: now(), updatedDateTime: now()),
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
            },
          ),
        );

        // 最後のピルの日付
        final lastPillDate = beginDate.add(Duration(days: sheetType.totalCount - 1));
        final result = pillSheet.takenPillSheet(lastPillDate);

        // 正常に記録され、RangeErrorが発生しないことを確認
        final resultV2 = result as PillSheetV2;
        expect(resultV2.lastTakenDate, equals(lastPillDate));
        final lastPill = resultV2.pills.last;
        expect(lastPill.pillTakens.length, 1); // 最後のピルなので1回のみ追加
      });

      test("finalTakenPillIndexが0（最初のピル）の場合、前日チェックがスキップされて正常に記録される", () {
        final mockTodayRepository = MockTodayService();
        final beginDate = DateTime.parse("2022-07-24");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(beginDate);

        const sheetType = PillSheetType.pillsheet_28_7;
        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          beginDate: beginDate,
          createdAt: now(),
          groupIndex: 0,
          restDurations: [],
          typeInfo: sheetType.typeInfo,
          pills: List.generate(
            sheetType.totalCount,
            (index) => Pill(
              index: index,
              takenCount: 2,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            ),
          ),
        );

        // 最初のピルの日付
        final result = pillSheet.takenPillSheet(beginDate);

        // 前日のピルが存在しないため、前日チェックがスキップされ、正常に記録される
        final resultV2 = result as PillSheetV2;
        expect(resultV2.lastTakenDate, equals(beginDate));
        expect(resultV2.pills[0].pillTakens.length, 1); // 最初のピルなので1回追加
      });

      test("pillsの長さがtypeInfo.totalCountより少ない場合、クランプされて最後のピルが対象になる", () {
        final mockTodayRepository = MockTodayService();
        final beginDate = DateTime.parse("2022-07-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(beginDate.add(const Duration(days: 14)));

        const sheetType = PillSheetType.pillsheet_28_7;
        // 通常28個のピルがあるべきところ、10個しかない（データ不整合のシミュレーション）
        // 最後のピル以外は完了済みにする
        final incompletePills = List.generate(
          10, // 本来は28個だが10個しかない
          (index) {
            if (index < 9) {
              return Pill(
                index: index,
                takenCount: 2,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(recordedTakenDateTime: beginDate.add(Duration(days: index)), createdDateTime: now(), updatedDateTime: now()),
                  PillTaken(recordedTakenDateTime: beginDate.add(Duration(days: index)), createdDateTime: now(), updatedDateTime: now()),
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
          },
        );

        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          beginDate: beginDate,
          createdAt: now(),
          groupIndex: 0,
          restDurations: [],
          typeInfo: sheetType.typeInfo, // typeInfo は28日分だが pills は10個
          pills: incompletePills,
        );

        // 15日目を記録しようとする（pillNumberFor は15を返すが、pills は10個しかない）
        // クランプされて最後のピル(index 9)が対象になる
        final targetDate = beginDate.add(const Duration(days: 14));
        final result = pillSheet.takenPillSheet(targetDate);

        // RangeErrorが発生せず、クランプされて処理されることを確認
        final resultV2 = result as PillSheetV2;
        expect(resultV2.pills.length, 10);
        expect(resultV2.pills.last.pillTakens.length, 1);
      });
    });
  });
}
