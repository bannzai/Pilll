import 'package:Pilll/main/calendar/date_range.dart';
import 'package:Pilll/main/calendar/utility.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/setting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("#menstruationDateRange", () {
    test(
      "First page with pillSheetType: pillsheet_28_7, beginingDate: 2020-09-01, fromMenstruation: 2, durationMenstruation: 3",
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
        var fromMenstruation = 2;
        var durationMenstruation = 3;
        var model = PillSheetModel(
          typeInfo: pillSheetType.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );
        var setting = Setting(
          pillSheetTypeRawPath: pillSheetType.rawPath,
          fromMenstruation: fromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: false,
          reminderTime: ReminderTime(hour: 1, minute: 1),
        );
        assert(pillSheetType.dosingPeriod == 21,
            "menstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
        expect(
          menstruationDateRange(model, setting, 0),
          DateRange(
            DateTime.parse("2020-09-23"),
            DateTime.parse("2020-09-25"),
          ),
        );
      },
    );
    test(
      "Second page with pillSheetType: pillsheet_28_7, beginingDate: 2020-09-01, fromMenstruation: 2, durationMenstruation: 3",
      () {
        var pillSheetType = PillSheetType.pillsheet_28_7;
        var beginingDate = DateTime.parse("2020-09-01");
        var fromMenstruation = 2;
        var durationMenstruation = 3;
        var model = PillSheetModel(
          typeInfo: pillSheetType.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );
        var setting = Setting(
          pillSheetTypeRawPath: pillSheetType.rawPath,
          fromMenstruation: fromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: false,
          reminderTime: ReminderTime(hour: 1, minute: 1),
        );
        assert(pillSheetType.dosingPeriod == 21,
            "menstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
        expect(
          menstruationDateRange(model, setting, 1),
          DateRange(
            DateTime.parse("2020-10-21"),
            DateTime.parse("2020-10-23"),
          ),
        );
      },
    );
    test(
      "Third page with pillSheetType: pillsheet_28_7, beginingDate: 2020-09-01, fromMenstruation: 2, durationMenstruation: 3",
      () {
        var pillSheetType = PillSheetType.pillsheet_28_7;
        var beginingDate = DateTime.parse("2020-09-01");
        var fromMenstruation = 2;
        var durationMenstruation = 3;
        var model = PillSheetModel(
          typeInfo: pillSheetType.typeInfo,
          beginingDate: beginingDate,
          lastTakenDate: null,
        );
        var setting = Setting(
          pillSheetTypeRawPath: pillSheetType.rawPath,
          fromMenstruation: fromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: false,
          reminderTime: ReminderTime(hour: 1, minute: 1),
        );
        assert(pillSheetType.dosingPeriod == 21,
            "menstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
        expect(
          menstruationDateRange(model, setting, 2),
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
  });
}
