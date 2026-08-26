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
import 'package:pilll/features/error/page.dart';
import 'package:pilll/features/before_pill_sheet_group_history/component/pill_sheet.dart';
import 'package:pilll/features/before_pill_sheet_group_history/component/rest_duration/rest_duration_section.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/before_pill_sheet_group_history/component/pill_sheet_modified_history_list.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class BeforePillSheetGroupHistoryPage extends HookConsumerWidget {
  const BeforePillSheetGroupHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueGroup.group4(
      ref.watch(beforePillSheetGroupProvider),
      ref.watch(latestPillSheetGroupProvider),
      ref.watch(settingProvider),
      ref.watch(userProvider),
    ).when(
      data: (data) {
        final beforePillSheetGroup = data.$1;
        final latestPillSheetGroup = data.$2;
        // ピルシートグループが1件しか無い時 beforePillSheetGroupProvider はその1件を返す。それが使用中 (終了も破棄もしていない) なら前回のピルシートグループではないので表示しない
        // 終了済みの場合は、まだ新しいピルシートグループを作っていない状態の前回のピルシートグループとして扱い、服用お休み期間を後から記録できるようにする
        final isLatestInUse =
            latestPillSheetGroup != null && beforePillSheetGroup?.id == latestPillSheetGroup.id && !latestPillSheetGroup.isDeactived;
        return _Page(
          pillSheetGroup: isLatestInUse ? null : beforePillSheetGroup,
          setting: data.$3,
          premiumOrTrial: data.$4.premiumOrTrial,
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
  final bool premiumOrTrial;

  const _Page({required this.pillSheetGroup, required this.setting, required this.premiumOrTrial});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillSheetGroup = this.pillSheetGroup;
    if (pillSheetGroup == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: AppColors.white,
          title: Text(L.previousPillSheetGroup),
          foregroundColor: TextColor.main,
        ),
        body: Center(child: Text(L.previousPillSheetGroupNotFound)),
      );
    }

    // 服用お休み期間の追加・変更でピルシートグループが再取得されても表示中のページを維持できるように、ピルシートではなくページ番号を状態に持つ
    final currentPage = useState(0);
    final currentPillSheet = pillSheetGroup.pillSheets[currentPage.value];
    final pageController = usePageController(
      initialPage: 0,
      viewportFraction: (PillSheetViewLayout.width + 20) / MediaQuery.of(context).size.width,
    );
    pageController.addListener(() {
      final page = pageController.page?.toInt();
      if (page == null) {
        return;
      }
      currentPage.value = page;
    });
    final begin = DateTimeFormatter.slashYearAndMonthAndDay(
      currentPillSheet.beginDate,
    );
    final end = DateTimeFormatter.slashYearAndMonthAndDay(
      currentPillSheet.estimatedEndTakenDate,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.white,
        title: Text(L.previousPillSheetGroup),
        foregroundColor: TextColor.main,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 40),
            Text(
              '$begin ~ $end',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: TextColor.main,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: PillSheetViewLayout.calcHeight(
                PillSheetViewLayout.mostLargePillSheetType(
                  pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList(),
                ).numberOfLineInPillSheet,
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
            // 破棄したピルシートグループの服用お休みは編集できない
            if (pillSheetGroup.deletedAt == null) ...[
              const SizedBox(height: 16),
              BeforePillSheetGroupRestDurationSection(pillSheetGroup: pillSheetGroup),
            ],
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: BeforePillSheetGroupHistoryPagePillSheetModifiedHistoryList(
                pillSheet: currentPillSheet,
                premiumOrTrial: premiumOrTrial,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension BeforePillSheetGroupHistoryPageRoute on BeforePillSheetGroupHistoryPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: 'BeforePillSheetGroupHistoryPage'),
      builder: (_) => const BeforePillSheetGroupHistoryPage(),
    );
  }
}
