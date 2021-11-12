import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/domain/settings/setting_page_state.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/user.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

class _FakeUser extends Fake implements User {
  _FakeUser({
    this.fakeIsPremium = false,
    this.fakeIsTrial = false,
    this.fakeIsExpiredDiscountEntitlements = false,
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
      final service = MockSettingService();
      final setting = Setting(
        reminderTimes: [
          ReminderTime(hour: 1, minute: 0),
          ReminderTime(hour: 2, minute: 0),
        ],
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 1,
        isOnReminder: false,
        pillSheetTypes: [PillSheetType.pillsheet_28_4],
      );

      when(service.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(service.stream())
          .thenAnswer((realInvocation) => Stream.value(setting));

      final batchFactory = MockBatchFactory();
      final pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      final pillSheetService = MockPillSheetService();
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

      final userService = MockUserService();
      when(userService.fetch())
          .thenAnswer((realInvocation) => Future.value(_FakeUser()));
      when(userService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      final pillSheetModifiedService = MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();
      when(pillSheetGroupService.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupService.streamForLatest())
          .thenAnswer((realInvocation) => Stream.empty());

      final store = SettingStateStore(
        batchFactory,
        service,
        pillSheetService,
        userService,
        pillSheetModifiedService,
        pillSheetGroupService,
      );

      // ignore: invalid_use_of_protected_member
      store.state = SettingState(entity: setting);

      when(service.update(setting.copyWith(reminderTimes: [
        ReminderTime(hour: 1, minute: 0),
        ReminderTime(hour: 2, minute: 0),
        ReminderTime(hour: 3, minute: 0),
      ]))).thenAnswer((realInvocation) => Future.value(setting));

      store.addReminderTimes(ReminderTime(hour: 3, minute: 0));
      verify(service.update(setting.copyWith(reminderTimes: [
        ReminderTime(hour: 1, minute: 0),
        ReminderTime(hour: 2, minute: 0),
        ReminderTime(hour: 3, minute: 0),
      ])));
    });
    test(
        "return exception when setting has reminderTimes count is ${ReminderTime.maximumCount}",
        () {
      final service = MockSettingService();
      final setting = _FakeSetting([
        ReminderTime(hour: 1, minute: 0),
        ReminderTime(hour: 2, minute: 0),
        ReminderTime(hour: 3, minute: 0)
      ]);
      when(service.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(service.stream())
          .thenAnswer((realInvocation) => Stream.value(setting));

      final batchFactory = MockBatchFactory();
      final pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

      final pillSheetService = MockPillSheetService();
      final userService = MockUserService();
      when(userService.fetch())
          .thenAnswer((realInvocation) => Future.value(_FakeUser()));
      when(userService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      final pillSheetModifiedService = MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();
      when(pillSheetGroupService.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupService.streamForLatest())
          .thenAnswer((realInvocation) => Stream.empty());

      final store = SettingStateStore(
        batchFactory,
        service,
        pillSheetService,
        userService,
        pillSheetModifiedService,
        pillSheetGroupService,
      );

      // ignore: invalid_use_of_protected_member
      store.state = SettingState(entity: setting);

      expect(() => store.addReminderTimes(ReminderTime(hour: 4, minute: 0)),
          throwsException);
    });
  });
  group("#deleteReminderTimes", () {
    test("when deleted reminder times ${ReminderTime.maximumCount}", () {
      final service = MockSettingService();
      final setting = Setting(
        reminderTimes: [
          ReminderTime(hour: 1, minute: 0),
          ReminderTime(hour: 2, minute: 0),
        ],
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 1,
        isOnReminder: false,
        pillSheetTypes: [PillSheetType.pillsheet_28_4],
      );
      when(service.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(service.stream())
          .thenAnswer((realInvocation) => Stream.value(setting));

      final pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

      final batchFactory = MockBatchFactory();
      final pillSheetService = MockPillSheetService();
      final userService = MockUserService();
      when(userService.fetch())
          .thenAnswer((realInvocation) => Future.value(_FakeUser()));
      when(userService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      final pillSheetModifiedService = MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();
      when(pillSheetGroupService.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupService.streamForLatest())
          .thenAnswer((realInvocation) => Stream.empty());

      final store = SettingStateStore(
        batchFactory,
        service,
        pillSheetService,
        userService,
        pillSheetModifiedService,
        pillSheetGroupService,
      );

      // ignore: invalid_use_of_protected_member
      store.state = SettingState(entity: setting);

      when(service.update(setting.copyWith(reminderTimes: [
        ReminderTime(hour: 1, minute: 0),
      ]))).thenAnswer((realInvocation) => Future.value(setting));

      store.deleteReminderTimes(1);
      verify(service.update(setting.copyWith(reminderTimes: [
        ReminderTime(hour: 1, minute: 0),
      ])));
    });
    test(
        "return exception when setting has remindertimes count is ${ReminderTime.minimumCount}",
        () {
      final service = MockSettingService();
      final setting = _FakeSetting([
        ReminderTime(hour: 1, minute: 0),
      ]);
      when(service.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(service.stream())
          .thenAnswer((realInvocation) => Stream.value(setting));

      final batchFactory = MockBatchFactory();
      final pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

      final pillSheetService = MockPillSheetService();

      final userService = MockUserService();
      when(userService.fetch())
          .thenAnswer((realInvocation) => Future.value(_FakeUser()));
      when(userService.stream())
          .thenAnswer((realInvocation) => Stream.empty());
      final pillSheetModifiedService = MockPillSheetModifiedHistoryService();
      final pillSheetGroupService = MockPillSheetGroupService();
      when(pillSheetGroupService.fetchLatest())
          .thenAnswer((realInvocation) => Future.value(pillSheetGroup));
      when(pillSheetGroupService.streamForLatest())
          .thenAnswer((realInvocation) => Stream.empty());

      final store = SettingStateStore(
        batchFactory,
        service,
        pillSheetService,
        userService,
        pillSheetModifiedService,
        pillSheetGroupService,
      );

      // ignore: invalid_use_of_protected_member
      store.state = SettingState(entity: setting);
      expect(() => store.deleteReminderTimes(0), throwsException);
    });
  });
}
