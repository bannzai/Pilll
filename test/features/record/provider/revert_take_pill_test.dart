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
        final _today = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
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
        );

        when(batchSetPillSheets(batch, [pillSheet.copyWith(lastTakenDate: yesterday.subtract(const Duration(days: 1)))]))
            .thenReturn([pillSheet.copyWith(lastTakenDate: yesterday.subtract(const Duration(days: 1)))]);

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
            pillSheet.copyWith(lastTakenDate: yesterday.subtract(const Duration(days: 1))),
          ],
          createdAt: now(),
        );

        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet,
          after: pillSheet.copyWith(
            lastTakenDate: yesterday.subtract(const Duration(days: 1)),
          ),
        );

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

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 0, pillNumberIntoPillSheet: 1);
      });

      test("Revert today pill", () async {
        var mockTodayRepository = MockTodayService();
        final _today = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
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
        );

        when(batchSetPillSheets(batch, [pillSheet.copyWith(lastTakenDate: yesterday)])).thenReturn([pillSheet.copyWith(lastTakenDate: yesterday)]);

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

        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet,
          after: pillSheet.copyWith(
            lastTakenDate: yesterday,
          ),
        );

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

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 0, pillNumberIntoPillSheet: 2);
      });

      test("revert with rest durations and removed rest duration", () async {
        var mockTodayRepository = MockTodayService();
        final _today = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
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
          restDurations: [
            RestDuration(
              beginDate: _today.subtract(const Duration(days: 2)),
              createdDate: _today.subtract(const Duration(days: 2)),
              endDate: _today.subtract(const Duration(days: 1)),
            ),
          ],
        );

        when(batchSetPillSheets(
          batch,
          [pillSheet.copyWith(lastTakenDate: beginDate.subtract(const Duration(days: 1)), restDurations: [])],
        )).thenReturn([pillSheet.copyWith(lastTakenDate: beginDate.subtract(const Duration(days: 1)), restDurations: [])]);

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
            pillSheet.copyWith(lastTakenDate: beginDate.subtract(const Duration(days: 1)), restDurations: []),
          ],
          createdAt: now(),
        );

        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet,
          after: pillSheet.copyWith(
            lastTakenDate: beginDate.subtract(const Duration(days: 1)),
            restDurations: [],
          ),
        );

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

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 0, pillNumberIntoPillSheet: 1);
      });

      test("revert with rest durations but no removed rest duration", () async {
        var mockTodayRepository = MockTodayService();
        final _today = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
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
          restDurations: [
            RestDuration(
              beginDate: _today.subtract(const Duration(days: 8)),
              createdDate: _today.subtract(const Duration(days: 8)),
              endDate: _today.subtract(const Duration(days: 7)),
            ),
          ],
        );

        when(batchSetPillSheets(
          batch,
          [pillSheet.copyWith(lastTakenDate: yesterday)],
        )).thenReturn([pillSheet.copyWith(lastTakenDate: yesterday)]);

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

        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet,
          after: pillSheet.copyWith(lastTakenDate: yesterday),
        );

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

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 0, pillNumberIntoPillSheet: 11);
      });
    });

    group("group has two pill sheet", () {
      test("call revert into actived pill sheet", () async {
        var mockTodayRepository = MockTodayService();
        final _today = DateTime.parse("2022-01-17");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
        final yesterday = DateTime.parse("2022-01-16");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "1",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: _today.subtract(const Duration(days: 29)),
          groupIndex: 0,
          lastTakenDate: _today.subtract(const Duration(days: 2)),
        );

        // actived pill sheet
        final pillSheet2 = PillSheet(
          id: "2",
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: yesterday,
          lastTakenDate: _today,
          groupIndex: 1,
        );

        when(batchSetPillSheets(batch, [
          pillSheet,
          pillSheet2.copyWith(lastTakenDate: yesterday),
        ])).thenReturn([
          pillSheet,
          pillSheet2.copyWith(lastTakenDate: yesterday),
        ]);

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
            pillSheet2.copyWith(lastTakenDate: yesterday),
          ],
          createdAt: now(),
        );

        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
          pillSheetGroupID: "group_id",
          before: pillSheet2,
          after: pillSheet2.copyWith(
            lastTakenDate: yesterday,
          ),
        );

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

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 1, pillNumberIntoPillSheet: 2);
      });

      test("call revert from actived pill sheet to before pill sheet", () async {
        var mockTodayRepository = MockTodayService();
        final _today = DateTime.parse("2022-01-31");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
        final yesterday = DateTime.parse("2022-01-30");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "1",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: _today.subtract(const Duration(days: 29)),
          groupIndex: 0,
          lastTakenDate: _today.subtract(const Duration(days: 2)),
        );

        // actived pill sheet
        final pillSheet2 = PillSheet(
          id: "2",
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: yesterday,
          lastTakenDate: _today,
          groupIndex: 1,
        );

        when(batchSetPillSheets(batch, [
          pillSheet.copyWith(lastTakenDate: _today.subtract(const Duration(days: 4))),
          pillSheet2.copyWith(lastTakenDate: pillSheet2.beginingDate.subtract(const Duration(days: 1))),
        ])).thenReturn([
          pillSheet.copyWith(lastTakenDate: _today.subtract(const Duration(days: 4))),
          pillSheet2.copyWith(lastTakenDate: pillSheet2.beginingDate.subtract(const Duration(days: 1))),
        ]);

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
            pillSheet.copyWith(lastTakenDate: _today.subtract(const Duration(days: 4))),
            pillSheet2.copyWith(lastTakenDate: pillSheet2.beginingDate.subtract(const Duration(days: 1))),
          ],
          createdAt: now(),
        );

        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
            pillSheetGroupID: "group_id", before: pillSheet2, after: pillSheet.copyWith(lastTakenDate: _today.subtract(const Duration(days: 4))));

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

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 0, pillNumberIntoPillSheet: 27);
      });
      test("call revert with rest duration", () async {
        var mockTodayRepository = MockTodayService();
        final _today = DateTime.parse("2022-01-31");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(_today);
        when(mockTodayRepository.now()).thenReturn(_today);
        final yesterday = DateTime.parse("2022-01-30");

        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);

        final pillSheet = PillSheet(
          id: "1",
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: _today.subtract(const Duration(days: 29)),
          groupIndex: 0,
          lastTakenDate: _today.subtract(const Duration(days: 2)),
        );

        // actived pill sheet
        final pillSheet2 = PillSheet(
          id: "2",
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: yesterday,
          lastTakenDate: _today,
          groupIndex: 1,
          restDurations: [
            RestDuration(beginDate: yesterday, createdDate: yesterday, endDate: _today),
          ],
        );

        when(batchSetPillSheets(batch, [
          pillSheet.copyWith(lastTakenDate: _today.subtract(const Duration(days: 4))),
          pillSheet2.copyWith(lastTakenDate: pillSheet2.beginingDate.subtract(const Duration(days: 1)), restDurations: []),
        ])).thenReturn([
          pillSheet.copyWith(lastTakenDate: _today.subtract(const Duration(days: 4))),
          pillSheet2.copyWith(lastTakenDate: pillSheet2.beginingDate.subtract(const Duration(days: 1)), restDurations: []),
        ]);

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
            pillSheet.copyWith(lastTakenDate: _today.subtract(const Duration(days: 4))),
            pillSheet2.copyWith(lastTakenDate: pillSheet2.beginingDate.subtract(const Duration(days: 1)), restDurations: []),
          ],
          createdAt: now(),
        );

        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

        final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
            pillSheetGroupID: "group_id",
            before: pillSheet2,
            after: pillSheet.copyWith(lastTakenDate: _today.subtract(const Duration(days: 4)), restDurations: []));

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

        await revertTakePill.call(pillSheetGroup: pillSheetGroup, pageIndex: 0, pillNumberIntoPillSheet: 27);
      });
    });
  });
}
