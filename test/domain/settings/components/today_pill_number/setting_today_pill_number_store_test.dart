import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_store.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_store_parameter.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#modifiyTodayPillNumber", () {
    test("group has only one pill sheet and it is not yet taken", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final pillSheet = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: null,
      );
      final updatedPillSheet = pillSheet.copyWith(
        beginingDate: _today.subtract(
          const Duration(days: 1),
        ),
        lastTakenDate: _today.subtract(
          const Duration(days: 1),
        ),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          pillSheet,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedPillSheet]);
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: updatedPillSheet,
      );

      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final parameter = SettingTodayPillNumberStoreParameter(
        appearanceMode: PillSheetAppearanceMode.number,
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheet,
      );
      final store = container.read(settingTodayPillNumberStoreProvider(parameter).notifier);

      expect(pillSheet.todayPillNumber, 1);

      store.markSelected(
        pageIndex: 0,
        pillNumberIntoPillSheet: 2,
      );
      await store.modifiyTodayPillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
      );
    });

    test("group has only one pill sheet and it is already taken", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final pillSheet = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: _today,
      );
      final updatedPillSheet = pillSheet.copyWith(
        beginingDate: _today.subtract(
          const Duration(days: 1),
        ),
        lastTakenDate: _today.subtract(
          const Duration(days: 1),
        ),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          pillSheet,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedPillSheet]);
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: updatedPillSheet,
      );

      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final parameter = SettingTodayPillNumberStoreParameter(
        appearanceMode: PillSheetAppearanceMode.number,
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheet,
      );
      final store = container.read(settingTodayPillNumberStoreProvider(parameter).notifier);

      expect(pillSheet.todayPillNumber, 1);

      store.markSelected(
        pageIndex: 0,
        pillNumberIntoPillSheet: 2,
      );
      await store.modifiyTodayPillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
      );
    });

    test("group has three pill sheet and it is changed direction middle to left", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2022-05-01");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final left = PillSheet(
        id: "sheet_id_left",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2022-04-03"),
        groupIndex: 0,
        lastTakenDate: DateTime.parse("2022-04-30"),
      );
      final middle = PillSheet(
        id: "sheet_id_middle",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2022-05-01"),
        groupIndex: 1,
        lastTakenDate: null,
      );
      final right = PillSheet(
        id: "sheet_id_right",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2022-05-29"),
        groupIndex: 2,
        lastTakenDate: null,
      );
      final updatedLeft = left.copyWith(
        beginingDate: DateTime.parse("2022-04-04"),
        lastTakenDate: DateTime.parse("2022-04-30"), // todayPillNumber - 1
      );
      final updatedMiddle = middle.copyWith(
        beginingDate: DateTime.parse("2022-05-02"),
      );
      final updatedRight = right.copyWith(
        beginingDate: DateTime.parse("2022-05-30"),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id_left", "sheet_id_middle", "sheet_id_right"],
        pillSheets: [
          left,
          middle,
          right,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [
        updatedLeft,
        updatedMiddle,
        updatedRight,
      ]);
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: middle,
        after: updatedLeft,
      );

      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final parameter = SettingTodayPillNumberStoreParameter(
        appearanceMode: PillSheetAppearanceMode.number,
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: middle,
      );
      final store = container.read(settingTodayPillNumberStoreProvider(parameter).notifier);

      expect(middle.todayPillNumber, 1);

      store.markSelected(
        pageIndex: 0,
        pillNumberIntoPillSheet: 28,
      );
      await store.modifiyTodayPillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
      );
    });
    test("group has three pill sheet and it is changed direction middle to left and cheking clear lastTakenDate", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2022-05-01");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final left = PillSheet(
        id: "sheet_id_left",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2022-04-03"),
        groupIndex: 0,
        lastTakenDate: DateTime.parse("2022-04-30"),
      );
      final middle = PillSheet(
        id: "sheet_id_middle",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2022-05-01"),
        groupIndex: 1,
        lastTakenDate: DateTime.parse("2022-05-01"),
      );
      final right = PillSheet(
        id: "sheet_id_right",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2022-05-29"),
        groupIndex: 2,
        lastTakenDate: null,
      );
      final updatedLeft = left.copyWith(
        beginingDate: DateTime.parse("2022-04-04"),
        lastTakenDate: DateTime.parse("2022-04-30"), // todayPillNumber - 1
      );
      final updatedMiddle = middle.copyWith(
        beginingDate: DateTime.parse("2022-05-02"),
        lastTakenDate: null,
      );
      final updatedRight = right.copyWith(
        beginingDate: DateTime.parse("2022-05-30"),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id_left", "sheet_id_middle", "sheet_id_right"],
        pillSheets: [
          left,
          middle,
          right,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [
        updatedLeft,
        updatedMiddle,
        updatedRight,
      ]);
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: middle,
        after: updatedLeft,
      );

      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final parameter = SettingTodayPillNumberStoreParameter(
        appearanceMode: PillSheetAppearanceMode.number,
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: middle,
      );
      final store = container.read(settingTodayPillNumberStoreProvider(parameter).notifier);

      expect(middle.todayPillNumber, 1);

      store.markSelected(
        pageIndex: 0,
        pillNumberIntoPillSheet: 28,
      );
      await store.modifiyTodayPillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
      );
    });
    test("group has three pill sheet and it is changed direction middle to right", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2022-05-01");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final left = PillSheet(
        id: "sheet_id_left",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2022-04-03"),
        groupIndex: 0,
        lastTakenDate: DateTime.parse("2022-04-30"),
      );
      final middle = PillSheet(
        id: "sheet_id_middle",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2022-05-01"),
        groupIndex: 1,
        lastTakenDate: null,
      );
      final right = PillSheet(
        id: "sheet_id_right",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2022-05-29"),
        groupIndex: 2,
        lastTakenDate: null,
      );
      final updatedLeft = left.copyWith(
        beginingDate: DateTime.parse("2022-03-06"),
        lastTakenDate: DateTime.parse("2022-04-02"),
      );
      final updatedMiddle = middle.copyWith(
        beginingDate: DateTime.parse("2022-04-03"),
        lastTakenDate: DateTime.parse("2022-04-30"),
      );
      final updatedRight = right.copyWith(
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: DateTime.parse("2022-04-30"),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id_left", "sheet_id_middle", "sheet_id_right"],
        pillSheets: [
          left,
          middle,
          right,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [
        updatedLeft,
        updatedMiddle,
        updatedRight,
      ]);
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: middle,
        after: updatedRight,
      );

      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final parameter = SettingTodayPillNumberStoreParameter(
        appearanceMode: PillSheetAppearanceMode.number,
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: middle,
      );
      final store = container.read(settingTodayPillNumberStoreProvider(parameter).notifier);

      expect(middle.todayPillNumber, 1);

      store.markSelected(
        pageIndex: 2,
        pillNumberIntoPillSheet: 1,
      );
      await store.modifiyTodayPillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
      );
    });
  });
  group("pill sheet has rest durations", () {
    test("group has three pill sheet and it is changed direction middle to left", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2022-05-02");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final left = PillSheet(
        id: "sheet_id_left",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2022-04-03"),
        groupIndex: 0,
        lastTakenDate: DateTime.parse("2022-04-30"),
        restDurations: [
          RestDuration(
            beginDate: DateTime.parse("2022-04-03"),
            createdDate: DateTime.parse("2022-04-03"),
            endDate: DateTime.parse("2022-04-04"),
          ),
        ],
      );
      final middle = PillSheet(
        id: "sheet_id_middle",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2022-05-02"),
        groupIndex: 1,
        lastTakenDate: null,
      );
      final right = PillSheet(
        id: "sheet_id_right",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2022-05-29"),
        groupIndex: 2,
        lastTakenDate: null,
      );
      final updatedLeft = left.copyWith(
        beginingDate: DateTime.parse("2022-04-05"),
        lastTakenDate: DateTime.parse("2022-05-01"), // todayPillNumber - 1
        restDurations: [],
      );
      final updatedMiddle = middle.copyWith(
        beginingDate: DateTime.parse("2022-05-03"),
      );
      final updatedRight = right.copyWith(
        beginingDate: DateTime.parse("2022-05-31"),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id_left", "sheet_id_middle", "sheet_id_right"],
        pillSheets: [
          left,
          middle,
          right,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [
        updatedLeft,
        updatedMiddle,
        updatedRight,
      ]);
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup)).thenReturn(null);

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: middle,
        after: updatedLeft,
      );

      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final parameter = SettingTodayPillNumberStoreParameter(
        appearanceMode: PillSheetAppearanceMode.number,
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: middle,
      );
      final store = container.read(settingTodayPillNumberStoreProvider(parameter).notifier);

      expect(middle.todayPillNumber, 1);

      store.markSelected(
        pageIndex: 0,
        pillNumberIntoPillSheet: 28,
      );
      await store.modifiyTodayPillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
      );
    });
  });
}
