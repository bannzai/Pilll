import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/service/setting.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#selectedPillSheetType", () {
    test("when first selected", () {
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final settingService = MockSettingService();
      final pillSheetService = MockPillSheetService();
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();

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
        ],
      );
      final store = container.read(initialSettingStoreProvider);

      store.selectedPillSheetType(PillSheetType.pillsheet_28_0);
      expect(container.read(initialSettingStateProvider).pillSheetTypes,
          [PillSheetType.pillsheet_28_0]);
    });
    test("overwrite pill sheet type", () {
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final settingService = MockSettingService();
      final pillSheetService = MockPillSheetService();
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();

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
        ],
      );
      final store = container.read(initialSettingStoreProvider);

      store.selectedPillSheetType(PillSheetType.pillsheet_21);
      expect(container.read(initialSettingStateProvider).pillSheetTypes,
          [PillSheetType.pillsheet_21]);

      store.selectedPillSheetType(PillSheetType.pillsheet_28_0);
      expect(container.read(initialSettingStateProvider).pillSheetTypes,
          [PillSheetType.pillsheet_28_0]);
    });

    test("reset todayPillNumber", () {
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final settingService = MockSettingService();
      final pillSheetService = MockPillSheetService();
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();

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
        ],
      );
      final store = container.read(initialSettingStoreProvider);
      // ignore: invalid_use_of_protected_member
      store.state = store.state.copyWith(
          todayPillNumber: InitialSettingTodayPillNumber(
              pageIndex: 0, pillNumberIntoPillSheet: 28));
      expect(
          container.read(initialSettingStateProvider).todayPillNumber,
          InitialSettingTodayPillNumber(
              pageIndex: 0, pillNumberIntoPillSheet: 28));

      store.selectedPillSheetType(PillSheetType.pillsheet_24_0);
      expect(container.read(initialSettingStateProvider).pillSheetTypes,
          [PillSheetType.pillsheet_24_0]);
      expect(
          container.read(initialSettingStateProvider).todayPillNumber,
          InitialSettingTodayPillNumber(
              pageIndex: 0, pillNumberIntoPillSheet: 24));
    });
  });
  group("#addPillSheetType", () {
    test("add new one", () {
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final settingService = MockSettingService();
      final pillSheetService = MockPillSheetService();
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();

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
        ],
      );
      final store = container.read(initialSettingStoreProvider);

      store.selectedPillSheetType(PillSheetType.pillsheet_21);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      expect(container.read(initialSettingStateProvider).pillSheetTypes,
          [PillSheetType.pillsheet_21, PillSheetType.pillsheet_28_0]);
    });
  });
  group("#changePillSheetType", () {
    test("replace with index", () {
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final settingService = MockSettingService();
      final pillSheetService = MockPillSheetService();
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();

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
        ],
      );
      final store = container.read(initialSettingStoreProvider);

      store.selectedPillSheetType(PillSheetType.pillsheet_21);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      store.changePillSheetType(1, PillSheetType.pillsheet_24_0);
      expect(container.read(initialSettingStateProvider).pillSheetTypes,
          [PillSheetType.pillsheet_21, PillSheetType.pillsheet_24_0]);
    });
  });
  group("#removePillSheetType", () {
    test("remove with index", () {
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final settingService = MockSettingService();
      final pillSheetService = MockPillSheetService();
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();

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
        ],
      );
      final store = container.read(initialSettingStoreProvider);

      store.selectedPillSheetType(PillSheetType.pillsheet_21);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      store.changePillSheetType(1, PillSheetType.pillsheet_24_0);
      store.removePillSheetType(0);
      expect(container.read(initialSettingStateProvider).pillSheetTypes,
          [PillSheetType.pillsheet_24_0]);
    });
  });
  group("#setReminderTime", () {
    test("replace default reminderTime", () {
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final settingService = MockSettingService();
      final pillSheetService = MockPillSheetService();
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();

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
        ],
      );
      final store = container.read(initialSettingStoreProvider);

      store.setReminderTime(index: 0, hour: 22, minute: 10);
      expect(container.read(initialSettingStateProvider).reminderTimes, [
        ReminderTime(hour: 22, minute: 10),
        ReminderTime(hour: 22, minute: 0)
      ]);
    });
    test("add reminderTime", () {
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final settingService = MockSettingService();
      final pillSheetService = MockPillSheetService();
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();

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
        ],
      );
      final store = container.read(initialSettingStoreProvider);

      store.setReminderTime(index: 2, hour: 22, minute: 10);
      expect(container.read(initialSettingStateProvider).reminderTimes, [
        ReminderTime(hour: 21, minute: 0),
        ReminderTime(hour: 22, minute: 0),
        ReminderTime(hour: 22, minute: 10)
      ]);
    });
  });
  group("#setFromMenstruation", () {
    test("when selected on first page", () {
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final settingService = MockSettingService();
      final pillSheetService = MockPillSheetService();
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();

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
        ],
      );
      final store = container.read(initialSettingStoreProvider);

      store.selectedPillSheetType(PillSheetType.pillsheet_21);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);

      store.setFromMenstruation(pageIndex: 0, fromMenstruation: 22);
      expect(container.read(initialSettingStateProvider).fromMenstruation, 22);
    });
    test("when selected on second page", () {
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final settingService = MockSettingService();
      final pillSheetService = MockPillSheetService();
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();

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
        ],
      );
      final store = container.read(initialSettingStoreProvider);

      store.selectedPillSheetType(PillSheetType.pillsheet_21);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);

      store.setFromMenstruation(pageIndex: 1, fromMenstruation: 22);
      expect(container.read(initialSettingStateProvider).fromMenstruation, 50);
    });
  });
  group("#retrieveMenstruationSelectedPillNumber", () {
    test("when selected first page", () {
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final settingService = MockSettingService();
      final pillSheetService = MockPillSheetService();
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();

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
        ],
      );
      final store = container.read(initialSettingStoreProvider);

      store.selectedPillSheetType(PillSheetType.pillsheet_21);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      store.setFromMenstruation(pageIndex: 0, fromMenstruation: 22);

      final result = store.retrieveMenstruationSelectedPillNumber(0);
      expect(result, 22);
    });
    test("when selected second page", () {
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final settingService = MockSettingService();
      final pillSheetService = MockPillSheetService();
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();

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
        ],
      );
      final store = container.read(initialSettingStoreProvider);

      store.selectedPillSheetType(PillSheetType.pillsheet_21);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      store.setFromMenstruation(pageIndex: 1, fromMenstruation: 22);

      final result = store.retrieveMenstruationSelectedPillNumber(1);
      expect(result, 22);
    });
    test("state.fromMenstruation > state.pillSheetTypes[pageIdnex].totalCount",
        () {
      final batchFactory = MockBatchFactory();
      final authService = MockAuthService();
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final settingService = MockSettingService();
      final pillSheetService = MockPillSheetService();
      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();

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
        ],
      );
      final store = container.read(initialSettingStoreProvider);

      store.selectedPillSheetType(PillSheetType.pillsheet_21);
      store.addPillSheetType(PillSheetType.pillsheet_28_0);
      store.setFromMenstruation(pageIndex: 1, fromMenstruation: 22);

      final result = store.retrieveMenstruationSelectedPillNumber(0);
      expect(result, null);
    });
  });
}
