import 'package:pilll/domain/record/components/pill_sheet/record_page_pill_sheet.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#RecordPagePillSheet.isContainedMenstruationDuration", () {
    test("group has only one pill sheet", () async {
      final anyDate = DateTime.parse("2020-09-19");
      final pillSheet = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 0,
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1"],
        pillSheets: [pillSheet],
        createdAt: anyDate,
      );
      final setting = Setting(
        pillSheetTypes: [PillSheetType.pillsheet_28_0],
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
      );
      final pageIndex = 0;

      for (int i = 1; i <= 28; i++) {
        expect(
            RecordPagePillSheet.isContainedMenstruationDuration(
                pillNumberIntoPillSheet: i,
                pillSheetGroup: pillSheetGroup,
                pageIndex: pageIndex,
                setting: setting),
            22 <= i && i <= 24,
            reason: "print debug informations pillNumberIntoPillSheet is $i");
      }
    });
    test(
        "group has three pill sheet and scheduled menstruation begin No.2 pillSheet",
        () async {
      final anyDate = DateTime.parse("2020-09-19");
      final one = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 0,
      );
      final two = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 1,
      );
      final three = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 2,
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1", "2", "3"],
        pillSheets: [one, two, three],
        createdAt: anyDate,
      );
      final setting = Setting(
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0
        ],
        pillNumberForFromMenstruation: 46,
        durationMenstruation: 3,
        isOnReminder: true,
      );
      final pageIndex = 0;

      final totalCount = [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0
      ].map((e) => e.totalCount).reduce((value, element) => value + element);

      for (int i = 1; i <= totalCount; i++) {
        expect(
            RecordPagePillSheet.isContainedMenstruationDuration(
                pillNumberIntoPillSheet: i,
                pillSheetGroup: pillSheetGroup,
                pageIndex: pageIndex,
                setting: setting),
            46 <= i && i <= 48,
            reason: "print debug informations pillNumberIntoPillSheet is $i");
      }
    });
  });
}
