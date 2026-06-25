import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/ended_pill_sheet_taken_summary.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';

/// Variant B: 服用記録の集計メッセージティーザー。
/// 終了したピルシートグループの服用記録できた日数・記録漏れ日数を集計して表示する。
class SummaryStatsTeaser extends ConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  const SummaryStatsTeaser({super.key, required this.pillSheetGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxDate = pillSheetGroup.pillSheets.last.estimatedEndTakenDate;
    final summary = endedPillSheetTakenSummary(
      histories: ref
              .watch(pillSheetModifiedHistoriesWithRangeProvider(
                begin: pillSheetGroup.pillSheets.first.beginDate,
                end: maxDate,
              ))
              .valueOrNull ??
          [],
      maxDate: maxDate,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L.endedPillSheetDialogSummaryTitle,
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: TextColor.main,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          L.endedPillSheetDialogSummaryMessage(summary.recordedDays, summary.missedDays),
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: TextColor.main,
          ),
        ),
      ],
    );
  }
}
