import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list_header.dart';
import 'package:pilll/domain/pill_sheet_modified_history/pill_sheet_modified_history_store.dart';

class PillSheetModifiedHistoriesPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(pillSheetModifiedHistoryStoreProvider);
    final state = useProvider(pillSheetModifiedHistoryStoreProvider.state);
    if (!state.isFirstLoadEnded) {
      return ScaffoldIndicator();
    }
    if (state.pillSheetModifiedHistories.isEmpty) {
      return ScaffoldIndicator();
    }
    return Scaffold(
      backgroundColor: PilllColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
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
            padding: EdgeInsets.only(left: 32, right: 32, top: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PillSheetModifiedHisotiryListHeader(),
                SizedBox(height: 4),
                Expanded(
                  child: CalendarPillSheetModifiedHistoryList(
                    padding: EdgeInsets.only(bottom: 20),
                    scrollPhysics: AlwaysScrollableScrollPhysics(),
                    pillSheetModifiedHistories:
                        state.pillSheetModifiedHistories,
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
      settings: RouteSettings(name: "PillSheetModifiedHistoriesPage"),
      builder: (_) => PillSheetModifiedHistoriesPage(),
    );
  }
}
