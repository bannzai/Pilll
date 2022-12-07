import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/record/components/supports/components/rest_duration/provider.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#beginRestDuration", () {
    test("group has only one pill sheet", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);

      final notYetEndRestDuration = RestDuration(
        beginDate: now(),
        createdDate: now(),
        endDate: null,
      );

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet =
          PillSheet(id: "pill_sheet_id_1", typeInfo: PillSheetType.pillsheet_28_0.typeInfo, beginingDate: now(), createdAt: DateTime.now());
      final updatedPillSheet = pillSheet.copyWith(restDurations: [notYetEndRestDuration]);

      final pillSheetGroup = PillSheetGroup(id: "group_id", pillSheetIDs: ["pill_sheet_id_1"].toList(), pillSheets: [pillSheet], createdAt: now());
      final updatedPillSheetGroup =
          PillSheetGroup(id: "group_id", pillSheetIDs: ["pill_sheet_id_1"].toList(), pillSheets: [updatedPillSheet], createdAt: now());
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          pillSheetGroupID: "group_id", before: pillSheet, after: updatedPillSheet, restDuration: notYetEndRestDuration);
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final beginRestDuration = BeginRestDuration(
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory);
      await beginRestDuration.call(activePillSheet: pillSheet, pillSheetGroup: pillSheetGroup);

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });
  });
  group("#endRestDuration", () {
    test("group has only one pill sheet", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);

      final notYetEndRestDuration = RestDuration(
        beginDate: now().subtract(const Duration(days: 1)),
        createdDate: now().subtract(const Duration(days: 1)),
        endDate: null,
      );
      final endedRestDuration = notYetEndRestDuration.copyWith(
        endDate: now(),
      );

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
          id: "pill_sheet_id_1",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: now(),
          restDurations: [notYetEndRestDuration],
          createdAt: DateTime.now());
      final updatedPillSheet = pillSheet.copyWith(restDurations: [endedRestDuration]);

      final pillSheetGroup = PillSheetGroup(id: "group_id", pillSheetIDs: ["pill_sheet_id_1"].toList(), pillSheets: [pillSheet], createdAt: now());
      final updatedPillSheetGroup =
          PillSheetGroup(id: "group_id", pillSheetIDs: ["pill_sheet_id_1"].toList(), pillSheets: [updatedPillSheet], createdAt: now());
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          pillSheetGroupID: "group_id", before: pillSheet, after: updatedPillSheet, restDuration: endedRestDuration);
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final endRestDuration = EndRestDuration(
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory);
      await endRestDuration.call(activePillSheet: pillSheet, pillSheetGroup: pillSheetGroup, restDuration: notYetEndRestDuration);

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });
    test("group has three pill sheets", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);

      final notYetEndRestDuration = RestDuration(
        beginDate: now().subtract(const Duration(days: 1)),
        createdDate: now().subtract(const Duration(days: 1)),
        endDate: null,
      );
      final endedRestDuration = notYetEndRestDuration.copyWith(
        endDate: now(),
      );

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final firstPillSheetBeginDate = now().subtract(const Duration(days: 10));
      var pillSheets = [
        PillSheet(
          id: "pill_sheet_id_1",
          groupIndex: 0,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: firstPillSheetBeginDate,
          restDurations: [notYetEndRestDuration],
          createdAt: DateTime.now(),
        ),
        PillSheet(
          id: "pill_sheet_id_2",
          groupIndex: 1,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: firstPillSheetBeginDate.add(const Duration(days: 28)),
          createdAt: DateTime.now(),
        ),
        PillSheet(
          id: "pill_sheet_id_3",
          groupIndex: 2,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: firstPillSheetBeginDate.add(const Duration(days: 56)),
          createdAt: DateTime.now(),
        )
      ];
      final updatedPillSheet1 = pillSheets[0].copyWith(restDurations: [endedRestDuration]);
      final updatedPillSheet2 = pillSheets[1].copyWith(beginingDate: updatedPillSheet1.estimatedEndTakenDate.add(const Duration(days: 1)));
      final updatedPillSheet3 = pillSheets[2].copyWith(beginingDate: updatedPillSheet2.estimatedEndTakenDate.add(const Duration(days: 1)));
      final updatedPillSheets = [
        updatedPillSheet1,
        updatedPillSheet2,
        updatedPillSheet3,
      ];

      expect(
        isSameDay(pillSheets[0].beginingDate, updatedPillSheet1.beginingDate),
        true,
      );
      expect(
        isSameDay(pillSheets[1].beginingDate, updatedPillSheet2.beginingDate),
        false,
      );
      expect(
        isSameDay(pillSheets[2].beginingDate, updatedPillSheet3.beginingDate),
        false,
      );

      final pillSheetGroup =
          PillSheetGroup(id: "group_id", pillSheetIDs: pillSheets.map((e) => e.id!).toList(), pillSheets: pillSheets, createdAt: now());
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          pillSheetGroupID: "group_id", before: pillSheets[0], after: updatedPillSheets[0], restDuration: endedRestDuration);
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final endRestDuration = EndRestDuration(
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory);
      await endRestDuration.call(activePillSheet: pillSheets[0], pillSheetGroup: pillSheetGroup, restDuration: notYetEndRestDuration);

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });
  });
}
