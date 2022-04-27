import 'package:pilll/analytics.dart';
import 'package:pilll/domain/record/record_page_state.codegen.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/service/day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/delay.dart';
import '../../helper/mock.mocks.dart';

class _FakeUser extends Fake implements User {
  _FakeUser({
// ignore: unused_element
    this.fakeIsPremium = false,
// ignore: unused_element
    this.fakeIsTrial = false,
// ignore: unused_element
    this.fakeTrialDeadlineDate,
// ignore: unused_element
    this.fakeDiscountEntitlementDeadlineDate,
// ignore: unused_element
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
  group("#markFor", () {
    test("it is alredy taken all", () async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(today);
      when(mockTodayRepository.now()).thenReturn(today);

      final pillSheetEntity =
          PillSheet.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-23"),
        createdAt: DateTime.parse("2020-11-21"),
      );
      final setting = const Setting(
        pillSheetTypes: [PillSheetType.pillsheet_21],
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 4,
        isOnReminder: true,
      );
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheetEntity], createdAt: now());
      final state =
          RecordPageState(pillSheetGroup: pillSheetGroup, setting: setting);

      final service = MockPillSheetDatastore();
      final batch = MockBatchFactory();
      final settingDatastore = MockSettingDatastore();
      when(settingDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(settingDatastore.stream())
          .thenAnswer((realInvocation) => const Stream.empty());

      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.stream())
          .thenAnswer((realInvocation) => const Stream.empty());
      final userDatastore = MockUserDatastore();
      when(userDatastore.fetch())
          .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
      when(userDatastore.stream())
          .thenAnswer((realInvocation) => const Stream.empty());
      final pillSheetModifedHistoryService =
          MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupDatastore.streamForLatest())
          .thenAnswer((realInvocation) => const Stream.empty());
      final store = RecordPageStore(
        batch,
        service,
        settingDatastore,
        userDatastore,
        authService,
        pillSheetModifedHistoryService,
        pillSheetGroupDatastore,
      );

      await waitForResetStoreState();
      expect(state.pillSheetGroup?.pillSheets.first.todayPillIsAlreadyTaken,
          isTrue);
      expect(
          store.markFor(pillNumberIntoPillSheet: 1, pillSheet: pillSheetEntity),
          PillMarkType.done);
      expect(
          store.markFor(pillNumberIntoPillSheet: 2, pillSheet: pillSheetEntity),
          PillMarkType.done);
      expect(
          store.markFor(pillNumberIntoPillSheet: 3, pillSheet: pillSheetEntity),
          PillMarkType.done);
      expect(
          store.markFor(pillNumberIntoPillSheet: 4, pillSheet: pillSheetEntity),
          PillMarkType.normal);
    });
    test("it is not taken all", () async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(today);
      when(mockTodayRepository.now()).thenReturn(today);

      final pillSheetEntity =
          PillSheet.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-22"),
        createdAt: DateTime.parse("2020-11-21"),
      );
      final setting = const Setting(
        pillSheetTypes: [PillSheetType.pillsheet_21],
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 4,
        isOnReminder: true,
      );
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheetEntity], createdAt: now());
      final state =
          RecordPageState(pillSheetGroup: pillSheetGroup, setting: setting);

      final service = MockPillSheetDatastore();
      final batch = MockBatchFactory();
      final settingDatastore = MockSettingDatastore();
      when(settingDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(settingDatastore.stream())
          .thenAnswer((realInvocation) => const Stream.empty());

      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.stream())
          .thenAnswer((realInvocation) => const Stream.empty());
      final userDatastore = MockUserDatastore();
      when(userDatastore.fetch())
          .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
      when(userDatastore.stream())
          .thenAnswer((realInvocation) => const Stream.empty());
      final pillSheetModifedHistoryService =
          MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupDatastore.streamForLatest())
          .thenAnswer((realInvocation) => const Stream.empty());

      final store = RecordPageStore(
        batch,
        service,
        settingDatastore,
        userDatastore,
        authService,
        pillSheetModifedHistoryService,
        pillSheetGroupDatastore,
      );

      await waitForResetStoreState();
      expect(state.pillSheetGroup?.pillSheets.first.todayPillIsAlreadyTaken,
          isFalse);
      expect(
          store.markFor(pillNumberIntoPillSheet: 1, pillSheet: pillSheetEntity),
          PillMarkType.done);
      expect(
          store.markFor(pillNumberIntoPillSheet: 2, pillSheet: pillSheetEntity),
          PillMarkType.done);
      expect(
          store.markFor(pillNumberIntoPillSheet: 3, pillSheet: pillSheetEntity),
          PillMarkType.normal);
      expect(
          store.markFor(pillNumberIntoPillSheet: 4, pillSheet: pillSheetEntity),
          PillMarkType.normal);
    });
  });
  group("#shouldPillMarkAnimation", () {
    test("it is alredy taken all", () async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(today);
      when(mockTodayRepository.now()).thenReturn(today);

      final pillSheetEntity =
          PillSheet.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-23"),
        createdAt: DateTime.parse("2020-11-21"),
      );
      final setting = const Setting(
        pillSheetTypes: [PillSheetType.pillsheet_21],
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 4,
        isOnReminder: true,
      );
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheetEntity], createdAt: now());
      final state =
          RecordPageState(pillSheetGroup: pillSheetGroup, setting: setting);

      final service = MockPillSheetDatastore();
      final batch = MockBatchFactory();
      final settingDatastore = MockSettingDatastore();
      when(settingDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(settingDatastore.stream())
          .thenAnswer((realInvocation) => const Stream.empty());

      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.stream())
          .thenAnswer((realInvocation) => const Stream.empty());
      final userDatastore = MockUserDatastore();
      when(userDatastore.fetch())
          .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
      when(userDatastore.stream())
          .thenAnswer((realInvocation) => const Stream.empty());
      final pillSheetModifedHistoryService =
          MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupDatastore.streamForLatest())
          .thenAnswer((realInvocation) => const Stream.empty());

      final store = RecordPageStore(
        batch,
        service,
        settingDatastore,
        userDatastore,
        authService,
        pillSheetModifedHistoryService,
        pillSheetGroupDatastore,
      );

      await waitForResetStoreState();
      expect(state.pillSheetGroup?.pillSheets.first.todayPillIsAlreadyTaken,
          isTrue);
      for (int i = 1; i <= pillSheetEntity.pillSheetType.totalCount; i++) {
        expect(
            store.shouldPillMarkAnimation(
              pillNumberIntoPillSheet: i,
              pillSheet: pillSheetEntity,
            ),
            isFalse);
      }
    });
    test("it is not taken all", () async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(today);
      when(mockTodayRepository.now()).thenReturn(today);

      final pillSheetEntity =
          PillSheet.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-22"),
        createdAt: DateTime.parse("2020-11-21"),
      );
      final setting = const Setting(
        pillSheetTypes: [PillSheetType.pillsheet_21],
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 4,
        isOnReminder: true,
      );
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheetEntity], createdAt: now());

      final state =
          RecordPageState(pillSheetGroup: pillSheetGroup, setting: setting);

      final service = MockPillSheetDatastore();
      final batch = MockBatchFactory();
      final settingDatastore = MockSettingDatastore();
      when(settingDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(settingDatastore.stream())
          .thenAnswer((realInvocation) => const Stream.empty());

      final authService = MockAuthService();
      when(authService.isLinkedApple()).thenReturn(false);
      when(authService.isLinkedGoogle()).thenReturn(false);
      when(authService.stream())
          .thenAnswer((realInvocation) => const Stream.empty());
      final userDatastore = MockUserDatastore();
      when(userDatastore.fetch())
          .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
      when(userDatastore.stream())
          .thenAnswer((realInvocation) => const Stream.empty());
      final pillSheetModifedHistoryService =
          MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupDatastore.streamForLatest())
          .thenAnswer((realInvocation) => const Stream.empty());

      final store = RecordPageStore(
        batch,
        service,
        settingDatastore,
        userDatastore,
        authService,
        pillSheetModifedHistoryService,
        pillSheetGroupDatastore,
      );

      await waitForResetStoreState();
      expect(state.pillSheetGroup?.pillSheets.first.todayPillIsAlreadyTaken,
          isFalse);
      expect(
          store.shouldPillMarkAnimation(
            pillNumberIntoPillSheet: 3,
            pillSheet: pillSheetEntity,
          ),
          isTrue);
    });
  });
}
