import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/features/record/components/add_pill_sheet_group/provider.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
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
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("sheet_id");
      firestoreIDGenerator = mockIDGenerator;

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: mockToday,
        groupIndex: 0,
        lastTakenDate: null,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0),
      );

      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          pillSheet.copyWith(id: "sheet_id"),
        ],
        createdAt: now(),
      );
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, pillSheetGroup)).thenReturn(pillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
        pillSheetGroupID: "group_id",
        pillSheetIDs: ["sheet_id"],
        beforePillSheetGroup: null,
        createdNewPillSheetGroup: pillSheetGroup.copyWith(id: "group_id"),
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
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      var idGeneratorCallCount = 0;
      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenAnswer((_) => ["sheet_id", "sheet_id2"][idGeneratorCallCount++]);
      firestoreIDGenerator = mockIDGenerator;

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: mockToday,
        groupIndex: 0,
        lastTakenDate: null,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0),
      );
      final pillSheet2 = PillSheet(
        id: "sheet_id2",
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: mockToday.add(const Duration(days: 28)),
        lastTakenDate: null,
        groupIndex: 1,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21),
      );

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
        pillSheetGroupID: "group_id",
        pillSheetIDs: ["sheet_id", "sheet_id2"],
        beforePillSheetGroup: null,
        createdNewPillSheetGroup: pillSheetGroup.copyWith(id: "group_id"),
      );
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
