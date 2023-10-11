import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/dots_page_indicator.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/features/before_pill_sheet_group_history/component/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/before_pill_sheet_group_history/component/pill_sheet_modified_history_list.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class BeforePillSheetGroupHistoryPage extends HookConsumerWidget {
  const BeforePillSheetGroupHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueGroup.group2(
      ref.watch(beforePillSheetGroupProvider),
      ref.watch(settingProvider),
    ).when(
      data: (data) {
        return _Page(
          pillSheetGroup: data.t1,
          setting: data.t2,
        );
      },
      error: (error, stackTrace) => UniversalErrorPage(
        error: error,
        reload: () => ref.refresh(refreshAppProvider),
        child: null,
      ),
      loading: () => const Indicator(),
    );
  }
}

class _Page extends HookConsumerWidget {
  final PillSheetGroup? pillSheetGroup;
  final Setting setting;

  const _Page({
    Key? key,
    required this.pillSheetGroup,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillSheetGroup = this.pillSheetGroup;
    if (pillSheetGroup == null) {
      return Scaffold(
        backgroundColor: PilllColors.background,
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: PilllColors.white,
          title: const Text("前回のピルシートグループ"),
          foregroundColor: TextColor.main,
        ),
        body: const Center(child: Text("前回のピルシートグループがまだ存在しません")),
      );
    }

    final currentPillSheet = useState(pillSheetGroup.pillSheets[0]);
    final pageController = usePageController(initialPage: 0, viewportFraction: (PillSheetViewLayout.width + 20) / MediaQuery.of(context).size.width);
    pageController.addListener(() {
      final page = pageController.page?.toInt();
      if (page == null) {
        return;
      }
      final pillSheet = pillSheetGroup.pillSheets[page];
      currentPillSheet.value = pillSheet;
    });
    final begin = DateTimeFormatter.slashYearAndMonthAndDay(currentPillSheet.value.beginingDate);
    final end = DateTimeFormatter.slashYearAndMonthAndDay(currentPillSheet.value.estimatedEndTakenDate);

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: PilllColors.white,
        title: const Text("前回のピルシートグループ"),
        foregroundColor: TextColor.main,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 40),
          Text(
            "$begin ~ $end",
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: FontFamily.japanese, fontSize: 17, fontWeight: FontWeight.w600, color: TextColor.main),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: PillSheetViewLayout.calcHeight(
              PillSheetViewLayout.mostLargePillSheetType(pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList()).numberOfLineInPillSheet,
              false,
            ),
            child: PageView(
              clipBehavior: Clip.none,
              controller: pageController,
              scrollDirection: Axis.horizontal,
              children: [
                for (final pillSheet in pillSheetGroup.pillSheets)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: HistoricalPillsheetGroupPagePillSheet(
                      pillSheetGroup: pillSheetGroup,
                      pillSheet: pillSheet,
                      setting: setting,
                    ),
                  ),
              ],
            ),
          ),
          if (pillSheetGroup.pillSheets.length > 1) ...[
            const SizedBox(height: 16),
            DotsIndicator(
              controller: pageController,
              itemCount: pillSheetGroup.pillSheets.length,
              onDotTapped: (page) {
                pageController.animateToPage(
                  page,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: BeforePillSheetGroupHistoryPagePillSheetModifiedHistoryList(
              pillSheet: currentPillSheet.value,
            ),
          ),
        ],
      ),
    );
  }
}

extension BeforePillSheetGroupHistoryPageRoute on BeforePillSheetGroupHistoryPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "BeforePillSheetGroupHistoryPage"),
      builder: (_) => const BeforePillSheetGroupHistoryPage(),
    );
  }
}
