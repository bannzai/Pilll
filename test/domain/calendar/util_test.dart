import 'package:mockito/mockito.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/components/organisms/calendar/utility.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/service/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#scheduledOrInTheMiddleMenstruationDateRanges", () {
    group("only one pillSheet", () {
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
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now())
              .thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.today())
              .thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_7;
          var beginingDate = DateTime.parse("2020-09-01");
          var fromMenstruation = 23;
          var durationMenstruation = 3;
          var pillSheet = PillSheet(
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup =
              PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet]);
          var setting = Setting(
            pillSheetTypes: [pillSheetType],
            menstruations: [
              MenstruationSetting(
                  pillNumberForFromMenstruation: fromMenstruation,
                  durationMenstruation: durationMenstruation)
            ],
            isOnReminder: false,
            reminderTimes: [ReminderTime(hour: 1, minute: 1)],
          );
          assert(pillSheetType.dosingPeriod == 21,
              "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
          expect(
            scheduledOrInTheMiddleMenstruationDateRanges(
                pillSheetGroup, setting, [], 1),
            [
              DateRange(
                DateTime.parse("2020-09-23"),
                DateTime.parse("2020-09-25"),
              )
            ],
          );
        },
      );
      test(
        "Second page with pillSheetType: pillsheet_28_7, beginingDate: 2020-09-01, fromMenstruation: 23, durationMenstruation: 3",
        () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now())
              .thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.today())
              .thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_7;
          var beginingDate = DateTime.parse("2020-09-01");
          var fromMenstruation = 23;
          var durationMenstruation = 3;
          var pillSheet = PillSheet(
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup =
              PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet]);

          var setting = Setting(
            pillSheetTypes: [pillSheetType],
            menstruations: [
              MenstruationSetting(
                  pillNumberForFromMenstruation: fromMenstruation,
                  durationMenstruation: durationMenstruation)
            ],
            isOnReminder: false,
            reminderTimes: [ReminderTime(hour: 1, minute: 1)],
          );
          assert(pillSheetType.dosingPeriod == 21,
              "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
          expect(
            scheduledOrInTheMiddleMenstruationDateRanges(
                pillSheetGroup, setting, [], 2),
            [
              DateRange(
                DateTime.parse("2020-09-23"),
                DateTime.parse("2020-09-25"),
              ),
              DateRange(
                DateTime.parse("2020-10-21"),
                DateTime.parse("2020-10-23"),
              ),
            ],
          );
        },
      );
      test(
        "Third page with pillSheetType: pillsheet_28_7, beginingDate: 2020-09-01, fromMenstruation: 23, durationMenstruation: 3",
        () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now())
              .thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.today())
              .thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_7;
          var beginingDate = DateTime.parse("2020-09-01");
          var fromMenstruation = 23;
          var durationMenstruation = 3;
          var pillSheet = PillSheet(
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup =
              PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet]);
          var setting = Setting(
            pillSheetTypes: [pillSheetType],
            menstruations: [
              MenstruationSetting(
                  pillNumberForFromMenstruation: fromMenstruation,
                  durationMenstruation: durationMenstruation)
            ],
            isOnReminder: false,
            reminderTimes: [ReminderTime(hour: 1, minute: 1)],
          );
          assert(pillSheetType.dosingPeriod == 21,
              "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
          expect(
            scheduledOrInTheMiddleMenstruationDateRanges(
                pillSheetGroup, setting, [], 3),
            [
              DateRange(
                DateTime.parse("2020-09-23"),
                DateTime.parse("2020-09-25"),
              ),
              DateRange(
                DateTime.parse("2020-10-21"),
                DateTime.parse("2020-10-23"),
              ),
              DateRange(
                DateTime.parse("2020-11-18"),
                DateTime.parse("2020-11-20"),
              )
            ],
          );
        },
      );
      test(
        "First page with pillSheetType: pillsheet_28_0, beginingDate: 2021-01-18, fromMenstruation: 23, durationMenstruation: 3",
        () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now())
              .thenReturn(DateTime.parse("2021-01-18"));
          when(mockTodayRepository.today())
              .thenReturn(DateTime.parse("2021-01-18"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_0;
          var beginingDate = DateTime.parse("2021-01-18");
          var fromMenstruation = 23;
          var durationMenstruation = 3;
          var pillSheet = PillSheet(
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup =
              PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet]);
          var setting = Setting(
            pillSheetTypes: [pillSheetType],
            menstruations: [
              MenstruationSetting(
                  pillNumberForFromMenstruation: fromMenstruation,
                  durationMenstruation: durationMenstruation)
            ],
            isOnReminder: false,
            reminderTimes: [ReminderTime(hour: 1, minute: 1)],
          );
          assert(pillSheetType.dosingPeriod == 28,
              "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
          expect(
            scheduledOrInTheMiddleMenstruationDateRanges(
                pillSheetGroup, setting, [], 1),
            [
              DateRange(
                DateTime.parse("2021-02-09"),
                DateTime.parse("2021-02-11"),
              )
            ],
          );
        },
      );
    });

    group("pillSheetGroup has 3 pilSheet", () {
      /*
        A = Start
        B = A with dosingPeriod
        C = B with fromMenstruation
        D = C with durationMenstruation
  08/30   08/31   09/01   09/02   09/03   09/04   09/05  
                   A==>
  09/06   09/07   09/08   09/09   09/10   09/11   09/12  

  09/13   09/14   09/15   09/16   09/17   09/18   09/19  

  09/20   09/21   09/22   09/23   09/24   09/25   09/26  
            B              C==>           D==>               
  09/27   09/28   09/29   09/30   10/01   10/02   10/03
  
  10/04   10/05   10/06   10/07   10/08   10/09   10/10
       
  10/11   10/12   10/13   10/14   10/15   10/16   10/17

  10/18   10/19   10/20   10/21   10/22   10/23   10/24

  10/25   10/26   10/27   10/28   10/29   10/30   10/31

  11/01   11/02   11/03   11/04   11/05   11/06   11/07
       
  11/08   11/09   11/10   11/11   11/12   11/13   11/14

  11/15   11/16   11/17   11/18   11/19   11/20   11/21

  11/22   11/23   11/24   11/25   11/26   11/27   11/28

  11/29   11/30   12/01   12/02   12/03   12/04   12/05
    */
      final originalTodayRepository = todayRepository;
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
      when(mockTodayRepository.today())
          .thenReturn(DateTime.parse("2020-09-01"));
      addTearDown(() {
        todayRepository = originalTodayRepository;
      });

      var pillSheetType = PillSheetType.pillsheet_28_7;
      var beginingDate = DateTime.parse("2020-09-01");
      var fromMenstruation = 23;
      var durationMenstruation = 3;
      var pillSheet = PillSheet(
        typeInfo: pillSheetType.typeInfo,
        beginingDate: beginingDate,
        lastTakenDate: null,
      );
      final pillSheetGroup =
          PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet]);
      var setting = Setting(
        pillSheetTypes: [pillSheetType],
        menstruations: [
          MenstruationSetting(
              pillNumberForFromMenstruation: fromMenstruation,
              durationMenstruation: durationMenstruation)
        ],
        isOnReminder: false,
        reminderTimes: [ReminderTime(hour: 1, minute: 1)],
      );
      assert(pillSheetType.dosingPeriod == 21,
          "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
      expect(
        scheduledOrInTheMiddleMenstruationDateRanges(
            pillSheetGroup, setting, [], 1),
        [
          DateRange(
            DateTime.parse("2020-09-23"),
            DateTime.parse("2020-09-25"),
          )
        ],
      );
    });
  });
  group("#nextPillSheetDateRanges", () {
    group("only one pillSheet", () {
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

          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now())
              .thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.today())
              .thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_7;
          var beginingDate = DateTime.parse("2020-09-01");
          var pillSheet = PillSheet(
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup =
              PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet]);
          expect(
            nextPillSheetDateRanges(pillSheetGroup, 1),
            [
              DateRange(
                DateTime.parse("2020-09-29"),
                DateTime.parse("2020-10-05"),
              ),
            ],
          );
        },
      );
      test(
        "Second page with pillSheetType: pillsheet_28_7, beginingDate: 2020-09-01",
        () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now())
              .thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.today())
              .thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_7;
          var beginingDate = DateTime.parse("2020-09-01");
          var pillSheet = PillSheet(
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup =
              PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet]);
          expect(
            nextPillSheetDateRanges(pillSheetGroup, 2),
            [
              DateRange(
                DateTime.parse("2020-09-29"),
                DateTime.parse("2020-10-05"),
              ),
              DateRange(
                DateTime.parse("2020-10-27"),
                DateTime.parse("2020-11-02"),
              ),
            ],
          );
        },
      );
      test(
        "Third page with pillSheetType: pillsheet_28_7, beginingDate: 2020-09-01",
        () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now())
              .thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.today())
              .thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_7;
          var beginingDate = DateTime.parse("2020-09-01");
          var pillSheet = PillSheet(
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup =
              PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet]);
          expect(
            nextPillSheetDateRanges(pillSheetGroup, 3),
            [
              DateRange(
                DateTime.parse("2020-09-29"),
                DateTime.parse("2020-10-05"),
              ),
              DateRange(
                DateTime.parse("2020-10-27"),
                DateTime.parse("2020-11-02"),
              ),
              DateRange(
                DateTime.parse("2020-11-24"),
                DateTime.parse("2020-11-30"),
              ),
            ],
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
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now())
              .thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.today())
              .thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_0;
          var beginingDate = DateTime.parse("2020-09-01");
          var pillSheet = PillSheet(
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup =
              PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet]);
          expect(
            nextPillSheetDateRanges(pillSheetGroup, 1),
            [
              DateRange(
                DateTime.parse("2020-09-29"),
                DateTime.parse("2020-10-05"),
              )
            ],
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
                CalendarScheduledMenstruationBandModel(
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
                CalendarScheduledMenstruationBandModel(
                  DateTime.parse("2021-02-08"),
                  DateTime.parse("2021-02-14"),
                ),
                true,
              ),
              1);
        },
      );
    });
  });
}
