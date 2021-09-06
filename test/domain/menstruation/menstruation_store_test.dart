import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/domain/menstruation/menstruation_card_state.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/user.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/domain/menstruation/menstruation_store.dart';
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
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group("#cardState", () {
    test(
      "if latestMenstruation is into today, when return card state of begining about menstruation ",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final today = DateTime(2021, 04, 29);
        when(mockTodayRepository.today()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final menstruationService = MockMenstruationService();
        when(menstruationService.fetchAll()).thenAnswer(
          (realInvocation) => Future.value([
            Menstruation(
              beginDate: DateTime(2021, 04, 28),
              endDate: DateTime(2021, 04, 30),
              createdAt: DateTime(2021, 04, 28),
            ),
            Menstruation(
              beginDate: DateTime(2021, 03, 28),
              endDate: DateTime(2021, 03, 30),
              createdAt: DateTime(2021, 03, 28),
            ),
          ]),
        );
        when(menstruationService.subscribeAll()).thenAnswer(
          (realInvocation) => Stream.value([
            Menstruation(
              beginDate: DateTime(2021, 04, 28),
              endDate: DateTime(2021, 04, 30),
              createdAt: DateTime(2021, 04, 28),
            ),
            Menstruation(
              beginDate: DateTime(2021, 03, 28),
              endDate: DateTime(2021, 03, 30),
              createdAt: DateTime(2021, 03, 28),
            ),
          ]),
        );
        final pillSheetService = MockPillSheetService();
        final diaryService = MockDiaryService();
        when(diaryService.fetchListAround90Days(today))
            .thenAnswer((realInvocation) => Future.value([]));
        when(diaryService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());
        final settingService = MockSettingService();
        when(settingService.fetch()).thenAnswer((realInvocation) =>
            Future.value(Setting(
                pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
                pillNumberForFromMenstruation: 22,
                durationMenstruation: 3,
                reminderTimes: [],
                isOnReminder: true)));
        when(settingService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());
        final userService = MockUserService();
        when(userService.fetch())
            .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
        when(userService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: [], pillSheets: []);

        final pillSheetGroupService = MockPillSheetGroupService();
        when(pillSheetGroupService.fetchLatest())
            .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
        when(pillSheetGroupService.subscribeForLatest())
            .thenAnswer((realInvocation) => Stream.empty());

        final store = MenstruationStore(
          menstruationService: menstruationService,
          diaryService: diaryService,
          settingService: settingService,
          pillSheetService: pillSheetService,
          userService: userService,
          pillSheetGroupService: pillSheetGroupService,
        );

        await waitForResetStoreState();
        final actual = store.cardState();

        expect(
            actual,
            MenstruationCardState(
                title: "生理開始日",
                scheduleDate: DateTime(2021, 04, 28),
                countdownString: "2日目"));
      },
    );
    test(
      "if latestMenstruation is out of duration and latest pill sheet is null",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final today = DateTime(2021, 04, 29);
        when(mockTodayRepository.today()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final menstruationService = MockMenstruationService();
        when(menstruationService.fetchAll()).thenAnswer(
          (realInvocation) => Future.value([
            Menstruation(
              beginDate: DateTime(2021, 03, 28),
              endDate: DateTime(2021, 03, 30),
              createdAt: DateTime(2021, 03, 28),
            ),
          ]),
        );
        when(menstruationService.subscribeAll()).thenAnswer(
          (realInvocation) => Stream.value([
            Menstruation(
              beginDate: DateTime(2021, 03, 28),
              endDate: DateTime(2021, 03, 30),
              createdAt: DateTime(2021, 03, 28),
            ),
          ]),
        );
        final pillSheetService = MockPillSheetService();
        final diaryService = MockDiaryService();
        when(diaryService.fetchListAround90Days(today))
            .thenAnswer((realInvocation) => Future.value([]));
        when(diaryService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());
        final settingService = MockSettingService();
        when(settingService.fetch()).thenAnswer((realInvocation) =>
            Future.value(Setting(
                pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
                pillNumberForFromMenstruation: 22,
                durationMenstruation: 3,
                reminderTimes: [],
                isOnReminder: true)));
        when(settingService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());
        final userService = MockUserService();
        when(userService.fetch())
            .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
        when(userService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());

        final pillSheetGroup = PillSheetGroup(pillSheetIDs: [], pillSheets: []);

        final pillSheetGroupService = MockPillSheetGroupService();
        when(pillSheetGroupService.fetchLatest())
            .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
        when(pillSheetGroupService.subscribeForLatest())
            .thenAnswer((realInvocation) => Stream.empty());

        final store = MenstruationStore(
          menstruationService: menstruationService,
          diaryService: diaryService,
          settingService: settingService,
          pillSheetService: pillSheetService,
          userService: userService,
          pillSheetGroupService: pillSheetGroupService,
        );

        await waitForResetStoreState();
        final actual = store.cardState();

        expect(actual, null);
      },
    );

    test(
      "if latest pillsheet.beginingDate + totalCount < today, when return schedueld card state",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final today = DateTime(2021, 04, 29);
        when(mockTodayRepository.today()).thenReturn(today);
        when(mockTodayRepository.now()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final menstruationService = MockMenstruationService();
        when(menstruationService.fetchAll()).thenAnswer(
          (realInvocation) => Future.value([]),
        );
        when(menstruationService.subscribeAll()).thenAnswer(
          (realInvocation) => Stream.value([]),
        );
        final pillSheetService = MockPillSheetService();
        final diaryService = MockDiaryService();
        when(diaryService.fetchListAround90Days(today))
            .thenAnswer((realInvocation) => Future.value([]));
        when(diaryService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());
        final settingService = MockSettingService();
        when(settingService.fetch()).thenAnswer((realInvocation) =>
            Future.value(Setting(
                pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
                pillNumberForFromMenstruation: 22,
                durationMenstruation: 3,
                reminderTimes: [],
                isOnReminder: true)));
        when(settingService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());
        final userService = MockUserService();
        when(userService.fetch())
            .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
        when(userService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());

        final pillSheetGroup = PillSheetGroup(pillSheetIDs: [
          "1"
        ], pillSheets: [
          PillSheet(
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2021, 04, 22),
          ),
        ]);

        final pillSheetGroupService = MockPillSheetGroupService();
        when(pillSheetGroupService.fetchLatest())
            .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
        when(pillSheetGroupService.subscribeForLatest())
            .thenAnswer((realInvocation) => Stream.empty());

        final store = MenstruationStore(
          menstruationService: menstruationService,
          diaryService: diaryService,
          settingService: settingService,
          pillSheetService: pillSheetService,
          userService: userService,
          pillSheetGroupService: pillSheetGroupService,
        );

        await waitForResetStoreState();
        final actual = store.cardState();

        expect(
            actual,
            MenstruationCardState(
                title: "生理予定日",
                scheduleDate: DateTime(2021, 05, 13),
                countdownString: "あと14日"));
      },
    );
    test(
      "if latest pillsheet.beginingDate + totalCount >= today, when return card state of into duration for schedueld menstruation",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final today = DateTime(2021, 04, 29);
        when(mockTodayRepository.today()).thenReturn(today);
        when(mockTodayRepository.now()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final menstruationService = MockMenstruationService();
        when(menstruationService.fetchAll()).thenAnswer(
          (realInvocation) => Future.value([]),
        );
        when(menstruationService.subscribeAll()).thenAnswer(
          (realInvocation) => Stream.value([]),
        );
        final pillSheetService = MockPillSheetService();
        final diaryService = MockDiaryService();
        when(diaryService.fetchListAround90Days(today))
            .thenAnswer((realInvocation) => Future.value([]));
        when(diaryService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());
        final settingService = MockSettingService();
        when(settingService.fetch()).thenAnswer((realInvocation) =>
            Future.value(Setting(
                pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
                pillNumberForFromMenstruation: 22,
                durationMenstruation: 3,
                reminderTimes: [],
                isOnReminder: true)));
        when(settingService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());
        final userService = MockUserService();
        when(userService.fetch())
            .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
        when(userService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());

        final pillSheetGroup = PillSheetGroup(pillSheetIDs: [
          "1"
        ], pillSheets: [
          PillSheet(
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2021, 04, 07),
          ),
        ]);
        final pillSheetGroupService = MockPillSheetGroupService();
        when(pillSheetGroupService.fetchLatest())
            .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
        when(pillSheetGroupService.subscribeForLatest())
            .thenAnswer((realInvocation) => Stream.empty());

        final store = MenstruationStore(
          menstruationService: menstruationService,
          diaryService: diaryService,
          settingService: settingService,
          pillSheetService: pillSheetService,
          userService: userService,
          pillSheetGroupService: pillSheetGroupService,
        );
        await waitForResetStoreState();
        final actual = store.cardState();

        expect(
          actual,
          MenstruationCardState(
              title: "生理予定日",
              scheduleDate: DateTime(2021, 04, 28),
              countdownString: "生理予定：2日目"),
        );
      },
    );
  });
}
