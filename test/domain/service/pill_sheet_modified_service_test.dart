import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_modified_history.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#createTakenPillAction", () {
    test("group has only one pill sheet and it is not yet taken", () async {
      final _today = DateTime.parse("2020-09-19");

      final before = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: null,
      );
      final after = before.copyWith(
        lastTakenDate: DateTime.parse("2020-09-20"),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          after,
        ],
        createdAt: now(),
      );

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: before,
        after: after,
        pillSheetGroup: pillSheetGroup,
      );

      expect(history.enumActionType, PillSheetModifiedActionType.takenPill);
      expect(history.value.takenPill, isNotNull);
      expect(history.value.takenPill?.differencePillCount, 2);
      expect(history.value.takenPill?.beforeLastTakenPillNumber, 0);
      expect(history.value.takenPill?.afterLastTakenPillNumber, 2);
    });
    test("group has only one pill sheet and it is increment pattern", () async {
      final _today = DateTime.parse("2020-09-19");

      final before = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: DateTime.parse("2020-09-19"),
      );
      final after = before.copyWith(
        lastTakenDate: DateTime.parse("2020-09-21"),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          after,
        ],
        createdAt: now(),
      );

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: before,
        after: after,
        pillSheetGroup: pillSheetGroup,
      );

      expect(history.enumActionType, PillSheetModifiedActionType.takenPill);
      expect(history.value.takenPill, isNotNull);
      expect(history.value.takenPill?.differencePillCount, 2);
      expect(history.value.takenPill?.beforeLastTakenPillNumber, 1);
      expect(history.value.takenPill?.afterLastTakenPillNumber, 3);
    });
    test("group has two pill sheets", () async {
      final _today = DateTime.parse("2020-09-01");

      final before = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: DateTime.parse("2020-09-24"),
      );
      final after = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: DateTime.parse("2020-09-29"),
        groupIndex: 1,
        lastTakenDate: DateTime.parse("2020-09-30"),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          after,
        ],
        createdAt: now(),
      );

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: "group_id",
        before: before,
        after: after,
        pillSheetGroup: pillSheetGroup,
      );

      expect(history.enumActionType, PillSheetModifiedActionType.takenPill);
      expect(history.value.takenPill, isNotNull);
      expect(history.value.takenPill?.differencePillCount, 7);
      expect(history.value.takenPill?.beforeLastTakenPillNumber, 24);
      expect(history.value.takenPill?.afterLastTakenPillNumber, 2);
    });
  });
}
