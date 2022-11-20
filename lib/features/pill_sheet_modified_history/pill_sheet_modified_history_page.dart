import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list_header.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';

class PillSheetModifiedHistoriesPage extends HookConsumerWidget {
  const PillSheetModifiedHistoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive(wantKeepAlive: true);

    final loadingNext = useState(false);
    final afterCursor = useState<DateTime?>(null);
    final histories = useState<List<PillSheetModifiedHistory>>([]);
    final pillSheetModifiedHistoryAsyncValue = ref.watch(pillSheetModifiedHistoriesProvider(afterCursor.value));
    useEffect(() {
      loadingNext.value = false;

      final pillSheetModifiedHistoriesValue = pillSheetModifiedHistoryAsyncValue.asData?.value;
      if (pillSheetModifiedHistoriesValue != null) {
        histories.value = [...histories.value, ...pillSheetModifiedHistoriesValue];
      }
      return null;
    }, [pillSheetModifiedHistoryAsyncValue.asData?.value]);

    return ref.watch(premiumAndTrialProvider).when(
          error: (error, _) => UniversalErrorPage(
            error: error,
            child: null,
            reload: () => ref.refresh(databaseProvider),
          ),
          loading: () => const ScaffoldIndicator(),
          data: (premiumAndTrial) {
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
                    if (!loadingNext.value && notification.metrics.pixels >= notification.metrics.maxScrollExtent && histories.value.isNotEmpty) {
                      loadingNext.value = true;
                      afterCursor.value = histories.value.last.estimatedEventCausingDate;
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
                            pillSheetModifiedHistories: histories.value,
                            premiumAndTrial: premiumAndTrial,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
  }
}

extension PillSheetModifiedHistoriesPageRoute on PillSheetModifiedHistoriesPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "PillSheetModifiedHistoriesPage"),
      builder: (_) => const PillSheetModifiedHistoriesPage(),
    );
  }
}
