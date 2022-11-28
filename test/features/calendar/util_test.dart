import 'package:mockito/mockito.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_function.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#scheduledOrInTheMiddleMenstruationDateRanges", () {
    group("multiple pill sheet pattern", () {
      test(
        "pillSheetType: [pillsheet_28_7, pillsheet_24_0], beginingDate: [2020-09-01, 2020-09-29], fromMenstruation: 23, durationMenstruation: 3",
        () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var beginingDate = DateTime.parse("2020-09-01");
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          var pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: PillSheetType.pillsheet_24_0.typeInfo,
            beginingDate: beginingDate.add(const Duration(days: 28)),
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1", "2"],
            pillSheets: [pillSheet, pillSheet2],
            createdAt: now(),
          );
          var setting = const Setting(
            pillSheetTypes: [PillSheetType.pillsheet_28_7, PillSheetType.pillsheet_24_0],
            pillNumberForFromMenstruation: 23,
            durationMenstruation: 3,
            isOnReminder: false,
            reminderTimes: [ReminderTime(hour: 1, minute: 1)],
            timezoneDatabaseName: null,
          );
          expect(
            scheduledOrInTheMiddleMenstruationDateRanges(pillSheetGroup, setting, [], 2),
            [
              DateRange(
                DateTime.parse("2020-09-23"),
                DateTime.parse("2020-09-25"),
              ),
              DateRange(
                DateTime.parse("2020-10-21"),
                DateTime.parse("2020-10-23"),
              )
            ],
          );
        },
      );
      test(
        "it check to ignore date range for pillSheetType.totalCount > setting.pillNumberFromMenstruation. pillSheetType: [pillsheet_28_7, pillsheet_21_0], beginingDate: [2020-09-01, 2020-09-29], fromMenstruation: 23, durationMenstruation: 3",
        () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var beginingDate = DateTime.parse("2020-09-01");
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          var pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
            beginingDate: beginingDate.add(const Duration(days: 28)),
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1", "2"],
            pillSheets: [pillSheet, pillSheet2],
            createdAt: now(),
          );
          var setting = const Setting(
            pillSheetTypes: [PillSheetType.pillsheet_28_7, PillSheetType.pillsheet_21_0],
            pillNumberForFromMenstruation: 23,
            durationMenstruation: 3,
            isOnReminder: false,
            reminderTimes: [ReminderTime(hour: 1, minute: 1)],
            timezoneDatabaseName: null,
          );
          expect(
            scheduledOrInTheMiddleMenstruationDateRanges(pillSheetGroup, setting, [], 2),
            [
              DateRange(
                DateTime.parse("2020-09-23"),
                DateTime.parse("2020-09-25"),
              ),
              DateRange(
                DateTime.parse("2020-11-11"),
                DateTime.parse("2020-11-13"),
              )
            ],
          );
        },
      );
      test(
        "over 1 pill sheet group period",
        () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var beginingDate = DateTime.parse("2020-09-01");
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          var pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: PillSheetType.pillsheet_24_0.typeInfo,
            beginingDate: beginingDate.add(const Duration(days: 28)),
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1", "2"],
            pillSheets: [pillSheet, pillSheet2],
            createdAt: now(),
          );
          var setting = const Setting(
            pillSheetTypes: [PillSheetType.pillsheet_28_7, PillSheetType.pillsheet_24_0],
            pillNumberForFromMenstruation: 23,
            durationMenstruation: 3,
            isOnReminder: false,
            reminderTimes: [ReminderTime(hour: 1, minute: 1)],
            timezoneDatabaseName: null,
          );
          expect(
            scheduledOrInTheMiddleMenstruationDateRanges(pillSheetGroup, setting, [], 4),
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
                DateTime.parse("2020-11-14"),
                DateTime.parse("2020-11-16"),
              ),
              DateRange(
                DateTime.parse("2020-12-12"),
                DateTime.parse("2020-12-14"),
              ),
            ],
          );
        },
      );
    });
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
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_7;
          var beginingDate = DateTime.parse("2020-09-01");
          var fromMenstruation = 23;
          var durationMenstruation = 3;
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());
          var setting = Setting(
            pillSheetTypes: [pillSheetType],
            pillNumberForFromMenstruation: fromMenstruation,
            durationMenstruation: durationMenstruation,
            isOnReminder: false,
            reminderTimes: [const ReminderTime(hour: 1, minute: 1)],
            timezoneDatabaseName: null,
          );
          assert(pillSheetType.dosingPeriod == 21,
              "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
          expect(
            scheduledOrInTheMiddleMenstruationDateRanges(pillSheetGroup, setting, [], 1),
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
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_7;
          var beginingDate = DateTime.parse("2020-09-01");
          var fromMenstruation = 23;
          var durationMenstruation = 3;
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          var setting = Setting(
            pillSheetTypes: [pillSheetType],
            pillNumberForFromMenstruation: fromMenstruation,
            durationMenstruation: durationMenstruation,
            isOnReminder: false,
            reminderTimes: [const ReminderTime(hour: 1, minute: 1)],
            timezoneDatabaseName: null,
          );
          assert(pillSheetType.dosingPeriod == 21,
              "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
          expect(
            scheduledOrInTheMiddleMenstruationDateRanges(pillSheetGroup, setting, [], 2),
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
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_7;
          var beginingDate = DateTime.parse("2020-09-01");
          var fromMenstruation = 23;
          var durationMenstruation = 3;
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());
          var setting = Setting(
            pillSheetTypes: [pillSheetType],
            pillNumberForFromMenstruation: fromMenstruation,
            durationMenstruation: durationMenstruation,
            isOnReminder: false,
            reminderTimes: [const ReminderTime(hour: 1, minute: 1)],
            timezoneDatabaseName: null,
          );
          assert(pillSheetType.dosingPeriod == 21,
              "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
          expect(
            scheduledOrInTheMiddleMenstruationDateRanges(pillSheetGroup, setting, [], 3),
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
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2021-01-18"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2021-01-18"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_0;
          var beginingDate = DateTime.parse("2021-01-18");
          var fromMenstruation = 23;
          var durationMenstruation = 3;
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());
          var setting = Setting(
            pillSheetTypes: [pillSheetType],
            pillNumberForFromMenstruation: fromMenstruation,
            durationMenstruation: durationMenstruation,
            isOnReminder: false,
            reminderTimes: [const ReminderTime(hour: 1, minute: 1)],
            timezoneDatabaseName: null,
          );
          assert(pillSheetType.dosingPeriod == 28,
              "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
          expect(
            scheduledOrInTheMiddleMenstruationDateRanges(pillSheetGroup, setting, [], 1),
            [
              DateRange(
                DateTime.parse("2021-02-09"),
                DateTime.parse("2021-02-11"),
              )
            ],
          );
        },
      );
      test(
        "over 1 pill sheet gropu period",
        () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2021-01-01"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2021-01-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_0;
          var beginingDate = DateTime.parse("2021-01-01");
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());
          var setting = Setting(
            pillSheetTypes: [pillSheetType],
            pillNumberForFromMenstruation: 23,
            durationMenstruation: 3,
            isOnReminder: false,
            reminderTimes: [const ReminderTime(hour: 1, minute: 1)],
            timezoneDatabaseName: null,
          );
          expect(
            scheduledOrInTheMiddleMenstruationDateRanges(pillSheetGroup, setting, [], 3),
            [
              DateRange(
                DateTime.parse("2021-01-23"),
                DateTime.parse("2021-01-25"),
              ),
              DateRange(
                DateTime.parse("2021-02-20"),
                DateTime.parse("2021-02-22"),
              ),
              DateRange(
                DateTime.parse("2021-03-20"),
                DateTime.parse("2021-03-22"),
              ),
            ],
          );
        },
      );
      test(
        "setting.pillNumberForFromMenstruation is zero",
        () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2021-01-18"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2021-01-18"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_0;
          var beginingDate = DateTime.parse("2021-01-18");
          var durationMenstruation = 3;
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());
          var setting = Setting(
            pillSheetTypes: [pillSheetType],
            pillNumberForFromMenstruation: 0,
            durationMenstruation: durationMenstruation,
            isOnReminder: false,
            reminderTimes: [const ReminderTime(hour: 1, minute: 1)],
            timezoneDatabaseName: null,
          );
          assert(pillSheetType.dosingPeriod == 28,
              "scheduledMenstruationDateRange adding value with dosingPeriod when it will create DateRange. pillsheet_28_7 type has 24 dosingPeriod");
          expect(
            scheduledOrInTheMiddleMenstruationDateRanges(pillSheetGroup, setting, [], 1),
            [],
          );
        },
      );
    });
  });
  group("#nextPillSheetDateRanges", () {
    group("multiple pillSheet pattern", () {
      test(
        "First page with pillSheetTypes: [pillsheet_28_7, pillsheet_21_0], beginingDate: [2020-09-01, 2020-09-29]",
        () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var beginingDate = DateTime.parse("2020-09-01");
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          var pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
            beginingDate: beginingDate.add(const Duration(days: 28)),
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1", "2"],
            pillSheets: [pillSheet, pillSheet2],
            createdAt: now(),
          );
          expect(
            nextPillSheetDateRanges(pillSheetGroup, 2),
            [
              DateRange(
                DateTime.parse("2020-09-29"),
                DateTime.parse("2020-10-05"),
              ),
              DateRange(
                DateTime.parse("2020-10-20"),
                DateTime.parse("2020-10-26"),
              ),
            ],
          );
        },
      );
    });
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
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_7;
          var beginingDate = DateTime.parse("2020-09-01");
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());
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
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_7;
          var beginingDate = DateTime.parse("2020-09-01");
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());
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
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_7;
          var beginingDate = DateTime.parse("2020-09-01");
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());
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
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          var pillSheetType = PillSheetType.pillsheet_28_0;
          var beginingDate = DateTime.parse("2020-09-01");
          var pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: pillSheetType.typeInfo,
            beginingDate: beginingDate,
            lastTakenDate: null,
          );
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());
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
}
