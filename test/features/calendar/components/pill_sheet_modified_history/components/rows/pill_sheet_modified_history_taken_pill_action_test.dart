import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_taken_pill_action.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../../../../../helper/mock.mocks.dart';

void main() {
  group('#PillSheetModifiedHistoryTakenPillAction', () {
    group('表示モードが cyclicSequential の場合', () {
      testWidgets(
          'lastTakenDate が服用終了予定日より2日以上後ろのピルシート(28錠)を含むスナップショットでも、例外を投げずにピル番号が表示される',
          (tester) async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse('2020-10-10'));

        // 28錠のピルシートは 2020-09-01 開始で 2020-09-28 に服用終了予定。lastTakenDate から計算するピル番号は 9/29 で29、9/30 で30 になり、錠数を超える
        PillSheetGroup pillSheetGroup({required DateTime lastTakenDate}) =>
            PillSheetGroup(
              id: 'group_id',
              pillSheetIDs: ['pill_sheet_id_1'],
              pillSheets: [
                PillSheet.v1(
                  id: 'pill_sheet_id_1',
                  typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
                  beginDate: DateTime(2020, 9, 1),
                  lastTakenDate: lastTakenDate,
                  createdAt: DateTime(2020, 9, 1),
                ),
              ],
              createdAt: DateTime(2020, 9, 1),
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            );
        final history = PillSheetModifiedHistory(
          id: 'taken_pill_history_id',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: DateTime(2020, 9, 30, 10),
          createdAt: DateTime(2020, 9, 30, 10),
          value:
              const PillSheetModifiedHistoryValue(takenPill: TakenPillValue()),
          beforePillSheetGroup:
              pillSheetGroup(lastTakenDate: DateTime(2020, 9, 29)),
          afterPillSheetGroup:
              pillSheetGroup(lastTakenDate: DateTime(2020, 9, 30)),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
            ],
            child: MaterialApp(
              home: Material(
                child: PillSheetModifiedHistoryTakenPillAction(
                  premiumOrTrial: true,
                  estimatedEventCausingDate: history.estimatedEventCausingDate,
                  history: history,
                  value: history.value.takenPill,
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(RowLayout), findsOneWidget);
        expect(find.byType(PillNumber), findsOneWidget);
      });
    });
  });
}
