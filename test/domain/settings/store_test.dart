import 'package:pilll/domain/settings/setting_page_async_action.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

class _FakeUser extends Fake implements User {
  _FakeUser({
// ignore: unused_element
    this.fakeIsPremium = false,
// ignore: unused_element
    this.fakeIsTrial = false,
// ignore: unused_element
    this.fakeIsExpiredDiscountEntitlements = false,
// ignore: unused_element
    this.fakeIsTrialDeadlineDate,
  });
  final bool fakeIsPremium;
  final bool fakeIsTrial;
  final bool fakeIsExpiredDiscountEntitlements;
  final DateTime? fakeIsTrialDeadlineDate;
  @override
  bool get isPremium => fakeIsPremium;
  @override
  bool get isTrial => fakeIsTrial;
  @override
  bool get hasDiscountEntitlement => fakeIsExpiredDiscountEntitlements;
  @override
  DateTime? get trialDeadlineDate => fakeIsTrialDeadlineDate;
}

class _FakeSetting extends Fake implements Setting {
  final List<ReminderTime> fakeReminderTimes;
  _FakeSetting(this.fakeReminderTimes);
  @override
  List<ReminderTime> get reminderTimes => fakeReminderTimes;
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#addReminderTimes", () {
    test("when added reminder times ${ReminderTime.maximumCount}", () {
      final settingDatastore = MockSettingDatastore();
      final setting = const Setting(
        reminderTimes: [
          ReminderTime(hour: 1, minute: 0),
          ReminderTime(hour: 2, minute: 0),
        ],
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 1,
        isOnReminder: false,
        pillSheetTypes: [PillSheetType.pillsheet_28_4],
      );

      when(settingDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(settingDatastore.stream())
          .thenAnswer((realInvocation) => Stream.value(setting));

      final batchFactory = MockBatchFactory();
      final pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      final pillSheetDatastore = MockPillSheetDatastore();
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

      final userDatastore = MockUserDatastore();
      when(userDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(_FakeUser()));
      when(userDatastore.stream())
          .thenAnswer((realInvocation) => const Stream.empty());
      final pillSheetModifiedService = MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupDatastore.latestPillSheetGroupStream())
          .thenAnswer((realInvocation) => const Stream.empty());

      final asyncAction = SettingPageAsyncAction(
        batchFactory,
        settingDatastore,
        pillSheetDatastore,
        pillSheetModifiedService,
        pillSheetGroupDatastore,
      );

      when(settingDatastore.update(setting.copyWith(reminderTimes: [
        const ReminderTime(hour: 1, minute: 0),
        const ReminderTime(hour: 2, minute: 0),
        const ReminderTime(hour: 3, minute: 0),
      ]))).thenAnswer((realInvocation) => Future.value(setting));

      asyncAction.addReminderTimes(
        reminderTime: const ReminderTime(hour: 3, minute: 0),
        setting: setting,
      );

      verify(settingDatastore.update(setting.copyWith(reminderTimes: [
        const ReminderTime(hour: 1, minute: 0),
        const ReminderTime(hour: 2, minute: 0),
        const ReminderTime(hour: 3, minute: 0),
      ])));
    });
    test(
        "return exception when setting has reminderTimes count is ${ReminderTime.maximumCount}",
        () {
      final settingDatastore = MockSettingDatastore();
      final setting = _FakeSetting([
        const ReminderTime(hour: 1, minute: 0),
        const ReminderTime(hour: 2, minute: 0),
        const ReminderTime(hour: 3, minute: 0)
      ]);
      when(settingDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(settingDatastore.stream())
          .thenAnswer((realInvocation) => Stream.value(setting));

      final batchFactory = MockBatchFactory();
      final pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

      final pillSheetDatastore = MockPillSheetDatastore();
      final userDatastore = MockUserDatastore();
      when(userDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(_FakeUser()));
      when(userDatastore.stream())
          .thenAnswer((realInvocation) => const Stream.empty());
      final pillSheetModifiedService = MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupDatastore.latestPillSheetGroupStream())
          .thenAnswer((realInvocation) => const Stream.empty());

      final asyncAction = SettingPageAsyncAction(
        batchFactory,
        settingDatastore,
        pillSheetDatastore,
        pillSheetModifiedService,
        pillSheetGroupDatastore,
      );

      expect(
          () => asyncAction.addReminderTimes(
              reminderTime: const ReminderTime(hour: 4, minute: 0),
              setting: setting),
          throwsException);
    });
  });
  group("#deleteReminderTimes", () {
    test("when deleted reminder times ${ReminderTime.maximumCount}", () {
      final settingDatastore = MockSettingDatastore();
      final setting = const Setting(
        reminderTimes: [
          ReminderTime(hour: 1, minute: 0),
          ReminderTime(hour: 2, minute: 0),
        ],
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 1,
        isOnReminder: false,
        pillSheetTypes: [PillSheetType.pillsheet_28_4],
      );
      when(settingDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(settingDatastore.stream())
          .thenAnswer((realInvocation) => Stream.value(setting));

      final pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

      final batchFactory = MockBatchFactory();
      final pillSheetDatastore = MockPillSheetDatastore();
      final userDatastore = MockUserDatastore();
      when(userDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(_FakeUser()));
      when(userDatastore.stream())
          .thenAnswer((realInvocation) => const Stream.empty());
      final pillSheetModifiedService = MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupDatastore.latestPillSheetGroupStream())
          .thenAnswer((realInvocation) => const Stream.empty());

      final asyncAction = SettingPageAsyncAction(
        batchFactory,
        settingDatastore,
        pillSheetDatastore,
        pillSheetModifiedService,
        pillSheetGroupDatastore,
      );

      when(settingDatastore.update(setting.copyWith(reminderTimes: [
        const ReminderTime(hour: 1, minute: 0),
      ]))).thenAnswer((realInvocation) => Future.value(setting));

      asyncAction.deleteReminderTimes(index: 1, setting: setting);

      verify(settingDatastore.update(setting.copyWith(reminderTimes: [
        const ReminderTime(hour: 1, minute: 0),
      ])));
    });
    test(
        "return exception when setting has remindertimes count is ${ReminderTime.minimumCount}",
        () {
      final settingDatastore = MockSettingDatastore();
      final setting = _FakeSetting([
        const ReminderTime(hour: 1, minute: 0),
      ]);
      when(settingDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(settingDatastore.stream())
          .thenAnswer((realInvocation) => Stream.value(setting));

      final batchFactory = MockBatchFactory();
      final pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

      final pillSheetDatastore = MockPillSheetDatastore();

      final userDatastore = MockUserDatastore();
      when(userDatastore.fetch())
          .thenAnswer((realInvocation) => Future.value(_FakeUser()));
      when(userDatastore.stream())
          .thenAnswer((realInvocation) => const Stream.empty());
      final pillSheetModifiedService = MockPillSheetModifiedHistoryDatastore();
      final pillSheetGroupDatastore = MockPillSheetGroupDatastore();
      when(pillSheetGroupDatastore.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupDatastore.latestPillSheetGroupStream())
          .thenAnswer((realInvocation) => const Stream.empty());

      final asyncAction = SettingPageAsyncAction(
        batchFactory,
        settingDatastore,
        pillSheetDatastore,
        pillSheetModifiedService,
        pillSheetGroupDatastore,
      );

      expect(() => asyncAction.deleteReminderTimes(index: 0, setting: setting),
          throwsException);
    });
  });
}
