import 'package:Pilll/main/calendar/date_range.dart';
import 'package:Pilll/main/calendar/utility.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/setting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("#menstruationDateRange", () {
    test(
      "First page with pillSheetType: pillsheet_28_4, beginingDate: 2020-09-01, fromMenstruation: 2, durationMenstruation: 3",
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
       B==>    C==>    D==>
  27   28  29  30
    */
        var pillSheetType = PillSheetType.pillsheet_28_4;
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
        assert(pillSheetType.dosingPeriod != 21,
            "menstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_4 type has 21 dosingPeriod");
        expect(
          menstruationDateRange(model, setting, 0),
          DateRange(
            DateTime.parse("2020-09-22"),
            DateTime.parse("2020-09-25"),
          ),
        );
      },
    );
  });
}
