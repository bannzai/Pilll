import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/util/today.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("today: 2020-09-19, begin: 2020-09-14, end: 2020-09-18", () {
    var sheetType = PillSheetType.pillsheet_21;
    var model = PillSheetModel(
      beginingDate: DateTime.parse("2020-09-14"),
      lastTakenDate: DateTime.parse("2020-09-18"),
      typeInfo: PillSheetTypeInfo(
        dosingPeriod: sheetType.dosingPeriod,
        totalCount: sheetType.totalCount,
        pillSheetTypeReferencePath: sheetType.rawPath,
      ),
      todayBuilder: () => DateTime.parse("2020-09-19"),
    );
    test("#todayPillNumber", () {
      expect(model.todayPillNumber, 6);
    });
  });
  group("boundary value tests", () {
    group("today: 2020-09-28, begin: 2020-09-01, end: 2020-09-28", () {
      var sheetType = PillSheetType.pillsheet_21;
      var model = PillSheetModel(
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-28"),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        todayBuilder: () => DateTime.parse("2020-09-28"),
      );
      test("#todayPillNumber", () {
        expect(model.todayPillNumber, 28);
      });
    });
    group("today: 2020-09-29, begin: 2020-09-01, end: 2020-09-28", () {
      var sheetType = PillSheetType.pillsheet_21;
      var model = PillSheetModel(
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-28"),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        todayBuilder: () => DateTime.parse("2020-09-29"),
      );
      test("#todayPillNumber", () {
        expect(model.todayPillNumber, 1);
      });
    });
    group("today: 2020-10-27, begin: 2020-09-01, end: 2020-09-28", () {
      var sheetType = PillSheetType.pillsheet_21;
      var model = PillSheetModel(
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-28"),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        todayBuilder: () => DateTime.parse("2020-10-27"),
      );
      test("#todayPillNumber", () {
        expect(model.todayPillNumber, 1);
      });
    });
  });
}
