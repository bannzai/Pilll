import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';

class HistoricalPillSheetGroupPagePillSheetModifiedHistoryList extends HookConsumerWidget {
  final DateTime begin;
  final DateTime end;

  HistoricalPillSheetGroupPagePillSheetModifiedHistoryList({
    super.key,
    required this.begin,
    required this.end,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(pillSheetModifiedHistoriesWithRangeProvider(begin: begin, end: end)).whenData((pillSheetModifiedHistories) {
      return PillSheetModifiedHistoryList(
        scrollPhysics: NeverScrollableScrollPhysics(),
        pillSheetModifiedHistories: pillSheetModifiedHistories,
        padding: EdgeInsets.zero,
        premiumAndTrial: true,
      );
    });
  }
}
