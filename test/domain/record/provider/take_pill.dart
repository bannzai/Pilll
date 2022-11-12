import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/record/components/add_pill_sheet_group/provider.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/database/pill_sheet.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#take", () {
    test("group has only one pill sheet", () async {
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
      final batchSetPillSheets = MockBatchSetPillSheets();
      when(batchSetPillSheets(batch, [pillSheet.copyWith(lastTakenDate: _today)])).thenReturn(null);

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          pillSheet,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          pillSheet.copyWith(lastTakenDate: _today),
        ],
        createdAt: now(),
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(null);

      final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: pillSheet.copyWith(
          lastTakenDate: _today,
        ),
        isQuickRecord: false,
      );
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      const setting = Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        timezoneDatabaseName: null,
        reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
        ],
      );
      final bachSetSetting = MockBatchSetSetting();
      when(bachSetSetting(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final asyncAction = container.read(recordPageAsyncActionProvider);

      await Future.delayed(const Duration(seconds: 1));
      final result = await asyncAction.taken(pillSheetGroup: pillSheetGroup);
      expect(result, isNotNull);
    });
    test("group has two pill sheet contains future pill sheet", () async {
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
      final pillSheet2 = PillSheet(
        id: "sheet_id_2",
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: _today.add(const Duration(days: 28)),
        groupIndex: 1,
        lastTakenDate: null,
      );
      final batchSetPillSheets = MockBatchSetPillSheets();
      when(batchSetPillSheets(batch, [
        pillSheet.copyWith(lastTakenDate: _today),
        pillSheet2,
      ])).thenReturn([
        pillSheet.copyWith(lastTakenDate: _today),
        pillSheet2,
      ]);

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id", "sheet_id_2"],
        pillSheets: [
          pillSheet,
          pillSheet2,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id", "sheet_id_2"],
        pillSheets: [
          pillSheet.copyWith(lastTakenDate: _today),
          pillSheet2,
        ],
        createdAt: now(),
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(null);

      final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: pillSheet.copyWith(
          lastTakenDate: _today,
        ),
        isQuickRecord: false,
      );
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      const setting = Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        timezoneDatabaseName: null,
        reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_21,
        ],
      );
      final bachSetSetting = MockBatchSetSetting();
      when(bachSetSetting(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final asyncAction = container.read(recordPageAsyncActionProvider);

      await Future.delayed(const Duration(seconds: 1));
      final result = await asyncAction.taken(pillSheetGroup: pillSheetGroup);
      expect(result, isNotNull);
    });
    test("group has two pill sheet for first pillSheet.isFill pattern", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2022-05-29");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2022-05-01"),
        groupIndex: 0,
        lastTakenDate: DateTime.parse("2022-05-28"),
      );
      final pillSheet2 = PillSheet(
        id: "sheet_id_2",
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: _today,
        groupIndex: 1,
        lastTakenDate: null,
      );
      final batchSetPillSheets = MockBatchSetPillSheets();
      when(batchSetPillSheets(batch, [
        pillSheet,
        pillSheet2.copyWith(lastTakenDate: _today),
      ])).thenReturn(null);

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id", "sheet_id_2"],
        pillSheets: [
          pillSheet,
          pillSheet2,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id", "sheet_id_2"],
        pillSheets: [
          pillSheet,
          pillSheet2.copyWith(lastTakenDate: _today),
        ],
        createdAt: now(),
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

      final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: pillSheet2,
        after: pillSheet2.copyWith(
          lastTakenDate: _today,
        ),
        isQuickRecord: false,
      );
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      const setting = Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        timezoneDatabaseName: null,
        reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_21,
        ],
      );
      final bachSetSetting = MockBatchSetSetting();
      when(bachSetSetting(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final asyncAction = container.read(recordPageAsyncActionProvider);

      await Future.delayed(const Duration(seconds: 1));
      final result = await asyncAction.taken(pillSheetGroup: pillSheetGroup);
      expect(result, isNotNull);
    });
    test("group has two pill sheet contains past pill sheet but not yet filled", () async {
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
        beginingDate: _today.subtract(const Duration(days: 28)),
        groupIndex: 0,
        lastTakenDate: _today.subtract(const Duration(days: 2)),
      );
      final pillSheet2 = PillSheet(
        id: "sheet_id_2",
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: _today,
        groupIndex: 1,
        lastTakenDate: null,
      );
      final batchSetPillSheets = MockBatchSetPillSheets();
      when(batchSetPillSheets(
              batch, [pillSheet.copyWith(lastTakenDate: DateTime.parse("2020-09-18 23:59:59")), pillSheet2.copyWith(lastTakenDate: _today)]))
          .thenReturn(null);

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id", "sheet_id_2"],
        pillSheets: [
          pillSheet,
          pillSheet2,
        ],
        createdAt: _today,
      );
      final updatedPillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id", "sheet_id_2"],
        pillSheets: [
          pillSheet.copyWith(lastTakenDate: DateTime.parse("2020-09-18 23:59:59")),
          pillSheet2.copyWith(lastTakenDate: _today),
        ],
        createdAt: _today,
      );

      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

      final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: pillSheet2.copyWith(
          lastTakenDate: _today,
        ),
        isQuickRecord: false,
      );
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      const setting = Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        timezoneDatabaseName: null,
        reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_21,
        ],
      );
      final bachSetSetting = MockBatchSetSetting();
      when(bachSetSetting(batch, setting)).thenReturn(null);

      final takePill = TakePill(
        batchFactory: batchFactory,
        batchSetPillSheets: batchSetPillSheets,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
      );

      final result = await takePill.call(
        takenDate: now(),
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: activedPillSheet,
        isQuickRecord: false,
      );
      expect(result, isNotNull);
    });
  });
}
