import 'package:flutter/services.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/setting.codegen.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/datetime/day.dart';
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
      final endInitialSetting = MockEndInitialSetting();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith((ref) => batchSetPillSheetModifiedHistory),
          batchSetPillSheetGroupProvider.overrideWith((ref) => batchSetPillSheetGroup),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      expect(container.read(initialSettingStateNotifierProvider).pillSheetTypes, [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ]);
    });
    test("re select first pill sheet type", () {
      final endInitialSetting = MockEndInitialSetting();
      final batchFactory = MockBatchFactory();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith((ref) => batchSetPillSheetModifiedHistory),
          batchSetPillSheetModifiedHistoryProvider.overrideWith((ref) => batchSetPillSheetModifiedHistory),
          batchSetPillSheetGroupProvider.overrideWith((ref) => batchSetPillSheetGroup),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      expect(container.read(initialSettingStateNotifierProvider).pillSheetTypes, [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ]);

      store.changePillSheetType(0, PillSheetType.pillsheet_21_0);
      expect(container.read(initialSettingStateNotifierProvider).pillSheetTypes, [
        PillSheetType.pillsheet_21_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ]);
    });
  });
  group("#addPillSheetType", () {
    test("add new one", () {
      final endInitialSetting = MockEndInitialSetting();
      final batchFactory = MockBatchFactory();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith((ref) => batchSetPillSheetModifiedHistory),
          batchSetPillSheetGroupProvider.overrideWith((ref) => batchSetPillSheetGroup),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      expect(container.read(initialSettingStateNotifierProvider).pillSheetTypes, [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ]);
    });
  });
  group("#changePillSheetType", () {
    test("replace with index", () {
      final endInitialSetting = MockEndInitialSetting();
      final batchFactory = MockBatchFactory();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith((ref) => batchSetPillSheetModifiedHistory),
          batchSetPillSheetGroupProvider.overrideWith((ref) => batchSetPillSheetGroup),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      store.changePillSheetType(1, PillSheetType.pillsheet_24_0);
      expect(container.read(initialSettingStateNotifierProvider).pillSheetTypes, [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_24_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ]);
    });
  });
  group("#removePillSheetType", () {
    test("remove with index", () {
      final endInitialSetting = MockEndInitialSetting();
      final batchFactory = MockBatchFactory();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith((ref) => batchSetPillSheetModifiedHistory),
          batchSetPillSheetGroupProvider.overrideWith((ref) => batchSetPillSheetGroup),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      store.changePillSheetType(1, PillSheetType.pillsheet_24_0);
      store.removePillSheetType(0);
      expect(container.read(initialSettingStateNotifierProvider).pillSheetTypes, [
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

      final endInitialSetting = MockEndInitialSetting();
      final batchFactory = MockBatchFactory();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith((ref) => batchSetPillSheetModifiedHistory),
          batchSetPillSheetGroupProvider.overrideWith((ref) => batchSetPillSheetGroup),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.setReminderTime(index: 0, hour: 22, minute: 10);
      expect(container.read(initialSettingStateNotifierProvider).reminderTimes,
          [const ReminderTime(hour: 22, minute: 10), const ReminderTime(hour: 21, minute: 0)]);
    });
    test("add reminderTime", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 29, 20, 0, 0));

      final endInitialSetting = MockEndInitialSetting();
      final batchFactory = MockBatchFactory();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith((ref) => batchSetPillSheetModifiedHistory),
          batchSetPillSheetGroupProvider.overrideWith((ref) => batchSetPillSheetGroup),
        ],
      );
      final store = container.read(initialSettingStateNotifierProvider.notifier);

      store.setReminderTime(index: 2, hour: 22, minute: 10);
      expect(container.read(initialSettingStateNotifierProvider).reminderTimes,
          [const ReminderTime(hour: 20, minute: 0), const ReminderTime(hour: 21, minute: 0), const ReminderTime(hour: 22, minute: 10)]);
    });
  });
  group("#register", () {
    test("state.pillSheetTypes has one pillSheetType", () async {
      final endInitialSetting = MockEndInitialSetting();
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("sheet_id");
      firestoreIDGenerator = mockIDGenerator;

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: mockToday,
        createdAt: now(),
      );

      final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["sheet_id"], pillSheets: [pillSheet.copyWith(id: "sheet_id")], createdAt: now());
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, pillSheetGroup)).thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(pillSheetGroupID: "group_id", pillSheetIDs: ["sheet_id"]);
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      const setting = Setting(
        pillNumberForFromMenstruation: 24,
        durationMenstruation: 4,
        isOnReminder: true,
        reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 21, minute: 0)],
        pillSheetTypes: [PillSheetType.pillsheet_21],
        timezoneDatabaseName: null,
      );
      final batchSetSetting = MockBatchSetSetting();
      when(batchSetSetting(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith((ref) => batchSetPillSheetModifiedHistory),
          batchSetPillSheetGroupProvider.overrideWith((ref) => batchSetPillSheetGroup),
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
      final endInitialSetting = MockEndInitialSetting();
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      var idGeneratorCallCount = 0;
      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenAnswer((_) => ["sheet_id", "sheet_id2"][idGeneratorCallCount++]);
      firestoreIDGenerator = mockIDGenerator;

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: mockToday.subtract(
          const Duration(days: 28),
        ),
        groupIndex: 0,
        lastTakenDate: DateTime.parse("2020-09-18"),
        createdAt: now(),
      );
      final pillSheet2 = PillSheet(
        id: "sheet_id2",
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: mockToday,
        lastTakenDate: mockToday.subtract(const Duration(days: 1)),
        groupIndex: 1,
        createdAt: now(),
      );

      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["sheet_id", "sheet_id2"],
        pillSheets: [
          pillSheet.copyWith(id: "sheet_id"),
          pillSheet2.copyWith(id: "sheet_id2"),
        ],
        createdAt: now(),
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, pillSheetGroup)).thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: "group_id", pillSheetIDs: ["sheet_id", "sheet_id2"]);
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      const setting = Setting(
        pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        pillNumberForFromMenstruation: 52,
        durationMenstruation: 4,
        isOnReminder: true,
        reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
        pillSheetTypes: [PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_21],
        timezoneDatabaseName: null,
      );
      final batchSetSetting = MockBatchSetSetting();
      when(batchSetSetting(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith((ref) => batchSetPillSheetModifiedHistory),
          batchSetPillSheetGroupProvider.overrideWith((ref) => batchSetPillSheetGroup),
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

      final endInitialSetting = MockEndInitialSetting();
      when(endInitialSetting(setting)).thenAnswer((_) => Future.value());

      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("sheet_id");
      firestoreIDGenerator = mockIDGenerator;

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_24_rest_4.typeInfo,
        beginingDate: mockToday,
        createdAt: now(),
      );

      final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["sheet_id"], pillSheets: [pillSheet.copyWith(id: "sheet_id")], createdAt: now());
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, pillSheetGroup)).thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(pillSheetGroupID: "group_id", pillSheetIDs: ["sheet_id"]);
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final batchSetSetting = MockBatchSetSetting();
      when(batchSetSetting(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith((ref) => batchSetPillSheetModifiedHistory),
          batchSetPillSheetGroupProvider.overrideWith((ref) => batchSetPillSheetGroup),
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
