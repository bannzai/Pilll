import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/components/history_blur_teaser.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/components/summary_stats_teaser.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/ended_pill_sheet_dialog.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/ended_pill_sheet_dialog_variant.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';

PillSheetGroup _dummyPillSheetGroup() => PillSheetGroup(
      id: 'group_id',
      pillSheetIDs: ['pill_sheet_id_1'],
      pillSheets: [
        PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
        ),
      ],
      createdAt: DateTime(2020, 9, 1),
    );

void main() {
  group('EndedPillSheetDialog', () {
    testWidgets('variant=historyBlur のとき HistoryBlurTeaser を表示し SummaryStatsTeaser は表示しない', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pillSheetModifiedHistoriesWithLimitProvider(limit: 30).overrideWith((ref) => Stream.value(<PillSheetModifiedHistory>[])),
          ],
          child: MaterialApp(
            home: EndedPillSheetDialog(
              variant: EndedPillSheetDialogVariant.historyBlur,
              pillSheetGroup: _dummyPillSheetGroup(),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(HistoryBlurTeaser), findsOneWidget);
      expect(find.byType(SummaryStatsTeaser), findsNothing);
    });

    testWidgets('variant=summaryStats のとき SummaryStatsTeaser を表示し HistoryBlurTeaser は表示しない', (tester) async {
      final pillSheetGroup = _dummyPillSheetGroup();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pillSheetModifiedHistoriesWithRangeProvider(
              begin: pillSheetGroup.pillSheets.first.beginDate,
              end: pillSheetGroup.pillSheets.last.estimatedEndTakenDate,
            ).overrideWith((ref) => Stream.value(<PillSheetModifiedHistory>[])),
          ],
          child: MaterialApp(
            home: EndedPillSheetDialog(
              variant: EndedPillSheetDialogVariant.summaryStats,
              pillSheetGroup: pillSheetGroup,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SummaryStatsTeaser), findsOneWidget);
      expect(find.byType(HistoryBlurTeaser), findsNothing);
    });
  });
}
