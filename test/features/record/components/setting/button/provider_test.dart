import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/provider.dart';
import 'package:pilll/utils/datetime/date_add.dart';
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
    test("ピルシートが1枚の時。未服用の場合は当日から服用お休み開始", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("rest_duration_id");
      firestoreIDGenerator = mockIDGenerator;
      final notYetEndRestDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: now(),
        createdDate: now(),
        endDate: null,
      );

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
        id: "pill_sheet_id_1",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: null,
        beginingDate: now(),
        createdAt: now(),
      );
      final updatedPillSheet = pillSheet.copyWith(restDurations: [notYetEndRestDuration]);

      final pillSheetGroup = PillSheetGroup(id: "group_id", pillSheetIDs: ["pill_sheet_id_1"].toList(), pillSheets: [pillSheet], createdAt: now());
      final updatedPillSheetGroup =
          PillSheetGroup(id: "group_id", pillSheetIDs: ["pill_sheet_id_1"].toList(), pillSheets: [updatedPillSheet], createdAt: now());
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: updatedPillSheet,
        restDuration: notYetEndRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final beginRestDuration = BeginRestDuration(
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory);
      await beginRestDuration.call(pillSheetGroup: pillSheetGroup);

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });

    test("ピルシートが1枚の時。服用済みの場合は次の日から服用お休み開始", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("rest_duration_id");
      firestoreIDGenerator = mockIDGenerator;
      final notYetEndRestDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: now().addDays(1),
        createdDate: now(),
        endDate: null,
      );

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
        id: "pill_sheet_id_1",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: now(),
        beginingDate: now(),
        createdAt: now(),
      );
      final updatedPillSheet = pillSheet.copyWith(restDurations: [notYetEndRestDuration]);

      final pillSheetGroup = PillSheetGroup(id: "group_id", pillSheetIDs: ["pill_sheet_id_1"].toList(), pillSheets: [pillSheet], createdAt: now());
      final updatedPillSheetGroup =
          PillSheetGroup(id: "group_id", pillSheetIDs: ["pill_sheet_id_1"].toList(), pillSheets: [updatedPillSheet], createdAt: now());
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: updatedPillSheet,
        restDuration: notYetEndRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final beginRestDuration = BeginRestDuration(
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory);
      await beginRestDuration.call(pillSheetGroup: pillSheetGroup);

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });

    test("ピルシートが複数枚。最後に服用記録がついたピルシートに未服用のピルがある。最後に服用記録がついたピルシートに次の日から服用お休み期間が適応される", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("rest_duration_id");
      firestoreIDGenerator = mockIDGenerator;

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet1 = PillSheet(
        id: "pill_sheet_id_1",
        groupIndex: 0,
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: now().addDays(-2),
        beginingDate: now().addDays(-28),
        createdAt: now(),
      );
      expect(pillSheet1.isTakenAll, false);

      final pillSheet2 = PillSheet(
        id: "pill_sheet_id_2",
        groupIndex: 1,
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: null,
        beginingDate: now(),
        createdAt: now(),
      );
      final notYetEndRestDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: pillSheet1.lastTakenDate!.addDays(1),
        createdDate: now(),
        endDate: null,
      );
      final updatedPillSheet = pillSheet1.copyWith(restDurations: [notYetEndRestDuration]);

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: [
          "pill_sheet_id_1",
          "pill_sheet_id_2",
        ],
        pillSheets: [
          pillSheet1,
          pillSheet2,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(
        pillSheets: [updatedPillSheet, pillSheet2],
      );

      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
        pillSheetGroupID: "group_id",
        before: pillSheet1,
        after: updatedPillSheet,
        restDuration: notYetEndRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final beginRestDuration = BeginRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
      );
      await beginRestDuration.call(pillSheetGroup: pillSheetGroup);

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });
    test("ピルシートが複数枚。最後に服用記録がついたピルシートがすべて服用済み。次のピルシートに服用お休み期間が適応される", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("rest_duration_id");
      firestoreIDGenerator = mockIDGenerator;

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet1 = PillSheet(
        id: "pill_sheet_id_1",
        groupIndex: 0,
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: now().addDays(-1),
        beginingDate: now().addDays(-28),
        createdAt: now(),
      );
      expect(pillSheet1.isTakenAll, true);

      final pillSheet2 = PillSheet(
        id: "pill_sheet_id_2",
        groupIndex: 1,
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: null,
        beginingDate: now(),
        createdAt: now(),
      );
      final notYetEndRestDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: now(),
        createdDate: now(),
        endDate: null,
      );
      final updatedPillSheet = pillSheet2.copyWith(restDurations: [notYetEndRestDuration]);

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: [
          "pill_sheet_id_1",
          "pill_sheet_id_2",
        ],
        pillSheets: [
          pillSheet1,
          pillSheet2,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(
        pillSheets: [pillSheet1, updatedPillSheet],
      );

      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
        pillSheetGroupID: "group_id",
        before: pillSheet2,
        after: updatedPillSheet,
        restDuration: notYetEndRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final beginRestDuration = BeginRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
      );
      await beginRestDuration.call(pillSheetGroup: pillSheetGroup);

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });
  });
  group("#endRestDuration", () {
    test("group has only one pill sheet", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final notYetEndRestDuration = RestDuration(
        id: "rest_duration_id",
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
        lastTakenDate: null,
        restDurations: [notYetEndRestDuration],
        createdAt: now(),
      );
      final updatedPillSheet = pillSheet.copyWith(restDurations: [endedRestDuration]);

      final pillSheetGroup = PillSheetGroup(id: "group_id", pillSheetIDs: ["pill_sheet_id_1"].toList(), pillSheets: [pillSheet], createdAt: now());
      final updatedPillSheetGroup =
          PillSheetGroup(id: "group_id", pillSheetIDs: ["pill_sheet_id_1"].toList(), pillSheets: [updatedPillSheet], createdAt: now());
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: updatedPillSheet,
        restDuration: endedRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
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
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final notYetEndRestDuration = RestDuration(
        id: "rest_duration_id",
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
          lastTakenDate: null,
          restDurations: [notYetEndRestDuration],
          createdAt: now(),
        ),
        PillSheet(
          id: "pill_sheet_id_2",
          groupIndex: 1,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: firstPillSheetBeginDate.add(const Duration(days: 28)),
          lastTakenDate: null,
          createdAt: now(),
        ),
        PillSheet(
          id: "pill_sheet_id_3",
          groupIndex: 2,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: firstPillSheetBeginDate.add(const Duration(days: 56)),
          lastTakenDate: null,
          createdAt: now(),
        )
      ];
      final updatedPillShee$1 = pillSheets[0].copyWith(restDurations: [endedRestDuration]);
      final updatedPillShee$2 = pillSheets[1].copyWith(beginingDate: updatedPillShee$1.estimatedEndTakenDate.add(const Duration(days: 1)));
      final updatedPillShee$3 = pillSheets[2].copyWith(beginingDate: updatedPillShee$2.estimatedEndTakenDate.add(const Duration(days: 1)));
      final updatedPillSheets = [
        updatedPillShee$1,
        updatedPillShee$2,
        updatedPillShee$3,
      ];

      expect(
        isSameDay(pillSheets[0].beginingDate, updatedPillShee$1.beginingDate),
        true,
      );
      expect(
        isSameDay(pillSheets[1].beginingDate, updatedPillShee$2.beginingDate),
        false,
      );
      expect(
        isSameDay(pillSheets[2].beginingDate, updatedPillShee$3.beginingDate),
        false,
      );

      final pillSheetGroup =
          PillSheetGroup(id: "group_id", pillSheetIDs: pillSheets.map((e) => e.id!).toList(), pillSheets: pillSheets, createdAt: now());
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
        pillSheetGroupID: "group_id",
        before: pillSheets[0],
        after: updatedPillSheets[0],
        restDuration: endedRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
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

  group("#changeRestDurationBeginDate", () {
    test("group has only one pill sheet", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("rest_duration_id");
      firestoreIDGenerator = mockIDGenerator;
      final beforeRestDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: now(),
        createdDate: now(),
        endDate: null,
      );
      final afterRestDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: now().subtract(const Duration(days: 1)),
        createdDate: now(),
        endDate: null,
      );

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
        id: "pill_sheet_id_1",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: null,
        beginingDate: now(),
        createdAt: now(),
        restDurations: [beforeRestDuration],
      );
      final updatedPillSheet = pillSheet.copyWith(
        restDurations: [afterRestDuration],
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["pill_sheet_id_1"].toList(),
        pillSheets: [pillSheet],
        createdAt: now(),
      );
      final updatedPillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["pill_sheet_id_1"].toList(),
        pillSheets: [updatedPillSheet],
        createdAt: now(),
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: updatedPillSheet,
        beforeRestDuration: beforeRestDuration,
        afterRestDuration: afterRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final beginRestDuration = ChangeRestDuration(
          actionType: PillSheetModifiedActionType.changedRestDurationBeginDate,
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory);
      await beginRestDuration.call(
        fromRestDuration: beforeRestDuration,
        toRestDuration: afterRestDuration,
        pillSheetGroup: pillSheetGroup,
      );

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });
  });

  group("#changeRestDuration", () {
    test("group has only one pill sheet", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("rest_duration_id");
      firestoreIDGenerator = mockIDGenerator;
      final beforeRestDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: now(),
        createdDate: now(),
        endDate: now(),
      );
      final afterRestDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: now().subtract(const Duration(days: 2)),
        createdDate: now(),
        endDate: now().subtract(const Duration(days: 1)),
      );

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
        id: "pill_sheet_id_1",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: null,
        beginingDate: now(),
        createdAt: now(),
        restDurations: [beforeRestDuration],
      );
      final updatedPillSheet = pillSheet.copyWith(
        restDurations: [afterRestDuration],
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["pill_sheet_id_1"].toList(),
        pillSheets: [pillSheet],
        createdAt: now(),
      );
      final updatedPillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["pill_sheet_id_1"].toList(),
        pillSheets: [updatedPillSheet],
        createdAt: now(),
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: updatedPillSheet,
        beforeRestDuration: beforeRestDuration,
        afterRestDuration: afterRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final beginRestDuration = ChangeRestDuration(
          actionType: PillSheetModifiedActionType.changedRestDuration,
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory);
      await beginRestDuration.call(
        fromRestDuration: beforeRestDuration,
        toRestDuration: afterRestDuration,
        pillSheetGroup: pillSheetGroup,
      );

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });
  });
}
