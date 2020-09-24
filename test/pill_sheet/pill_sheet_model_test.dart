import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/util/today.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  PillSheetType sheetType;
  DateTime beginingDate;
  DateTime lastTakenDate;

  PillSheetModel model;
  setUp(() {
    model = PillSheetModel(
      beginingDate: beginingDate,
      lastTakenDate: lastTakenDate,
      typeInfo: PillSheetTypeInfo(
        dosingPeriod: sheetType.dosingPeriod,
        totalCount: sheetType.totalCount,
        pillSheetTypeReferencePath: sheetType.rawPath,
      ),
    );
  });

  group("today: 2020-09-19, begin: 2020-09-14, end: 2020-09-18", () {
    sheetType = PillSheetType.pillsheet_21;
    beginingDate = DateTime.parse("2020-09-14");
    lastTakenDate = DateTime.parse("2020-09-18");
    injectToday(() {
      return DateTime.parse("2020-09-19");
    });
    test("#todayPillNumber", () {
      expect(model.todayPillNumber, 6);
    });
  });
}
