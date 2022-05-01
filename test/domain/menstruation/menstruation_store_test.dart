import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/domain/menstruation/menstruation_card_state.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/domain/menstruation/menstruation_store.dart';
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
        when(mockTodayRepository.now()).thenReturn(today);
        when(mockTodayRepository.now()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final menstruationDatastore = MockMenstruationDatastore();
        when(menstruationDatastore.fetchAll()).thenAnswer(
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
        when(menstruationDatastore.streamAll()).thenAnswer(
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
        final pillSheetDatastore = MockPillSheetDatastore();
        final diaryDatastore = MockDiaryDatastore();
        when(diaryDatastore.fetchListAround90Days(today))
            .thenAnswer((realInvocation) => Future.value([]));
        when(diaryDatastore.stream())
            .thenAnswer((realInvocation) => const Stream.empty());
        final settingDatastore = MockSettingDatastore();
        when(settingDatastore.fetch())
            .thenAnswer((realInvocation) => Future.value(
                  const Setting(
                    pillSheetTypes: [PillSheetType.pillsheet_21],
                    pillNumberForFromMenstruation: 22,
                    durationMenstruation: 3,
                    reminderTimes: [],
                    isOnReminder: true,
                  ),
                ));
        when(settingDatastore.stream())
            .thenAnswer((realInvocation) => const Stream.empty());
        final userDatastore = MockUserDatastore();
        when(userDatastore.fetch())
            .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
        when(userDatastore.stream())
            .thenAnswer((realInvocation) => const Stream.empty());
        final pillSheetGroup =
            PillSheetGroup(pillSheetIDs: [], pillSheets: [], createdAt: now());

        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        when(pillSheetGroupDatastore.fetchLatest())
            .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
        when(pillSheetGroupDatastore.latestPillSheetGroupStream())
            .thenAnswer((realInvocation) => const Stream.empty());

        final store = MenstruationStore(
          menstruationDatastore: menstruationDatastore,
          diaryDatastore: diaryDatastore,
          settingDatastore: settingDatastore,
          pillSheetDatastore: pillSheetDatastore,
          userDatastore: userDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
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
        when(mockTodayRepository.now()).thenReturn(today);
        when(mockTodayRepository.now()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final menstruationDatastore = MockMenstruationDatastore();
        when(menstruationDatastore.fetchAll()).thenAnswer(
          (realInvocation) => Future.value([
            Menstruation(
              beginDate: DateTime(2021, 03, 28),
              endDate: DateTime(2021, 03, 30),
              createdAt: DateTime(2021, 03, 28),
            ),
          ]),
        );
        when(menstruationDatastore.streamAll()).thenAnswer(
          (realInvocation) => Stream.value([
            Menstruation(
              beginDate: DateTime(2021, 03, 28),
              endDate: DateTime(2021, 03, 30),
              createdAt: DateTime(2021, 03, 28),
            ),
          ]),
        );
        final pillSheetDatastore = MockPillSheetDatastore();
        final diaryDatastore = MockDiaryDatastore();
        when(diaryDatastore.fetchListAround90Days(today))
            .thenAnswer((realInvocation) => Future.value([]));
        when(diaryDatastore.stream())
            .thenAnswer((realInvocation) => const Stream.empty());
        final settingDatastore = MockSettingDatastore();
        when(settingDatastore.fetch())
            .thenAnswer((realInvocation) => Future.value(const Setting(
                  pillSheetTypes: [PillSheetType.pillsheet_21],
                  pillNumberForFromMenstruation: 22,
                  durationMenstruation: 3,
                  reminderTimes: [],
                  isOnReminder: true,
                )));
        when(settingDatastore.stream())
            .thenAnswer((realInvocation) => const Stream.empty());
        final userDatastore = MockUserDatastore();
        when(userDatastore.fetch())
            .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
        when(userDatastore.stream())
            .thenAnswer((realInvocation) => const Stream.empty());

        final pillSheetGroup =
            PillSheetGroup(pillSheetIDs: [], pillSheets: [], createdAt: now());

        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        when(pillSheetGroupDatastore.fetchLatest())
            .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
        when(pillSheetGroupDatastore.latestPillSheetGroupStream())
            .thenAnswer((realInvocation) => const Stream.empty());

        final store = MenstruationStore(
          menstruationDatastore: menstruationDatastore,
          diaryDatastore: diaryDatastore,
          settingDatastore: settingDatastore,
          pillSheetDatastore: pillSheetDatastore,
          userDatastore: userDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
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
        when(mockTodayRepository.now()).thenReturn(today);
        when(mockTodayRepository.now()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final menstruationDatastore = MockMenstruationDatastore();
        when(menstruationDatastore.fetchAll()).thenAnswer(
          (realInvocation) => Future.value([]),
        );
        when(menstruationDatastore.streamAll()).thenAnswer(
          (realInvocation) => Stream.value([]),
        );
        final pillSheetDatastore = MockPillSheetDatastore();
        final diaryDatastore = MockDiaryDatastore();
        when(diaryDatastore.fetchListAround90Days(today))
            .thenAnswer((realInvocation) => Future.value([]));
        when(diaryDatastore.stream())
            .thenAnswer((realInvocation) => const Stream.empty());
        final settingDatastore = MockSettingDatastore();
        when(settingDatastore.fetch()).thenAnswer(
          (realInvocation) => Future.value(
            const Setting(
              pillSheetTypes: [PillSheetType.pillsheet_21],
              pillNumberForFromMenstruation: 22,
              durationMenstruation: 3,
              reminderTimes: [],
              isOnReminder: true,
            ),
          ),
        );
        when(settingDatastore.stream())
            .thenAnswer((realInvocation) => const Stream.empty());
        final userDatastore = MockUserDatastore();
        when(userDatastore.fetch())
            .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
        when(userDatastore.stream())
            .thenAnswer((realInvocation) => const Stream.empty());

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"],
          pillSheets: [
            PillSheet(
              typeInfo: PillSheetType.pillsheet_21.typeInfo,
              beginingDate: DateTime(2021, 04, 22),
            ),
          ],
          createdAt: now(),
        );

        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        when(pillSheetGroupDatastore.fetchLatest())
            .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
        when(pillSheetGroupDatastore.latestPillSheetGroupStream())
            .thenAnswer((realInvocation) => const Stream.empty());

        final store = MenstruationStore(
          menstruationDatastore: menstruationDatastore,
          diaryDatastore: diaryDatastore,
          settingDatastore: settingDatastore,
          pillSheetDatastore: pillSheetDatastore,
          userDatastore: userDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
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
      "if todayPillNumber > setting.pillNumberForFromMenstruation, when return card state of into duration for schedueld menstruation",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final today = DateTime(2021, 04, 29);
        when(mockTodayRepository.now()).thenReturn(today);
        when(mockTodayRepository.now()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final menstruationDatastore = MockMenstruationDatastore();
        when(menstruationDatastore.fetchAll()).thenAnswer(
          (realInvocation) => Future.value([]),
        );
        when(menstruationDatastore.streamAll()).thenAnswer(
          (realInvocation) => Stream.value([]),
        );
        final pillSheetDatastore = MockPillSheetDatastore();
        final diaryDatastore = MockDiaryDatastore();
        when(diaryDatastore.fetchListAround90Days(today))
            .thenAnswer((realInvocation) => Future.value([]));
        when(diaryDatastore.stream())
            .thenAnswer((realInvocation) => const Stream.empty());
        final settingDatastore = MockSettingDatastore();
        when(settingDatastore.fetch()).thenAnswer(
          (realInvocation) => Future.value(
            const Setting(
              pillSheetTypes: [PillSheetType.pillsheet_21],
              pillNumberForFromMenstruation: 22,
              durationMenstruation: 3,
              reminderTimes: [],
              isOnReminder: true,
            ),
          ),
        );
        when(settingDatastore.stream())
            .thenAnswer((realInvocation) => const Stream.empty());
        final userDatastore = MockUserDatastore();
        when(userDatastore.fetch())
            .thenAnswer((reaInvocation) => Future.value(_FakeUser()));
        when(userDatastore.stream())
            .thenAnswer((realInvocation) => const Stream.empty());

        final pillSheetGroup = PillSheetGroup(pillSheetIDs: [
          "1"
        ], pillSheets: [
          PillSheet(
            typeInfo: PillSheetType.pillsheet_21.typeInfo,
            beginingDate: DateTime(2021, 04, 07),
          ),
        ], createdAt: now());
        final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
        when(pillSheetGroupDatastore.fetchLatest())
            .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
        when(pillSheetGroupDatastore.latestPillSheetGroupStream())
            .thenAnswer((realInvocation) => const Stream.empty());

        final store = MenstruationStore(
          menstruationDatastore: menstruationDatastore,
          diaryDatastore: diaryDatastore,
          settingDatastore: settingDatastore,
          pillSheetDatastore: pillSheetDatastore,
          userDatastore: userDatastore,
          pillSheetGroupDatastore: pillSheetGroupDatastore,
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
