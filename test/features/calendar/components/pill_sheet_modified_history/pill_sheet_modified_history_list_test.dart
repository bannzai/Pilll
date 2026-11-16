import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list.dart';
import 'package:pilll/features/error/error_boundary.dart';
import 'package:pilll/features/error/page.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../../../helper/mock.mocks.dart';

void main() {
  group('#PillSheetModifiedHistoryList', () {
    testWidgets('描画に失敗する履歴が1件あっても、その履歴だけが fallback の表示になり、同じ一覧の他の履歴は表示される',
        (tester) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-29'));

      PillSheetGroup pillSheetGroup({required List<PillSheet> pillSheets}) =>
          PillSheetGroup(
            id: 'group_id',
            pillSheetIDs: ['pill_sheet_id_1'],
            pillSheets: pillSheets,
            createdAt: DateTime(2020, 9, 1),
          );
      PillSheet pillSheet({required DateTime lastTakenDate}) => PillSheet.v1(
            id: 'pill_sheet_id_1',
            typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
            beginDate: DateTime(2020, 9, 1),
            lastTakenDate: lastTakenDate,
            createdAt: DateTime(2020, 9, 1),
          );
      final displayableHistory = PillSheetModifiedHistory(
        id: 'displayable_history_id',
        actionType: PillSheetModifiedActionType.takenPill.name,
        estimatedEventCausingDate: DateTime(2020, 9, 11, 10),
        createdAt: DateTime(2020, 9, 11, 10),
        value: const PillSheetModifiedHistoryValue(takenPill: TakenPillValue()),
        beforePillSheetGroup: pillSheetGroup(
            pillSheets: [pillSheet(lastTakenDate: DateTime(2020, 9, 10))]),
        afterPillSheetGroup: pillSheetGroup(
            pillSheets: [pillSheet(lastTakenDate: DateTime(2020, 9, 11))]),
      );
      // ピルシートが空のスナップショットは lastTakenPillSheetOrFirstPillSheet の pillSheets[0] で RangeError になり、行の build が失敗する
      final undisplayableHistory = PillSheetModifiedHistory(
        id: 'undisplayable_history_id',
        actionType: PillSheetModifiedActionType.takenPill.name,
        estimatedEventCausingDate: DateTime(2020, 9, 10, 10),
        createdAt: DateTime(2020, 9, 10, 10),
        value: const PillSheetModifiedHistoryValue(takenPill: TakenPillValue()),
        beforePillSheetGroup: pillSheetGroup(pillSheets: []),
        afterPillSheetGroup: pillSheetGroup(pillSheets: []),
      );

      final originalErrorWidgetBuilder = ErrorWidget.builder;
      // テスト環境では ForceUpdate が ErrorWidget.builder を設定しないため、本番と同じ builder をこのテストの間だけ設定する。
      // flutter_test はテストの終了時に ErrorWidget.builder が元に戻っていることを検査するため、テストの本体の中で戻す
      ErrorWidget.builder =
          (details) => buildErrorWidget(details: details, reload: () {});
      try {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
            ],
            child: MaterialApp(
              home: Material(
                child: SingleChildScrollView(
                  child: PillSheetModifiedHistoryList(
                    pillSheetModifiedHistories: [
                      displayableHistory,
                      undisplayableHistory
                    ],
                    premiumOrTrial: true,
                  ),
                ),
              ),
            ),
          ),
        );

        // 行の build の例外は FlutterError に報告されたうえで、その行だけが fallback の表示に差し替わる
        expect(tester.takeException(), isNotNull);
        expect(find.byType(UniversalErrorPage), findsNothing);
        expect(find.byType(ErrorBoundary), findsNWidgets(2));
        // 描画できる履歴は通常の行として表示される
        expect(
          find.descendant(
              of: find.byType(ErrorBoundary).first,
              matching: find.byType(RowLayout)),
          findsOneWidget,
        );
        // 描画に失敗した履歴は通常の行の代わりに fallback の Text だけが表示される
        expect(
          find.descendant(
              of: find.byType(ErrorBoundary).last,
              matching: find.byType(RowLayout)),
          findsNothing,
        );
        expect(
          find.descendant(
              of: find.byType(ErrorBoundary).last, matching: find.byType(Text)),
          findsOneWidget,
        );
      } finally {
        ErrorWidget.builder = originalErrorWidgetBuilder;
      }
    });
  });
}
