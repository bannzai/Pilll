import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_taken_pill_action.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/day.dart';

/// Variant A: ピルシート履歴のぼかしティーザー。
/// 対象グループの最新の服用記録3件を表示し、先頭1件は鮮明・残り2件は blur で見せて「続きはプレミアム」を訴求する。
class HistoryBlurTeaser extends ConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  const HistoryBlurTeaser({super.key, required this.pillSheetGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 直近の取得件数だけでは別グループ（削除して作り直した場合など）の履歴が混ざるため、対象グループの履歴に絞る
    final groupHistories = (ref.watch(pillSheetModifiedHistoriesWithLimitProvider(limit: 30)).valueOrNull ?? [])
        .where((history) => history.afterPillSheetGroup?.id == pillSheetGroup.id)
        .toList();
    // 取り消し(revertTakenPill)を反映した最終的な服用記録日の集合。取り消されたままの服用記録をティーザーに表示しないために使う。
    // maxDate は服用予定日(scheduledDates)の構築にのみ影響し takenDates には影響しない
    final takenDates = pillTakenDateSets(histories: groupHistories, maxDate: today())?.takenDates ?? {};
    final takenHistories = groupHistories
        .where((history) =>
            history.enumActionType == PillSheetModifiedActionType.takenPill && takenDates.contains(history.estimatedEventCausingDate.date()))
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
            // blur で視覚的に隠した内容がスクリーンリーダーで読み上げられないよう、semantics ごと除外する
            child: ExcludeSemantics(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: row,
              ),
            ),
          );
        }),
      ],
    );
  }
}
