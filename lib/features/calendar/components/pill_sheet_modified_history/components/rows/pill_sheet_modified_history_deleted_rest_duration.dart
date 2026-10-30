import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/features/localizations/l.dart';

/// 服用お休み期間を削除した履歴の行
class PillSheetModifiedHistoryDeletedRestDuration extends StatelessWidget {
  /// 服用お休み期間を削除した日時
  final DateTime estimatedEventCausingDate;

  /// 削除した服用お休み期間の情報。履歴に値が無い時は null で、行を表示しない
  final DeletedRestDurationValue? value;

  const PillSheetModifiedHistoryDeletedRestDuration({
    super.key,
    required this.estimatedEventCausingDate,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value == null) {
      return Container();
    }
    return RowLayout(
      day: Day(estimatedEventCausingDate: estimatedEventCausingDate),
      pillNumbersOrHyphenOrDate: PillNumber(
        pillNumber: PillSheetModifiedHistoryPillNumberOrDate.deletedRestDuration(value),
      ),
      detail: Text(
        L.deletePausePeriod,
        style: const TextStyle(
          color: TextColor.main,
          fontSize: 12,
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
