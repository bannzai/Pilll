import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/revert_take_pill.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  group("#revertTaken", () {
    group("group has only one pill sheet", () {
      test("Revert to first pill sheet", () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        final yesterday = DateTime.parse("2022-01-16");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "sheet_id",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: yesterday,
          groupIndex: 0,
          lastTakenDate: today(),
          createdAt: now(),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id"],
          pillSheets: [
            pillSheet,
          ],
          createdAt: now(),
        );
        final updatedPillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id"],
          pillSheets: [
            pillSheet.copyWith(
              lastTakenDate: null,
            ),
          ],
          createdAt: now(),
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet,
          after: pillSheet.copyWith(
            lastTakenDate: yesterday.subtract(const Duration(days: 1)),
          ),
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        const setting = Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          timezoneDatabaseName: null,
          reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
          ],
        );
        final bachSetSetting = MockBatchSetSetting();
        when(bachSetSetting(batch, setting)).thenReturn(null);

        final revertTakePill = RevertTakePill(
            batchFactory: batchFactory,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
            batchSetPillSheetGroup: batchSetPillSheetGroup);

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 0, targetRevertPillNumberIntoPillSheet: 1);
      });

      test("Revert today pill", () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        final yesterday = DateTime.parse("2022-01-16");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "sheet_id",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: yesterday,
          groupIndex: 0,
          lastTakenDate: today(),
          createdAt: now(),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id"],
          pillSheets: [
            pillSheet,
          ],
          createdAt: now(),
        );
        final updatedPillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id"],
          pillSheets: [
            pillSheet.copyWith(lastTakenDate: yesterday),
          ],
          createdAt: now(),
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet,
          after: pillSheet.copyWith(
            lastTakenDate: yesterday,
          ),
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        const setting = Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          timezoneDatabaseName: null,
          reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
          ],
        );
        final bachSetSetting = MockBatchSetSetting();
        when(bachSetSetting(batch, setting)).thenReturn(null);

        final revertTakePill = RevertTakePill(
            batchFactory: batchFactory,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
            batchSetPillSheetGroup: batchSetPillSheetGroup);

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 0, targetRevertPillNumberIntoPillSheet: 2);
      });

      test("revert with rest durations and removed rest duration", () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        final beginDate = DateTime.parse("2022-01-06");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "sheet_id",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: beginDate,
          groupIndex: 0,
          lastTakenDate: today(),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: mockToday.subtract(const Duration(days: 2)),
              createdDate: mockToday.subtract(const Duration(days: 2)),
              endDate: mockToday.subtract(const Duration(days: 1)),
            ),
          ],
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id"],
          pillSheets: [
            pillSheet,
          ],
          createdAt: now(),
        );
        final updatedPillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id"],
          pillSheets: [
            pillSheet.copyWith(
              lastTakenDate: null,
              restDurations: [],
            ),
          ],
          createdAt: now(),
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet,
          after: pillSheet.copyWith(
            lastTakenDate: beginDate.subtract(const Duration(days: 1)),
            restDurations: [],
          ),
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        const setting = Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          timezoneDatabaseName: null,
          reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
          ],
        );
        final bachSetSetting = MockBatchSetSetting();
        when(bachSetSetting(batch, setting)).thenReturn(null);

        final revertTakePill = RevertTakePill(
            batchFactory: batchFactory,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
            batchSetPillSheetGroup: batchSetPillSheetGroup);

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 0, targetRevertPillNumberIntoPillSheet: 1);
      });

      test("revert with rest durations but no removed rest duration", () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        final beginDate = DateTime.parse("2022-01-06");
        final yesterday = DateTime.parse("2022-01-16");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "sheet_id",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: beginDate,
          groupIndex: 0,
          lastTakenDate: today(),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: mockToday.subtract(const Duration(days: 8)),
              createdDate: mockToday.subtract(const Duration(days: 8)),
              endDate: mockToday.subtract(const Duration(days: 7)),
            ),
          ],
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id"],
          pillSheets: [
            pillSheet,
          ],
          createdAt: now(),
        );
        final updatedPillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["sheet_id"],
          pillSheets: [
            pillSheet.copyWith(
              lastTakenDate: yesterday,
            ),
          ],
          createdAt: now(),
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet,
          after: pillSheet.copyWith(lastTakenDate: yesterday),
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        const setting = Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          timezoneDatabaseName: null,
          reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
          ],
        );
        final bachSetSetting = MockBatchSetSetting();
        when(bachSetSetting(batch, setting)).thenReturn(null);

        final revertTakePill = RevertTakePill(
            batchFactory: batchFactory,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
            batchSetPillSheetGroup: batchSetPillSheetGroup);

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 0, targetRevertPillNumberIntoPillSheet: 11);
      });
    });

    group("group has two pill sheet", () {
      test("call revert into actived pill sheet", () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        final yesterday = DateTime.parse("2022-01-16");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "1",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: mockToday.subtract(const Duration(days: 29)),
          groupIndex: 0,
          lastTakenDate: mockToday.subtract(const Duration(days: 2)),
          createdAt: now(),
        );

        // actived pill sheet
        final pillSheet2 = PillSheet(
          id: "2",
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: yesterday,
          lastTakenDate: mockToday,
          groupIndex: 1,
          createdAt: now(),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["1", "2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
        );
        final updatedPillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["1", "2"],
          pillSheets: [
            pillSheet,
            pillSheet2.copyWith(
              lastTakenDate: yesterday,
            ),
          ],
          createdAt: now(),
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet2,
          after: pillSheet2.copyWith(
            lastTakenDate: yesterday,
          ),
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        const setting = Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          timezoneDatabaseName: null,
          reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
            PillSheetType.pillsheet_21,
          ],
        );
        final bachSetSetting = MockBatchSetSetting();
        when(bachSetSetting(batch, setting)).thenReturn(null);

        final revertTakePill = RevertTakePill(
            batchFactory: batchFactory,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
            batchSetPillSheetGroup: batchSetPillSheetGroup);

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 1, targetRevertPillNumberIntoPillSheet: 2);
      });

      test("call revert from actived pill sheet to before pill sheet", () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-01-31");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        final yesterday = DateTime.parse("2022-01-30");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "1",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: mockToday.subtract(const Duration(days: 29)),
          groupIndex: 0,
          lastTakenDate: mockToday.subtract(const Duration(days: 2)),
          createdAt: now(),
        );

        // actived pill sheet
        final pillSheet2 = PillSheet(
          id: "2",
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: yesterday,
          lastTakenDate: mockToday,
          groupIndex: 1,
          createdAt: now(),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["1", "2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
        );
        final updatedPillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["1", "2"],
          pillSheets: [
            pillSheet.copyWith(
              lastTakenDate: mockToday.subtract(const Duration(days: 4)),
            ),
            pillSheet2.copyWith(
              lastTakenDate: null,
            ),
          ],
          createdAt: now(),
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet2,
          after: pillSheet.copyWith(lastTakenDate: mockToday.subtract(const Duration(days: 4))),
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        const setting = Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          timezoneDatabaseName: null,
          reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
            PillSheetType.pillsheet_21,
          ],
        );
        final bachSetSetting = MockBatchSetSetting();
        when(bachSetSetting(batch, setting)).thenReturn(null);

        final revertTakePill = RevertTakePill(
            batchFactory: batchFactory,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
            batchSetPillSheetGroup: batchSetPillSheetGroup);

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 0, targetRevertPillNumberIntoPillSheet: 27);
      });
      test("call revert with rest duration", () async {
        var mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2022-01-31");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        final yesterday = DateTime.parse("2022-01-30");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "1",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: mockToday.subtract(const Duration(days: 29)),
          groupIndex: 0,
          lastTakenDate: mockToday.subtract(const Duration(days: 2)),
          createdAt: now(),
        );

        // actived pill sheet
        final pillSheet2 = PillSheet(
          id: "2",
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: yesterday,
          lastTakenDate: mockToday,
          groupIndex: 1,
          restDurations: [
            RestDuration(id: "rest_duration_id", beginDate: yesterday, createdDate: yesterday, endDate: today()),
          ],
          createdAt: now(),
        );

        final pillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["1", "2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
        );
        final updatedPillSheetGroup = PillSheetGroup(
          id: "group_id",
          pillSheetIDs: ["1", "2"],
          pillSheets: [
            pillSheet.copyWith(
              lastTakenDate: mockToday.subtract(const Duration(days: 4)),
            ),
            pillSheet2.copyWith(
              lastTakenDate: pillSheet2.beginingDate.subtract(const Duration(days: 1)),
              restDurations: [],
            )
          ],
          createdAt: now(),
        );
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet2,
          after: pillSheet.copyWith(lastTakenDate: mockToday.subtract(const Duration(days: 4)), restDurations: []),
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
        final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
        when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

        const setting = Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: true,
          timezoneDatabaseName: null,
          reminderTimes: [ReminderTime(hour: 21, minute: 20), ReminderTime(hour: 22, minute: 0)],
          pillSheetTypes: [
            PillSheetType.pillsheet_28_0,
            PillSheetType.pillsheet_21,
          ],
        );
        final bachSetSetting = MockBatchSetSetting();
        when(bachSetSetting(batch, setting)).thenReturn(null);

        final revertTakePill = RevertTakePill(
            batchFactory: batchFactory,
            batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
            batchSetPillSheetGroup: batchSetPillSheetGroup);

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 0, targetRevertPillNumberIntoPillSheet: 27);
      });
    });
  });
}
