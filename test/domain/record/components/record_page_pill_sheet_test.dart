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
  });
}
