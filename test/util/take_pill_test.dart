import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/domain/record/util/take_pill.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.mocks.dart';

void main() {
  final _today = DateTime.parse("2022-07-20");
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

        final pillSheetDatastore = MockPillSheetDatastore();
        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);
        when(pillSheetDatastore.update(batch, [updatedActivePillSheet])).thenReturn(null);

        final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: activedPillSheet, after: updatedActivePillSheet);
        when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedActivePillSheet]);
        when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          pillSheetDatastore: pillSheetDatastore,
          pillSheetModifiedHistoryDatastore: pillSheetModifiedHistoryDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(pillSheetDatastore.update(batch, [updatedActivePillSheet])).called(1);
        verify(pillSheetModifiedHistoryDatastore.add(batch, history)).called(1);
        verify(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).called(1);

        expect(result, updatedPillSheetGroup);
      });

      test("activedPillSheet.todayPillIsAlreadyTaken", () async {
        final takenDate = _today.add(const Duration(seconds: 1));
        activedPillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);

        final batchFactory = MockBatchFactory();
        final pillSheetDatastore = MockPillSheetDatastore();
        final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();

        final takePill = TakePill(
          batchFactory: batchFactory,
          pillSheetDatastore: pillSheetDatastore,
          pillSheetModifiedHistoryDatastore: pillSheetModifiedHistoryDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
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

        final pillSheetDatastore = MockPillSheetDatastore();
        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);
        when(pillSheetDatastore.update(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet])).thenReturn(null);

        final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: activedPillSheet, after: updatedActivePillSheet);
        when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          pillSheetDatastore: pillSheetDatastore,
          pillSheetModifiedHistoryDatastore: pillSheetModifiedHistoryDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(pillSheetDatastore.update(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet])).called(1);
        verify(pillSheetModifiedHistoryDatastore.add(batch, history)).called(1);
        verify(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).called(1);
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
        final pillSheetDatastore = MockPillSheetDatastore();
        final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();

        final takePill = TakePill(
          batchFactory: batchFactory,
          pillSheetDatastore: pillSheetDatastore,
          pillSheetModifiedHistoryDatastore: pillSheetModifiedHistoryDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
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

        final pillSheetDatastore = MockPillSheetDatastore();
        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);
        when(pillSheetDatastore.update(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet])).thenReturn(null);

        final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: activedPillSheet, after: updatedActivePillSheet);
        when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          pillSheetDatastore: pillSheetDatastore,
          pillSheetModifiedHistoryDatastore: pillSheetModifiedHistoryDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(pillSheetDatastore.update(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet])).called(1);
        verify(pillSheetModifiedHistoryDatastore.add(batch, history)).called(1);
        verify(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).called(1);

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

        final pillSheetDatastore = MockPillSheetDatastore();
        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: activedPillSheet.estimatedEndTakenDate);
        when(pillSheetDatastore.update(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet])).thenReturn(null);

        final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: activedPillSheet, after: updatedActivePillSheet);
        when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          pillSheetDatastore: pillSheetDatastore,
          pillSheetModifiedHistoryDatastore: pillSheetModifiedHistoryDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(pillSheetDatastore.update(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet])).called(1);
        verify(pillSheetModifiedHistoryDatastore.add(batch, history)).called(1);
        verify(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).called(1);

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

        final pillSheetDatastore = MockPillSheetDatastore();
        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: activedPillSheet.estimatedEndTakenDate);
        when(pillSheetDatastore.update(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet])).thenReturn(null);

        final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: activedPillSheet, after: updatedActivePillSheet);
        when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [previousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          pillSheetDatastore: pillSheetDatastore,
          pillSheetModifiedHistoryDatastore: pillSheetModifiedHistoryDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(pillSheetDatastore.update(batch, [previousPillSheet, updatedActivePillSheet, nextPillSheet])).called(1);
        verify(pillSheetModifiedHistoryDatastore.add(batch, history)).called(1);
        verify(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).called(1);
        expect(result, updatedPillSheetGroup);
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

        final pillSheetDatastore = MockPillSheetDatastore();
        final updatedPreviousPillSheet = previousPillSheet.copyWith(lastTakenDate: previousPillSheet.estimatedEndTakenDate);
        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);
        when(pillSheetDatastore.update(batch, [updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet])).thenReturn(null);

        final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: updatedPreviousPillSheet, after: updatedActivePillSheet);
        when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          pillSheetDatastore: pillSheetDatastore,
          pillSheetModifiedHistoryDatastore: pillSheetModifiedHistoryDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(pillSheetDatastore.update(batch, [updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet])).called(1);
        verify(pillSheetModifiedHistoryDatastore.add(batch, history)).called(1);
        verify(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).called(1);
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

        final pillSheetDatastore = MockPillSheetDatastore();
        final updatedPreviousPillSheet = previousPillSheet.copyWith(lastTakenDate: previousPillSheet.estimatedEndTakenDate);
        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);
        when(pillSheetDatastore.update(batch, [updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet])).thenReturn(null);

        final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: updatedPreviousPillSheet, after: updatedActivePillSheet);
        when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          pillSheetDatastore: pillSheetDatastore,
          pillSheetModifiedHistoryDatastore: pillSheetModifiedHistoryDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(pillSheetDatastore.update(batch, [updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet])).called(1);
        verify(pillSheetModifiedHistoryDatastore.add(batch, history)).called(1);
        verify(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).called(1);
        expect(result, updatedPillSheetGroup);
      });
      // Bugfix https://github.com/bannzai/Pilll/pull/651

      test(
          "when previous pill sheet is not taken all. And active pill sheet lastTakenDate equal beginDate minus 1 that means reverted taken first pill. And record previous pill sheet last taken date",
          () async {
        previousPillSheet = previousPillSheet.copyWith(lastTakenDate: previousPillSheet.lastTakenDate!.subtract(const Duration(days: 1)));
        activedPillSheet = activedPillSheet.copyWith(lastTakenDate: previousPillSheet.estimatedEndTakenDate);
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

        final pillSheetDatastore = MockPillSheetDatastore();
        final updatedPreviousPillSheet = previousPillSheet.copyWith(lastTakenDate: takenDate);
        final updatedActivePillSheet = activedPillSheet.copyWith(lastTakenDate: takenDate);
        when(pillSheetDatastore.update(batch, [updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet])).thenReturn(null);

        final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
        final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
            pillSheetGroupID: pillSheetGroup.id, isQuickRecord: false, before: previousPillSheet, after: updatedPreviousPillSheet);
        when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet]);
        when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

        final takePill = TakePill(
          batchFactory: batchFactory,
          pillSheetDatastore: pillSheetDatastore,
          pillSheetModifiedHistoryDatastore: pillSheetModifiedHistoryDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
        );
        final result = await takePill(
          takenDate: takenDate,
          activedPillSheet: activedPillSheet,
          pillSheetGroup: pillSheetGroup,
          isQuickRecord: false,
        );

        verify(pillSheetDatastore.update(batch, [updatedPreviousPillSheet, updatedActivePillSheet, nextPillSheet])).called(1);
        verify(pillSheetModifiedHistoryDatastore.add(batch, history)).called(1);
        verify(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).called(1);

        expect(result, updatedPillSheetGroup);
      });
    });
  });
}
