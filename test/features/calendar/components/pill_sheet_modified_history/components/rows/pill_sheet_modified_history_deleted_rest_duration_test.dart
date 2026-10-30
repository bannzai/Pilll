import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_deleted_rest_duration.dart';

void main() {
  group('#PillSheetModifiedHistoryDeletedRestDuration', () {
    testWidgets('valueがある場合、削除した服用お休み期間の行が表示される', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PillSheetModifiedHistoryDeletedRestDuration(
              estimatedEventCausingDate: DateTime(2020, 9, 19, 10),
              value: DeletedRestDurationValue(
                restDuration: RestDuration(
                  id: 'rest_duration_id',
                  beginDate: DateTime(2020, 9, 10),
                  endDate: DateTime(2020, 9, 13),
                  createdDate: DateTime(2020, 9, 10),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(RowLayout), findsOneWidget);
      expect(find.byType(PillNumber), findsOneWidget);
      expect(find.text('09/10~09/13'), findsOneWidget);
    });

    testWidgets('valueがnullの場合、行は表示されない', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PillSheetModifiedHistoryDeletedRestDuration(
              estimatedEventCausingDate: DateTime(2020, 9, 19, 10),
              value: null,
            ),
          ),
        ),
      );

      expect(find.byType(RowLayout), findsNothing);
    });
  });
}
