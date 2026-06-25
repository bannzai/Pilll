import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_taken_pill_action.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';

/// Variant A: ピルシート履歴のぼかしティーザー。
/// 最新の服用記録3件を表示し、先頭1件は鮮明・残り2件は blur で見せて「続きはプレミアム」を訴求する。
class HistoryBlurTeaser extends ConsumerWidget {
  const HistoryBlurTeaser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final takenHistories = (ref.watch(pillSheetModifiedHistoriesWithLimitProvider(limit: 30)).valueOrNull ?? [])
        .where((history) => history.enumActionType == PillSheetModifiedActionType.takenPill)
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L.endedPillSheetDialogHistoryTitle,
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: TextColor.main,
          ),
        ),
        const SizedBox(height: 16),
        ...takenHistories.indexed.map((entry) {
          final row = PillSheetModifiedHistoryTakenPillAction(
            premiumOrTrial: false,
            estimatedEventCausingDate: entry.$2.estimatedEventCausingDate,
            history: entry.$2,
            value: entry.$2.value.takenPill,
          );
          if (entry.$1 == 0) {
            return Padding(padding: const EdgeInsets.only(bottom: 12), child: row);
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: row,
            ),
          );
        }),
      ],
    );
  }
}
