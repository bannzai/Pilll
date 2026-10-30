import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/error/alert_error.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/provider.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../helper/mock.mocks.dart';

// NOTE: DatePickerの表示制御により、最後に服用記録をつけた日付(lastTakenDate)+1以上の日付は選択できない
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

      final pillSheet = PillSheet.v1(
        id: "pill_sheet_id_1",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: null,
        beginDate: now(),
        createdAt: now(),
      );
      final updatedPillSheet = pillSheet.copyWith(
        restDurations: [notYetEndRestDuration],
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["pill_sheet_id_1"].toList(),
        pillSheets: [pillSheet],
        createdAt: now(),
        pillSheetAppearanceMode: PillSheetAppearanceMode.number,
      );
      final updatedPillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["pill_sheet_id_1"].toList(),
        pillSheets: [updatedPillSheet],
        createdAt: now(),
        pillSheetAppearanceMode: PillSheetAppearanceMode.number,
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(
        batchSetPillSheetGroup(batch, updatedPillSheetGroup),
      ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createBeganRestDurationAction(
        restDuration: notYetEndRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final beginRestDuration = BeginRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
      );
      await beginRestDuration.call(
          pillSheetGroup: pillSheetGroup, endDate: null);

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

      final pillSheet = PillSheet.v1(
        id: "pill_sheet_id_1",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: now(),
        beginDate: now(),
        createdAt: now(),
      );
      final updatedPillSheet = pillSheet.copyWith(
        restDurations: [notYetEndRestDuration],
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["pill_sheet_id_1"].toList(),
        pillSheets: [pillSheet],
        createdAt: now(),
        pillSheetAppearanceMode: PillSheetAppearanceMode.number,
      );
      final updatedPillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["pill_sheet_id_1"].toList(),
        pillSheets: [updatedPillSheet],
        createdAt: now(),
        pillSheetAppearanceMode: PillSheetAppearanceMode.number,
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(
        batchSetPillSheetGroup(batch, updatedPillSheetGroup),
      ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createBeganRestDurationAction(
        restDuration: notYetEndRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final beginRestDuration = BeginRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
      );
      await beginRestDuration.call(
          pillSheetGroup: pillSheetGroup, endDate: null);

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });

    test(
      "ピルシートが複数枚。最後に服用記録がついたピルシートに未服用のピルがある。最後に服用記録がついたピルシートに次の日から服用お休み期間が適応される",
      () async {
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

        final pillSheet1 = PillSheet.v1(
          id: "pill_sheet_id_1",
          groupIndex: 0,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: now().addDays(-2),
          beginDate: now().addDays(-28),
          createdAt: now(),
        );
        expect(pillSheet1.isTakenAll, false);

        final pillSheet2 = PillSheet.v1(
          id: "pill_sheet_id_2",
          groupIndex: 1,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: null,
          beginDate: now(),
          createdAt: now(),
        );
        final notYetEndRestDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: pillSheet1.lastTakenDate!.addDays(1),
          createdDate: now(),
          endDate: null,
        );
        final updatedPillSheet = pillSheet1.copyWith(
          restDurations: [notYetEndRestDuration],
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["pill_sheet_id_1", "pill_sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedPillSheet, pillSheet2],
        );

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createBeganRestDurationAction(
          restDuration: notYetEndRestDuration,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final beginRestDuration = BeginRestDuration(
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        );
        await beginRestDuration.call(
            pillSheetGroup: pillSheetGroup, endDate: null);

        verify(batchFactory.batch()).called(1);

        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
      },
    );
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

      final pillSheet1 = PillSheet.v1(
        id: "pill_sheet_id_1",
        groupIndex: 0,
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: now().addDays(-1),
        beginDate: now().addDays(-28),
        createdAt: now(),
      );
      expect(pillSheet1.isTakenAll, true);

      final pillSheet2 = PillSheet.v1(
        id: "pill_sheet_id_2",
        groupIndex: 1,
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: null,
        beginDate: now(),
        createdAt: now(),
      );
      final notYetEndRestDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: now(),
        createdDate: now(),
        endDate: null,
      );
      final updatedPillSheet = pillSheet2.copyWith(
        restDurations: [notYetEndRestDuration],
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["pill_sheet_id_1", "pill_sheet_id_2"],
        pillSheets: [pillSheet1, pillSheet2],
        createdAt: now(),
        pillSheetAppearanceMode: PillSheetAppearanceMode.number,
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(
        pillSheets: [pillSheet1, updatedPillSheet],
      );

      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(
        batchSetPillSheetGroup(batch, updatedPillSheetGroup),
      ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createBeganRestDurationAction(
        restDuration: notYetEndRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final beginRestDuration = BeginRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
      );
      await beginRestDuration.call(
          pillSheetGroup: pillSheetGroup, endDate: null);

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });

    test("endDateありで開始するとrestDurationにendDateが入り、2枚目のbeginDateが予定終了日+1日になる",
        () async {
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

      // 9/19から9/24の前日までの5日間お休みする。1枚目(28錠)は9/10開始なので、お休みの全日数を含めると10/12に服用が終わる
      final plannedEndDate = DateTime.parse("2020-09-24");
      final pillSheet1 = PillSheet.v1(
        id: "pill_sheet_id_1",
        groupIndex: 0,
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: DateTime.parse("2020-09-18"),
        beginDate: DateTime.parse("2020-09-10"),
        createdAt: now(),
      );
      final pillSheet2 = PillSheet.v1(
        id: "pill_sheet_id_2",
        groupIndex: 1,
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: null,
        beginDate: DateTime.parse("2020-10-08"),
        createdAt: now(),
      );
      final plannedRestDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: DateTime.parse("2020-09-19"),
        createdDate: now(),
        endDate: plannedEndDate,
      );
      final updatedPillSheet1 = pillSheet1.copyWith(
        restDurations: [plannedRestDuration],
      );
      final updatedPillSheet2 = pillSheet2.copyWith(
        beginDate: DateTime.parse("2020-10-13"),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["pill_sheet_id_1", "pill_sheet_id_2"],
        pillSheets: [pillSheet1, pillSheet2],
        createdAt: now(),
        pillSheetAppearanceMode: PillSheetAppearanceMode.number,
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(
        pillSheets: [updatedPillSheet1, updatedPillSheet2],
      );

      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(
        batchSetPillSheetGroup(batch, updatedPillSheetGroup),
      ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createBeganRestDurationAction(
        restDuration: plannedRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final beginRestDuration = BeginRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
      );
      await beginRestDuration.call(
        pillSheetGroup: pillSheetGroup,
        endDate: plannedEndDate,
      );

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });

    group("終了済みの服用お休みの後に服用記録を付けずに服用お休みを開始する場合", () {
      PillSheet pillSheet({required bool isV2}) {
        final beginDate = DateTime.parse("2026-10-13");
        final lastTakenDate = DateTime.parse("2026-10-25");
        final restDurations = [
          RestDuration(
            id: "finished_rest_duration_id",
            beginDate: DateTime.parse("2026-10-26"),
            endDate: DateTime.parse("2026-10-29"),
            createdDate: DateTime.parse("2026-10-26"),
          ),
        ];
        if (isV2) {
          return PillSheet.v2(
            id: "pill_sheet_id_1",
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            beginDate: beginDate,
            createdAt: beginDate,
            restDurations: restDurations,
            pills: Pill.testGenerateAndIterateTo(
              pillSheetType: PillSheetType.pillsheet_28_0,
              fromDate: beginDate,
              lastTakenDate: lastTakenDate,
              pillTakenCount: 2,
            ),
          );
        }
        return PillSheet.v1(
          id: "pill_sheet_id_1",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: beginDate,
          lastTakenDate: lastTakenDate,
          createdAt: beginDate,
          restDurations: restDurations,
        );
      }

      Future<PillSheetGroup> beginRestDurationAndCaptureGroup({required PillSheet pillSheet}) async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2026-10-29"));
        final mockIDGenerator = MockFirestoreIDGenerator();
        when(mockIDGenerator.call()).thenReturn("rest_duration_id");
        firestoreIDGenerator = mockIDGenerator;

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(batchSetPillSheetGroup(any, any)).thenAnswer((invocation) => invocation.positionalArguments[1] as PillSheetGroup);
        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(any, any)).thenReturn(null);

        await BeginRestDuration(
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        ).call(
          pillSheetGroup: PillSheetGroup(
            id: "group_id",
            pillSheetIDs: ["pill_sheet_id_1"],
            pillSheets: [pillSheet],
            createdAt: DateTime.parse("2026-10-13"),
          ),
          endDate: null,
        );
        return verify(batchSetPillSheetGroup(batch, captureAny)).captured.single as PillSheetGroup;
      }

      test("v1: 追加される服用お休みは終了済みの服用お休みの終了日から始まる", () async {
        final updatedPillSheetGroup = await beginRestDurationAndCaptureGroup(pillSheet: pillSheet(isV2: false));

        expect(updatedPillSheetGroup.pillSheets.first.restDurations.last.beginDate, DateTime.parse("2026-10-29"));
      });

      group("v2", () {
        test("追加される服用お休みは終了済みの服用お休みの終了日から始まる", () async {
          final updatedPillSheetGroup = await beginRestDurationAndCaptureGroup(pillSheet: pillSheet(isV2: true));

          expect(updatedPillSheetGroup.pillSheets.first.restDurations.last.beginDate, DateTime.parse("2026-10-29"));
        });
      });
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
      final endedRestDuration = notYetEndRestDuration.copyWith(endDate: now());

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet.v1(
        id: "pill_sheet_id_1",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginDate: now(),
        lastTakenDate: null,
        restDurations: [notYetEndRestDuration],
        createdAt: now(),
      );
      final updatedPillSheet = pillSheet.copyWith(
        restDurations: [endedRestDuration],
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["pill_sheet_id_1"].toList(),
        pillSheets: [pillSheet],
        createdAt: now(),
        pillSheetAppearanceMode: PillSheetAppearanceMode.number,
      );
      final updatedPillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["pill_sheet_id_1"].toList(),
        pillSheets: [updatedPillSheet],
        createdAt: now(),
        pillSheetAppearanceMode: PillSheetAppearanceMode.number,
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(
        batchSetPillSheetGroup(batch, updatedPillSheetGroup),
      ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createEndedRestDurationAction(
        restDuration: endedRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final endRestDuration = EndRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
      );
      await endRestDuration.call(
        activePillSheet: pillSheet,
        pillSheetGroup: pillSheetGroup,
        restDuration: notYetEndRestDuration,
      );

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
      final endedRestDuration = notYetEndRestDuration.copyWith(endDate: now());

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final firstPillSheetBeginDate = now().subtract(const Duration(days: 10));
      var pillSheets = [
        PillSheet.v1(
          id: "pill_sheet_id_1",
          groupIndex: 0,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: firstPillSheetBeginDate,
          lastTakenDate: null,
          restDurations: [notYetEndRestDuration],
          createdAt: now(),
        ),
        PillSheet.v1(
          id: "pill_sheet_id_2",
          groupIndex: 1,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: firstPillSheetBeginDate.add(const Duration(days: 28)),
          lastTakenDate: null,
          createdAt: now(),
        ),
        PillSheet.v1(
          id: "pill_sheet_id_3",
          groupIndex: 2,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: firstPillSheetBeginDate.add(const Duration(days: 56)),
          lastTakenDate: null,
          createdAt: now(),
        ),
      ];
      final updatedPillShee$1 = pillSheets[0].copyWith(
        restDurations: [endedRestDuration],
      );
      final updatedPillShee$2 = pillSheets[1].copyWith(
        beginDate: updatedPillShee$1.estimatedEndTakenDate.add(
          const Duration(days: 1),
        ),
      );
      final updatedPillShee$3 = pillSheets[2].copyWith(
        beginDate: updatedPillShee$2.estimatedEndTakenDate.add(
          const Duration(days: 1),
        ),
      );
      final updatedPillSheets = [
        updatedPillShee$1,
        updatedPillShee$2,
        updatedPillShee$3,
      ];

      expect(
        isSameDay(pillSheets[0].beginDate, updatedPillShee$1.beginDate),
        true,
      );
      expect(
        isSameDay(pillSheets[1].beginDate, updatedPillShee$2.beginDate),
        false,
      );
      expect(
        isSameDay(pillSheets[2].beginDate, updatedPillShee$3.beginDate),
        false,
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: pillSheets.map((e) => e.id!).toList(),
        pillSheets: pillSheets,
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(
        pillSheets: updatedPillSheets,
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(
        batchSetPillSheetGroup(batch, updatedPillSheetGroup),
      ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createEndedRestDurationAction(
        restDuration: endedRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final endRestDuration = EndRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
      );
      await endRestDuration.call(
        activePillSheet: pillSheets[0],
        pillSheetGroup: pillSheetGroup,
        restDuration: notYetEndRestDuration,
      );

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });

    test(
        "endDateが未来の服用お休み期間を今日で終了すると、endDateが今日になり2枚目のbeginDateが今日までの服用お休みで再計算される",
        () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final plannedRestDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: DateTime.parse("2020-09-17"),
        createdDate: DateTime.parse("2020-09-17"),
        endDate: DateTime.parse("2020-09-24"),
      );
      final endedRestDuration = plannedRestDuration.copyWith(endDate: now());

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheets = [
        PillSheet.v1(
          id: "pill_sheet_id_1",
          groupIndex: 0,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime.parse("2020-09-10"),
          lastTakenDate: null,
          restDurations: [plannedRestDuration],
          createdAt: now(),
        ),
        PillSheet.v1(
          id: "pill_sheet_id_2",
          groupIndex: 1,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          // 予定の終了日(9/24)まで全日数含めた値で確定されていた開始日
          beginDate: DateTime.parse("2020-10-15"),
          lastTakenDate: null,
          createdAt: now(),
        ),
      ];
      expect(pillSheets[0].activeRestDuration, plannedRestDuration);

      final updatedPillSheet1 = pillSheets[0].copyWith(
        restDurations: [endedRestDuration],
      );
      final updatedPillSheet2 = pillSheets[1].copyWith(
        beginDate: updatedPillSheet1.estimatedEndTakenDate.add(
          const Duration(days: 1),
        ),
      );
      // 9/17から今日(9/19)までの2日だけ数えるので、2枚目は予定の終了日までの全日数で確定されていた10/15より早くなる
      expect(
          updatedPillSheet2.beginDate.isBefore(pillSheets[1].beginDate), true);
      expect(updatedPillSheet1.activeRestDuration, null);

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: pillSheets.map((e) => e.id!).toList(),
        pillSheets: pillSheets,
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(
        pillSheets: [updatedPillSheet1, updatedPillSheet2],
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(
        batchSetPillSheetGroup(batch, updatedPillSheetGroup),
      ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createEndedRestDurationAction(
        restDuration: endedRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final endRestDuration = EndRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
      );
      await endRestDuration.call(
        activePillSheet: pillSheets[0],
        pillSheetGroup: pillSheetGroup,
        restDuration: plannedRestDuration,
      );

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });
  });

  group("#changeRestDurationBeginDate", () {
    test("ピルシートが1枚の場合", () async {
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

      final pillSheet = PillSheet.v1(
        id: "pill_sheet_id_1",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: null,
        beginDate: now(),
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
      when(
        batchSetPillSheetGroup(batch, updatedPillSheetGroup),
      ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createChangedRestDurationBeginDateAction(
        beforeRestDuration: beforeRestDuration,
        afterRestDuration: afterRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final changeRestDuration = ChangeRestDuration(
        actionType: PillSheetModifiedActionType.changedRestDurationBeginDate,
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
      );
      await changeRestDuration.call(
        fromRestDuration: beforeRestDuration,
        toRestDuration: afterRestDuration,
        pillSheetGroup: pillSheetGroup,
      );

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });

    test(
      "ピルシートが複数枚。2枚目から1枚目に変更する場合。2枚目以降のpillSheet.beginDateも変更される & 2枚目以降のlastTakenDateはクリアされる",
      () async {
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
          beginDate: now().addDays(-3),
          createdDate: now(),
          endDate: null,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet1 = PillSheet.v1(
          id: "pill_sheet_id_1",
          groupIndex: 0,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: now().addDays(-4),
          beginDate: now().addDays(-30),
          createdAt: now(),
          restDurations: [],
        );
        final pillSheet2 = PillSheet.v1(
          id: "pill_sheet_id_2",
          groupIndex: 1,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: now(),
          beginDate: now().addDays(-2),
          createdAt: now(),
          restDurations: [beforeRestDuration],
        );
        final pillSheet3 = PillSheet.v1(
          id: "pill_sheet_id_3",
          groupIndex: 2,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: null,
          beginDate: pillSheet2.estimatedEndTakenDate.addDays(1).date(),
          createdAt: now(),
          restDurations: [],
        );
        final updatedPillSheet1 = pillSheet1.copyWith(
          restDurations: [afterRestDuration],
        );
        // afterRestDuration.beginDateで生じた差(-3)の数だけ、pillSheet.beginDateが動く
        final updatedPillSheet2 = (pillSheet2 as PillSheetV1).copyWith(
          beginDate: pillSheet2.beginDate.addDays(3),
          lastTakenDate: null,
          restDurations: [],
        );
        final updatedPillSheet3 = pillSheet3.copyWith(
          beginDate: updatedPillSheet2.estimatedEndTakenDate.addDays(1).date(),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [
            "pill_sheet_id_1",
            "pill_sheet_id_2",
            "pill_sheet_id_3",
          ],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedPillSheet1, updatedPillSheet2, updatedPillSheet3],
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final changeRestDuration = ChangeRestDuration(
          actionType: PillSheetModifiedActionType.changedRestDurationBeginDate,
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        );
        await changeRestDuration.call(
          fromRestDuration: beforeRestDuration,
          toRestDuration: afterRestDuration,
          pillSheetGroup: pillSheetGroup,
        );

        verify(batchFactory.batch()).called(1);

        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
      },
    );

    test(
      "ピルシートが複数枚。2枚目から1枚目に変更する場合。変更後もrestDurationを1つ持っている。2枚目以降のpillSheet.beginDateも変更される & 2枚目以降のlastTakenDateはクリアされない",
      () async {
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
        // テストケース的に日付の差分は考えなくて良いので begin == end のデータを用意して、テストケースの用意を簡略化している
        final notChangeRestDuration = RestDuration(
          id: "_rest_duration_id",
          beginDate: now(),
          createdDate: now(),
          endDate: now(),
        );
        final afterRestDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: now().addDays(-3),
          createdDate: now(),
          endDate: null,
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet1 = PillSheet.v1(
          id: "pill_sheet_id_1",
          groupIndex: 0,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: now().addDays(-4),
          beginDate: now().addDays(-30),
          createdAt: now(),
          restDurations: [],
        );
        final pillSheet2 = PillSheet.v1(
          id: "pill_sheet_id_2",
          groupIndex: 1,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: now(),
          beginDate: now().addDays(-2),
          createdAt: now(),
          restDurations: [notChangeRestDuration, beforeRestDuration],
        );
        final pillSheet3 = PillSheet.v1(
          id: "pill_sheet_id_3",
          groupIndex: 2,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: null,
          beginDate: pillSheet2.estimatedEndTakenDate.addDays(1).date(),
          createdAt: now(),
          restDurations: [],
        );
        final updatedPillSheet1 = pillSheet1.copyWith(
          restDurations: [afterRestDuration],
        );
        // afterRestDuration.beginDateで生じた差(-3)の数だけ、pillSheet.beginDateが動く
        final updatedPillSheet2 = pillSheet2.copyWith(
          beginDate: pillSheet2.beginDate.addDays(3),
          // 変更されない
          // lastTakenDate: null,
          restDurations: [notChangeRestDuration],
        );
        final updatedPillSheet3 = pillSheet3.copyWith(
          beginDate: updatedPillSheet2.estimatedEndTakenDate.addDays(1).date(),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [
            "pill_sheet_id_1",
            "pill_sheet_id_2",
            "pill_sheet_id_3",
          ],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedPillSheet1, updatedPillSheet2, updatedPillSheet3],
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createChangedRestDurationBeginDateAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final changeRestDuration = ChangeRestDuration(
          actionType: PillSheetModifiedActionType.changedRestDurationBeginDate,
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        );
        await changeRestDuration.call(
          fromRestDuration: beforeRestDuration,
          toRestDuration: afterRestDuration,
          pillSheetGroup: pillSheetGroup,
        );

        verify(batchFactory.batch()).called(1);

        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
      },
    );

    group("服用お休み中の開始日を、終了済みの別の服用お休みと重なる日に変更する場合", () {
      final finishedRestDuration = RestDuration(
        id: "finished_rest_duration_id",
        beginDate: DateTime.parse("2026-10-26"),
        endDate: DateTime.parse("2026-10-29"),
        createdDate: DateTime.parse("2026-10-26"),
      );
      final activeRestDuration = RestDuration(
        id: "active_rest_duration_id",
        beginDate: DateTime.parse("2026-10-29"),
        endDate: null,
        createdDate: DateTime.parse("2026-10-29"),
      );

      PillSheet pillSheet({required bool isV2}) {
        final beginDate = DateTime.parse("2026-10-13");
        final lastTakenDate = DateTime.parse("2026-10-25");
        if (isV2) {
          return PillSheet.v2(
            id: "pill_sheet_id_1",
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            beginDate: beginDate,
            createdAt: beginDate,
            restDurations: [finishedRestDuration, activeRestDuration],
            pills: Pill.testGenerateAndIterateTo(
              pillSheetType: PillSheetType.pillsheet_28_0,
              fromDate: beginDate,
              lastTakenDate: lastTakenDate,
              pillTakenCount: 2,
            ),
          );
        }
        return PillSheet.v1(
          id: "pill_sheet_id_1",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: beginDate,
          lastTakenDate: lastTakenDate,
          createdAt: beginDate,
          restDurations: [finishedRestDuration, activeRestDuration],
        );
      }

      Future<void> expectNotSavedWithError({required PillSheet pillSheet}) async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2026-10-30"));

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();

        await expectLater(
          ChangeRestDuration(
            actionType: PillSheetModifiedActionType.changedRestDurationBeginDate,
            batchFactory: batchFactory,
            batchSetPillSheetGroup: batchSetPillSheetGroup,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          ).call(
            fromRestDuration: activeRestDuration,
            toRestDuration: RestDuration(
              id: "changed_rest_duration_id",
              beginDate: DateTime.parse("2026-10-28"),
              endDate: null,
              createdDate: DateTime.parse("2026-10-30"),
            ),
            pillSheetGroup: PillSheetGroup(
              id: "group_id",
              pillSheetIDs: ["pill_sheet_id_1"],
              pillSheets: [pillSheet],
              createdAt: DateTime.parse("2026-10-13"),
            ),
          ),
          throwsA(isA<AlertError>()),
        );
        verifyNever(batchSetPillSheetGroup(any, any));
        verifyNever(batchSetPillSheetModifiedHistory(any, any));
        verifyNever(batch.commit());
      }

      test("v1: 保存せずにエラーになる", () async {
        await expectNotSavedWithError(pillSheet: pillSheet(isV2: false));
      });

      group("v2", () {
        test("保存せずにエラーになる", () async {
          await expectNotSavedWithError(pillSheet: pillSheet(isV2: true));
        });
      });
    });
  });

  group("#changeRestDuration", () {
    test("ピルシートが1枚の時", () async {
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

      final pillSheet = PillSheet.v1(
        id: "pill_sheet_id_1",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        lastTakenDate: null,
        beginDate: now(),
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
      when(
        batchSetPillSheetGroup(batch, updatedPillSheetGroup),
      ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createChangedRestDurationAction(
        beforeRestDuration: beforeRestDuration,
        afterRestDuration: afterRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final beginRestDuration = ChangeRestDuration(
        actionType: PillSheetModifiedActionType.changedRestDuration,
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
      );
      await beginRestDuration.call(
        fromRestDuration: beforeRestDuration,
        toRestDuration: afterRestDuration,
        pillSheetGroup: pillSheetGroup,
      );

      verify(batchFactory.batch()).called(1);

      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });

    test(
      "ピルシートが複数枚。2枚目から1枚目に変更する場合。2枚目以降のpillSheet.beginDateも変更される & 2枚目以降のlastTakenDateはクリアされる",
      () async {
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
        // テストケース的に日付の差分は考えなくて良いので begin == end のデータを用意して、テストケースの用意を簡略化している
        final notChangeRestDuration = RestDuration(
          id: "_rest_duration_id",
          beginDate: now(),
          createdDate: now(),
          endDate: now(),
        );
        final afterRestDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: now().addDays(-3),
          createdDate: now(),
          endDate: now().addDays(-2),
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet1 = PillSheet.v1(
          id: "pill_sheet_id_1",
          groupIndex: 0,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: now().addDays(-4),
          beginDate: now().addDays(-30),
          createdAt: now(),
          restDurations: [],
        );
        final pillSheet2 = PillSheet.v1(
          id: "pill_sheet_id_2",
          groupIndex: 1,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: now(),
          beginDate: now().addDays(-2),
          createdAt: now(),
          restDurations: [notChangeRestDuration, beforeRestDuration],
        );
        final pillSheet3 = PillSheet.v1(
          id: "pill_sheet_id_3",
          groupIndex: 2,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: null,
          beginDate: pillSheet2.estimatedEndTakenDate.addDays(1).date(),
          createdAt: now(),
          restDurations: [],
        );
        final updatedPillSheet1 = pillSheet1.copyWith(
          restDurations: [afterRestDuration],
        );
        final updatedPillSheet2 = pillSheet2.copyWith(
          beginDate: updatedPillSheet1.estimatedEndTakenDate.date().addDays(1),
          // 変更されない
          // lastTakenDate: null,
          restDurations: [notChangeRestDuration],
        );
        final updatedPillSheet3 = pillSheet3.copyWith(
          beginDate: updatedPillSheet2.estimatedEndTakenDate.addDays(1).date(),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [
            "pill_sheet_id_1",
            "pill_sheet_id_2",
            "pill_sheet_id_3",
          ],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedPillSheet1, updatedPillSheet2, updatedPillSheet3],
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final changeRestDuration = ChangeRestDuration(
          actionType: PillSheetModifiedActionType.changedRestDuration,
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        );
        await changeRestDuration.call(
          fromRestDuration: beforeRestDuration,
          toRestDuration: afterRestDuration,
          pillSheetGroup: pillSheetGroup,
        );

        verify(batchFactory.batch()).called(1);

        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
      },
    );

    test(
      "ピルシートが複数枚。2枚目から1枚目に変更する場合。変更後もrestDurationを1つ持っている。2枚目以降のpillSheet.beginDateも変更される & 2枚目以降のlastTakenDateはクリアされない",
      () async {
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
          beginDate: now().addDays(-3),
          createdDate: now(),
          endDate: now().addDays(-2),
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet1 = PillSheet.v1(
          id: "pill_sheet_id_1",
          groupIndex: 0,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: now().addDays(-4),
          beginDate: now().addDays(-30),
          createdAt: now(),
          restDurations: [],
        );
        final pillSheet2 = PillSheet.v1(
          id: "pill_sheet_id_2",
          groupIndex: 1,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: now(),
          beginDate: now().addDays(-2),
          createdAt: now(),
          restDurations: [beforeRestDuration],
        );
        final pillSheet3 = PillSheet.v1(
          id: "pill_sheet_id_3",
          groupIndex: 2,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: null,
          beginDate: pillSheet2.estimatedEndTakenDate.addDays(1).date(),
          createdAt: now(),
          restDurations: [],
        );
        final updatedPillSheet1 = pillSheet1.copyWith(
          restDurations: [afterRestDuration],
        );
        final updatedPillSheet2 = (pillSheet2 as PillSheetV1).copyWith(
          beginDate: updatedPillSheet1.estimatedEndTakenDate.date().addDays(1),
          lastTakenDate: null,
          restDurations: [],
        );
        final updatedPillSheet3 = pillSheet3.copyWith(
          beginDate: updatedPillSheet2.estimatedEndTakenDate.addDays(1).date(),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: [
            "pill_sheet_id_1",
            "pill_sheet_id_2",
            "pill_sheet_id_3",
          ],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedPillSheet1, updatedPillSheet2, updatedPillSheet3],
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final changeRestDuration = ChangeRestDuration(
          actionType: PillSheetModifiedActionType.changedRestDuration,
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        );
        await changeRestDuration.call(
          fromRestDuration: beforeRestDuration,
          toRestDuration: afterRestDuration,
          pillSheetGroup: pillSheetGroup,
        );

        verify(batchFactory.batch()).called(1);

        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
      },
    );

    test(
      "服用再開予定日(endDateが未来)ありの服用お休み中に終了日を2日延ばすと、2枚目のbeginDateが新しい予定終了日+1日になる",
      () async {
        var mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse("2020-09-19"));

        // 9/17開始で服用再開予定日が9/24の服用お休み中
        final beforeRestDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime.parse("2020-09-17"),
          createdDate: DateTime.parse("2020-09-17"),
          endDate: DateTime.parse("2020-09-24"),
        );
        // 服用再開予定日を9/26へ2日延ばす
        final afterRestDuration = beforeRestDuration.copyWith(
          endDate: DateTime.parse("2020-09-26"),
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet1 = PillSheet.v1(
          id: "pill_sheet_id_1",
          groupIndex: 0,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: DateTime.parse("2020-09-16"),
          beginDate: DateTime.parse("2020-09-10"),
          createdAt: DateTime.parse("2020-09-10"),
          restDurations: [beforeRestDuration],
        );
        // 変更前: 9/10 + 27日 + 服用お休み7日(9/17〜9/24) = 10/14 なので、2枚目は10/15開始
        final pillSheet2 = PillSheet.v1(
          id: "pill_sheet_id_2",
          groupIndex: 1,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: null,
          beginDate: DateTime.parse("2020-10-15"),
          createdAt: DateTime.parse("2020-09-10"),
        );
        expect(
          pillSheet1.estimatedEndTakenDateWithPlannedResume.date().addDays(1),
          DateTime.parse("2020-10-15"),
        );
        // 表示用のestimatedEndTakenDateは今日(9/19)までの2日で打ち切るので、2枚目の開始日の確定には使えない
        expect(
          pillSheet1.estimatedEndTakenDate.date().addDays(1),
          DateTime.parse("2020-10-10"),
        );

        final updatedPillSheet1 = pillSheet1.copyWith(
          restDurations: [afterRestDuration],
        );
        // 変更後: 9/10 + 27日 + 服用お休み9日(9/17〜9/26) = 10/16 なので、2枚目は10/17開始
        final updatedPillSheet2 = pillSheet2.copyWith(
          beginDate: DateTime.parse("2020-10-17"),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["pill_sheet_id_1", "pill_sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: DateTime.parse("2020-09-10"),
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedPillSheet1, updatedPillSheet2],
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createChangedRestDurationAction(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final changeRestDuration = ChangeRestDuration(
          actionType: PillSheetModifiedActionType.changedRestDuration,
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        );
        await changeRestDuration.call(
          fromRestDuration: beforeRestDuration,
          toRestDuration: afterRestDuration,
          pillSheetGroup: pillSheetGroup,
        );

        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
      },
    );

    test(
      "服用再開予定日ありの服用お休み中に同じシートの過去の服用お休みを変更しても、restDurationsは開始日順に保たれ、2枚目のbeginDateは予定終了日+1日から計算される",
      () async {
        var mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse("2020-09-19"));

        // 9/12〜9/14(2日)の終了済みの服用お休みと、9/17開始で服用再開予定日が9/24の服用お休み中
        final pastRestDuration = RestDuration(
          id: "rest_duration_id_past",
          beginDate: DateTime.parse("2020-09-12"),
          createdDate: DateTime.parse("2020-09-12"),
          endDate: DateTime.parse("2020-09-14"),
        );
        final plannedRestDuration = RestDuration(
          id: "rest_duration_id_planned",
          beginDate: DateTime.parse("2020-09-17"),
          createdDate: DateTime.parse("2020-09-17"),
          endDate: DateTime.parse("2020-09-24"),
        );
        // 過去の服用お休みを9/12〜9/15(3日)に1日延ばす
        final afterPastRestDuration = pastRestDuration.copyWith(
          endDate: DateTime.parse("2020-09-15"),
        );

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet1 = PillSheet.v1(
          id: "pill_sheet_id_1",
          groupIndex: 0,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: DateTime.parse("2020-09-16"),
          beginDate: DateTime.parse("2020-09-10"),
          createdAt: DateTime.parse("2020-09-10"),
          restDurations: [pastRestDuration, plannedRestDuration],
        );
        // 変更前: 9/10 + 27日 + 服用お休み2日 + 7日(9/17〜9/24) = 10/16 なので、2枚目は10/17開始
        final pillSheet2 = PillSheet.v1(
          id: "pill_sheet_id_2",
          groupIndex: 1,
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          lastTakenDate: null,
          beginDate: DateTime.parse("2020-10-17"),
          createdAt: DateTime.parse("2020-09-10"),
        );
        expect(
          pillSheet1.estimatedEndTakenDateWithPlannedResume.date().addDays(1),
          DateTime.parse("2020-10-17"),
        );

        // 変更後の末尾は、過去の服用お休みではなく服用再開予定日ありの服用お休み
        final updatedPillSheet1 = pillSheet1.copyWith(
          restDurations: [afterPastRestDuration, plannedRestDuration],
        );
        // 変更後: 9/10 + 27日 + 服用お休み3日 + 7日 = 10/17 なので、2枚目は10/18開始
        final updatedPillSheet2 = pillSheet2.copyWith(
          beginDate: DateTime.parse("2020-10-18"),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["pill_sheet_id_1", "pill_sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: DateTime.parse("2020-09-10"),
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedPillSheet1, updatedPillSheet2],
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createChangedRestDurationAction(
          beforeRestDuration: pastRestDuration,
          afterRestDuration: afterPastRestDuration,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final changeRestDuration = ChangeRestDuration(
          actionType: PillSheetModifiedActionType.changedRestDuration,
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        );
        await changeRestDuration.call(
          fromRestDuration: pastRestDuration,
          toRestDuration: afterPastRestDuration,
          pillSheetGroup: pillSheetGroup,
        );

        verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
        verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
      },
    );

    group("lastTakenDateの補正", () {
      test(
        "1枚のシートで28番まで服用済みの状態で服用お休み期間を4日から2日に短くすると、lastTakenDateが新しい終了予定日の日付に補正されlastTakenOrZeroPillNumberが28のまま",
        () async {
          var mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now())
              .thenReturn(DateTime.parse("2020-12-01"));

          final beforeRestDuration = RestDuration(
            id: "rest_duration_id",
            beginDate: DateTime.parse("2020-09-10"),
            createdDate: DateTime.parse("2020-09-10"),
            endDate: DateTime.parse("2020-09-14"),
          );
          final afterRestDuration = RestDuration(
            id: "rest_duration_id",
            beginDate: DateTime.parse("2020-09-10"),
            createdDate: DateTime.parse("2020-09-10"),
            endDate: DateTime.parse("2020-09-12"),
          );

          final batchFactory = MockBatchFactory();
          final batch = MockWriteBatch();
          when(batchFactory.batch()).thenReturn(batch);

          // 28錠を服用お休み4日分延びた10/2に28番まで服用済み
          final pillSheet = PillSheet.v1(
            id: "pill_sheet_id_1",
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            lastTakenDate: DateTime.parse("2020-10-02"),
            beginDate: DateTime.parse("2020-09-01"),
            createdAt: DateTime.parse("2020-09-01"),
            restDurations: [beforeRestDuration],
          );
          expect(pillSheet.lastTakenOrZeroPillNumber, 28);
          // 補正しない場合は短くした2日分、錠数を超える
          expect(
            pillSheet.copyWith(
                restDurations: [afterRestDuration]).lastTakenOrZeroPillNumber,
            30,
          );
          final updatedPillSheet = (pillSheet as PillSheetV1).copyWith(
            lastTakenDate: DateTime.parse("2020-09-30"),
            restDurations: [afterRestDuration],
          );
          expect(updatedPillSheet.lastTakenOrZeroPillNumber, 28);

          final pillSheetGroup = PillSheetGroup(
            id: "group_id",
            pillSheetIDs: ["pill_sheet_id_1"],
            pillSheets: [pillSheet],
            createdAt: DateTime.parse("2020-09-01"),
          );
          final updatedPillSheetGroup = pillSheetGroup.copyWith(
            pillSheets: [updatedPillSheet],
          );
          final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
          when(
            batchSetPillSheetGroup(batch, updatedPillSheetGroup),
          ).thenReturn(updatedPillSheetGroup);

          final history = PillSheetModifiedHistoryServiceActionFactory
              .createChangedRestDurationAction(
            beforeRestDuration: beforeRestDuration,
            afterRestDuration: afterRestDuration,
            beforePillSheetGroup: pillSheetGroup,
            afterPillSheetGroup: updatedPillSheetGroup,
          );
          final batchSetPillSheetModifiedHistory =
              MockBatchSetPillSheetModifiedHistory();
          when(batchSetPillSheetModifiedHistory(batch, history))
              .thenReturn(null);

          final changeRestDuration = ChangeRestDuration(
            actionType: PillSheetModifiedActionType.changedRestDuration,
            batchFactory: batchFactory,
            batchSetPillSheetGroup: batchSetPillSheetGroup,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          );
          await changeRestDuration.call(
            fromRestDuration: beforeRestDuration,
            toRestDuration: afterRestDuration,
            pillSheetGroup: pillSheetGroup,
          );

          verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup))
              .called(1);
          verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
        },
      );

      for (final isTakenAllSecondPillSheet in [true, false]) {
        test(
          isTakenAllSecondPillSheet
              ? "複数シートで1枚目の服用お休み期間を短くした時、2枚目が全て服用済みなら2枚目のlastTakenDateも新しい終了予定日に補正される"
              : "複数シートで1枚目の服用お休み期間を短くした時、2枚目が服用途中ならlastTakenDateは変わらない",
          () async {
            var mockTodayRepository = MockTodayService();
            todayRepository = mockTodayRepository;
            when(mockTodayRepository.now())
                .thenReturn(DateTime.parse("2020-12-01"));

            final beforeRestDuration = RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-14"),
            );
            final afterRestDuration = RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-12"),
            );
            // 変更対象ではない2枚目の服用お休み期間。2枚目がlastTakenDateをクリアされず保持される条件
            final secondPillSheetRestDuration = RestDuration(
              id: "second_rest_duration_id",
              beginDate: DateTime.parse("2020-10-10"),
              createdDate: DateTime.parse("2020-10-10"),
              endDate: DateTime.parse("2020-10-12"),
            );

            final batchFactory = MockBatchFactory();
            final batch = MockWriteBatch();
            when(batchFactory.batch()).thenReturn(batch);

            final pillSheet1 = PillSheet.v1(
              id: "pill_sheet_id_1",
              groupIndex: 0,
              typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
              lastTakenDate: DateTime.parse("2020-10-02"),
              beginDate: DateTime.parse("2020-09-01"),
              createdAt: DateTime.parse("2020-09-01"),
              restDurations: [beforeRestDuration],
            );
            // 変更前の終了予定日は 10/3 + 27日 + 服用お休み2日 = 11/1
            final pillSheet2 = PillSheet.v1(
              id: "pill_sheet_id_2",
              groupIndex: 1,
              typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
              lastTakenDate: DateTime.parse(
                isTakenAllSecondPillSheet ? "2020-11-01" : "2020-10-20",
              ),
              beginDate: DateTime.parse("2020-10-03"),
              createdAt: DateTime.parse("2020-09-01"),
              restDurations: [secondPillSheetRestDuration],
            );
            final updatedPillSheet1 = (pillSheet1 as PillSheetV1).copyWith(
              lastTakenDate: DateTime.parse("2020-09-30"),
              restDurations: [afterRestDuration],
            );
            // 変更後の2枚目は 10/1 開始で終了予定日が 10/30 になる
            final updatedPillSheet2 = (pillSheet2 as PillSheetV1).copyWith(
              lastTakenDate: DateTime.parse(
                isTakenAllSecondPillSheet ? "2020-10-30" : "2020-10-20",
              ),
              beginDate: DateTime.parse("2020-10-01"),
            );
            expect(
              updatedPillSheet2.estimatedEndTakenDate.date(),
              DateTime.parse("2020-10-30"),
            );
            expect(
              updatedPillSheet2.lastTakenOrZeroPillNumber,
              isTakenAllSecondPillSheet ? 28 : 18,
            );

            final pillSheetGroup = PillSheetGroup(
              id: "group_id",
              pillSheetIDs: ["pill_sheet_id_1", "pill_sheet_id_2"],
              pillSheets: [pillSheet1, pillSheet2],
              createdAt: DateTime.parse("2020-09-01"),
            );
            final updatedPillSheetGroup = pillSheetGroup.copyWith(
              pillSheets: [updatedPillSheet1, updatedPillSheet2],
            );
            final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
            when(
              batchSetPillSheetGroup(batch, updatedPillSheetGroup),
            ).thenReturn(updatedPillSheetGroup);

            final history = PillSheetModifiedHistoryServiceActionFactory
                .createChangedRestDurationAction(
              beforeRestDuration: beforeRestDuration,
              afterRestDuration: afterRestDuration,
              beforePillSheetGroup: pillSheetGroup,
              afterPillSheetGroup: updatedPillSheetGroup,
            );
            final batchSetPillSheetModifiedHistory =
                MockBatchSetPillSheetModifiedHistory();
            when(batchSetPillSheetModifiedHistory(batch, history))
                .thenReturn(null);

            final changeRestDuration = ChangeRestDuration(
              actionType: PillSheetModifiedActionType.changedRestDuration,
              batchFactory: batchFactory,
              batchSetPillSheetGroup: batchSetPillSheetGroup,
              batchSetPillSheetModifiedHistory:
                  batchSetPillSheetModifiedHistory,
            );
            await changeRestDuration.call(
              fromRestDuration: beforeRestDuration,
              toRestDuration: afterRestDuration,
              pillSheetGroup: pillSheetGroup,
            );

            verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup))
                .called(1);
            verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
          },
        );
      }
    });

    group("同じピルシートの別の服用お休みとの重なり", () {
      final firstRestDuration = RestDuration(
        id: "first_rest_duration_id",
        beginDate: DateTime.parse("2026-10-26"),
        endDate: DateTime.parse("2026-10-29"),
        createdDate: DateTime.parse("2026-10-26"),
      );
      final secondRestDuration = RestDuration(
        id: "second_rest_duration_id",
        beginDate: DateTime.parse("2026-10-29"),
        endDate: DateTime.parse("2026-10-30"),
        createdDate: DateTime.parse("2026-10-29"),
      );

      PillSheet pillSheet({required bool isV2}) {
        final beginDate = DateTime.parse("2026-10-13");
        final lastTakenDate = DateTime.parse("2026-10-25");
        if (isV2) {
          return PillSheet.v2(
            id: "pill_sheet_id_1",
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            beginDate: beginDate,
            createdAt: beginDate,
            restDurations: [firstRestDuration, secondRestDuration],
            pills: Pill.testGenerateAndIterateTo(
              pillSheetType: PillSheetType.pillsheet_28_0,
              fromDate: beginDate,
              lastTakenDate: lastTakenDate,
              pillTakenCount: 2,
            ),
          );
        }
        return PillSheet.v1(
          id: "pill_sheet_id_1",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: beginDate,
          lastTakenDate: lastTakenDate,
          createdAt: beginDate,
          restDurations: [firstRestDuration, secondRestDuration],
        );
      }

      /// [secondRestDuration] を [toRestDuration] へ変更し、保存の検証に使うモックを返す
      Future<({MockBatchSetPillSheetGroup batchSetPillSheetGroup, MockWriteBatch batch})> changeSecondRestDuration({
        required PillSheet pillSheet,
        required RestDuration toRestDuration,
      }) async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2026-10-31"));

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(batchSetPillSheetGroup(any, any)).thenAnswer((invocation) => invocation.positionalArguments[1] as PillSheetGroup);
        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(any, any)).thenReturn(null);

        final mocks = (batchSetPillSheetGroup: batchSetPillSheetGroup, batch: batch);
        await ChangeRestDuration(
          actionType: PillSheetModifiedActionType.changedRestDuration,
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        ).call(
          fromRestDuration: secondRestDuration,
          toRestDuration: toRestDuration,
          pillSheetGroup: PillSheetGroup(
            id: "group_id",
            pillSheetIDs: ["pill_sheet_id_1"],
            pillSheets: [pillSheet],
            createdAt: DateTime.parse("2026-10-13"),
          ),
        );
        return mocks;
      }

      for (final isV2 in [false, true]) {
        group(isV2 ? "v2" : "v1", () {
          test("別の服用お休みと重なる期間へ変更すると、保存せずにエラーになる", () async {
            final mockTodayRepository = MockTodayService();
            todayRepository = mockTodayRepository;
            when(mockTodayRepository.now()).thenReturn(DateTime.parse("2026-10-31"));

            final batchFactory = MockBatchFactory();
            final batch = MockWriteBatch();
            when(batchFactory.batch()).thenReturn(batch);
            final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
            final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();

            await expectLater(
              ChangeRestDuration(
                actionType: PillSheetModifiedActionType.changedRestDuration,
                batchFactory: batchFactory,
                batchSetPillSheetGroup: batchSetPillSheetGroup,
                batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
              ).call(
                fromRestDuration: secondRestDuration,
                toRestDuration: RestDuration(
                  id: "changed_rest_duration_id",
                  beginDate: DateTime.parse("2026-10-28"),
                  endDate: DateTime.parse("2026-10-30"),
                  createdDate: DateTime.parse("2026-10-31"),
                ),
                pillSheetGroup: PillSheetGroup(
                  id: "group_id",
                  pillSheetIDs: ["pill_sheet_id_1"],
                  pillSheets: [pillSheet(isV2: isV2)],
                  createdAt: DateTime.parse("2026-10-13"),
                ),
              ),
              throwsA(isA<AlertError>()),
            );
            verifyNever(batchSetPillSheetGroup(any, any));
            verifyNever(batchSetPillSheetModifiedHistory(any, any));
            verifyNever(batch.commit());
          });

          test("変更後の開始日が別の服用お休みの終了日と同じ日なら重ならない扱いで保存される", () async {
            final mocks = await changeSecondRestDuration(
              pillSheet: pillSheet(isV2: isV2),
              toRestDuration: RestDuration(
                id: "changed_rest_duration_id",
                beginDate: DateTime.parse("2026-10-29"),
                endDate: DateTime.parse("2026-10-31"),
                createdDate: DateTime.parse("2026-10-31"),
              ),
            );
            verify(mocks.batchSetPillSheetGroup(mocks.batch, any)).called(1);
            verify(mocks.batch.commit()).called(1);
          });
        });
      }
    });
  });
}
