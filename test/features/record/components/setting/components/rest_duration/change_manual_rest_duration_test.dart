import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/change_manual_rest_duration.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/delete_rest_duration_button.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../../../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    initializeDateFormatting('ja_JP');
  });

  group('#ChangeManualRestDuration', () {
    /// [restDuration] を持つピルシート1枚のグループを作る
    PillSheetGroup pillSheetGroup({required RestDuration restDuration}) => PillSheetGroup(
          id: 'group_id',
          pillSheetIDs: ['pill_sheet_id_1'],
          pillSheets: [
            PillSheet.v1(
              id: 'pill_sheet_id_1',
              typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
              beginDate: DateTime(2020, 9, 1),
              lastTakenDate: DateTime(2020, 9, 14),
              createdAt: DateTime(2020, 9, 1),
              restDurations: [restDuration],
            ),
          ],
          createdAt: DateTime(2020, 9, 1),
        );

    Future<void> pump(WidgetTester tester, {required RestDuration restDuration}) {
      return tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
          ],
          child: MaterialApp(
            home: Material(
              child: ChangeManualRestDuration(
                restDuration: restDuration,
                pillSheetGroup: pillSheetGroup(restDuration: restDuration),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('継続中(endDateがnull)の服用お休みの行に削除ボタンが表示される', (tester) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-19'));

      await pump(
        tester,
        restDuration: RestDuration(
          id: 'rest_duration_id',
          beginDate: DateTime(2020, 9, 15),
          endDate: null,
          createdDate: DateTime(2020, 9, 15),
        ),
      );

      expect(find.byType(DeleteRestDurationButton), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('終了済みの服用お休みの行に削除ボタンが表示される', (tester) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-19'));

      await pump(
        tester,
        restDuration: RestDuration(
          id: 'rest_duration_id',
          beginDate: DateTime(2020, 9, 15),
          endDate: DateTime(2020, 9, 17),
          createdDate: DateTime(2020, 9, 15),
        ),
      );

      expect(find.byType(DeleteRestDurationButton), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });
  });
}
