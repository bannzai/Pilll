import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list_header.dart';
import 'package:pilll/domain/pill_sheet_modified_history/pill_sheet_modified_history_store.dart';

class PillSheetModifiedHistoriesPage extends HookConsumerWidget {
  const PillSheetModifiedHistoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(pillSheetModifiedHistoryStoreProvider.notifier);
    final state = ref.watch(pillSheetModifiedHistoryStoreProvider);
    if (!state.isFirstLoadEnded) {
      return const ScaffoldIndicator();
    }
    if (state.pillSheetModifiedHistories.isEmpty) {
      return const ScaffoldIndicator();
    }
    return Scaffold(
      backgroundColor: PilllColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "服用履歴",
          style: TextStyle(color: TextColor.main),
        ),
        centerTitle: false,
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (!state.isLoading &&
                notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent) {
              store.fetchNext();
            }
            return true;
          },
          child: Container(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PillSheetModifiedHisotiryListHeader(),
                const SizedBox(height: 4),
                Expanded(
                  child: PillSheetModifiedHistoryList(
                    padding: const EdgeInsets.only(bottom: 20),
                    scrollPhysics: const AlwaysScrollableScrollPhysics(),
                    pillSheetModifiedHistories:
                        state.pillSheetModifiedHistories,
                    onEditTakenPillAction: store.editTakenValue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension PillSheetModifiedHistoriesPageRoute
    on PillSheetModifiedHistoriesPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "PillSheetModifiedHistoriesPage"),
      builder: (_) => const PillSheetModifiedHistoriesPage(),
    );
  }
}
