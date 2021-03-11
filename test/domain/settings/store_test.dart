import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/state/setting.dart';
import 'package:pilll/store/setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.dart';

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
        durationMenstruation: 1,
        pillNumberForFromMenstruation: 22,
        isOnReminder: false,
        pillSheetTypeRawPath: PillSheetType.pillsheet_28_4.rawPath,
      );

      when(service.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(service.subscribe())
          .thenAnswer((realInvocation) => Stream.value(setting));

      final store = SettingStateStore(service);
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
      when(service.subscribe())
          .thenAnswer((realInvocation) => Stream.value(setting));

      final store = SettingStateStore(service);
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
        durationMenstruation: 1,
        pillNumberForFromMenstruation: 22,
        isOnReminder: false,
        pillSheetTypeRawPath: PillSheetType.pillsheet_28_4.rawPath,
      );
      when(service.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(service.subscribe())
          .thenAnswer((realInvocation) => Stream.value(setting));

      final store = SettingStateStore(service);
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
      when(service.subscribe())
          .thenAnswer((realInvocation) => Stream.value(setting));

      final store = SettingStateStore(service);
      // ignore: invalid_use_of_protected_member
      store.state = SettingState(entity: setting);
      expect(() => store.deleteReminderTimes(0), throwsException);
    });
  });
}
