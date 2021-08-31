import 'package:pilll/analytics.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/user.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/delay.dart';
import '../../helper/mock.mocks.dart';

class _FakeUser extends Fake implements User {
  _FakeUser({
    this.fakeIsPremium = false,
    this.fakeIsTrial = false,
    this.fakeTrialDeadlineDate,
    this.fakeDiscountEntitlementDeadlineDate,
    this.fakeIsExpiredDiscountEntitlements = false,
  });
  final DateTime? fakeTrialDeadlineDate;
  final DateTime? fakeDiscountEntitlementDeadlineDate;
  final bool fakeIsPremium;
  final bool fakeIsTrial;
  final bool fakeIsExpiredDiscountEntitlements;
  @override
  bool get isPremium => fakeIsPremium;
  @override
  bool get isTrial => fakeIsTrial;
  @override
  bool get hasDiscountEntitlement => fakeIsExpiredDiscountEntitlements;
  @override
  DateTime? get trialDeadlineDate => fakeTrialDeadlineDate;
  @override
  DateTime? get discountEntitlementDeadlineDate =>
      fakeDiscountEntitlementDeadlineDate;
}

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    analytics = MockAnalytics();
  });
  group("#calcBeginingDateFromNextTodayPillNumber", () {
    test("pill number changed to future", () async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime.parse("2020-11-22");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.today()).thenReturn(today);

      final pillSheetEntity =
          PillSheet.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-22"),
        createdAt: DateTime.parse("2020-11-22"),
      );
      final settingEntity = Setting(
        pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 4,
        isOnReminder: true,
      );
      final state =
          RecordPageState(entity: pillSheetEntity, setting: settingEntity);

      final service = MockPillSheetService();
      when(service.fetchActivePillSheet())
          .thenAnswer((realInvocation) => Future.value(state.entity));
      when(service.fetchAll()).thenAnswer((realInvocation) => Future.value([]));
      when(service.fetchListWithMax(2)).thenAnswer((_) => Future.value([]));
      when(service.subscribeForLatestPillSheet())
          .thenAnswer((realInvocation) => Stream.empty());
      final batch = MockBatchFactory();
      final settingService = MockSettingService();
      when(settingService.fetch())
          .thenAnswer((realInvocation) => Future.value(settingEntity));
      when(settingService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final userService = MockUserService();
      when(userService.fetch())
          .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
      when(userService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final pillSheetModifedHistoryService =
          MockPillSheetModifiedHistoryService();

      final store = RecordPageStore(
        batch,
        service,
        settingService,
        userService,
        authService,
        pillSheetModifedHistoryService,
      );
      await waitForResetStoreState();
      expect(state.entity?.todayPillNumber, equals(1));

      final expected = DateTime.parse("2020-11-13");
      final actual = store.calcBeginingDateFromNextTodayPillNumber(10);
      expect(isSameDay(expected, actual), isTrue);
    });
  });
  test("pill number changed to past", () async {
    final mockTodayRepository = MockTodayService();
    final today = DateTime.parse("2020-11-23");
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.today()).thenReturn(today);

    final pillSheetEntity =
        PillSheet.create(PillSheetType.pillsheet_21).copyWith(
      beginingDate: DateTime.parse("2020-11-21"),
      createdAt: DateTime.parse("2020-11-21"),
    );
    final settingEntity = Setting(
      pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
      pillNumberForFromMenstruation: 22,
      durationMenstruation: 4,
      isOnReminder: true,
    );
    final state =
        RecordPageState(entity: pillSheetEntity, setting: settingEntity);

    final service = MockPillSheetService();
    when(service.fetchActivePillSheet())
        .thenAnswer((realInvocation) => Future.value(state.entity));
    when(service.fetchAll()).thenAnswer((realInvocation) => Future.value([]));
    when(service.fetchListWithMax(2)).thenAnswer((_) => Future.value([]));
    when(service.subscribeForLatestPillSheet())
        .thenAnswer((realInvocation) => Stream.empty());
    final batch = MockBatchFactory();

    final settingService = MockSettingService();
    when(settingService.fetch())
        .thenAnswer((realInvocation) => Future.value(settingEntity));
    when(settingService.subscribe())
        .thenAnswer((realInvocation) => Stream.empty());
    final authService = MockAuthService();
    when(authService.isLinkedApple()).thenReturn(false);
    when(authService.isLinkedGoogle()).thenReturn(false);
    when(authService.subscribe())
        .thenAnswer((realInvocation) => Stream.empty());
    final userService = MockUserService();
    when(userService.fetch())
        .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
    when(userService.subscribe())
        .thenAnswer((realInvocation) => Stream.empty());
    final pillSheetModifedHistoryService =
        MockPillSheetModifiedHistoryService();

    final store = RecordPageStore(
      batch,
      service,
      settingService,
      userService,
      authService,
      pillSheetModifedHistoryService,
    );

    await waitForResetStoreState();
    expect(state.entity?.todayPillNumber, equals(3));

    final expected = DateTime.parse("2020-11-22");
    final actual = store.calcBeginingDateFromNextTodayPillNumber(2);
    expect(isSameDay(expected, actual), isTrue);
  });
  group("#markFor", () {
    test("it is alredy taken all", () async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.today()).thenReturn(today);

      final pillSheetEntity =
          PillSheet.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-23"),
        createdAt: DateTime.parse("2020-11-21"),
      );
      final settingEntity = Setting(
        pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 4,
        isOnReminder: true,
      );
      final state =
          RecordPageState(entity: pillSheetEntity, setting: settingEntity);

      final service = MockPillSheetService();
      when(service.fetchActivePillSheet())
          .thenAnswer((realInvocation) => Future.value(state.entity));
      when(service.fetchAll()).thenAnswer((realInvocation) => Future.value([]));
      when(service.fetchListWithMax(2))
          .thenAnswer((realInvocation) => Future.value([]));
      when(service.subscribeForLatestPillSheet())
          .thenAnswer((realInvocation) => Stream.empty());
      final batch = MockBatchFactory();
      final settingService = MockSettingService();
      when(settingService.fetch())
          .thenAnswer((realInvocation) => Future.value(settingEntity));
      when(settingService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());

      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final userService = MockUserService();
      when(userService.fetch())
          .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
      when(userService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final pillSheetModifedHistoryService =
          MockPillSheetModifiedHistoryService();

      final store = RecordPageStore(
        batch,
        service,
        settingService,
        userService,
        authService,
        pillSheetModifedHistoryService,
      );

      await waitForResetStoreState();
      expect(state.entity?.allTaken, isTrue);
      expect(store.markFor(1), PillMarkType.done);
      expect(store.markFor(2), PillMarkType.done);
      expect(store.markFor(3), PillMarkType.done);
      expect(store.markFor(4), PillMarkType.normal);
    });
    test("it is not taken all", () async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.today()).thenReturn(today);

      final pillSheetEntity =
          PillSheet.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-22"),
        createdAt: DateTime.parse("2020-11-21"),
      );
      final settingEntity = Setting(
        pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 4,
        isOnReminder: true,
      );
      final state =
          RecordPageState(entity: pillSheetEntity, setting: settingEntity);

      final service = MockPillSheetService();
      when(service.fetchActivePillSheet())
          .thenAnswer((realInvocation) => Future.value(state.entity));
      when(service.fetchAll()).thenAnswer((realInvocation) => Future.value([]));
      when(service.fetchListWithMax(2))
          .thenAnswer((realInvocation) => Future.value([]));
      when(service.subscribeForLatestPillSheet())
          .thenAnswer((realInvocation) => Stream.empty());
      final batch = MockBatchFactory();
      final settingService = MockSettingService();
      when(settingService.fetch())
          .thenAnswer((realInvocation) => Future.value(settingEntity));
      when(settingService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());

      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final userService = MockUserService();
      when(userService.fetch())
          .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
      when(userService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final pillSheetModifedHistoryService =
          MockPillSheetModifiedHistoryService();

      final store = RecordPageStore(
        batch,
        service,
        settingService,
        userService,
        authService,
        pillSheetModifedHistoryService,
      );

      await waitForResetStoreState();
      expect(state.entity?.allTaken, isFalse);
      expect(store.markFor(1), PillMarkType.done);
      expect(store.markFor(2), PillMarkType.done);
      expect(store.markFor(3), PillMarkType.normal);
      expect(store.markFor(4), PillMarkType.normal);
    });
  });
  group("#shouldPillMarkAnimation", () {
    test("it is alredy taken all", () async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.today()).thenReturn(today);

      final pillSheetEntity =
          PillSheet.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-23"),
        createdAt: DateTime.parse("2020-11-21"),
      );
      final settingEntity = Setting(
        pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 4,
        isOnReminder: true,
      );
      final state =
          RecordPageState(entity: pillSheetEntity, setting: settingEntity);

      final service = MockPillSheetService();
      when(service.fetchActivePillSheet())
          .thenAnswer((realInvocation) => Future.value(state.entity));
      when(service.fetchListWithMax(2)).thenAnswer((_) => Future.value([]));
      when(service.fetchAll()).thenAnswer((realInvocation) => Future.value([]));
      when(service.subscribeForLatestPillSheet())
          .thenAnswer((realInvocation) => Stream.empty());
      final batch = MockBatchFactory();
      final settingService = MockSettingService();
      when(settingService.fetch())
          .thenAnswer((realInvocation) => Future.value(settingEntity));
      when(settingService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());

      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final userService = MockUserService();
      when(userService.fetch())
          .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
      when(userService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final pillSheetModifedHistoryService =
          MockPillSheetModifiedHistoryService();

      final store = RecordPageStore(
        batch,
        service,
        settingService,
        userService,
        authService,
        pillSheetModifedHistoryService,
      );

      await waitForResetStoreState();
      expect(state.entity?.allTaken, isTrue);
      for (int i = 1; i <= pillSheetEntity.pillSheetType.totalCount; i++) {
        expect(store.shouldPillMarkAnimation(i), isFalse);
      }
    });
    test("it is not taken all", () async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.today()).thenReturn(today);

      final pillSheetEntity =
          PillSheet.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-22"),
        createdAt: DateTime.parse("2020-11-21"),
      );
      final settingEntity = Setting(
        pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 4,
        isOnReminder: true,
      );
      final state =
          RecordPageState(entity: pillSheetEntity, setting: settingEntity);

      final service = MockPillSheetService();
      when(service.fetchActivePillSheet())
          .thenAnswer((realInvocation) => Future.value(state.entity));
      when(service.fetchAll()).thenAnswer((realInvocation) => Future.value([]));
      when(service.fetchListWithMax(2))
          .thenAnswer((realInvocation) => Future.value([]));
      when(service.subscribeForLatestPillSheet())
          .thenAnswer((realInvocation) => Stream.empty());
      final batch = MockBatchFactory();
      final settingService = MockSettingService();
      when(settingService.fetch())
          .thenAnswer((realInvocation) => Future.value(settingEntity));
      when(settingService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());

      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final userService = MockUserService();
      when(userService.fetch())
          .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
      when(userService.subscribe())
          .thenAnswer((realInvocation) => Stream.empty());
      final pillSheetModifedHistoryService =
          MockPillSheetModifiedHistoryService();

      final store = RecordPageStore(
        batch,
        service,
        settingService,
        userService,
        authService,
        pillSheetModifedHistoryService,
      );

      await waitForResetStoreState();
      expect(state.entity?.allTaken, isFalse);
      expect(store.shouldPillMarkAnimation(3), isTrue);
    });
  });
}
