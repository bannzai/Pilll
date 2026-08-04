import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_taken_pill_action.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/day.dart';

/// HistoryBlurTeaser が参照する履歴の取得上限。
/// 表示前判定(home/page.dart)とティーザー本体で同じ provider 引数を使うための定数
const historyBlurTeaserHistoriesLimit = 30;

/// 対象グループの履歴から、ティーザーに表示する服用記録（取り消し反映済み・最新3件）を返す。
/// 表示前判定(home/page.dart)とティーザー本体の双方で同じ選定ロジックを使うために切り出している
List<PillSheetModifiedHistory> historyBlurTeaserHistories({
  required PillSheetGroup pillSheetGroup,
  required List<PillSheetModifiedHistory> histories,
}) {
  // 直近の取得件数だけでは別グループ（削除して作り直した場合など）の履歴が混ざるため、対象グループの履歴に絞る
  final groupHistories = histories.where((history) => history.afterPillSheetGroup?.id == pillSheetGroup.id).toList();
  // 取り消し(revertTakenPill)を反映した最終的な服用記録日の集合。取り消されたままの服用記録をティーザーに表示しないために使う。
  // maxDate は服用予定日(scheduledDates)の構築にのみ影響し takenDates には影響しない
  final takenDates = pillTakenDateSets(histories: groupHistories, maxDate: today())?.takenDates ?? {};
  // 過去日のピルを後から記録した履歴は操作日と記録対象日が異なるため、記録対象日で照合する。
  // 一部だけ取り消されたまとめ記録は行表示（afterPillSheetGroup ベース）が実態とずれるため、
  // 記録対象日の全てが取り消されず残っている履歴だけを表示する
  return groupHistories
      .where((history) {
        if (history.enumActionType != PillSheetModifiedActionType.takenPill) {
          return false;
        }
        final targetDates = takenPillHistoryTargetDates(history);
        return targetDates.isNotEmpty && targetDates.every(takenDates.contains);
      })
      .take(3)
      .toList();
}

/// Variant A: ピルシート履歴のぼかしティーザー。
/// 対象グループの最新の服用記録3件を表示し、先頭1件は鮮明・残り2件は blur で見せて「続きはプレミアム」を訴求する。
class HistoryBlurTeaser extends ConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  const HistoryBlurTeaser({super.key, required this.pillSheetGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        ref.watch(pillSheetModifiedHistoriesWithLimitProvider(limit: historyBlurTeaserHistoriesLimit)).when(
              data: (histories) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: historyBlurTeaserHistories(pillSheetGroup: pillSheetGroup, histories: histories).indexed.map((entry) {
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
                }).toList(),
              ),
              error: (error, _) => Text(
                error.toString(),
                style: const TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: TextColor.main,
                ),
              ),
              // 読み込み完了前に履歴0件の空ティーザーを描画しない
              loading: () => const Center(child: Indicator()),
            ),
      ],
    );
  }
}
