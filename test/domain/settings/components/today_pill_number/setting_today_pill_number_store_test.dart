import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_store.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_store_parameter.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#modifiyTodayPillNumber", () {
    test("group has only one pill sheet and it is not yet taken", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.today()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final pillSheet = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: null,
      );
      final updatedPillSheet = pillSheet.copyWith(
        beginingDate: _today.subtract(
          Duration(days: 1),
        ),
        lastTakenDate: _today.subtract(
          Duration(days: 1),
        ),
      );
      final pillSheetService = MockPillSheetService();
      when(pillSheetService.update(batch, [updatedPillSheet])).thenReturn(null);

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          pillSheet,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup =
          pillSheetGroup.copyWith(pillSheets: [updatedPillSheet]);
      final pillSheetGroupService = MockPillSheetGroupService();
      when(pillSheetGroupService.update(batch, updatedPillSheetGroup))
          .thenReturn(updatedPillSheetGroup);

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: pillSheet.copyWith(
          beginingDate: pillSheet.beginingDate.subtract(
            Duration(days: 1),
          ),
          lastTakenDate: _today.subtract(Duration(days: 1)),
        ),
      );

      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      when(pillSheetModifiedHistoryService.add(batch, history))
          .thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          pillSheetServiceProvider.overrideWithValue(pillSheetService),
          pillSheetModifiedHistoryServiceProvider
              .overrideWithValue(pillSheetModifiedHistoryService),
          pillSheetGroupServiceProvider
              .overrideWithValue(pillSheetGroupService),
        ],
      );
      final parameter = SettingTodayPillNumberStoreParameter(
          pillSheetGroup: pillSheetGroup, activedPillSheet: pillSheet);
      final store =
          container.read(settingTodayPillNumberStoreProvider(parameter));

      expect(pillSheet.todayPillNumber, 1);

      store.markSelected(
        pageIndex: 0,
        pillNumberIntoPillSheet: 2,
      );
      await store.modifiyTodayPillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
      );
    });

    test("group has only one pill sheet and it is already taken", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.today()).thenReturn(_today);
      when(mockTodayRepository.now()).thenReturn(_today);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final pillSheet = PillSheet(
        id: "sheet_id",
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: _today,
        groupIndex: 0,
        lastTakenDate: _today,
      );
      final updatedPillSheet = pillSheet.copyWith(
        beginingDate: _today.subtract(
          Duration(days: 1),
        ),
        lastTakenDate: _today.subtract(
          Duration(days: 1),
        ),
      );
      final pillSheetService = MockPillSheetService();
      when(pillSheetService.update(batch, [updatedPillSheet])).thenReturn(null);

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          pillSheet,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup =
          pillSheetGroup.copyWith(pillSheets: [updatedPillSheet]);
      final pillSheetGroupService = MockPillSheetGroupService();
      when(pillSheetGroupService.update(batch, updatedPillSheetGroup))
          .thenReturn(updatedPillSheetGroup);

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: pillSheet.copyWith(
          beginingDate: pillSheet.beginingDate.subtract(
            Duration(days: 1),
          ),
          lastTakenDate: _today.subtract(Duration(days: 1)),
        ),
      );

      final pillSheetModifiedHistoryService =
          MockPillSheetModifiedHistoryService();
      when(pillSheetModifiedHistoryService.add(batch, history))
          .thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          batchFactoryProvider.overrideWithValue(batchFactory),
          pillSheetServiceProvider.overrideWithValue(pillSheetService),
          pillSheetModifiedHistoryServiceProvider
              .overrideWithValue(pillSheetModifiedHistoryService),
          pillSheetGroupServiceProvider
              .overrideWithValue(pillSheetGroupService),
        ],
      );
      final parameter = SettingTodayPillNumberStoreParameter(
          pillSheetGroup: pillSheetGroup, activedPillSheet: pillSheet);
      final store =
          container.read(settingTodayPillNumberStoreProvider(parameter));

      expect(pillSheet.todayPillNumber, 1);

      store.markSelected(
        pageIndex: 0,
        pillNumberIntoPillSheet: 2,
      );
      await store.modifiyTodayPillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
      );
    });
  });
}
