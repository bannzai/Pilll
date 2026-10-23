import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/features/settings/provider.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/features/initial_setting/initial_setting_state.codegen.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/setting.codegen.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

void main() {
  const MethodChannel timezoneChannel = MethodChannel('flutter_timezone');
  late RegisterReminderLocalNotificationRunner
      registerReminderLocalNotificationRunner;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(timezoneChannel, (
      MethodCall methodCall,
    ) async {
      return 'Asia/Tokyo';
    });
    errorLogger = MockErrorLogger();

    initializeDateFormatting('ja_JP');
    await LocalNotificationService.setupTimeZone();
    final mockLocalNotificationService = MockLocalNotificationService();
    localNotificationService = mockLocalNotificationService;

    registerReminderLocalNotificationRunner =
        MockRegisterReminderLocalNotificationRunner();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(timezoneChannel, null);
  });
  group("#selectedFirstPillSheetType", () {
    test("when first selected", () {
      final batchFactory = MockBatchFactory();
      final endInitialSetting = MockEndInitialSetting();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => batchSetPillSheetModifiedHistory,
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => batchSetPillSheetGroup,
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
          deviceTimezoneNameProvider.overrideWith(
            (ref) => Future.value("Asia/Tokyo"),
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      expect(
        container.read(initialSettingStateNotifierProvider).pillSheetTypes,
        [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
        ],
      );
    });
    test("re select first pill sheet type", () {
      final endInitialSetting = MockEndInitialSetting();
      final batchFactory = MockBatchFactory();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => batchSetPillSheetModifiedHistory,
          ),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => batchSetPillSheetModifiedHistory,
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => batchSetPillSheetGroup,
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
          deviceTimezoneNameProvider.overrideWith(
            (ref) => Future.value("Asia/Tokyo"),
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      expect(
        container.read(initialSettingStateNotifierProvider).pillSheetTypes,
        [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
        ],
      );

      store.changePillSheetType(0, PillSheetType.pillsheet_21_0);
      expect(
        container.read(initialSettingStateNotifierProvider).pillSheetTypes,
        [
          PillSheetType.pillsheet_21_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
        ],
      );
    });
  });
  group("#addPillSheetType", () {
    test("add new one", () {
      final endInitialSetting = MockEndInitialSetting();
      final batchFactory = MockBatchFactory();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => batchSetPillSheetModifiedHistory,
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => batchSetPillSheetGroup,
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
          deviceTimezoneNameProvider.overrideWith(
            (ref) => Future.value("Asia/Tokyo"),
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      expect(
        container.read(initialSettingStateNotifierProvider).pillSheetTypes,
        [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
        ],
      );
    });
  });
  group("#changePillSheetType", () {
    test("replace with index", () {
      final endInitialSetting = MockEndInitialSetting();
      final batchFactory = MockBatchFactory();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => batchSetPillSheetModifiedHistory,
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => batchSetPillSheetGroup,
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
          deviceTimezoneNameProvider.overrideWith(
            (ref) => Future.value("Asia/Tokyo"),
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      store.changePillSheetType(1, PillSheetType.pillsheet_24_0);
      expect(
        container.read(initialSettingStateNotifierProvider).pillSheetTypes,
        [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_24_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
        ],
      );
    });
  });
  group("#removePillSheetType", () {
    test("remove with index", () {
      final endInitialSetting = MockEndInitialSetting();
      final batchFactory = MockBatchFactory();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => batchSetPillSheetModifiedHistory,
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => batchSetPillSheetGroup,
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
          deviceTimezoneNameProvider.overrideWith(
            (ref) => Future.value("Asia/Tokyo"),
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      store.changePillSheetType(1, PillSheetType.pillsheet_24_0);
      store.removePillSheetType(0);
      expect(
        container.read(initialSettingStateNotifierProvider).pillSheetTypes,
        [
          PillSheetType.pillsheet_24_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
        ],
      );
    });
  });
  group("#setReminderTime", () {
    test("replace default reminderTime", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(
        mockTodayRepository.now(),
      ).thenReturn(DateTime(2020, 9, 29, 20, 0, 0));

      final endInitialSetting = MockEndInitialSetting();
      final batchFactory = MockBatchFactory();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => batchSetPillSheetModifiedHistory,
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => batchSetPillSheetGroup,
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
          deviceTimezoneNameProvider.overrideWith(
            (ref) => Future.value("Asia/Tokyo"),
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );

      store.setReminderTime(index: 0, hour: 22, minute: 10);
      expect(
        container.read(initialSettingStateNotifierProvider).reminderTimes,
        [
          const ReminderTime(hour: 22, minute: 10),
          const ReminderTime(hour: 21, minute: 0),
        ],
      );
    });
    test("add reminderTime", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(
        mockTodayRepository.now(),
      ).thenReturn(DateTime(2020, 9, 29, 20, 0, 0));

      final endInitialSetting = MockEndInitialSetting();
      final batchFactory = MockBatchFactory();
      final batchSetSetting = MockBatchSetSetting();

      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => batchSetPillSheetModifiedHistory,
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => batchSetPillSheetGroup,
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
          deviceTimezoneNameProvider.overrideWith(
            (ref) => Future.value("Asia/Tokyo"),
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );

      store.setReminderTime(index: 2, hour: 22, minute: 10);
      expect(
        container.read(initialSettingStateNotifierProvider).reminderTimes,
        [
          const ReminderTime(hour: 20, minute: 0),
          const ReminderTime(hour: 21, minute: 0),
          const ReminderTime(hour: 22, minute: 10),
        ],
      );
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

      final pillSheet = PillSheet.v1(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginDate: mockToday,
        lastTakenDate: null,
        createdAt: now(),
      );

      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["sheet_id"],
        pillSheets: [pillSheet.copyWith(id: "sheet_id")],
        createdAt: now(),
        pillSheetAppearanceMode: PillSheetAppearanceMode.date,
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(
        batchSetPillSheetGroup(batch, pillSheetGroup),
      ).thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createCreatedPillSheetAction(
        beforePillSheetGroup: null,
        createdNewPillSheetGroup: pillSheetGroup.copyWith(id: "group_id"),
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      const setting = Setting(
        pillNumberForFromMenstruation: 24,
        durationMenstruation: 4,
        isOnReminder: true,
        reminderTimes: [
          ReminderTime(hour: 21, minute: 20),
          ReminderTime(hour: 21, minute: 0),
        ],
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
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => batchSetPillSheetModifiedHistory,
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => batchSetPillSheetGroup,
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
          deviceTimezoneNameProvider.overrideWith(
            (ref) => Future.value("Asia/Tokyo"),
          ),
          registerReminderLocalNotificationRunnerProvider.overrideWithValue(
            registerReminderLocalNotificationRunner,
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_21);
      store.removePillSheetType(1);
      store.removePillSheetType(1);
      store.setTodayPillNumber(pageIndex: 0, pillNumberInPillSheet: 1);
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
      when(
        mockIDGenerator.call(),
      ).thenAnswer((_) => ["sheet_id", "sheet_id2"][idGeneratorCallCount++]);
      firestoreIDGenerator = mockIDGenerator;

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet.v1(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginDate: mockToday.subtract(const Duration(days: 28)),
        groupIndex: 0,
        lastTakenDate: DateTime.parse("2020-09-18"),
        createdAt: now(),
      );
      final pillSheet2 = PillSheet.v1(
        id: "sheet_id2",
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginDate: mockToday,
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
        pillSheetAppearanceMode: PillSheetAppearanceMode.date,
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(
        batchSetPillSheetGroup(batch, pillSheetGroup),
      ).thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createCreatedPillSheetAction(
        beforePillSheetGroup: null,
        createdNewPillSheetGroup: pillSheetGroup.copyWith(id: "group_id"),
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      const setting = Setting(
        pillNumberForFromMenstruation: 52,
        durationMenstruation: 4,
        isOnReminder: true,
        reminderTimes: [
          ReminderTime(hour: 21, minute: 20),
          ReminderTime(hour: 22, minute: 0),
        ],
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_21,
        ],
        timezoneDatabaseName: null,
      );
      final batchSetSetting = MockBatchSetSetting();
      when(batchSetSetting(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => batchSetPillSheetModifiedHistory,
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => batchSetPillSheetGroup,
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
          deviceTimezoneNameProvider.overrideWith(
            (ref) => Future.value("Asia/Tokyo"),
          ),
          registerReminderLocalNotificationRunnerProvider.overrideWithValue(
            registerReminderLocalNotificationRunner,
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_28_0);
      store.addPillSheetType(PillSheetType.pillsheet_21);
      store.removePillSheetType(1);
      store.removePillSheetType(1);
      store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 1);
      store.setReminderTime(index: 0, hour: 21, minute: 20);

      await store.register();
    });

    // ref: https://github.com/bannzai/Pilll/pull/534
    test("state.pillSheetTypes is [PillSheetType.pillsheet_24_rest_4]",
        () async {
      const setting = Setting(
        pillNumberForFromMenstruation: 24,
        durationMenstruation: 4,
        isOnReminder: true,
        reminderTimes: [
          ReminderTime(hour: 21, minute: 20),
          ReminderTime(hour: 22, minute: 0),
        ],
        pillSheetTypes: [PillSheetType.pillsheet_24_rest_4],
        timezoneDatabaseName: null,
      );

      final remoteConfigParameter = RemoteConfigParameter();
      final endInitialSetting = MockEndInitialSetting();
      when(
        endInitialSetting(remoteConfigParameter),
      ).thenAnswer((_) => Future.value());

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

      final pillSheet = PillSheet.v1(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_24_rest_4.typeInfo,
        beginDate: mockToday,
        lastTakenDate: null,
        createdAt: now(),
      );

      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["sheet_id"],
        pillSheets: [pillSheet.copyWith(id: "sheet_id")],
        createdAt: now(),
        pillSheetAppearanceMode: PillSheetAppearanceMode.date,
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(
        batchSetPillSheetGroup(batch, pillSheetGroup),
      ).thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createCreatedPillSheetAction(
        beforePillSheetGroup: null,
        createdNewPillSheetGroup: pillSheetGroup.copyWith(id: "group_id"),
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final batchSetSetting = MockBatchSetSetting();
      when(batchSetSetting(batch, setting)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith((ref) => endInitialSetting),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => batchSetPillSheetModifiedHistory,
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => batchSetPillSheetGroup,
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
          deviceTimezoneNameProvider.overrideWith(
            (ref) => Future.value("Asia/Tokyo"),
          ),
          registerReminderLocalNotificationRunnerProvider.overrideWithValue(
            registerReminderLocalNotificationRunner,
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );

      store.selectedFirstPillSheetType(PillSheetType.pillsheet_24_rest_4);
      store.removePillSheetType(1);
      store.removePillSheetType(1);
      store.setTodayPillNumber(pageIndex: 0, pillNumberInPillSheet: 1);
      store.setReminderTime(index: 0, hour: 21, minute: 20);

      await store.register();
    });
  });

  group("#register ヤーズフレックス", () {
    // 今日を [mockToday] に固定し、[input] で入力した状態で register した時に保存されるピルシートグループを返す
    Future<PillSheetGroup> registerYazFlex({
      required DateTime mockToday,
      required void Function(InitialSettingStateNotifier store) input,
    }) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("id");
      firestoreIDGenerator = mockIDGenerator;

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(any, any)).thenAnswer(
        (invocation) => invocation.positionalArguments[1] as PillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(any, any)).thenReturn(null);
      final batchSetSetting = MockBatchSetSetting();
      when(batchSetSetting(any, any)).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith(
            (ref) => MockEndInitialSetting(),
          ),
          batchFactoryProvider.overrideWithValue(batchFactory),
          batchSetSettingProvider.overrideWith((ref) => batchSetSetting),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => batchSetPillSheetModifiedHistory,
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => batchSetPillSheetGroup,
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
          deviceTimezoneNameProvider.overrideWith(
            (ref) => Future.value("Asia/Tokyo"),
          ),
          registerReminderLocalNotificationRunnerProvider.overrideWithValue(
            registerReminderLocalNotificationRunner,
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );
      store.selectYazFlex();
      input(store);
      await store.register();

      return verify(batchSetPillSheetGroup(batch, captureAny)).captured.single
          as PillSheetGroup;
    }

    test("1枚目の16番を飲んだ後に4日休薬して17番から再開し、今日が2枚目の2番の場合は服用日数が14になり1枚目に休薬の期間が入る",
        () async {
      // 今日(2022-03-02)は2枚目の2番。再開した17番は13日前の2022-02-17で、休薬の開始日はその4日前の2022-02-13 (16番は2022-02-12)
      final pillSheetGroup = await registerYazFlex(
        mockToday: DateTime.parse("2022-03-02"),
        input: (store) {
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
          store.setYazFlexLastTakenPillNumberBeforeRest(
              pageIndex: 0, pillNumberInPillSheet: 16);
        },
      );

      expect(pillSheetGroup.sequentialTodayPillNumber, 14);
      expect(
        pillSheetGroup.sequentialTodayPillNumber,
        daysBetween(DateTime.parse("2022-02-17"), today()) + 1,
      );
      expect(pillSheetGroup.pillSheets[0].restDurations.length, 1);
      expect(
        pillSheetGroup.pillSheets[0].restDurations[0].beginDate,
        DateTime.parse("2022-02-13"),
      );
      expect(
        pillSheetGroup.pillSheets[0].restDurations[0].endDate,
        DateTime.parse("2022-02-17"),
      );
      expect(pillSheetGroup.pillSheets[1].restDurations, isEmpty);
      expect(pillSheetGroup.pillSheets[2].restDurations, isEmpty);
      // 1枚目の開始日は今日から(28 + 2 - 1)日と休薬の4日ぶん前
      expect(
          pillSheetGroup.pillSheets[0].beginDate, DateTime.parse("2022-01-28"));
      expect(pillSheetGroup.pillSheets[0].displayPillTakeDate(16),
          DateTime.parse("2022-02-12"));
      expect(pillSheetGroup.pillSheets[0].displayPillTakeDate(17),
          DateTime.parse("2022-02-17"));
      // 1枚目はすべて服用済みで、2枚目は1枚目の休薬を含めた最後のピルの翌日から始まる
      expect(pillSheetGroup.pillSheets[0].lastTakenOrZeroPillNumber, 28);
      expect(pillSheetGroup.pillSheets[0].isTakenAll, true);
      expect(
          pillSheetGroup.pillSheets[1].beginDate, DateTime.parse("2022-03-01"));
      expect(
        pillSheetGroup.pillSheets[1].beginDate,
        pillSheetGroup.pillSheets[0].dates.last.addDays(1),
      );
      expect(pillSheetGroup.pillSheets[1].lastTakenOrZeroPillNumber, 1);
      expect(pillSheetGroup.pillSheets[1].todayPillNumber, 2);
      expect(
          pillSheetGroup.pillSheets[2].beginDate, DateTime.parse("2022-03-29"));
      expect(pillSheetGroup.activePillSheet?.groupIndex, 1);
      expect(pillSheetGroup.displayNumberSetting?.beginPillNumber, 1);
      expect(
        pillSheetGroup.pillSheetAppearanceMode,
        PillSheetAppearanceMode.cyclicSequential,
      );
      expect(
        pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList(),
        [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
        ],
      );
    });

    test("休薬の日数を7日に変えた場合は、休薬の開始日が再開日の7日前になる", () async {
      final pillSheetGroup = await registerYazFlex(
        mockToday: DateTime.parse("2022-03-02"),
        input: (store) {
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
          store.setYazFlexLastTakenPillNumberBeforeRest(
              pageIndex: 0, pillNumberInPillSheet: 16);
          store.setYazFlexRestDurationDays(yazFlexRestDurationDays: 7);
        },
      );

      expect(
        pillSheetGroup.pillSheets[0].restDurations[0].beginDate,
        DateTime.parse("2022-02-10"),
      );
      expect(
        pillSheetGroup.pillSheets[0].restDurations[0].endDate,
        DateTime.parse("2022-02-17"),
      );
      expect(
          pillSheetGroup.pillSheets[0].beginDate, DateTime.parse("2022-01-25"));
      expect(pillSheetGroup.sequentialTodayPillNumber, 14);
    });

    test("休薬の入力をスキップし、開始番号1で今日が1枚目の10番の場合は服用日数が10になり服用お休み期間が無い", () async {
      final pillSheetGroup = await registerYazFlex(
        mockToday: DateTime.parse("2022-03-02"),
        input: (store) {
          store.setTodayPillNumber(pageIndex: 0, pillNumberInPillSheet: 10);
          store.setYazFlexHasNotRestedYet(yazFlexHasNotRestedYet: true);
          store.setYazFlexBeginPillNumber(yazFlexBeginPillNumber: 1);
        },
      );

      expect(pillSheetGroup.sequentialTodayPillNumber, 10);
      expect(pillSheetGroup.restDurations, isEmpty);
      expect(
          pillSheetGroup.pillSheets[0].beginDate, DateTime.parse("2022-02-21"));
      expect(pillSheetGroup.pillSheets[0].lastTakenOrZeroPillNumber, 9);
      expect(
          pillSheetGroup.pillSheets[1].beginDate, DateTime.parse("2022-03-21"));
      expect(pillSheetGroup.displayNumberSetting?.beginPillNumber, 1);
      expect(
        pillSheetGroup.pillSheetAppearanceMode,
        PillSheetAppearanceMode.cyclicSequential,
      );
    });

    test("休薬の入力をスキップし、開始番号7で今日が1枚目の10番の場合は服用日数が16になる", () async {
      final pillSheetGroup = await registerYazFlex(
        mockToday: DateTime.parse("2022-03-02"),
        input: (store) {
          store.setTodayPillNumber(pageIndex: 0, pillNumberInPillSheet: 10);
          store.setYazFlexBeginPillNumber(yazFlexBeginPillNumber: 7);
          store.setYazFlexHasNotRestedYet(yazFlexHasNotRestedYet: true);
        },
      );

      expect(pillSheetGroup.restDurations, isEmpty);
      expect(pillSheetGroup.displayNumberSetting?.beginPillNumber, 7);
      expect(pillSheetGroup.sequentialTodayPillNumber, 16);
    });

    group("休薬のピルと今日の番号の境界", () {
      test("1枚目の1番を飲んだ後に休薬した場合は、1枚目の2番が再開日になり開始番号は入力値のまま", () async {
        // 今日(2022-03-02)は1枚目の10番。2番は8日前の2022-02-22、休薬の開始日はその4日前の2022-02-18、1番はその前日
        final pillSheetGroup = await registerYazFlex(
          mockToday: DateTime.parse("2022-03-02"),
          input: (store) {
            store.setTodayPillNumber(pageIndex: 0, pillNumberInPillSheet: 10);
            store.setYazFlexBeginPillNumber(yazFlexBeginPillNumber: 30);
            store.setYazFlexLastTakenPillNumberBeforeRest(
                pageIndex: 0, pillNumberInPillSheet: 1);
          },
        );

        expect(pillSheetGroup.pillSheets[0].restDurations.length, 1);
        expect(
          pillSheetGroup.pillSheets[0].restDurations[0].beginDate,
          DateTime.parse("2022-02-18"),
        );
        expect(
          pillSheetGroup.pillSheets[0].restDurations[0].endDate,
          DateTime.parse("2022-02-22"),
        );
        expect(pillSheetGroup.pillSheets[0].beginDate,
            DateTime.parse("2022-02-17"));
        expect(pillSheetGroup.pillSheets[0].displayPillTakeDate(2),
            DateTime.parse("2022-02-22"));
        expect(pillSheetGroup.pillSheets[0].lastTakenOrZeroPillNumber, 9);
        // 1番は休薬前の周期の30日目、2番から1に戻る
        expect(pillSheetGroup.displayNumberSetting?.beginPillNumber, 30);
        expect(
          pillSheetGroup.displayPillNumberWithoutDate(
              pageIndex: 0, pillNumberInPillSheet: 1),
          "30",
        );
        expect(
          pillSheetGroup.displayPillNumberWithoutDate(
              pageIndex: 0, pillNumberInPillSheet: 2),
          "1",
        );
        expect(pillSheetGroup.sequentialTodayPillNumber, 9);
      });
      test("今日の前日のピル (1枚目の16番、今日は17番) を飲んだ後に休薬した場合は、今日が再開日で服用日数が1になる",
          () async {
        final pillSheetGroup = await registerYazFlex(
          mockToday: DateTime.parse("2022-03-02"),
          input: (store) {
            store.setTodayPillNumber(pageIndex: 0, pillNumberInPillSheet: 17);
            store.setYazFlexLastTakenPillNumberBeforeRest(
                pageIndex: 0, pillNumberInPillSheet: 16);
          },
        );

        expect(pillSheetGroup.pillSheets[0].restDurations.length, 1);
        expect(
          pillSheetGroup.pillSheets[0].restDurations[0].beginDate,
          DateTime.parse("2022-02-26"),
        );
        expect(
          pillSheetGroup.pillSheets[0].restDurations[0].endDate,
          DateTime.parse("2022-03-02"),
        );
        expect(pillSheetGroup.pillSheets[0].lastTakenDate,
            DateTime.parse("2022-02-25"));
        expect(pillSheetGroup.pillSheets[0].lastTakenOrZeroPillNumber, 16);
        expect(pillSheetGroup.pillSheets[0].todayPillNumber, 17);
        expect(pillSheetGroup.sequentialTodayPillNumber, 1);
      });
      test("今日のピル以降をタップしても休薬のピルにならない", () async {
        final pillSheetGroup = await registerYazFlex(
          mockToday: DateTime.parse("2022-03-02"),
          input: (store) {
            store.setTodayPillNumber(pageIndex: 0, pillNumberInPillSheet: 17);
            store.setYazFlexLastTakenPillNumberBeforeRest(
                pageIndex: 0, pillNumberInPillSheet: 17);
            store.setYazFlexLastTakenPillNumberBeforeRest(
                pageIndex: 1, pillNumberInPillSheet: 3);
          },
        );

        expect(pillSheetGroup.restDurations, isEmpty);
        expect(pillSheetGroup.sequentialTodayPillNumber, 17);
      });
    });

    test(
        "休薬と今日が同じピルシートの場合(1枚目の16番の後に休薬、今日は1枚目の20番)は、今日の前日まで服用済みで2枚目は休薬を含めた1枚目の最後のピルの翌日から始まる",
        () async {
      // 今日(2022-03-02)は1枚目の20番。再開した17番は3日前の2022-02-27、休薬の開始日はその4日前の2022-02-23
      final pillSheetGroup = await registerYazFlex(
        mockToday: DateTime.parse("2022-03-02"),
        input: (store) {
          store.setTodayPillNumber(pageIndex: 0, pillNumberInPillSheet: 20);
          store.setYazFlexLastTakenPillNumberBeforeRest(
              pageIndex: 0, pillNumberInPillSheet: 16);
        },
      );

      expect(pillSheetGroup.pillSheets[0].restDurations.length, 1);
      expect(
        pillSheetGroup.pillSheets[0].restDurations[0].beginDate,
        DateTime.parse("2022-02-23"),
      );
      expect(
        pillSheetGroup.pillSheets[0].restDurations[0].endDate,
        DateTime.parse("2022-02-27"),
      );
      expect(
          pillSheetGroup.pillSheets[0].beginDate, DateTime.parse("2022-02-07"));
      expect(pillSheetGroup.pillSheets[0].lastTakenOrZeroPillNumber, 19);
      expect(pillSheetGroup.pillSheets[0].todayPillNumber, 20);
      expect(pillSheetGroup.pillSheets[0].lastTakenDate,
          DateTime.parse("2022-03-01"));
      expect(
        pillSheetGroup.pillSheets[1].beginDate,
        pillSheetGroup.pillSheets[0].dates.last.addDays(1),
      );
      expect(
          pillSheetGroup.pillSheets[1].beginDate, DateTime.parse("2022-03-11"));
      expect(pillSheetGroup.pillSheets[1].lastTakenDate, isNull);
      expect(pillSheetGroup.sequentialTodayPillNumber, 4);
    });

    test(
        "1枚目の28番を飲んだ後に休薬して2枚目の1番から再開した場合 (今日は2枚目の5番) は、2枚目に服用お休み期間が入り2枚目の開始日が休薬の開始日になる",
        () async {
      // 今日(2022-03-02)は2枚目の5番。再開した2枚目の1番は4日前の2022-02-26、休薬の開始日はその4日前の2022-02-22
      final pillSheetGroup = await registerYazFlex(
        mockToday: DateTime.parse("2022-03-02"),
        input: (store) {
          store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 5);
          store.setYazFlexLastTakenPillNumberBeforeRest(
              pageIndex: 0, pillNumberInPillSheet: 28);
        },
      );

      expect(pillSheetGroup.pillSheets[0].restDurations, isEmpty);
      expect(pillSheetGroup.pillSheets[1].restDurations.length, 1);
      expect(
          pillSheetGroup.pillSheets[0].beginDate, DateTime.parse("2022-01-25"));
      expect(pillSheetGroup.pillSheets[0].lastTakenDate,
          DateTime.parse("2022-02-21"));
      expect(pillSheetGroup.pillSheets[0].isTakenAll, true);
      expect(
          pillSheetGroup.pillSheets[1].beginDate, DateTime.parse("2022-02-22"));
      expect(pillSheetGroup.pillSheets[1].displayPillTakeDate(1),
          DateTime.parse("2022-02-26"));
      expect(pillSheetGroup.pillSheets[1].todayPillNumber, 5);
      expect(pillSheetGroup.pillSheets[1].lastTakenOrZeroPillNumber, 4);
      expect(
          pillSheetGroup.pillSheets[2].beginDate, DateTime.parse("2022-03-26"));
      expect(pillSheetGroup.sequentialTodayPillNumber, 5);
      expect(
        pillSheetGroup.sequentialTodayPillNumber,
        daysBetween(DateTime.parse("2022-02-26"), today()) + 1,
      );
    });
  });

  group(
      "#setYazFlexLastTakenPillNumberBeforeRest / #setYazFlexRestDurationDays",
      () {
    test("スキップした後に戻ってピルをタップし直すとスキップが解除され、再開日と休薬の開始日が逆算される", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith(
            (ref) => MockEndInitialSetting(),
          ),
          batchFactoryProvider.overrideWithValue(MockBatchFactory()),
          batchSetSettingProvider.overrideWith((ref) => MockBatchSetSetting()),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => MockBatchSetPillSheetModifiedHistory(),
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => MockBatchSetPillSheetGroup(),
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );
      store.selectYazFlex();
      store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
      store.setYazFlexHasNotRestedYet(yazFlexHasNotRestedYet: true);

      store.setYazFlexLastTakenPillNumberBeforeRest(
          pageIndex: 0, pillNumberInPillSheet: 16);
      final state = container.read(initialSettingStateNotifierProvider);
      expect(state.yazFlexHasNotRestedYet, false);
      expect(
        state.yazFlexLastTakenPillNumberBeforeRest,
        const InitialSettingTodayPillNumber(
            pageIndex: 0, pillNumberInPillSheet: 16),
      );
      expect(
          state.yazFlexLastRestDurationEndDate, DateTime.parse("2022-02-17"));
      expect(
          state.yazFlexLastRestDurationBeginDate, DateTime.parse("2022-02-13"));
      expect(
        state.yazFlexResumedPillPosition,
        (pageIndex: 0, pillNumberInPillSheet: 17),
      );

      store.setYazFlexRestDurationDays(yazFlexRestDurationDays: 2);
      expect(
        container
            .read(initialSettingStateNotifierProvider)
            .yazFlexLastRestDurationBeginDate,
        DateTime.parse("2022-02-15"),
      );
    });
    test("休薬の入力をスキップすると選んだピルが消え、日数は残る", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith(
            (ref) => MockEndInitialSetting(),
          ),
          batchFactoryProvider.overrideWithValue(MockBatchFactory()),
          batchSetSettingProvider.overrideWith((ref) => MockBatchSetSetting()),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => MockBatchSetPillSheetModifiedHistory(),
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => MockBatchSetPillSheetGroup(),
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );
      store.selectYazFlex();
      store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
      store.setYazFlexLastTakenPillNumberBeforeRest(
          pageIndex: 0, pillNumberInPillSheet: 16);
      store.setYazFlexRestDurationDays(yazFlexRestDurationDays: 5);

      store.setYazFlexHasNotRestedYet(yazFlexHasNotRestedYet: true);
      final state = container.read(initialSettingStateNotifierProvider);
      expect(state.yazFlexHasNotRestedYet, true);
      expect(state.yazFlexLastTakenPillNumberBeforeRest, isNull);
      expect(state.yazFlexLastRestDurationEndDate, isNull);
      expect(state.yazFlexRestDurationDays, 5);
    });
  });

  group("#selectYazFlex", () {
    test("「はい」を選ぶと28錠タイプのピルシートが3枚になり、ヤーズフレックス向けの導線の状態になる", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith(
            (ref) => MockEndInitialSetting(),
          ),
          batchFactoryProvider.overrideWithValue(MockBatchFactory()),
          batchSetSettingProvider.overrideWith((ref) => MockBatchSetSetting()),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => MockBatchSetPillSheetModifiedHistory(),
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => MockBatchSetPillSheetGroup(),
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );

      // 「いいえ」でピルシートの種類を選んでから戻って「はい」を選んだ場合も28錠タイプ3枚になる
      store.selectedFirstPillSheetType(PillSheetType.pillsheet_21);
      store.selectYazFlex();

      final state = container.read(initialSettingStateNotifierProvider);
      expect(state.isYazFlex, true);
      expect(state.pillSheetTypes, [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ]);
      expect(state.todayPillNumber, isNull);
    });
  });

  group("#selectNotYazFlex", () {
    test("「はい」を選んでから「いいえ」を選ぶと、ピルシートの種類を選ぶ前の従来の導線と同じ状態に戻る", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith(
            (ref) => MockEndInitialSetting(),
          ),
          batchFactoryProvider.overrideWithValue(MockBatchFactory()),
          batchSetSettingProvider.overrideWith((ref) => MockBatchSetSetting()),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => MockBatchSetPillSheetModifiedHistory(),
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => MockBatchSetPillSheetGroup(),
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );

      store.selectYazFlex();
      store.setTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 2);
      store.setYazFlexHasNotRestedYet(yazFlexHasNotRestedYet: true);
      store.setYazFlexBeginPillNumber(yazFlexBeginPillNumber: 3);
      store.selectNotYazFlex();

      final state = container.read(initialSettingStateNotifierProvider);
      expect(state.isYazFlex, false);
      expect(state.pillSheetTypes, isEmpty);
      expect(state.todayPillNumber, isNull);
      expect(state.yazFlexHasNotRestedYet, false);
      expect(state.yazFlexBeginPillNumber, 1);
    });
    test("「いいえ」から戻って再度「いいえ」を選んだ場合は、選択済みのピルシートの種類を残す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));

      final container = ProviderContainer(
        overrides: [
          endInitialSettingProvider.overrideWith(
            (ref) => MockEndInitialSetting(),
          ),
          batchFactoryProvider.overrideWithValue(MockBatchFactory()),
          batchSetSettingProvider.overrideWith((ref) => MockBatchSetSetting()),
          batchSetPillSheetModifiedHistoryProvider.overrideWith(
            (ref) => MockBatchSetPillSheetModifiedHistory(),
          ),
          batchSetPillSheetGroupProvider.overrideWith(
            (ref) => MockBatchSetPillSheetGroup(),
          ),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(),
          ),
        ],
      );
      final store = container.read(
        initialSettingStateNotifierProvider.notifier,
      );

      store.selectNotYazFlex();
      store.selectedFirstPillSheetType(PillSheetType.pillsheet_21);
      store.selectNotYazFlex();

      expect(
        container.read(initialSettingStateNotifierProvider).pillSheetTypes,
        [
          PillSheetType.pillsheet_21,
          PillSheetType.pillsheet_21,
          PillSheetType.pillsheet_21,
        ],
      );
    });
  });
}
