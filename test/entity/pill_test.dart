import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  group("#generateAndFillTo", () {
    group("pillTakenCount = 1", () {
      test("lastTakenDate is null", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        final actual = Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: now(), lastTakenDate: null, pillTakenCount: 1);
        final expected = [
          for (var i = 0; i < PillSheetType.pillsheet_21.totalCount; i++)
            Pill(index: i, createdDateTime: now(), updatedDateTime: now(), pillTakens: []),
        ];
        expect(actual, expected);
      });
      test("lastTakenDate is before beginDate", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        final actual = Pill.generateAndFillTo(
            pillSheetType: PillSheetType.pillsheet_21, fromDate: now(), lastTakenDate: DateTime.parse("2020-09-18"), pillTakenCount: 1);
        final expected = [
          for (var i = 0; i < PillSheetType.pillsheet_21.totalCount; i++)
            Pill(index: i, createdDateTime: now(), updatedDateTime: now(), pillTakens: []),
        ];
        expect(actual, expected);
      });
      test("lastTakenDate is today", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        final actual = Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: now(), lastTakenDate: today(), pillTakenCount: 1);
        final expected = [
          Pill(
            index: 0,
            createdDateTime: now(),
            updatedDateTime: now(),
            pillTakens: [
              PillTaken(takenDateTime: today(), createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false),
            ],
          ),
          for (var i = 1; i < PillSheetType.pillsheet_21.totalCount; i++)
            Pill(index: i, createdDateTime: now(), updatedDateTime: now(), pillTakens: []),
        ];
        expect(actual, expected);
      });
      test("lastTakenDate is estimatedLastTakenDate - 1 day", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        final lastTakenDate = today().add(Duration(days: PillSheetType.pillsheet_21.totalCount - 1 - 1));
        final actual = Pill.generateAndFillTo(
          pillSheetType: PillSheetType.pillsheet_21,
          fromDate: now(),
          lastTakenDate: lastTakenDate,
          pillTakenCount: 1,
        );
        final expected = [
          for (var i = 0; i < PillSheetType.pillsheet_21.totalCount - 1; i++)
            Pill(
              index: i,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [
                PillTaken(takenDateTime: lastTakenDate, createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false),
              ],
            ),
          Pill(
            index: PillSheetType.pillsheet_21.totalCount - 1,
            createdDateTime: now(),
            updatedDateTime: now(),
            pillTakens: [],
          ),
        ];
        expect(actual, expected);
      });
      test("lastTakenDate is estimatedLastTakenDate", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        final lastTakenDate = today().add(Duration(days: PillSheetType.pillsheet_21.totalCount - 1));
        final actual = Pill.generateAndFillTo(
          pillSheetType: PillSheetType.pillsheet_21,
          fromDate: now(),
          lastTakenDate: lastTakenDate,
          pillTakenCount: 1,
        );
        final expected = [
          for (var i = 0; i < PillSheetType.pillsheet_21.totalCount; i++)
            Pill(
              index: i,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [
                PillTaken(takenDateTime: lastTakenDate, createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false),
              ],
            ),
        ];
        expect(actual, expected);
      });
    });
    group("pillTakenCount = 2", () {
      test("lastTakenDate is null", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        final actual = Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: now(), lastTakenDate: null, pillTakenCount: 2);
        final expected = [
          for (var i = 0; i < PillSheetType.pillsheet_21.totalCount; i++)
            Pill(index: i, createdDateTime: now(), updatedDateTime: now(), pillTakens: []),
        ];
        expect(actual, expected);
      });
      test("lastTakenDate is before beginDate", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        final actual = Pill.generateAndFillTo(
            pillSheetType: PillSheetType.pillsheet_21, fromDate: now(), lastTakenDate: DateTime.parse("2020-09-18"), pillTakenCount: 2);
        final expected = [
          for (var i = 0; i < PillSheetType.pillsheet_21.totalCount; i++)
            Pill(index: i, createdDateTime: now(), updatedDateTime: now(), pillTakens: []),
        ];
        expect(actual, expected);
      });
      test("lastTakenDate is today", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        final actual = Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: now(), lastTakenDate: today(), pillTakenCount: 2);
        final expected = [
          Pill(
            index: 0,
            createdDateTime: now(),
            updatedDateTime: now(),
            pillTakens: [
              PillTaken(takenDateTime: today(), createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false),
            ],
          ),
          for (var i = 1; i < PillSheetType.pillsheet_21.totalCount; i++)
            Pill(index: i, createdDateTime: now(), updatedDateTime: now(), pillTakens: []),
        ];
        expect(actual, expected);
      });
      test("lastTakenDate is estimatedLastTakenDate - 1 day", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        final lastTakenDate = today().add(Duration(days: PillSheetType.pillsheet_21.totalCount - 1 - 1));
        final actual = Pill.generateAndFillTo(
          pillSheetType: PillSheetType.pillsheet_21,
          fromDate: now(),
          lastTakenDate: lastTakenDate,
          pillTakenCount: 2,
        );
        final expected = [
          for (var i = 0; i < PillSheetType.pillsheet_21.totalCount - 1; i++)
            Pill(
              index: i,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [
                PillTaken(takenDateTime: lastTakenDate, createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false),
              ],
            ),
          Pill(
            index: PillSheetType.pillsheet_21.totalCount - 1,
            createdDateTime: now(),
            updatedDateTime: now(),
            pillTakens: [],
          ),
        ];
        expect(actual, expected);
      });
      test("lastTakenDate is estimatedLastTakenDate", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        final lastTakenDate = today().add(Duration(days: PillSheetType.pillsheet_21.totalCount - 1));
        final actual = Pill.generateAndFillTo(
          pillSheetType: PillSheetType.pillsheet_21,
          fromDate: now(),
          lastTakenDate: lastTakenDate,
          pillTakenCount: 2,
        );
        final expected = [
          for (var i = 0; i < PillSheetType.pillsheet_21.totalCount; i++)
            Pill(
              index: i,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [
                PillTaken(takenDateTime: lastTakenDate, createdDateTime: now(), updatedDateTime: now(), isAutomaticallyRecorded: false),
              ],
            ),
        ];
        expect(actual, expected);
      });
    });
  });
}
