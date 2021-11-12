import 'dart:async';
import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/user.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/service/user.dart';
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
      when(mockTodayRepository.today()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.stream())
          .thenAnswer((realInvocation) => Stream.empty());

      final pillSheet = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: null,
      );
      final pillSheetService = MockPillSheetService();
      when(pillSheetService.register(batch, [pillSheet])).thenReturn([
        pillSheet.copyWith(id: "sheet_id"),
      ]);

      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          pillSheet.copyWith(id: "sheet_id"),
        ],
        createdAt: now(),
      );
      final pillSheetGroupService = MockPillSheetGroupService();
      when(pillSheetGroupService.fetchLatest())
          .thenAnswer((realInvocation) async => pillSheetGroup);
      when(pillSheetGroupService.streamForLatest())
          .thenAnswer((realInvocation) => Stream.empty());
      when(pillSheetGroupService.register(batch, pillSheetGroup))
          .thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createCreatedPillSheetAction(
              pillSheetGroupID: "group_id", pillSheetIDs: ["sheet_id"]);
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      when(pillSheetModifiedHistoryService.add(batch, history))
          .thenReturn(null);

      final setting = Setting(
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
      final settingService = MockSettingService();
      when(settingService.fetch())
          .thenAnswer((realInvocation) async => setting);
      when(settingService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      when(settingService.updateWithBatch(batch, setting)).thenReturn(null);

      final user = User();
      final userService = MockUserService();
      when(userService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      when(userService.fetch()).thenAnswer((realInvocation) async => user);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingServiceProvider.overrideWithValue(settingService),
          pillSheetServiceProvider.overrideWithValue(pillSheetService),
          pillSheetModifiedHistoryServiceProvider
              .overrideWithValue(pillSheetModifiedHistoryService),
          pillSheetGroupServiceProvider
              .overrideWithValue(pillSheetGroupService),
          userServiceProvider.overrideWithValue(userService),
        ],
      );
      final store = container.read(recordPageStoreProvider);

      await Future.delayed(Duration(seconds: 1));
      await store.register(setting);
    });
    test("group has two pill sheet", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.today()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.stream())
          .thenAnswer((realInvocation) => Stream.empty());

      final pillSheet = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: null,
      );
      final pillSheet2 = PillSheet(
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: _today.add(Duration(days: 28)),
        lastTakenDate: null,
        groupIndex: 1,
      );
      final pillSheetService = MockPillSheetService();
      when(pillSheetService.register(batch, [pillSheet, pillSheet2]))
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
      final pillSheetGroupService = MockPillSheetGroupService();
      when(pillSheetGroupService.fetchLatest())
          .thenAnswer((realInvocation) async => pillSheetGroup);
      when(pillSheetGroupService.streamForLatest())
          .thenAnswer((realInvocation) => Stream.empty());
      when(pillSheetGroupService.register(batch, pillSheetGroup))
          .thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createCreatedPillSheetAction(
              pillSheetGroupID: "group_id",
              pillSheetIDs: ["sheet_id", "sheet_id2"]);
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      when(pillSheetModifiedHistoryService.add(batch, history))
          .thenReturn(null);

      final setting = Setting(
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
      final settingService = MockSettingService();
      when(settingService.fetch())
          .thenAnswer((realInvocation) async => setting);
      when(settingService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      when(settingService.updateWithBatch(batch, setting)).thenReturn(null);

      final user = User();
      final userService = MockUserService();
      when(userService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      when(userService.fetch()).thenAnswer((realInvocation) async => user);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingServiceProvider.overrideWithValue(settingService),
          pillSheetServiceProvider.overrideWithValue(pillSheetService),
          pillSheetModifiedHistoryServiceProvider
              .overrideWithValue(pillSheetModifiedHistoryService),
          pillSheetGroupServiceProvider
              .overrideWithValue(pillSheetGroupService),
          userServiceProvider.overrideWithValue(userService),
        ],
      );
      final store = container.read(recordPageStoreProvider);

      await Future.delayed(Duration(seconds: 1));
      await store.register(setting);
    });
  });
  group("#take", () {
    test("group has only one pill sheet", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.today()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.stream())
          .thenAnswer((realInvocation) => Stream.empty());

      final pillSheet = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: null,
      );
      final pillSheetService = MockPillSheetService();
      when(pillSheetService.update(
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
      final pillSheetGroupService = MockPillSheetGroupService();
      when(pillSheetGroupService.fetchLatest())
          .thenAnswer((realInvocation) async => pillSheetGroup);
      when(pillSheetGroupService.streamForLatest())
          .thenAnswer((realInvocation) => Stream.empty());
      when(pillSheetGroupService.update(batch, updatedPillSheetGroup))
          .thenReturn(null);

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: pillSheet.copyWith(
          lastTakenDate: _today,
        ),
      );
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      when(pillSheetModifiedHistoryService.add(batch, history))
          .thenReturn(null);

      final setting = Setting(
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
      final settingService = MockSettingService();
      when(settingService.fetch())
          .thenAnswer((realInvocation) async => setting);
      when(settingService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      when(settingService.updateWithBatch(batch, setting)).thenReturn(null);

      final user = User();
      final userService = MockUserService();
      when(userService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      when(userService.fetch()).thenAnswer((realInvocation) async => user);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingServiceProvider.overrideWithValue(settingService),
          pillSheetServiceProvider.overrideWithValue(pillSheetService),
          pillSheetModifiedHistoryServiceProvider
              .overrideWithValue(pillSheetModifiedHistoryService),
          pillSheetGroupServiceProvider
              .overrideWithValue(pillSheetGroupService),
          userServiceProvider.overrideWithValue(userService),
        ],
      );
      final store = container.read(recordPageStoreProvider);

      await Future.delayed(Duration(seconds: 1));
      final result = await store.taken();
      expect(result, isTrue);
    });
    test("group has two pill sheet contains future pill sheet", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.today()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.stream())
          .thenAnswer((realInvocation) => Stream.empty());

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
        beginingDate: _today.add(Duration(days: 28)),
        groupIndex: 1,
        lastTakenDate: null,
      );
      final pillSheetService = MockPillSheetService();
      when(pillSheetService.update(batch, [
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
      final pillSheetGroupService = MockPillSheetGroupService();
      when(pillSheetGroupService.fetchLatest())
          .thenAnswer((realInvocation) async => pillSheetGroup);
      when(pillSheetGroupService.streamForLatest())
          .thenAnswer((realInvocation) => Stream.empty());
      when(pillSheetGroupService.update(batch, updatedPillSheetGroup))
          .thenReturn(null);

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: pillSheet.copyWith(
          lastTakenDate: _today,
        ),
      );
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      when(pillSheetModifiedHistoryService.add(batch, history))
          .thenReturn(null);

      final setting = Setting(
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
      final settingService = MockSettingService();
      when(settingService.fetch())
          .thenAnswer((realInvocation) async => setting);
      when(settingService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      when(settingService.updateWithBatch(batch, setting)).thenReturn(null);

      final user = User();
      final userService = MockUserService();
      when(userService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      when(userService.fetch()).thenAnswer((realInvocation) async => user);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingServiceProvider.overrideWithValue(settingService),
          pillSheetServiceProvider.overrideWithValue(pillSheetService),
          pillSheetModifiedHistoryServiceProvider
              .overrideWithValue(pillSheetModifiedHistoryService),
          pillSheetGroupServiceProvider
              .overrideWithValue(pillSheetGroupService),
          userServiceProvider.overrideWithValue(userService),
        ],
      );
      final store = container.read(recordPageStoreProvider);

      await Future.delayed(Duration(seconds: 1));
      final result = await store.taken();
      expect(result, isTrue);
    });
    test("group has two pill sheet for first pillSheet.isFill pattern",
        () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2022-05-29");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.today()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.stream())
          .thenAnswer((realInvocation) => Stream.empty());

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
      final pillSheetService = MockPillSheetService();
      when(pillSheetService.update(batch, [
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
      final pillSheetGroupService = MockPillSheetGroupService();
      when(pillSheetGroupService.fetchLatest())
          .thenAnswer((realInvocation) async => pillSheetGroup);
      when(pillSheetGroupService.streamForLatest())
          .thenAnswer((realInvocation) => Stream.empty());
      when(pillSheetGroupService.update(batch, updatedPillSheetGroup))
          .thenReturn(null);

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: pillSheet2,
        after: pillSheet2.copyWith(
          lastTakenDate: _today,
        ),
      );
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      when(pillSheetModifiedHistoryService.add(batch, history))
          .thenReturn(null);

      final setting = Setting(
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
      final settingService = MockSettingService();
      when(settingService.fetch())
          .thenAnswer((realInvocation) async => setting);
      when(settingService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      when(settingService.updateWithBatch(batch, setting)).thenReturn(null);

      final user = User();
      final userService = MockUserService();
      when(userService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      when(userService.fetch()).thenAnswer((realInvocation) async => user);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingServiceProvider.overrideWithValue(settingService),
          pillSheetServiceProvider.overrideWithValue(pillSheetService),
          pillSheetModifiedHistoryServiceProvider
              .overrideWithValue(pillSheetModifiedHistoryService),
          pillSheetGroupServiceProvider
              .overrideWithValue(pillSheetGroupService),
          userServiceProvider.overrideWithValue(userService),
        ],
      );
      final store = container.read(recordPageStoreProvider);

      await Future.delayed(Duration(seconds: 1));
      final result = await store.taken();
      expect(result, isTrue);
    });
    test("group has two pill sheet contains past pill sheet but not yet filled",
        () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.today()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.stream())
          .thenAnswer((realInvocation) => Stream.empty());

      final pillSheet = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today.subtract(Duration(days: 28)),
        groupIndex: 0,
        lastTakenDate: _today.subtract(Duration(days: 2)),
      );
      final pillSheet2 = PillSheet(
        id: "sheet_id_2",
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: _today,
        groupIndex: 1,
        lastTakenDate: null,
      );
      final pillSheetService = MockPillSheetService();
      when(pillSheetService.update(batch, [
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

      final pillSheetGroupService = MockPillSheetGroupService();
      when(pillSheetGroupService.fetchLatest())
          .thenAnswer((realInvocation) async => pillSheetGroup);
      when(pillSheetGroupService.streamForLatest())
          .thenAnswer((realInvocation) => Stream.empty());
      when(pillSheetGroupService.update(batch, updatedPillSheetGroup))
          .thenReturn(null);

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: pillSheet2.copyWith(
          lastTakenDate: _today,
        ),
      );
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      when(pillSheetModifiedHistoryService.add(batch, history))
          .thenReturn(null);

      final setting = Setting(
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
      final settingService = MockSettingService();
      when(settingService.fetch())
          .thenAnswer((realInvocation) async => setting);
      when(settingService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      when(settingService.updateWithBatch(batch, setting)).thenReturn(null);

      final user = User();
      final userService = MockUserService();
      when(userService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      when(userService.fetch()).thenAnswer((realInvocation) async => user);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingServiceProvider.overrideWithValue(settingService),
          pillSheetServiceProvider.overrideWithValue(pillSheetService),
          pillSheetModifiedHistoryServiceProvider
              .overrideWithValue(pillSheetModifiedHistoryService),
          pillSheetGroupServiceProvider
              .overrideWithValue(pillSheetGroupService),
          userServiceProvider.overrideWithValue(userService),
        ],
      );
      final store = container.read(recordPageStoreProvider);

      await Future.delayed(Duration(seconds: 1));
      final result = await store.taken();
      expect(result, isTrue);
    });
  });
}
