import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/domain/calendar/utility.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#scheduledMenstruationDateRange", () {
    test(
      "First page with pillSheetType: pillsheet_28_7, beginingDate: 2020-09-01, fromMenstruation: 23, durationMenstruation: 3",
      () {
        /*
        A = Start
        B = A with dosingPeriod
        C = B with fromMenstruation
        D = C with durationMenstruation
  30   31   1   2   3   4   5  
            A==>
   6    7   8   9  10  11  12  

  13   14  15  16  17  18  19  

  20   21  22  23  24  25  26  
       B       C==>    D==>               
  27   28  29  30
       
    */
        var pillSheetType = PillSheetType.pillsheet_28_7;
        var beginingDate = DateTime.parse("2020-09-01");
        var fromMenstruation = 23;
        var durationMenstruation = 3;
        var model = PillSheetModel(
          typeInfo: pillSheetType.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );
        var setting = Setting(
          pillSheetTypeRawPath: pillSheetType.rawPath,
          pillNumberForFromMenstruation: fromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: false,
          reminderTimes: [ReminderTime(hour: 1, minute: 1)],
        );
        assert(pillSheetType.dosingPeriod == 21,
            "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
        expect(
          scheduledMenstruationDateRange(model, setting, 0),
          DateRange(
            DateTime.parse("2020-09-23"),
            DateTime.parse("2020-09-25"),
          ),
        );
      },
    );
    test(
      "First page with pillSheetType: pillsheet_28_0, beginingDate: 2021-01-18, fromMenstruation: 23, durationMenstruation: 3",
      () {
        var pillSheetType = PillSheetType.pillsheet_28_0;
        var beginingDate = DateTime.parse("2021-01-18");
        var fromMenstruation = 23;
        var durationMenstruation = 3;
        var model = PillSheetModel(
          typeInfo: pillSheetType.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );
        var setting = Setting(
          pillSheetTypeRawPath: pillSheetType.rawPath,
          pillNumberForFromMenstruation: fromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: false,
          reminderTimes: [ReminderTime(hour: 1, minute: 1)],
        );
        assert(pillSheetType.dosingPeriod == 28,
            "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
        expect(
          scheduledMenstruationDateRange(model, setting, 0),
          DateRange(
            DateTime.parse("2021-02-09"),
            DateTime.parse("2021-02-11"),
          ),
        );
      },
    );
    test(
      "Second page with pillSheetType: pillsheet_28_7, beginingDate: 2020-09-01, fromMenstruation: 23, durationMenstruation: 3",
      () {
        var pillSheetType = PillSheetType.pillsheet_28_7;
        var beginingDate = DateTime.parse("2020-09-01");
        var fromMenstruation = 23;
        var durationMenstruation = 3;
        var model = PillSheetModel(
          typeInfo: pillSheetType.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );
        var setting = Setting(
          pillSheetTypeRawPath: pillSheetType.rawPath,
          pillNumberForFromMenstruation: fromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: false,
          reminderTimes: [ReminderTime(hour: 1, minute: 1)],
        );
        assert(pillSheetType.dosingPeriod == 21,
            "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
        expect(
          scheduledMenstruationDateRange(model, setting, 1),
          DateRange(
            DateTime.parse("2020-10-21"),
            DateTime.parse("2020-10-23"),
          ),
        );
      },
    );
    test(
      "Third page with pillSheetType: pillsheet_28_7, beginingDate: 2020-09-01, fromMenstruation: 23, durationMenstruation: 3",
      () {
        var pillSheetType = PillSheetType.pillsheet_28_7;
        var beginingDate = DateTime.parse("2020-09-01");
        var fromMenstruation = 23;
        var durationMenstruation = 3;
        var model = PillSheetModel(
          typeInfo: pillSheetType.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );
        var setting = Setting(
          pillSheetTypeRawPath: pillSheetType.rawPath,
          pillNumberForFromMenstruation: fromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: false,
          reminderTimes: [ReminderTime(hour: 1, minute: 1)],
        );
        assert(pillSheetType.dosingPeriod == 21,
            "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
        expect(
          scheduledMenstruationDateRange(model, setting, 2),
          DateRange(
            DateTime.parse("2020-11-18"),
            DateTime.parse("2020-11-20"),
          ),
        );
      },
    );
  });
  group("#nextPillSheetDateRange", () {
    test(
      "First page with pillSheetType: pillsheet_28_7, beginingDate: 2020-09-01",
      () {
        /*
        A = Current Pill Sheett Start
        B = Next Pill Sheet Start
        C = End of Next Pill Sheet Band
  30   31   1   2   3   4   5  
            A==>
   6    7   8   9  10  11  12  

  13   14  15  16  17  18  19  

  20   21  22  23  24  25  26  
       
  27   28  29  30   1   2   3
           B==>
   4    5   6   7   8   9  10
        C  
    */
        var pillSheetType = PillSheetType.pillsheet_28_7;
        var beginingDate = DateTime.parse("2020-09-01");
        var model = PillSheetModel(
          typeInfo: pillSheetType.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );
        expect(
          nextPillSheetDateRange(model, 0),
          DateRange(
            DateTime.parse("2020-09-29"),
            DateTime.parse("2020-10-05"),
          ),
        );
      },
    );
    test(
      "Second page with pillSheetType: pillsheet_28_7, beginingDate: 2020-09-01",
      () {
        var pillSheetType = PillSheetType.pillsheet_28_7;
        var beginingDate = DateTime.parse("2020-09-01");
        var model = PillSheetModel(
          typeInfo: pillSheetType.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );
        expect(
          nextPillSheetDateRange(model, 1),
          DateRange(
            DateTime.parse("2020-10-27"),
            DateTime.parse("2020-11-02"),
          ),
        );
      },
    );
    test(
      "Third page with pillSheetType: pillsheet_28_7, beginingDate: 2020-09-01",
      () {
        var pillSheetType = PillSheetType.pillsheet_28_7;
        var beginingDate = DateTime.parse("2020-09-01");
        var model = PillSheetModel(
          typeInfo: pillSheetType.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );
        expect(
          nextPillSheetDateRange(model, 2),
          DateRange(
            DateTime.parse("2020-11-24"),
            DateTime.parse("2020-11-30"),
          ),
        );
      },
    );
    test(
      "First page with pillSheetType: pillsheet_28_0(that means pill sheet is not exists not taken duration and totalCount == dosingPerod), beginingDate: 2020-09-01",
      () {
        /*
        A = Current Pill Sheett Start
        B = Next Pill Sheet Start
        C = End of Next Pill Sheet Band
  30   31   1   2   3   4   5  
            A==>
   6    7   8   9  10  11  12  

  13   14  15  16  17  18  19  

  20   21  22  23  24  25  26  
       
  27   28  29  30   1   2   3
           B==>
   4    5   6   7   8   9  10
        C  
    */
        var pillSheetType = PillSheetType.pillsheet_28_0;
        var beginingDate = DateTime.parse("2020-09-01");
        var model = PillSheetModel(
          typeInfo: pillSheetType.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );
        expect(
          nextPillSheetDateRange(model, 0),
          DateRange(
            DateTime.parse("2020-09-29"),
            DateTime.parse("2020-10-05"),
          ),
        );
      },
    );
  });
  group("#bandLength", () {
    test(
      "range: DateRange(2021-02-07, 2021-02-13), bandMode: (2021-02-10, 2021-02-13), isLineBreaked: false",
      () {
        expect(
            bandLength(
              DateRange(
                DateTime.parse("2021-02-07"),
                DateTime.parse("2021-02-13"),
              ),
              CalendarMenstruationBandModel(
                DateTime.parse("2021-02-10"),
                DateTime.parse("2021-02-13"),
              ),
              false,
            ),
            4);
      },
    );
    test(
      "range: DateRange(2021-02-14, 2021-02-20), bandMode: (2021-02-08, 2021-02-14), isLineBreaked: false",
      () {
        expect(
            bandLength(
              DateRange(
                DateTime.parse("2021-02-14"),
                DateTime.parse("2021-02-20"),
              ),
              CalendarMenstruationBandModel(
                DateTime.parse("2021-02-08"),
                DateTime.parse("2021-02-14"),
              ),
              true,
            ),
            1);
      },
    );
  });
}
