import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';

class BeforePillSheetGroupHistoryPagePillSheetModifiedHistoryList extends HookConsumerWidget {
  final PillSheet pillSheet;

  const BeforePillSheetGroupHistoryPagePillSheetModifiedHistoryList({
    super.key,
    required this.pillSheet,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final begin = pillSheet.beginingDate;
    final end = pillSheet.estimatedEndTakenDate;

    return ref.watch(pillSheetModifiedHistoriesWithRangeProvider(begin: begin, end: end)).when(
          data: (pillSheetModifiedHistories) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: PillSheetModifiedHistoryList(
                pillSheetModifiedHistories: pillSheetModifiedHistories,
                premiumOrTrial: true,
              ),
            );
          },
          loading: () => const Indicator(),
          error: (e, _) => Text("服用履歴情報の取得に失敗しました。${e.toString()}"),
        );
  }
}
