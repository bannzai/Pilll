import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/provider/change_pill_number.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#changePillNumber", () {
    test("group has only one pill sheet and it is not yet taken", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final pillSheet = PillSheet.v1(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginDate: mockToday,
        groupIndex: 0,
        lastTakenDate: null,
        createdAt: now(),
      );
      final updatedPillSheet = (pillSheet as PillSheetV1).copyWith(
        beginDate: mockToday.subtract(const Duration(days: 1)),
        lastTakenDate: mockToday.subtract(const Duration(days: 1)),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id"],
        pillSheets: [pillSheet],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(
        pillSheets: [updatedPillSheet],
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(
        batchSetPillSheetGroup(batch, updatedPillSheetGroup),
      ).thenReturn(updatedPillSheetGroup);

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createChangedPillNumberAction(
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );

      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final changePillNumber = ChangePillNumber(
        batchFactory: batchFactory,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
      );

      expect(pillSheet.todayPillNumber, 1);

      await changePillNumber(
        pillSheetGroup: pillSheetGroup,
        activePillSheet: pillSheetGroup.activePillSheet!,
        pillSheetPageIndex: 0,
        pillNumberInPillSheet: 2,
      );
    });

    test("group has only one pill sheet and it is already taken", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final pillSheet = PillSheet.v1(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginDate: mockToday,
        groupIndex: 0,
        lastTakenDate: mockToday,
        createdAt: now(),
      );
      final updatedPillSheet = (pillSheet as PillSheetV1).copyWith(
        beginDate: mockToday.subtract(const Duration(days: 1)),
        lastTakenDate: mockToday.subtract(const Duration(days: 1)),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id"],
        pillSheets: [pillSheet],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(
        pillSheets: [updatedPillSheet],
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(
        batchSetPillSheetGroup(batch, updatedPillSheetGroup),
      ).thenReturn(updatedPillSheetGroup);

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createChangedPillNumberAction(
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );

      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final changePillNumber = ChangePillNumber(
        batchFactory: batchFactory,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
      );

      expect(pillSheet.todayPillNumber, 1);

      await changePillNumber(
        pillSheetGroup: pillSheetGroup,
        activePillSheet: pillSheetGroup.activePillSheet!,
        pillSheetPageIndex: 0,
        pillNumberInPillSheet: 2,
      );
    });

    test(
      "group has three pill sheet and it is changed direction middle to left",
      () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-05-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);
        final left = PillSheet.v1(
          id: "sheet_id_left",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime.parse("2022-04-03"),
          groupIndex: 0,
          lastTakenDate: DateTime.parse("2022-04-30"),
          createdAt: now(),
        );
        final middle = PillSheet.v1(
          id: "sheet_id_middle",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime.parse("2022-05-01"),
          groupIndex: 1,
          lastTakenDate: null,
          createdAt: now(),
        );
        final right = PillSheet.v1(
          id: "sheet_id_right",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime.parse("2022-05-29"),
          groupIndex: 2,
          lastTakenDate: null,
          createdAt: now(),
        );
        final updatedLeft = (left as PillSheetV1).copyWith(
          beginDate: DateTime.parse("2022-04-04"),
          lastTakenDate: DateTime.parse("2022-04-30"), // todayPillNumber - 1
        );
        final updatedMiddle = middle.copyWith(
          beginDate: DateTime.parse("2022-05-02"),
        );
        final updatedRight = right.copyWith(
          beginDate: DateTime.parse("2022-05-30"),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id_left", "sheet_id_middle", "sheet_id_right"],
          pillSheets: [left, middle, right],
          createdAt: now(),
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedLeft, updatedMiddle, updatedRight],
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createChangedPillNumberAction(
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final changePillNumber = ChangePillNumber(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );

        expect(middle.todayPillNumber, 1);

        await changePillNumber(
          pillSheetGroup: pillSheetGroup,
          activePillSheet: pillSheetGroup.activePillSheet!,
          pillSheetPageIndex: 0,
          pillNumberInPillSheet: 28,
        );
      },
    );
    test(
      "group has three pill sheet and it is changed direction middle to left and cheking clear lastTakenDate",
      () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-05-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);
        final left = PillSheet.v1(
          id: "sheet_id_left",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime.parse("2022-04-03"),
          groupIndex: 0,
          lastTakenDate: DateTime.parse("2022-04-30"),
          createdAt: now(),
        );
        final middle = PillSheet.v1(
          id: "sheet_id_middle",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime.parse("2022-05-01"),
          groupIndex: 1,
          lastTakenDate: DateTime.parse("2022-05-01"),
          createdAt: now(),
        );
        final right = PillSheet.v1(
          id: "sheet_id_right",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime.parse("2022-05-29"),
          groupIndex: 2,
          lastTakenDate: null,
          createdAt: now(),
        );
        final updatedLeft = (left as PillSheetV1).copyWith(
          beginDate: DateTime.parse("2022-04-04"),
          lastTakenDate: DateTime.parse("2022-04-30"), // todayPillNumber - 1
        );
        final updatedMiddle = (middle as PillSheetV1).copyWith(
          beginDate: DateTime.parse("2022-05-02"),
          lastTakenDate: null,
        );
        final updatedRight = (right as PillSheetV1).copyWith(
          beginDate: DateTime.parse("2022-05-30"),
          lastTakenDate: null,
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id_left", "sheet_id_middle", "sheet_id_right"],
          pillSheets: [left, middle, right],
          createdAt: now(),
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedLeft, updatedMiddle, updatedRight],
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createChangedPillNumberAction(
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final changePillNumber = ChangePillNumber(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );

        expect(middle.todayPillNumber, 1);

        await changePillNumber(
          pillSheetGroup: pillSheetGroup,
          activePillSheet: pillSheetGroup.activePillSheet!,
          pillSheetPageIndex: 0,
          pillNumberInPillSheet: 28,
        );
      },
    );
    test(
      "group has three pill sheet and it is changed direction middle to right",
      () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-05-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);
        final left = PillSheet.v1(
          id: "sheet_id_left",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime.parse("2022-04-03"),
          groupIndex: 0,
          lastTakenDate: DateTime.parse("2022-04-30"),
          createdAt: now(),
        );
        final middle = PillSheet.v1(
          id: "sheet_id_middle",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime.parse("2022-05-01"),
          groupIndex: 1,
          lastTakenDate: null,
          createdAt: now(),
        );
        final right = PillSheet.v1(
          id: "sheet_id_right",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime.parse("2022-05-29"),
          groupIndex: 2,
          lastTakenDate: null,
          createdAt: now(),
        );
        final updatedLeft = (left as PillSheetV1).copyWith(
          beginDate: DateTime.parse("2022-03-06"),
          lastTakenDate: DateTime.parse("2022-04-02"),
        );
        final updatedMiddle = (middle as PillSheetV1).copyWith(
          beginDate: DateTime.parse("2022-04-03"),
          lastTakenDate: DateTime.parse("2022-04-30"),
        );
        final updatedRight = (right as PillSheetV1).copyWith(
          beginDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id_left", "sheet_id_middle", "sheet_id_right"],
          pillSheets: [left, middle, right],
          createdAt: now(),
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedLeft, updatedMiddle, updatedRight],
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createChangedPillNumberAction(
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final changePillNumber = ChangePillNumber(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );

        expect(middle.todayPillNumber, 1);

        await changePillNumber(
          pillSheetGroup: pillSheetGroup,
          activePillSheet: pillSheetGroup.activePillSheet!,
          pillSheetPageIndex: 2,
          pillNumberInPillSheet: 1,
        );
      },
    );

    group("v2のピルシート", () {
      test("未服用のv2ピルシートでピル番号を変更するとpillsが再構築される", () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-05-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          typeInfo: sheetType.typeInfo,
          beginDate: mockToday,
          groupIndex: 0,
          createdAt: now(),
          restDurations: [],
          pills: Pill.testGenerateAndIterateTo(
            pillSheetType: sheetType,
            fromDate: mockToday,
            lastTakenDate: null,
            pillTakenCount: 2,
          ),
        );

        // ピル番号2を選択した時の期待値
        final expectedBeginDate = mockToday.subtract(const Duration(days: 1));
        final expectedLastTakenDate = mockToday.subtract(
          const Duration(days: 1),
        );
        final updatedPillSheet = (pillSheet as PillSheetV2).copyWith(
          beginDate: expectedBeginDate,
          restDurations: [],
          pills: Pill.generateAndFillTo(
            pillSheetType: sheetType,
            fromDate: expectedBeginDate,
            lastTakenDate: expectedLastTakenDate,
            pillTakenCount: 2,
          ),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedPillSheet],
        );

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createChangedPillNumberAction(
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final changePillNumber = ChangePillNumber(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );

        expect(pillSheet.todayPillNumber, 1);

        await changePillNumber(
          pillSheetGroup: pillSheetGroup,
          activePillSheet: pillSheetGroup.activePillSheet!,
          pillSheetPageIndex: 0,
          pillNumberInPillSheet: 2,
        );
      });

      test("服用済みのv2ピルシートでピル番号を変更するとpillTakensが正しく埋まる", () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-05-05");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        const sheetType = PillSheetType.pillsheet_28_0;
        // 3日目まで服用済み
        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          typeInfo: sheetType.typeInfo,
          beginDate: DateTime.parse("2022-05-01"),
          groupIndex: 0,
          createdAt: now(),
          restDurations: [],
          pills: Pill.testGenerateAndIterateTo(
            pillSheetType: sheetType,
            fromDate: DateTime.parse("2022-05-01"),
            lastTakenDate: DateTime.parse("2022-05-03"),
            pillTakenCount: 2,
          ),
        );

        // ピル番号10を選択：開始日を5日前に、5日目まで服用済みに
        final expectedBeginDate = mockToday.subtract(const Duration(days: 9));
        final expectedLastTakenDate = mockToday.subtract(
          const Duration(days: 1),
        );
        final updatedPillSheet = (pillSheet as PillSheetV2).copyWith(
          beginDate: expectedBeginDate,
          restDurations: [],
          pills: Pill.generateAndFillTo(
            pillSheetType: sheetType,
            fromDate: expectedBeginDate,
            lastTakenDate: expectedLastTakenDate,
            pillTakenCount: 2,
          ),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedPillSheet],
        );

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createChangedPillNumberAction(
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final changePillNumber = ChangePillNumber(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );

        expect(pillSheet.todayPillNumber, 5);

        await changePillNumber(
          pillSheetGroup: pillSheetGroup,
          activePillSheet: pillSheetGroup.activePillSheet!,
          pillSheetPageIndex: 0,
          pillNumberInPillSheet: 10,
        );
      });

      test("2錠飲み設定(takenCount=2)でピル番号を変更するとpillTakensが2つずつ生成される", () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-05-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet.v2(
          id: "sheet_id",
          typeInfo: sheetType.typeInfo,
          beginDate: mockToday,
          groupIndex: 0,
          createdAt: now(),
          restDurations: [],
          pills: Pill.testGenerateAndIterateTo(
            pillSheetType: sheetType,
            fromDate: mockToday,
            lastTakenDate: null,
            pillTakenCount: 2,
          ),
        );

        // ピル番号5を選択した時
        final expectedBeginDate = mockToday.subtract(const Duration(days: 4));
        final expectedLastTakenDate = mockToday.subtract(
          const Duration(days: 1),
        );
        final updatedPillSheet = (pillSheet as PillSheetV2).copyWith(
          beginDate: expectedBeginDate,
          restDurations: [],
          pills: Pill.generateAndFillTo(
            pillSheetType: sheetType,
            fromDate: expectedBeginDate,
            lastTakenDate: expectedLastTakenDate,
            pillTakenCount: 2,
          ),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedPillSheet],
        );

        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createChangedPillNumberAction(
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final changePillNumber = ChangePillNumber(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );

        expect(pillSheet.todayPillNumber, 1);

        await changePillNumber(
          pillSheetGroup: pillSheetGroup,
          activePillSheet: pillSheetGroup.activePillSheet!,
          pillSheetPageIndex: 0,
          pillNumberInPillSheet: 5,
        );

        // 更新後のピルシートでは1〜4番目のピルにそれぞれ2つのpillTakensがあることを確認
        for (var i = 0; i < 4; i++) {
          expect(updatedPillSheet.pills[i].pillTakens.length, 2);
          // 各服用記録の日付が正しいことを確認
          expect(
            isSameDay(
              updatedPillSheet.pills[i].pillTakens.first.recordedTakenDateTime,
              expectedLastTakenDate,
            ),
            isTrue,
            reason:
                'Pill at index $i should have taken date $expectedLastTakenDate, but was ${updatedPillSheet.pills[i].pillTakens.first.recordedTakenDateTime}',
          );
        }
      });
    });
  });
  group("pill sheet has rest durations", () {
    test(
      "group has three pill sheet and it is changed direction middle to left",
      () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-05-02");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);
        final left = PillSheet.v1(
          id: "sheet_id_left",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime.parse("2022-04-03"),
          groupIndex: 0,
          lastTakenDate: DateTime.parse("2022-04-30"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-04-03"),
              createdDate: DateTime.parse("2022-04-03"),
              endDate: DateTime.parse("2022-04-04"),
            ),
          ],
        );
        final middle = PillSheet.v1(
          id: "sheet_id_middle",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime.parse("2022-05-02"),
          groupIndex: 1,
          lastTakenDate: null,
          createdAt: now(),
        );
        final right = PillSheet.v1(
          id: "sheet_id_right",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime.parse("2022-05-29"),
          groupIndex: 2,
          lastTakenDate: null,
          createdAt: now(),
        );
        final updatedLeft = (left as PillSheetV1).copyWith(
          beginDate: DateTime.parse("2022-04-05"),
          lastTakenDate: DateTime.parse("2022-05-01"), // todayPillNumber - 1
          restDurations: [],
        );
        final updatedMiddle = middle.copyWith(
          beginDate: DateTime.parse("2022-05-03"),
        );
        final updatedRight = right.copyWith(
          beginDate: DateTime.parse("2022-05-31"),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id_left", "sheet_id_middle", "sheet_id_right"],
          pillSheets: [left, middle, right],
          createdAt: now(),
        );
        final updatedPillSheetGroup = pillSheetGroup.copyWith(
          pillSheets: [updatedLeft, updatedMiddle, updatedRight],
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(
          batchSetPillSheetGroup(batch, updatedPillSheetGroup),
        ).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createChangedPillNumberAction(
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );

        final batchSetPillSheetModifiedHistory =
            MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        final changePillNumber = ChangePillNumber(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        );

        expect(middle.todayPillNumber, 1);
        await changePillNumber(
          pillSheetGroup: pillSheetGroup,
          activePillSheet: pillSheetGroup.activePillSheet!,
          pillSheetPageIndex: 0,
          pillNumberInPillSheet: 28,
        );
      },
    );
  });
}
