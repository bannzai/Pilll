import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/service/today.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helper/mock.dart';

void main() {
  group("#todayPillNumber", () {
    test("today: 2020-09-19, begin: 2020-09-14, end: 2020-09-18", () {
      var mockTodayRepository = MockTodayRepository();
      todayRepository = mockTodayRepository;
      when(todayRepository.today()).thenReturn(DateTime.parse("2020-09-19"));

      var sheetType = PillSheetType.pillsheet_21;
      var model = PillSheetModel(
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-18"),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillNumber, 6);
    });
    test("today: 2020-09-28, begin: 2020-09-01, end: 2020-09-28", () {
      var mockTodayRepository = MockTodayRepository();
      todayRepository = mockTodayRepository;
      when(todayRepository.today()).thenReturn(DateTime.parse("2020-09-28"));

      var sheetType = PillSheetType.pillsheet_21;
      var model = PillSheetModel(
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-28"),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillNumber, 28);
    });
    test("today: 2020-09-29, begin: 2020-09-01, end: 2020-09-28", () {
      var mockTodayRepository = MockTodayRepository();
      todayRepository = mockTodayRepository;
      when(todayRepository.today()).thenReturn(DateTime.parse("2020-09-29"));

      var sheetType = PillSheetType.pillsheet_21;
      var model = PillSheetModel(
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-28"),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillNumber, 1);
    });
    test("today: 2020-10-27, begin: 2020-09-01, end: 2020-09-28", () {
      var mockTodayRepository = MockTodayRepository();
      todayRepository = mockTodayRepository;
      when(todayRepository.today()).thenReturn(DateTime.parse("2020-10-27"));

      var sheetType = PillSheetType.pillsheet_21;
      var model = PillSheetModel(
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-28"),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillNumber, 1);
    });
  });

  group("#resetTodayTakenPillNumber", () {
    test("pass before pill number for today", () {
      var mockTodayRepository = MockTodayRepository();
      todayRepository = mockTodayRepository;
      when(todayRepository.today()).thenReturn(DateTime.parse("2020-09-28"));

      var sheetType = PillSheetType.pillsheet_21;
      var model = PillSheetModel(
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-28"),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillNumber, 15);
      model.resetTodayTakenPillNumber(14);
      expect(model.beginingDate, DateTime.parse("2020-09-13"));
    });
    test("pass after pill number for today", () {
      var mockTodayRepository = MockTodayRepository();
      todayRepository = mockTodayRepository;
      when(todayRepository.today()).thenReturn(DateTime.parse("2020-09-28"));

      var sheetType = PillSheetType.pillsheet_21;
      var model = PillSheetModel(
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-28"),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillNumber, 15);
      model.resetTodayTakenPillNumber(16);
      expect(model.beginingDate, DateTime.parse("2020-09-15"));
    });
    test("pass same pill number as today", () {
      var mockTodayRepository = MockTodayRepository();
      todayRepository = mockTodayRepository;
      when(todayRepository.today()).thenReturn(DateTime.parse("2020-09-28"));

      var sheetType = PillSheetType.pillsheet_21;
      var model = PillSheetModel(
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-28"),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillNumber, 15);
      model.resetTodayTakenPillNumber(15);
      expect(model.beginingDate, DateTime.parse("2020-09-14"));
    });
  });
}
