import 'package:pilll/features/record/components/add_pill_sheet_group/provider.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#register", () {
    test("group has only one pill sheet", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: null,
      );
      final batchSetPillSheets = MockBatchSetPillSheets();
      when(batchSetPillSheets(batch, [pillSheet])).thenReturn([
        pillSheet.copyWith(id: "sheet_id"),
      ]);

      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          pillSheet.copyWith(id: "sheet_id"),
        ],
        createdAt: now(),
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, pillSheetGroup)).thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history =
          PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(pillSheetGroupID: "group_id", pillSheetIDs: ["sheet_id"]);
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      const setting = Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        timezoneDatabaseName: null,
        reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
        pillSheetTypes: [
          PillSheetType.pillsheet_24_0,
        ],
      );
      final batchSetSetting = MockBatchSetSetting();
      when(
        batchSetSetting(
          batch,
          setting.copyWith(
            pillSheetTypes: [
              PillSheetType.pillsheet_28_0,
            ],
          ),
        ),
      ).thenReturn(null);

      final addPillSheetGroup = AddPillSheetGroup(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheets: batchSetPillSheets,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        batchSetSetting: batchSetSetting,
      );

      await addPillSheetGroup.call(
        setting: setting,
        pillSheetGroup: null,
        pillSheetTypes: [PillSheetType.pillsheet_28_0],
        displayNumberSetting: null,
      );
    });
    test("group has two pill sheet", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: null,
      );
      final pillSheet2 = PillSheet(
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: _today.add(const Duration(days: 28)),
        lastTakenDate: null,
        groupIndex: 1,
      );
      final batchSetPillSheets = MockBatchSetPillSheets();
      when(batchSetPillSheets(batch, [pillSheet, pillSheet2])).thenReturn([pillSheet.copyWith(id: "sheet_id"), pillSheet2.copyWith(id: "sheet_id2")]);

      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["sheet_id", "sheet_id2"],
        pillSheets: [
          pillSheet.copyWith(id: "sheet_id"),
          pillSheet2.copyWith(id: "sheet_id2"),
        ],
        createdAt: now(),
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, pillSheetGroup)).thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
          pillSheetGroupID: "group_id", pillSheetIDs: ["sheet_id", "sheet_id2"]);
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      const setting = Setting(
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        timezoneDatabaseName: null,
        reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
        pillSheetTypes: [PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_24_0],
      );
      final batchSetSetting = MockBatchSetSetting();
      when(
        batchSetSetting(
          batch,
          setting.copyWith(
            pillSheetTypes: [
              PillSheetType.pillsheet_28_0,
              PillSheetType.pillsheet_21,
            ],
          ),
        ),
      ).thenReturn(null);

      final addPillSheetGroup = AddPillSheetGroup(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheets: batchSetPillSheets,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        batchSetSetting: batchSetSetting,
      );

      await addPillSheetGroup.call(
        setting: setting,
        pillSheetGroup: null,
        pillSheetTypes: [PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_21],
        displayNumberSetting: null,
      );
    });
  });
}
