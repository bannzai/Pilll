import 'dart:async';
import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/record/components/add_pill_sheet_group/add_pill_sheet_group_store.dart';
import 'package:pilll/domain/record/record_page_async_action.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/database/pill_sheet.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/database/user.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#register", () {
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
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: null,
      );
      final pillSheetDatastore = MockPillSheetDatastore();
      when(pillSheetDatastore.register(batch, [pillSheet])).thenReturn([
        pillSheet.copyWith(id: "sheet_id"),
      ]);

      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          pillSheet.copyWith(id: "sheet_id"),
        ],
        createdAt: now(),
      );
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.register(batch, pillSheetGroup))
          .thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createCreatedPillSheetAction(
              pillSheetGroupID: "group_id", pillSheetIDs: ["sheet_id"]);
      final pillSheetModifiedHistoryDatastore =
          MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history))
          .thenReturn(null);

      final setting = const Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        reminderTimes: [
          ReminderTime(hour: 21, minute: 20),
          ReminderTime(hour: 22, minute: 0)
        ],
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
        ],
      );
      final settingDatastore = MockSettingDatastore();
      when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider
              .overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider
              .overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final store =
          container.read(addPillSheetGroupStateStoreProvider.notifier);

      await store.register(setting);
    });
    test("group has two pill sheet", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: null,
      );
      final pillSheet2 = PillSheet(
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: _today.add(const Duration(days: 28)),
        lastTakenDate: null,
        groupIndex: 1,
      );
      final pillSheetDatastore = MockPillSheetDatastore();
      when(pillSheetDatastore.register(batch, [pillSheet, pillSheet2]))
          .thenReturn([
        pillSheet.copyWith(id: "sheet_id"),
        pillSheet2.copyWith(id: "sheet_id2")
      ]);

      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["sheet_id", "sheet_id2"],
        pillSheets: [
          pillSheet.copyWith(id: "sheet_id"),
          pillSheet2.copyWith(id: "sheet_id2"),
        ],
        createdAt: now(),
      );
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.register(batch, pillSheetGroup))
          .thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createCreatedPillSheetAction(
              pillSheetGroupID: "group_id",
              pillSheetIDs: ["sheet_id", "sheet_id2"]);
      final pillSheetModifiedHistoryDatastore =
          MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history))
          .thenReturn(null);

      final setting = const Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        reminderTimes: [
          ReminderTime(hour: 21, minute: 20),
          ReminderTime(hour: 22, minute: 0)
        ],
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_21
        ],
      );
      final settingDatastore = MockSettingDatastore();
      when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider
              .overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider
              .overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final store =
          container.read(addPillSheetGroupStateStoreProvider.notifier);

      await store.register(setting);
    });
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
      final pillSheetDatastore = MockPillSheetDatastore();
      when(pillSheetDatastore.update(
          batch, [pillSheet.copyWith(lastTakenDate: _today)])).thenReturn(null);

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
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.updateWithBatch(
              batch, updatedPillSheetGroup))
          .thenReturn(null);

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: pillSheet.copyWith(
          lastTakenDate: _today,
        ),
        isQuickRecord: false,
      );
      final pillSheetModifiedHistoryDatastore =
          MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history))
          .thenReturn(null);

      final setting = const Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        reminderTimes: [
          ReminderTime(hour: 21, minute: 20),
          ReminderTime(hour: 22, minute: 0)
        ],
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
        ],
      );
      final settingDatastore = MockSettingDatastore();
      when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider
              .overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider
              .overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final asyncAction = container.read(recordPageAsyncActionProvider);

      await Future.delayed(const Duration(seconds: 1));
      final result = await asyncAction.taken(pillSheetGroup: pillSheetGroup);
      expect(result, isTrue);
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
      final pillSheetDatastore = MockPillSheetDatastore();
      when(pillSheetDatastore.update(batch, [
        pillSheet.copyWith(lastTakenDate: _today),
        pillSheet2,
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
          pillSheet.copyWith(lastTakenDate: _today),
          pillSheet2,
        ],
        createdAt: now(),
      );
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.updateWithBatch(
              batch, updatedPillSheetGroup))
          .thenReturn(null);

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: pillSheet.copyWith(
          lastTakenDate: _today,
        ),
        isQuickRecord: false,
      );
      final pillSheetModifiedHistoryDatastore =
          MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history))
          .thenReturn(null);

      final setting = const Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        reminderTimes: [
          ReminderTime(hour: 21, minute: 20),
          ReminderTime(hour: 22, minute: 0)
        ],
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_21,
        ],
      );
      final settingDatastore = MockSettingDatastore();
      when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider
              .overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider
              .overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final asyncAction = container.read(recordPageAsyncActionProvider);

      await Future.delayed(const Duration(seconds: 1));
      final result = await asyncAction.taken(pillSheetGroup: pillSheetGroup);
      expect(result, isTrue);
    });
    test("group has two pill sheet for first pillSheet.isFill pattern",
        () async {
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
      final pillSheetDatastore = MockPillSheetDatastore();
      when(pillSheetDatastore.update(batch, [
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
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.updateWithBatch(
              batch, updatedPillSheetGroup))
          .thenReturn(null);

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: pillSheet2,
        after: pillSheet2.copyWith(
          lastTakenDate: _today,
        ),
        isQuickRecord: false,
      );
      final pillSheetModifiedHistoryDatastore =
          MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history))
          .thenReturn(null);

      final setting = const Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        reminderTimes: [
          ReminderTime(hour: 21, minute: 20),
          ReminderTime(hour: 22, minute: 0)
        ],
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_21,
        ],
      );
      final settingDatastore = MockSettingDatastore();
      when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider
              .overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider
              .overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final asyncAction = container.read(recordPageAsyncActionProvider);

      await Future.delayed(const Duration(seconds: 1));
      final result = await asyncAction.taken(pillSheetGroup: pillSheetGroup);
      expect(result, isTrue);
    });
    test("group has two pill sheet contains past pill sheet but not yet filled",
        () async {
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
      final pillSheetDatastore = MockPillSheetDatastore();
      when(pillSheetDatastore.update(batch, [
        pillSheet.copyWith(
            lastTakenDate: DateTime.parse("2020-09-18 23:59:59")),
        pillSheet2.copyWith(lastTakenDate: _today)
      ])).thenReturn(null);

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
          pillSheet.copyWith(
              lastTakenDate: DateTime.parse("2020-09-18 23:59:59")),
          pillSheet2.copyWith(lastTakenDate: _today),
        ],
        createdAt: _today,
      );

      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.updateWithBatch(
              batch, updatedPillSheetGroup))
          .thenReturn(null);

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: pillSheet2.copyWith(
          lastTakenDate: _today,
        ),
        isQuickRecord: false,
      );
      final pillSheetModifiedHistoryDatastore =
          MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history))
          .thenReturn(null);

      final setting = const Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        reminderTimes: [
          ReminderTime(hour: 21, minute: 20),
          ReminderTime(hour: 22, minute: 0)
        ],
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_21,
        ],
      );
      final settingDatastore = MockSettingDatastore();
      when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider
              .overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider
              .overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final asyncAction = container.read(recordPageAsyncActionProvider);

      await Future.delayed(const Duration(seconds: 1));
      final result = await asyncAction.taken(pillSheetGroup: pillSheetGroup);
      expect(result, isTrue);
    });
  });

  group("#revertTaken", () {
    group("group has only one pill sheet", () {
      test("Revert to first pill sheet", () async {
        var mockTodayRepository = MockTodayService();
        final _today = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
        final yesterday = DateTime.parse("2022-01-16");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "sheet_id",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: yesterday,
          groupIndex: 0,
          lastTakenDate: today(),
        );
        final pillSheetDatastore = MockPillSheetDatastore();
        when(pillSheetDatastore.update(batch, [
          pillSheet.copyWith(
              lastTakenDate: yesterday.subtract(const Duration(days: 1)))
        ])).thenReturn(null);

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
            pillSheet.copyWith(
                lastTakenDate: yesterday.subtract(const Duration(days: 1))),
          ],
          createdAt: now(),
        );
        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        when(pillSheetGroupDatastore.updateWithBatch(
                batch, updatedPillSheetGroup))
            .thenReturn(null);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet,
          after: pillSheet.copyWith(
            lastTakenDate: yesterday.subtract(const Duration(days: 1)),
          ),
        );
        final pillSheetModifiedHistoryDatastore =
            MockPillSheetModifiedHistoryDatastore();
        when(pillSheetModifiedHistoryDatastore.add(batch, history))
            .thenReturn(null);

        final setting = const Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          reminderTimes: [
            ReminderTime(hour: 21, minute: 20),
            ReminderTime(hour: 22, minute: 0)
          ],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
          ],
        );
        final settingDatastore = MockSettingDatastore();
        when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

        final container = ProviderContainer(
          overrides: [
            batchFactoryProvider.overrideWithValue(batchFactory),
            settingDatastoreProvider.overrideWithValue(settingDatastore),
            pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
            pillSheetModifiedHistoryDatastoreProvider
                .overrideWithValue(pillSheetModifiedHistoryDatastore),
            pillSheetGroupDatastoreProvider
                .overrideWithValue(pillSheetGroupDatastore),
          ],
        );
        final asyncAction = container.read(recordPageAsyncActionProvider);

        await Future.delayed(const Duration(seconds: 1));
        await asyncAction.revertTaken(
            pillSheetGroup: pillSheetGroup,
            pageIndex: 0,
            pillNumberIntoPillSheet: 1);
      });

      test("Revert today pill", () async {
        var mockTodayRepository = MockTodayService();
        final _today = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
        final yesterday = DateTime.parse("2022-01-16");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "sheet_id",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: yesterday,
          groupIndex: 0,
          lastTakenDate: today(),
        );
        final pillSheetDatastore = MockPillSheetDatastore();
        when(pillSheetDatastore
                .update(batch, [pillSheet.copyWith(lastTakenDate: yesterday)]))
            .thenReturn(null);

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
            pillSheet.copyWith(lastTakenDate: yesterday),
          ],
          createdAt: now(),
        );
        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        when(pillSheetGroupDatastore.updateWithBatch(
                batch, updatedPillSheetGroup))
            .thenReturn(null);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet,
          after: pillSheet.copyWith(
            lastTakenDate: yesterday,
          ),
        );
        final pillSheetModifiedHistoryDatastore =
            MockPillSheetModifiedHistoryDatastore();
        when(pillSheetModifiedHistoryDatastore.add(batch, history))
            .thenReturn(null);

        final setting = const Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          reminderTimes: [
            ReminderTime(hour: 21, minute: 20),
            ReminderTime(hour: 22, minute: 0)
          ],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
          ],
        );
        final settingDatastore = MockSettingDatastore();
        when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

        final container = ProviderContainer(
          overrides: [
            batchFactoryProvider.overrideWithValue(batchFactory),
            settingDatastoreProvider.overrideWithValue(settingDatastore),
            pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
            pillSheetModifiedHistoryDatastoreProvider
                .overrideWithValue(pillSheetModifiedHistoryDatastore),
            pillSheetGroupDatastoreProvider
                .overrideWithValue(pillSheetGroupDatastore),
          ],
        );
        final asyncAction = container.read(recordPageAsyncActionProvider);

        await Future.delayed(const Duration(seconds: 1));
        await asyncAction.revertTaken(
            pillSheetGroup: pillSheetGroup,
            pageIndex: 0,
            pillNumberIntoPillSheet: 2);
      });

      test("revert with rest durations and removed rest duration", () async {
        var mockTodayRepository = MockTodayService();
        final _today = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
        final beginDate = DateTime.parse("2022-01-06");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "sheet_id",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: beginDate,
          groupIndex: 0,
          lastTakenDate: today(),
          restDurations: [
            RestDuration(
              beginDate: _today.subtract(const Duration(days: 2)),
              createdDate: _today.subtract(const Duration(days: 2)),
              endDate: _today.subtract(const Duration(days: 1)),
            ),
          ],
        );
        final pillSheetDatastore = MockPillSheetDatastore();
        when(pillSheetDatastore.update(
          batch,
          [
            pillSheet.copyWith(
                lastTakenDate: beginDate.subtract(const Duration(days: 1)),
                restDurations: [])
          ],
        )).thenReturn(null);

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
            pillSheet.copyWith(
                lastTakenDate: beginDate.subtract(const Duration(days: 1)),
                restDurations: []),
          ],
          createdAt: now(),
        );
        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        when(pillSheetGroupDatastore.updateWithBatch(
                batch, updatedPillSheetGroup))
            .thenReturn(null);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet,
          after: pillSheet.copyWith(
            lastTakenDate: beginDate.subtract(const Duration(days: 1)),
            restDurations: [],
          ),
        );
        final pillSheetModifiedHistoryDatastore =
            MockPillSheetModifiedHistoryDatastore();
        when(pillSheetModifiedHistoryDatastore.add(batch, history))
            .thenReturn(null);

        final setting = const Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          reminderTimes: [
            ReminderTime(hour: 21, minute: 20),
            ReminderTime(hour: 22, minute: 0)
          ],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
          ],
        );
        final settingDatastore = MockSettingDatastore();
        when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

        final container = ProviderContainer(
          overrides: [
            batchFactoryProvider.overrideWithValue(batchFactory),
            settingDatastoreProvider.overrideWithValue(settingDatastore),
            pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
            pillSheetModifiedHistoryDatastoreProvider
                .overrideWithValue(pillSheetModifiedHistoryDatastore),
            pillSheetGroupDatastoreProvider
                .overrideWithValue(pillSheetGroupDatastore),
          ],
        );
        final asyncAction = container.read(recordPageAsyncActionProvider);

        await Future.delayed(const Duration(seconds: 1));
        await asyncAction.revertTaken(
            pillSheetGroup: pillSheetGroup,
            pageIndex: 0,
            pillNumberIntoPillSheet: 1);
      });

      test("revert with rest durations but no removed rest duration", () async {
        var mockTodayRepository = MockTodayService();
        final _today = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
        final beginDate = DateTime.parse("2022-01-06");
        final yesterday = DateTime.parse("2022-01-16");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "sheet_id",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: beginDate,
          groupIndex: 0,
          lastTakenDate: today(),
          restDurations: [
            RestDuration(
              beginDate: _today.subtract(const Duration(days: 8)),
              createdDate: _today.subtract(const Duration(days: 8)),
              endDate: _today.subtract(const Duration(days: 7)),
            ),
          ],
        );
        final pillSheetDatastore = MockPillSheetDatastore();
        when(pillSheetDatastore.update(
          batch,
          [pillSheet.copyWith(lastTakenDate: yesterday)],
        )).thenReturn(null);

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
            pillSheet.copyWith(lastTakenDate: yesterday),
          ],
          createdAt: now(),
        );
        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        when(pillSheetGroupDatastore.updateWithBatch(
                batch, updatedPillSheetGroup))
            .thenReturn(null);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet,
          after: pillSheet.copyWith(lastTakenDate: yesterday),
        );
        final pillSheetModifiedHistoryDatastore =
            MockPillSheetModifiedHistoryDatastore();
        when(pillSheetModifiedHistoryDatastore.add(batch, history))
            .thenReturn(null);

        final setting = const Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          reminderTimes: [
            ReminderTime(hour: 21, minute: 20),
            ReminderTime(hour: 22, minute: 0)
          ],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
          ],
        );
        final settingDatastore = MockSettingDatastore();
        when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

        final container = ProviderContainer(
          overrides: [
            batchFactoryProvider.overrideWithValue(batchFactory),
            settingDatastoreProvider.overrideWithValue(settingDatastore),
            pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
            pillSheetModifiedHistoryDatastoreProvider
                .overrideWithValue(pillSheetModifiedHistoryDatastore),
            pillSheetGroupDatastoreProvider
                .overrideWithValue(pillSheetGroupDatastore),
          ],
        );
        final asyncAction = container.read(recordPageAsyncActionProvider);

        await Future.delayed(const Duration(seconds: 1));
        await asyncAction.revertTaken(
            pillSheetGroup: pillSheetGroup,
            pageIndex: 0,
            pillNumberIntoPillSheet: 11);
      });
    });

    group("group has two pill sheet", () {
      test("call revert into actived pill sheet", () async {
        var mockTodayRepository = MockTodayService();
        final _today = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
        final yesterday = DateTime.parse("2022-01-16");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "1",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: _today.subtract(const Duration(days: 29)),
          groupIndex: 0,
          lastTakenDate: _today.subtract(const Duration(days: 2)),
        );

        // actived pill sheet
        final pillSheet2 = PillSheet(
          id: "2",
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: yesterday,
          lastTakenDate: _today,
          groupIndex: 1,
        );

        final pillSheetDatastore = MockPillSheetDatastore();
        when(pillSheetDatastore.update(batch, [
          pillSheet,
          pillSheet2.copyWith(lastTakenDate: yesterday),
        ])).thenReturn(null);

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["1", "2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
        );
        final updatedPillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["1", "2"],
          pillSheets: [
            pillSheet,
            pillSheet2.copyWith(lastTakenDate: yesterday),
          ],
          createdAt: now(),
        );
        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        when(pillSheetGroupDatastore.updateWithBatch(
                batch, updatedPillSheetGroup))
            .thenReturn(null);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet2,
          after: pillSheet2.copyWith(
            lastTakenDate: yesterday,
          ),
        );
        final pillSheetModifiedHistoryDatastore =
            MockPillSheetModifiedHistoryDatastore();
        when(pillSheetModifiedHistoryDatastore.add(batch, history))
            .thenReturn(null);

        final setting = const Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          reminderTimes: [
            ReminderTime(hour: 21, minute: 20),
            ReminderTime(hour: 22, minute: 0)
          ],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
            PillSheetType.pillsheet_21,
          ],
        );
        final settingDatastore = MockSettingDatastore();
        when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

        final container = ProviderContainer(
          overrides: [
            batchFactoryProvider.overrideWithValue(batchFactory),
            settingDatastoreProvider.overrideWithValue(settingDatastore),
            pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
            pillSheetModifiedHistoryDatastoreProvider
                .overrideWithValue(pillSheetModifiedHistoryDatastore),
            pillSheetGroupDatastoreProvider
                .overrideWithValue(pillSheetGroupDatastore),
          ],
        );
        final asyncAction = container.read(recordPageAsyncActionProvider);

        await Future.delayed(const Duration(seconds: 1));
        await asyncAction.revertTaken(
            pillSheetGroup: pillSheetGroup,
            pageIndex: 1,
            pillNumberIntoPillSheet: 2);
      });

      test("call revert from actived pill sheet to before pill sheet",
          () async {
        var mockTodayRepository = MockTodayService();
        final _today = DateTime.parse("2022-01-31");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
        final yesterday = DateTime.parse("2022-01-30");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "1",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: _today.subtract(const Duration(days: 29)),
          groupIndex: 0,
          lastTakenDate: _today.subtract(const Duration(days: 2)),
        );

        // actived pill sheet
        final pillSheet2 = PillSheet(
          id: "2",
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: yesterday,
          lastTakenDate: _today,
          groupIndex: 1,
        );

        final pillSheetDatastore = MockPillSheetDatastore();
        when(pillSheetDatastore.update(batch, [
          pillSheet.copyWith(
              lastTakenDate: _today.subtract(const Duration(days: 4))),
          pillSheet2.copyWith(
              lastTakenDate:
                  pillSheet2.beginingDate.subtract(const Duration(days: 1))),
        ])).thenReturn(null);

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["1", "2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
        );
        final updatedPillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["1", "2"],
          pillSheets: [
            pillSheet.copyWith(
                lastTakenDate: _today.subtract(const Duration(days: 4))),
            pillSheet2.copyWith(
                lastTakenDate:
                    pillSheet2.beginingDate.subtract(const Duration(days: 1))),
          ],
          createdAt: now(),
        );
        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        when(pillSheetGroupDatastore.updateWithBatch(
                batch, updatedPillSheetGroup))
            .thenReturn(null);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
                pillSheetGroupID: "group_id",
                before: pillSheet2,
                after: pillSheet.copyWith(
                    lastTakenDate: _today.subtract(const Duration(days: 4))));
        final pillSheetModifiedHistoryDatastore =
            MockPillSheetModifiedHistoryDatastore();
        when(pillSheetModifiedHistoryDatastore.add(batch, history))
            .thenReturn(null);

        final setting = const Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          reminderTimes: [
            ReminderTime(hour: 21, minute: 20),
            ReminderTime(hour: 22, minute: 0)
          ],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
            PillSheetType.pillsheet_21,
          ],
        );
        final settingDatastore = MockSettingDatastore();
        when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

        final container = ProviderContainer(
          overrides: [
            batchFactoryProvider.overrideWithValue(batchFactory),
            settingDatastoreProvider.overrideWithValue(settingDatastore),
            pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
            pillSheetModifiedHistoryDatastoreProvider
                .overrideWithValue(pillSheetModifiedHistoryDatastore),
            pillSheetGroupDatastoreProvider
                .overrideWithValue(pillSheetGroupDatastore),
          ],
        );
        final asyncAction = container.read(recordPageAsyncActionProvider);

        await Future.delayed(const Duration(seconds: 1));
        await asyncAction.revertTaken(
            pillSheetGroup: pillSheetGroup,
            pageIndex: 0,
            pillNumberIntoPillSheet: 27);
      });
      test("call revert with rest duration", () async {
        var mockTodayRepository = MockTodayService();
        final _today = DateTime.parse("2022-01-31");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
        final yesterday = DateTime.parse("2022-01-30");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "1",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: _today.subtract(const Duration(days: 29)),
          groupIndex: 0,
          lastTakenDate: _today.subtract(const Duration(days: 2)),
        );

        // actived pill sheet
        final pillSheet2 = PillSheet(
          id: "2",
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: yesterday,
          lastTakenDate: _today,
          groupIndex: 1,
          restDurations: [
            RestDuration(
                beginDate: yesterday, createdDate: yesterday, endDate: _today),
          ],
        );

        final pillSheetDatastore = MockPillSheetDatastore();
        when(pillSheetDatastore.update(batch, [
          pillSheet.copyWith(
              lastTakenDate: _today.subtract(const Duration(days: 4))),
          pillSheet2.copyWith(
              lastTakenDate:
                  pillSheet2.beginingDate.subtract(const Duration(days: 1)),
              restDurations: []),
        ])).thenReturn(null);

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["1", "2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
        );
        final updatedPillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["1", "2"],
          pillSheets: [
            pillSheet.copyWith(
                lastTakenDate: _today.subtract(const Duration(days: 4))),
            pillSheet2.copyWith(
                lastTakenDate:
                    pillSheet2.beginingDate.subtract(const Duration(days: 1)),
                restDurations: []),
          ],
          createdAt: now(),
        );
        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        when(pillSheetGroupDatastore.updateWithBatch(
                batch, updatedPillSheetGroup))
            .thenReturn(null);

        final history = PillSheetModifiedHistoryServiceActionFactory
            .createRevertTakenPillAction(
                pillSheetGroupID: "group_id",
                before: pillSheet2,
                after: pillSheet.copyWith(
                    lastTakenDate: _today.subtract(const Duration(days: 4)),
                    restDurations: []));
        final pillSheetModifiedHistoryDatastore =
            MockPillSheetModifiedHistoryDatastore();
        when(pillSheetModifiedHistoryDatastore.add(batch, history))
            .thenReturn(null);

        final setting = const Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          reminderTimes: [
            ReminderTime(hour: 21, minute: 20),
            ReminderTime(hour: 22, minute: 0)
          ],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
            PillSheetType.pillsheet_21,
          ],
        );
        final settingDatastore = MockSettingDatastore();
        when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

        final container = ProviderContainer(
          overrides: [
            batchFactoryProvider.overrideWithValue(batchFactory),
            settingDatastoreProvider.overrideWithValue(settingDatastore),
            pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
            pillSheetModifiedHistoryDatastoreProvider
                .overrideWithValue(pillSheetModifiedHistoryDatastore),
            pillSheetGroupDatastoreProvider
                .overrideWithValue(pillSheetGroupDatastore),
          ],
        );
        final asycnAction = container.read(recordPageAsyncActionProvider);

        await Future.delayed(const Duration(seconds: 1));
        await asycnAction.revertTaken(
            pillSheetGroup: pillSheetGroup,
            pageIndex: 0,
            pillNumberIntoPillSheet: 27);
      });
    });
  });
}
