import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/state/setting.dart';
import 'package:Pilll/store/setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helper/mock.dart';

class _FakeSetting extends Fake implements Setting {
  final List<ReminderTime> fakeReminderTimes;
  _FakeSetting(this.fakeReminderTimes);
  @override
  List<ReminderTime> get reminderTimes => fakeReminderTimes;
}

void main() {
  group("#addReminderTimes", () {
    test("when added reminder times ${ReminderTime.maximumCount}", () {
      final service = MockSettingService();
      final setting = Setting(
        reminderTimes: [
          ReminderTime(hour: 1, minute: 0),
          ReminderTime(hour: 2, minute: 0),
        ],
        durationMenstruation: 1,
        fromMenstruation: 1,
        isOnReminder: false,
        pillSheetTypeRawPath: PillSheetType.pillsheet_28_4.rawPath,
      );
      final store = SettingStateStore(service);
      // ignore: invalid_use_of_protected_member
      store.state = SettingState(entity: setting);

      when(service.update(setting.copyWith(reminderTimes: [
        ReminderTime(hour: 1, minute: 0),
        ReminderTime(hour: 2, minute: 0),
        ReminderTime(hour: 3, minute: 0),
      ]))).thenAnswer((realInvocation) => Future.value(setting));

      store.addReminderTimes(ReminderTime(hour: 3, minute: 0));
      verify(service.update(setting));
    });
    test(
        "return exception when setting has reminderTimes count is ${ReminderTime.maximumCount}",
        () {
      final setting = _FakeSetting([
        ReminderTime(hour: 1, minute: 0),
        ReminderTime(hour: 2, minute: 0),
        ReminderTime(hour: 3, minute: 0)
      ]);
      final store = SettingStateStore(null);
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
        fromMenstruation: 1,
        isOnReminder: false,
        pillSheetTypeRawPath: PillSheetType.pillsheet_28_4.rawPath,
      );
      final store = SettingStateStore(service);
      // ignore: invalid_use_of_protected_member
      store.state = SettingState(entity: setting);

      when(service.update(setting.copyWith(reminderTimes: [
        ReminderTime(hour: 1, minute: 0),
      ]))).thenAnswer((realInvocation) => Future.value(setting));

      store.deleteReminderTimes(1);
      verify(service.update(setting));
    });
    test(
        "return exception when setting has remindertimes count is ${ReminderTime.minimumCount}",
        () {
      final setting = _FakeSetting([
        ReminderTime(hour: 1, minute: 0),
      ]);
      final store = SettingStateStore(null);
      // ignore: invalid_use_of_protected_member
      store.state = SettingState(entity: setting);
      expect(() => store.deleteReminderTimes(0), throwsException);
    });
  });
}
