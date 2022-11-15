import 'package:flutter/services.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/setting.codegen.dart';
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
  const MethodChannel timezoneChannel = MethodChannel('flutter_native_timezone');

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});

    timezoneChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      return 'Asia/Tokyo';
    });
  });

  tearDown(() {
    timezoneChannel.setMockMethodCallHandler(null);
  });
  group("#selectedFirstPillSheetType", () {
    test("when first selected", () {
      final batchFactory = MockBatchFactory();
      final userDatastore = MockUserDatastore();
      final authService = MockAuthService();
      when(authService.stream()).thenAnswer((realInvocation) => const Stream.empty());
      final settingDatastore = MockSettingDatastore();
      final pillSheetDatastore = MockPillSheetDatastore();
      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();

      final container = ProviderContainer(
        overrides: [
          userDatastoreProvider.overrideWithValue(userDatastore),
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      expect(container.read(initialSettingStateProvider).pillSheetTypes, [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ]);
    });
    test("re select first pill sheet type", () {
      final userDatastore = MockUserDatastore();
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.stream()).thenAnswer((realInvocation) => const Stream.empty());
      final settingDatastore = MockSettingDatastore();
      final pillSheetDatastore = MockPillSheetDatastore();
      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();

      final container = ProviderContainer(
        overrides: [
          userDatastoreProvider.overrideWithValue(userDatastore),
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      expect(container.read(initialSettingStateProvider).pillSheetTypes, [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ]);

      store.changePillSheetType(0, PillSheetType.pillsheet_21_0);
      expect(container.read(initialSettingStateProvider).pillSheetTypes, [
        PillSheetType.pillsheet_21_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ]);
    });
  });
  group("#addPillSheetType", () {
    test("add new one", () {
      final userDatastore = MockUserDatastore();
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.stream()).thenAnswer((realInvocation) => const Stream.empty());
      final settingDatastore = MockSettingDatastore();
      final pillSheetDatastore = MockPillSheetDatastore();
      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();

      final container = ProviderContainer(
        overrides: [
          userDatastoreProvider.overrideWithValue(userDatastore),
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      expect(container.read(initialSettingStateProvider).pillSheetTypes, [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ]);
    });
  });
  group("#changePillSheetType", () {
    test("replace with index", () {
      final userDatastore = MockUserDatastore();
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.stream()).thenAnswer((realInvocation) => const Stream.empty());
      final settingDatastore = MockSettingDatastore();
      final pillSheetDatastore = MockPillSheetDatastore();
      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();

      final container = ProviderContainer(
        overrides: [
          userDatastoreProvider.overrideWithValue(userDatastore),
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      store.changePillSheetType(1, PillSheetType.pillsheet_24_0);
      expect(container.read(initialSettingStateProvider).pillSheetTypes, [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_24_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ]);
    });
  });
  group("#removePillSheetType", () {
    test("remove with index", () {
      final userDatastore = MockUserDatastore();
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.stream()).thenAnswer((realInvocation) => const Stream.empty());
      final settingDatastore = MockSettingDatastore();
      final pillSheetDatastore = MockPillSheetDatastore();
      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();

      final container = ProviderContainer(
        overrides: [
          userDatastoreProvider.overrideWithValue(userDatastore),
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      store.changePillSheetType(1, PillSheetType.pillsheet_24_0);
      store.removePillSheetType(0);
      expect(container.read(initialSettingStateProvider).pillSheetTypes, [
        PillSheetType.pillsheet_24_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ]);
    });
  });
  group("#setReminderTime", () {
    test("replace default reminderTime", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 29, 20, 0, 0));

      final userDatastore = MockUserDatastore();
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.stream()).thenAnswer((realInvocation) => const Stream.empty());
      final settingDatastore = MockSettingDatastore();
      final pillSheetDatastore = MockPillSheetDatastore();
      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();

      final container = ProviderContainer(
        overrides: [
          userDatastoreProvider.overrideWithValue(userDatastore),
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.setReminderTime(index: 0, hour: 22, minute: 10);
      expect(container.read(initialSettingStateProvider).reminderTimes,
          [const ReminderTime(hour: 22, minute: 10), const ReminderTime(hour: 21, minute: 0)]);
    });
    test("add reminderTime", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 29, 20, 0, 0));

      final userDatastore = MockUserDatastore();
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.stream()).thenAnswer((realInvocation) => const Stream.empty());
      final settingDatastore = MockSettingDatastore();
      final pillSheetDatastore = MockPillSheetDatastore();
      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();

      final container = ProviderContainer(
        overrides: [
          userDatastoreProvider.overrideWithValue(userDatastore),
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.setReminderTime(index: 2, hour: 22, minute: 10);
      expect(container.read(initialSettingStateProvider).reminderTimes,
          [const ReminderTime(hour: 20, minute: 0), const ReminderTime(hour: 21, minute: 0), const ReminderTime(hour: 22, minute: 10)]);
    });
  });
  group("#register", () {
    test("state.pillSheetTypes has one pillSheetType", () async {
      final userDatastore = MockUserDatastore();
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final authService = MockAuthService();
      when(authService.stream()).thenAnswer((realInvocation) => const Stream.empty());

      final pillSheet = PillSheet(typeInfo: PillSheetType.pillsheet_21.typeInfo, beginingDate: _today);
      final pillSheetDatastore = MockPillSheetDatastore();
      when(pillSheetDatastore.register(batch, [pillSheet])).thenReturn([pillSheet.copyWith(id: "sheet_id")]);

      final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["sheet_id"], pillSheets: [pillSheet.copyWith(id: "sheet_id")], createdAt: now());
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.register(batch, pillSheetGroup)).thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(pillSheetGroupID: "group_id", pillSheetIDs: ["sheet_id"]);
      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

      const setting = Setting(
        pillNumberForFromMenstruation: 24,
        durationMenstruation: 4,
        isOnReminder: true,
        reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 21, minute: 0)],
        pillSheetTypes: [PillSheetType.pillsheet_21],
        timezoneDatabaseName: null,
      );
      final settingDatastore = MockSettingDatastore();
      when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          userDatastoreProvider.overrideWithValue(userDatastore),
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_21);
      store.removePillSheetType(1);
      store.removePillSheetType(1);
      store.setTodayPillNumber(pageIndex: 0, pillNumberIntoPillSheet: 1);
      store.setReminderTime(index: 0, hour: 21, minute: 20);

      await store.register();
    });
    test("state.pillSheetTypes has two pillSheetType", () async {
      final userDatastore = MockUserDatastore();
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final authService = MockAuthService();
      when(authService.stream()).thenAnswer((realInvocation) => const Stream.empty());

      final pillSheet = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today.subtract(
          const Duration(days: 28),
        ),
        groupIndex: 0,
        lastTakenDate: DateTime.parse("2020-09-18"),
      );
      final pillSheet2 = PillSheet(
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: _today,
        lastTakenDate: _today.subtract(const Duration(days: 1)),
        groupIndex: 1,
      );
      final pillSheetDatastore = MockPillSheetDatastore();

      when(pillSheetDatastore.register(batch, [pillSheet, pillSheet2]))
          .thenReturn([pillSheet.copyWith(id: "sheet_id"), pillSheet2.copyWith(id: "sheet_id2")]);

      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["sheet_id", "sheet_id2"],
        pillSheets: [
          pillSheet.copyWith(id: "sheet_id"),
          pillSheet2.copyWith(id: "sheet_id2"),
        ],
        createdAt: now(),
      );
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.register(batch, pillSheetGroup)).thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: "group_id", pillSheetIDs: ["sheet_id", "sheet_id2"]);
      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

      const setting = Setting(
        pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        pillNumberForFromMenstruation: 52,
        durationMenstruation: 4,
        isOnReminder: true,
        reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
        pillSheetTypes: [PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_21],
        timezoneDatabaseName: null,
      );
      final settingDatastore = MockSettingDatastore();
      when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          userDatastoreProvider.overrideWithValue(userDatastore),
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      store.addPillSheetType(PillSheetType.pillsheet_21);
      store.removePillSheetType(1);
      store.removePillSheetType(1);
      store.setTodayPillNumber(pageIndex: 1, pillNumberIntoPillSheet: 1);
      store.setReminderTime(index: 0, hour: 21, minute: 20);

      await store.register();
    });

    // ref: https://github.com/bannzai/Pilll/pull/534
    test("state.pillSheetTypes is [PillSheetType.pillsheet_24_rest_4]", () async {
      const setting = Setting(
        pillNumberForFromMenstruation: 24,
        durationMenstruation: 4,
        isOnReminder: true,
        reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
        pillSheetTypes: [PillSheetType.pillsheet_24_rest_4],
        timezoneDatabaseName: null,
      );

      final userDatastore = MockUserDatastore();
      when(userDatastore.endInitialSetting(setting)).thenAnswer((_) => Future.value());

      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final authService = MockAuthService();
      when(authService.stream()).thenAnswer((realInvocation) => const Stream.empty());

      final pillSheet = PillSheet(typeInfo: PillSheetType.pillsheet_24_rest_4.typeInfo, beginingDate: _today);
      final pillSheetDatastore = MockPillSheetDatastore();
      when(pillSheetDatastore.register(batch, [pillSheet])).thenReturn([pillSheet.copyWith(id: "sheet_id")]);

      final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["sheet_id"], pillSheets: [pillSheet.copyWith(id: "sheet_id")], createdAt: now());
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.register(batch, pillSheetGroup)).thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(pillSheetGroupID: "group_id", pillSheetIDs: ["sheet_id"]);
      final pillSheetModifiedHistoryDatastore = MockPillSheetModifiedHistoryDatastore();
      when(pillSheetModifiedHistoryDatastore.add(batch, history)).thenReturn(null);

      final settingDatastore = MockSettingDatastore();
      when(settingDatastore.updateWithBatch(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          userDatastoreProvider.overrideWithValue(userDatastore),
          batchFactoryProvider.overrideWithValue(batchFactory),
          authServiceProvider.overrideWithValue(authService),
          settingDatastoreProvider.overrideWithValue(settingDatastore),
          pillSheetDatastoreProvider.overrideWithValue(pillSheetDatastore),
          pillSheetModifiedHistoryDatastoreProvider.overrideWithValue(pillSheetModifiedHistoryDatastore),
          pillSheetGroupDatastoreProvider.overrideWithValue(pillSheetGroupDatastore),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_24_rest_4);
      store.removePillSheetType(1);
      store.removePillSheetType(1);
      store.setTodayPillNumber(pageIndex: 0, pillNumberIntoPillSheet: 1);
      store.setReminderTime(index: 0, hour: 21, minute: 20);

      await store.register();
    });
  });
}
