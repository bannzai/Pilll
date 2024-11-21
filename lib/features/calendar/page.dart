import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/features/root/localization/l.dart';  // Lクラスをインポート
import 'package:pilll/provider/database.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list_header.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/user.dart';

class CalendarPage extends HookConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingNext = useState(false);
    final limit = useState(20);
    final historiesAsync = ref.watch(pillSheetModifiedHistoriesWithLimitProvider(limit: limit.value));
    final histories = historiesAsync.asData?.value ?? [];

    return ref.watch(userProvider).when(
          error: (error, _) => UniversalErrorPage(
            error: error,
            child: null,
            reload: () => ref.refresh(databaseProvider),
          ),
          loading: () => const ScaffoldIndicator(),
          data: (user) {
            return Scaffold(
              backgroundColor: PilllColors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  L.medicationHistory,  // 服用履歴を翻訳
                  style: const TextStyle(color: TextColor.main),
                ),
                centerTitle: false,
                backgroundColor: PilllColors.white,
              ),
              body: SafeArea(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (!loadingNext.value && notification.metrics.pixels >= notification.metrics.maxScrollExtent && histories.isNotEmpty) {
                      loadingNext.value = true;
                      limit.value += 20;
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
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 20),
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: PillSheetModifiedHistoryList(
                              pillSheetModifiedHistories: histories,
                              premiumOrTrial: user.premiumOrTrial,
                            ),
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

extension CalendarPageRoute on CalendarPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: 'CalendarPage'),
      builder: (_) => const CalendarPage(),
    );
  }
}
