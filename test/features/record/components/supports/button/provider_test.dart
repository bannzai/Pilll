import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/features/record/components/supports/components/rest_duration/provider.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../helper/factory.dart';
import '../../../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#beginRestDuration", () {
    test("group has only one pill sheet", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);

      final restDuration = Factory.notYetEndRestDuration();

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = Factory.pillSheet1()[0];
      final updatedPillSheet = pillSheet.copyWith(restDurations: [restDuration]);
      final batchSetPillSheets = MockBatchSetPillSheets();
      when(batchSetPillSheets(batch, [updatedPillSheet])).thenReturn([updatedPillSheet]);

      final pillSheetGroup = Factory.pillSheetGroup([pillSheet]).copyWith(id: "group_id");
      final updatedPillSheetGroup = Factory.pillSheetGroup([updatedPillSheet]).copyWith(id: "group_id");
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
          pillSheetGroupID: "group_id", before: pillSheet, after: updatedPillSheet, restDuration: restDuration);
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final beginRestDuration = BeginRestDuration(
          batchFactory: batchFactory,
          batchSetPillSheets: batchSetPillSheets,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory);
      await beginRestDuration.call(activePillSheet: pillSheet, pillSheetGroup: pillSheetGroup);

      verify(batchFactory.batch()).called(1);
      verify(batchSetPillSheets(batch, [updatedPillSheet])).called(1);
      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });
  });
  group("#endRestDuration", () {
    test("group has only one pill sheet", () async {
      var mockTodayRepository = MockTodayService();
      final _today = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(_today);

      final notYetEndRestDuration = RestDuration(
        beginDate: now().subtract(const Duration(days: 1)),
        createdDate: now().subtract(const Duration(days: 1)),
        endDate: null,
      );
      final endedRestDuration = notYetEndRestDuration.copyWith(
        endDate: now(),
      );

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);

      final pillSheet = Factory.pillSheet1()[0].copyWith(restDurations: [notYetEndRestDuration]);
      final updatedPillSheet = pillSheet.copyWith(restDurations: [endedRestDuration]);
      final batchSetPillSheets = MockBatchSetPillSheets();
      when(batchSetPillSheets(batch, [updatedPillSheet])).thenReturn([updatedPillSheet]);

      final pillSheetGroup = Factory.pillSheetGroup([pillSheet]).copyWith(id: "group_id");
      final updatedPillSheetGroup = Factory.pillSheetGroup([updatedPillSheet]).copyWith(id: "group_id");
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup.copyWith(id: "group_id"));

      final history = PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
          pillSheetGroupID: "group_id", before: pillSheet, after: updatedPillSheet, restDuration: endedRestDuration);
      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final endRestDuration = EndRestDuration(
          batchFactory: batchFactory,
          batchSetPillSheets: batchSetPillSheets,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory);
      await endRestDuration.call(activePillSheet: pillSheet, pillSheetGroup: pillSheetGroup, restDuration: notYetEndRestDuration);

      verify(batchFactory.batch()).called(1);
      verify(batchSetPillSheets(batch, [updatedPillSheet])).called(1);
      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, history)).called(1);
    });
  });
}
