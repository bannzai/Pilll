import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../helper/mock.mocks.dart';

class _FakePillSheet extends Fake implements PillSheet {}

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
    previousPillSheet = PillSheet(
      id: "previous_pill_sheet_id",
      groupIndex: 0,
      typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
      beginingDate: activePillSheetBeginDate.subtract(const Duration(days: 28)),
      lastTakenDate: activePillSheetBeginDate.subtract(const Duration(days: 1)),
      createdAt: now(),
      pills: Pill.generateAndFillTo(
        pillSheetType: PillSheetType.pillsheet_28_7,
        fromDate: activePillSheetBeginDate.subtract(const Duration(days: 28)),
        lastTakenDate: activePillSheetBeginDate.subtract(const Duration(days: 1)),
        pillTakenCount: 1,
      ),
    );
    activePillSheet = PillSheet(
      id: "active_pill_sheet_id",
      groupIndex: 1,
      typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
      beginingDate: activePillSheetBeginDate,
      lastTakenDate: activePillSheetLastTakenDate,
      createdAt: now(),
      pills: Pill.generateAndFillTo(
          pillSheetType: PillSheetType.pillsheet_28_7,
          fromDate: activePillSheetBeginDate,
          lastTakenDate: activePillSheetLastTakenDate,
          pillTakenCount: 1),
    );
    nextPillSheet = PillSheet(
      id: "next_pill_sheet_id",
      groupIndex: 2,
      typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
      beginingDate: activePillSheetBeginDate.add(const Duration(days: 28)),
      lastTakenDate: null,
      createdAt: now(),
      pills: Pill.generateAndFillTo(
          pillSheetType: PillSheetType.pillsheet_28_7,
          fromDate: activePillSheetBeginDate.add(const Duration(days: 28)),
          lastTakenDate: null,
          pillTakenCount: 1),
    );
  }

  group("#pillSheet.takenPillSheet", () {
    final activePillSheetBeginDate = mockNow.date();

    setUp(() {
      prepare(activePillSheetBeginDate: activePillSheetBeginDate, activePillSheetLastTakenDate: null);
    });
    group("pillTakenCount = 1", () {
      test("未服用から服用", () {
        final lastTakenPillIndex = max(0, activePillSheet.lastCompletedPillNumber - 1);
        final takenDate = activePillSheetBeginDate;
        final updatedActivePillSheet = activePillSheet.takenPillSheet(takenDate);
        final expected = activePillSheet.copyWith(
          lastTakenDate: takenDate,
          pills: [...activePillSheet.pills]..replaceRange(
              lastTakenPillIndex,
              1,
              [
                Pill(
                    index: lastTakenPillIndex,
                    createdDateTime: now(),
                    updatedDateTime: now(),
                    pillTakens: [PillTaken(takenDateTime: takenDate, createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false)])
              ],
            ),
        );
        // 事前条件
        expect(activePillSheet.lastCompletedPillNumber, 0);
        // テスト内容
        expect(updatedActivePillSheet.pills, expected.pills);
        expect(updatedActivePillSheet, expected);
        expect(updatedActivePillSheet.todayPillsAreAlreadyTaken, true);
        expect(updatedActivePillSheet.anyTodayPillsAreAlreadyTaken, true);
      });
      test("未服用のピルが複数個ある", () {
        prepare(activePillSheetBeginDate: today().subtract(const Duration(days: 2)), activePillSheetLastTakenDate: null);

        final lastTakenPillIndex = max(0, activePillSheet.lastCompletedPillNumber - 1);
        final takenDate = today();
        final updatedActivePillSheet = activePillSheet.takenPillSheet(takenDate);
        final expected = activePillSheet.copyWith(
          lastTakenDate: takenDate,
          pills: [...activePillSheet.pills]..replaceRange(
              lastTakenPillIndex,
              3,
              [
                Pill(
                  index: 0,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(takenDateTime: takenDate, createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false),
                  ],
                ),
                Pill(
                  index: 1,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(takenDateTime: takenDate, createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false),
                  ],
                ),
                Pill(
                  index: 2,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(takenDateTime: takenDate, createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false),
                  ],
                ),
              ],
            ),
        );
        // 事前条件
        expect(activePillSheet.lastCompletedPillNumber, 0);
        expect(activePillSheet.todayPillNumber, 3);
        // テスト内容
        expect(updatedActivePillSheet.pills, expected.pills);
        expect(updatedActivePillSheet, expected);
        expect(updatedActivePillSheet.todayPillsAreAlreadyTaken, true);
        expect(updatedActivePillSheet.anyTodayPillsAreAlreadyTaken, true);
      });
    });
    group("pillTakenCount = 2", () {
      test("未服用から服用", () {
        activePillSheet = activePillSheet.copyWith(pillTakenCount: 2);
        final lastTakenPillIndex = max(0, activePillSheet.lastCompletedPillNumber - 1);

        final takenDate = activePillSheetBeginDate;
        final updatedActivePillSheet = activePillSheet.takenPillSheet(takenDate);
        final expected = activePillSheet.copyWith(
          lastTakenDate: takenDate,
          pills: [...activePillSheet.pills]..replaceRange(
              lastTakenPillIndex,
              1,
              [
                Pill(
                  index: lastTakenPillIndex,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(takenDateTime: takenDate, createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false),
                  ],
                )
              ],
            ),
        );
        // 事前条件
        expect(activePillSheet.lastCompletedPillNumber, 0);
        // テスト内容
        expect(updatedActivePillSheet.pills, expected.pills);
        expect(updatedActivePillSheet, expected);
        expect(updatedActivePillSheet.todayPillsAreAlreadyTaken, false);
        expect(updatedActivePillSheet.anyTodayPillsAreAlreadyTaken, true);
      });

      test("1度服用済みから2度目の服用", () {
        final takenDate = activePillSheetBeginDate;
        final lastTakenPillIndex = max(0, activePillSheet.lastCompletedPillNumber - 1);
        // 1度服用済みにする
        activePillSheet = activePillSheet.copyWith(
          pillTakenCount: 2,
          lastTakenDate: takenDate,
          pills: [...activePillSheet.pills]..replaceRange(
              lastTakenPillIndex,
              1,
              [
                Pill(
                    index: lastTakenPillIndex,
                    createdDateTime: now(),
                    updatedDateTime: now(),
                    pillTakens: [PillTaken(takenDateTime: takenDate, createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false)])
              ],
            ),
        );

        final updatedActivePillSheet = activePillSheet.takenPillSheet(takenDate);
        final expected = activePillSheet.copyWith(
          lastTakenDate: takenDate,
          pills: [...activePillSheet.pills]..replaceRange(
              lastTakenPillIndex,
              1,
              [
                Pill(
                  index: lastTakenPillIndex,
                  createdDateTime: now(),
                  updatedDateTime: now(),
                  pillTakens: [
                    PillTaken(takenDateTime: takenDate, createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false),
                    PillTaken(takenDateTime: takenDate, createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false),
                  ],
                )
              ],
            ),
        );
        // 事前条件
        expect(activePillSheet.lastCompletedPillNumber, 0);
        // テスト内容
        expect(updatedActivePillSheet.pills, expected.pills);
        expect(updatedActivePillSheet, expected);
        expect(updatedActivePillSheet.todayPillsAreAlreadyTaken, true);
        expect(updatedActivePillSheet.anyTodayPillsAreAlreadyTaken, true);
      });
    });
  });

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
          previousPillSheet = _FakePillSheet();
          nextPillSheet = _FakePillSheet();
        });

        test("take pill", () async {
          final takenDate = mockNow.add(const Duration(seconds: 1));

          final batchFactory = MockBatchFactory();
          final batch = MockWriteBatch();
          when(batchFactory.batch()).thenReturn(batch);

          final updatedActivePillSheet = activePillSheet.takenPillSheet(takenDate);

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

        test("activePillSheet.todayPillsAreAlreadyTaken", () async {
          final takenDate = mockNow.add(const Duration(seconds: 1));
          activePillSheet = activePillSheet.takenPillSheet(takenDate);

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

        final updatedActivePillSheet = activePillSheet.takenPillSheet(takenDate);

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

      test("activePillSheet.todayPillsAreAlreadyTaken", () async {
        final takenDate = mockNow.add(const Duration(seconds: 1));
        activePillSheet = activePillSheet.takenPillSheet(takenDate);
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

        final updatedActivePillSheet = activePillSheet.takenPillSheet(takenDate);

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

        final updatedActivePillSheet = activePillSheet.takenPillSheet(activePillSheet.estimatedEndTakenDate);

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
          pills: Pill.testGenerateAndIterateTo(
            pillSheetType: activePillSheet.pillSheetType,
            fromDate: activePillSheet.beginingDate,
            lastTakenDate: lastTakenDate,
            pillTakenCount: 1,
          ),
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

        final updatedActivePillSheet = activePillSheet.takenPillSheet(activePillSheet.estimatedEndTakenDate);

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

        verify(batchSetPillSheetModifiedHistory(batch, history));
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup));
        expect(result, isNotNull);
      });
      test("when previous pill sheet is not taken all.", () async {
        final takenDate = mockNow.add(const Duration(seconds: 1));
        final lastTakenDate = previousPillSheet.lastTakenDate!.subtract(const Duration(days: 1));
        previousPillSheet = previousPillSheet.copyWith(
          lastTakenDate: lastTakenDate,
          pills: Pill.testGenerateAndIterateTo(
            pillSheetType: activePillSheet.pillSheetType,
            fromDate: activePillSheet.beginingDate,
            lastTakenDate: lastTakenDate,
            pillTakenCount: 1,
          ),
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

        final updatedPreviousPillSheet = previousPillSheet.takenPillSheet(previousPillSheet.estimatedEndTakenDate);
        final updatedActivePillSheet = activePillSheet.takenPillSheet(takenDate);

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
          pills: Pill.testGenerateAndIterateTo(
            pillSheetType: activePillSheet.pillSheetType,
            fromDate: activePillSheet.beginingDate,
            lastTakenDate: lastTakenDate,
            pillTakenCount: 1,
          ),
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

        final updatedPreviousPillSheet = previousPillSheet.takenPillSheet(previousPillSheet.estimatedEndTakenDate);

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
          pills: Pill.testGenerateAndIterateTo(
            pillSheetType: activePillSheet.pillSheetType,
            fromDate: activePillSheet.beginingDate,
            lastTakenDate: previousPillSheetLastTakenDate,
            pillTakenCount: 1,
          ),
        );
        final activePillSheetLastTakenDate = activePillSheet.beginingDate.subtract(const Duration(days: 1));
        activePillSheet = activePillSheet.copyWith(
          lastTakenDate: activePillSheetLastTakenDate,
          pills: Pill.testGenerateAndIterateTo(
            pillSheetType: activePillSheet.pillSheetType,
            fromDate: activePillSheet.beginingDate,
            lastTakenDate: activePillSheetLastTakenDate,
            pillTakenCount: 1,
          ),
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

        final updatedPreviousPillSheet = previousPillSheet.takenPillSheet(takenDate);

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

      test("Real case 1. Timesensitive pattern(takenDate(19:02:00) < beginingDate(19:02:21)) and with rest durations", () async {
        previousPillSheet =
            previousPillSheet.copyWith(beginingDate: DateTime.parse("2022-06-22T19:02:21")).takenPillSheet(DateTime.parse("2022-07-23T19:00:04"));
        previousPillSheet = previousPillSheet.copyWith(restDurations: [
          RestDuration(
              beginDate: DateTime.parse("2022-07-14T18:25:41"),
              createdDate: DateTime.parse("2022-07-14T18:25:41"),
              endDate: DateTime.parse("2022-07-18T18:10:01"))
        ]);
        activePillSheet = activePillSheet.copyWith(beginingDate: DateTime.parse("2022-07-24T19:02:21"), lastTakenDate: null);
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activePillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activePillSheet, nextPillSheet],
          createdAt: mockNow,
        );

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

        final updatedActivePillSheet = activePillSheet.takenPillSheet(takenDate);

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

        previousPillSheet =
            previousPillSheet.copyWith(beginingDate: DateTime.parse("2022-06-23T00:00:00")).takenPillSheet(DateTime.parse("2022-07-20T00:00:00"));
        activePillSheet = activePillSheet.copyWith(beginingDate: DateTime.parse("2022-07-21T00:00:00")).takenPillSheet(DateTime.parse("2022-08-11"));
        activePillSheet = activePillSheet.copyWith(restDurations: [
          RestDuration(
              beginDate: DateTime.parse("2022-08-04T08:19:04"),
              createdDate: DateTime.parse("2022-08-04T08:19:04"),
              endDate: DateTime.parse("2022-08-04T08:19:17")),
          RestDuration(
              beginDate: DateTime.parse("2022-08-04T08:19:32"),
              createdDate: DateTime.parse("2022-08-04T08:19:32"),
              endDate: DateTime.parse("2022-08-07T10:48:19")),
          RestDuration(
              beginDate: DateTime.parse("2022-08-07T10:48:22"),
              createdDate: DateTime.parse("2022-08-07T10:48:22"),
              endDate: DateTime.parse("2022-08-08T19:47:49"))
        ]);
        nextPillSheet = PillSheet(
          id: "next_pill_sheet_id",
          groupIndex: 2,
          typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
          beginingDate: activePillSheetBeginDate.add(const Duration(days: 28)),
          lastTakenDate: null,
          createdAt: now(),
          pills: Pill.generateAndFillTo(
              pillSheetType: PillSheetType.pillsheet_28_7,
              fromDate: activePillSheetBeginDate.add(const Duration(days: 28)),
              lastTakenDate: null,
              pillTakenCount: 1),
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

        final updatedActivePillSheet = activePillSheet.takenPillSheet(takenDate);

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
