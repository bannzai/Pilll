import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../helper/mock.mocks.dart';

void main() {
  final _today = DateTime.parse("2022-07-24T19:02:00");
  late DateTime activePillSheetBeginDate;
  late DateTime? activePillSheetLastTakenDate;
  late PillSheet previousPillSheet;
  late PillSheet activedPillSheet;
  late PillSheet nextPillSheet;
  late PillSheetGroup pillSheetGroup;

  group("#TakePill", () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);

      activePillSheetBeginDate = _today;
      activePillSheetLastTakenDate = null;
      previousPillSheet = PillSheet(
        id: "previous_pill_sheet_id",
        groupIndex: 0,
        typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
        beginingDate: activePillSheetBeginDate.subtract(const Duration(days: 28)),
        lastTakenDate: activePillSheetBeginDate.subtract(const Duration(days: 1)),
      );
      activedPillSheet = PillSheet(
        id: "active_pill_sheet_id",
        groupIndex: 1,
        typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
        beginingDate: activePillSheetBeginDate,
        lastTakenDate: activePillSheetLastTakenDate,
      );
      nextPillSheet = PillSheet(
        id: "next_pill_sheet_id",
        groupIndex: 2,
        typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
        beginingDate: activePillSheetBeginDate.add(const Duration(days: 28)),
        lastTakenDate: null,
      );
    });
    group("one pill sheet", () {
      setUp(() {
        activedPillSheet = activedPillSheet.copyWith(groupIndex: 0);
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [activedPillSheet.id!],
          pillSheets: [activedPillSheet],
          createdAt: _today,
        );
      });

      test("take pill", () async {
        final takenDate = _today.add(const Duration(seconds: 1));

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);
        when(batchSetPillSheets(batch, [updatedActivePillSheet])).thenReturn([updatedActivePillSheet]);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: activedPillSheet, after: updatedActivePillSheet);
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedActivePillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheets(batch, [updatedActivePillSheet])).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);

        expect(result, updatedPillSheetGroup);
      });

      test("activedPillSheet.todayPillIsAlreadyTaken", () async {
        final takenDate = _today.add(const Duration(seconds: 1));
        activedPillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);

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
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        expect(result, null);
      });
    });

    group("three pill sheet", () {
      test("take pill", () async {
        final takenDate = _today.add(const Duration(seconds: 1));
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activedPillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activedPillSheet, nextPillSheet],
          createdAt: _today,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);
        when(batchSetPillSheets(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet]))
            .thenReturn([previousPillSheet, updatedActivePillSheet, nextPillSheet]);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: activedPillSheet, after: updatedActivePillSheet);
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheets(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet])).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        expect(result, updatedPillSheetGroup);
      });

      test("activedPillSheet.todayPillIsAlreadyTaken", () async {
        final takenDate = _today.add(const Duration(seconds: 1));
        activedPillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activedPillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activedPillSheet, nextPillSheet],
          createdAt: _today,
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
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        expect(result, null);
      });

      test("bounday test. taken activePillSheet.estimatedEndTakenDate", () async {
        final takenDate = activedPillSheet.estimatedEndTakenDate;
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activedPillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activedPillSheet, nextPillSheet],
          createdAt: _today,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);
        when(batchSetPillSheets(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet]))
            .thenReturn([previousPillSheet, updatedActivePillSheet, nextPillSheet]);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: activedPillSheet, after: updatedActivePillSheet);
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheets(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet])).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);

        expect(result, updatedPillSheetGroup);
      });
      test("bounday test. taken activePillSheet.estimatedEndTakenDate + 1.second. it is over active pill sheet range pattern", () async {
        final takenDate = activedPillSheet.estimatedEndTakenDate.add(const Duration(seconds: 1));
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activedPillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activedPillSheet, nextPillSheet],
          createdAt: _today,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: activedPillSheet.estimatedEndTakenDate);
        when(batchSetPillSheets(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet]))
            .thenReturn([previousPillSheet, updatedActivePillSheet, nextPillSheet]);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: activedPillSheet, after: updatedActivePillSheet);
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheets(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet])).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);

        expect(result, updatedPillSheetGroup);
      });

      test(
          "bounday test. activePillSheet.lastTakenDate != null and taken activePillSheet.estimatedEndTakenDate + 1.second. it is over active pill sheet range pattern. ",
          () async {
        final takenDate = activedPillSheet.estimatedEndTakenDate.add(const Duration(seconds: 1));
        activedPillSheet = activedPillSheet.copyWith(lastTakenDate: activedPillSheet.estimatedEndTakenDate.subtract(const Duration(days: 10)));
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activedPillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activedPillSheet, nextPillSheet],
          createdAt: _today,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: activedPillSheet.estimatedEndTakenDate);
        when(batchSetPillSheets(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet]))
            .thenReturn([previousPillSheet, updatedActivePillSheet, nextPillSheet]);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: activedPillSheet, after: updatedActivePillSheet);
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verifyNever(batchSetPillSheets(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet]));
        verifyNever(batchSetPillSheetModifiedHistory(batch, history));
        verifyNever(batchSetPillSheetGroup(batch, updatedPillSheetGroup));
        expect(result, isNull);
      });
      test("when previous pill sheet is not taken all.", () async {
        final takenDate = _today.add(const Duration(seconds: 1));
        previousPillSheet = previousPillSheet.copyWith(lastTakenDate: previousPillSheet.lastTakenDate!.subtract(const Duration(days: 1)));
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activedPillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activedPillSheet, nextPillSheet],
          createdAt: _today,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedPreviousPillSheet = previousPillSheet.copyWith(lastTakenDate: previousPillSheet.estimatedEndTakenDate);
        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);
        when(batchSetPillSheets(batch, [updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet]))
            .thenReturn([updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet]);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: previousPillSheet, after: updatedActivePillSheet);
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheets(batch, [updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet])).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        expect(result, updatedPillSheetGroup);
      });
      test("when previous pill sheet is not taken all. and takenDate is previous pill sheet estimate last taken date", () async {
        previousPillSheet = previousPillSheet.copyWith(lastTakenDate: previousPillSheet.lastTakenDate!.subtract(const Duration(days: 1)));
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activedPillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activedPillSheet, nextPillSheet],
          createdAt: _today,
        );
        final takenDate = previousPillSheet.estimatedEndTakenDate;

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedPreviousPillSheet = previousPillSheet.copyWith(lastTakenDate: previousPillSheet.estimatedEndTakenDate);
        when(batchSetPillSheets(batch, [updatedPreviousPillSheet, activedPillSheet, nextPillSheet]))
            .thenReturn([updatedPreviousPillSheet, activedPillSheet, nextPillSheet]);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: previousPillSheet, after: updatedPreviousPillSheet);
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedPreviousPillSheet, activedPillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheets(batch, [updatedPreviousPillSheet, activedPillSheet, nextPillSheet])).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        expect(result, updatedPillSheetGroup);
      });
      // Bugfix https://github.com/bannzai/Pilll/pull/651

      test(
          "when previous pill sheet is not taken all. And active pill sheet lastTakenDate equal beginDate minus 1 that means reverted taken first pill. And record previous pill sheet last taken date",
          () async {
        previousPillSheet = previousPillSheet.copyWith(lastTakenDate: previousPillSheet.lastTakenDate!.subtract(const Duration(days: 1)));
        activedPillSheet = activedPillSheet.copyWith(lastTakenDate: activedPillSheet.beginingDate.subtract(const Duration(days: 1)));
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activedPillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activedPillSheet, nextPillSheet],
          createdAt: _today,
        );
        final takenDate = previousPillSheet.estimatedEndTakenDate.subtract(const Duration(seconds: 1));

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedPreviousPillSheet = previousPillSheet.copyWith(lastTakenDate: takenDate);
        when(batchSetPillSheets(batch, [updatedPreviousPillSheet, activedPillSheet, nextPillSheet]))
            .thenReturn([updatedPreviousPillSheet, activedPillSheet, nextPillSheet]);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: previousPillSheet, after: updatedPreviousPillSheet);
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedPreviousPillSheet, activedPillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheets(batch, [updatedPreviousPillSheet, activedPillSheet, nextPillSheet])).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);

        expect(result, updatedPillSheetGroup);
      });

      test("Real case 1. Timesensitive pattern(takenDate(19:02:00) < beginingDate(19:02:21)) and with rest durations", () async {
        previousPillSheet =
            previousPillSheet.copyWith(beginingDate: DateTime.parse("2022-06-22T19:02:21"), lastTakenDate: DateTime.parse("2022-07-23T19:00:04"));
        previousPillSheet = previousPillSheet.copyWith(restDurations: [
          RestDuration(
              beginDate: DateTime.parse("2022-07-14T18:25:41"),
              createdDate: DateTime.parse("2022-07-14T18:25:41"),
              endDate: DateTime.parse("2022-07-18T18:10:01"))
        ]);
        activedPillSheet = activedPillSheet.copyWith(beginingDate: DateTime.parse("2022-07-24T19:02:21"), lastTakenDate: null);
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activedPillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activedPillSheet, nextPillSheet],
          createdAt: _today,
        );

        final takenDate = _today.add(const Duration(seconds: 1));
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activedPillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activedPillSheet, nextPillSheet],
          createdAt: _today,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);
        when(batchSetPillSheets(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet]))
            .thenReturn([previousPillSheet, updatedActivePillSheet, nextPillSheet]);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: activedPillSheet, after: updatedActivePillSheet);
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(batchSetPillSheets(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet])).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        expect(result, updatedPillSheetGroup);
      });
      test("Real case 2", () async {
        final _today = DateTime.parse("2022-08-11T19:06:00");
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);

        previousPillSheet =
            previousPillSheet.copyWith(beginingDate: DateTime.parse("2022-06-23T00:00:00"), lastTakenDate: DateTime.parse("2022-07-20T00:00:00"));
        activedPillSheet =
            activedPillSheet.copyWith(beginingDate: DateTime.parse("2022-07-21T00:00:00"), lastTakenDate: DateTime.parse("2022-08-11"));
        activedPillSheet = activedPillSheet.copyWith(restDurations: [
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
        );
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activedPillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activedPillSheet, nextPillSheet],
          createdAt: _today,
        );

        final takenDate = _today.add(const Duration(seconds: 1));
        pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [previousPillSheet.id!, activedPillSheet.id!, nextPillSheet.id!],
          pillSheets: [previousPillSheet, activedPillSheet, nextPillSheet],
          createdAt: _today,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);
        when(batchSetPillSheets(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet]))
            .thenReturn([previousPillSheet, updatedActivePillSheet, nextPillSheet]);

        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: activedPillSheet, after: updatedActivePillSheet);
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(batchSetPillSheetGroup(batch, pillSheetGroup)).thenReturn(pillSheetGroup);

        final takePill = TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verifyNever(batchSetPillSheets(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet]));
        verifyNever(batchSetPillSheetModifiedHistory(batch, history));
        verifyNever(batchSetPillSheetGroup(batch, pillSheetGroup));
        expect(result, null);
      });
    });
  });
}
