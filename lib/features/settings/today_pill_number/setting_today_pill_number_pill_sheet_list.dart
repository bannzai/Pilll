import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/molecules/dots_page_indicator.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/setting_pill_sheet_view.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class SettingTodayPillNumberPillSheetList extends HookConsumerWidget {
  final List<PillSheetType> pillSheetTypes;
  final int? Function(int pageIndex) selectedTodayPillNumberIntoPillSheet;
  final Function(int pageIndex, int pillNumberInPillSheet) markSelected;
  final PillSheetAppearanceMode pillSheetAppearanceMode;

  const SettingTodayPillNumberPillSheetList({
    super.key,
    required this.pillSheetTypes,
    required this.selectedTodayPillNumberIntoPillSheet,
    required this.markSelected,
    required this.pillSheetAppearanceMode,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // iPhone Duo の外側ディスプレイでは OS が画面右端の列を占有して SafeArea の右 inset になり、
    // MediaQuery の幅 (画面全体) より使える幅が狭い。画面幅ではなく PageView 自身の幅からページ幅を決める
    return LayoutBuilder(
      builder: (context, constraints) => HookBuilder(
        builder: (context) {
          final pageController = usePageController(
            viewportFraction: (PillSheetViewLayout.width + 20) / constraints.maxWidth,
            keys: [constraints.maxWidth],
          );

          return Column(
            children: [
              SizedBox(
                height: PillSheetViewLayout.calcHeight(
                  PillSheetViewLayout.mostLargePillSheetType(
                    pillSheetTypes,
                  ).numberOfLineInPillSheet,
                  true,
                ),
                child: PageView(
                  clipBehavior: Clip.none,
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(pillSheetTypes.length, (pageIndex) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SettingPillSheetView(
                            pageIndex: pageIndex,
                            appearanceMode: pillSheetAppearanceMode,
                            pillSheetTypes: pillSheetTypes,
                            selectedPillNumberIntoPillSheet: selectedTodayPillNumberIntoPillSheet(pageIndex),
                            markSelected: (pageIndex, number) {
                              analytics.logEvent(
                                name: 'selected_today_number_setting',
                                parameters: {
                                  'pill_number': number,
                                  'page': pageIndex,
                                },
                              );
                              markSelected(pageIndex, number);
                            },
                          ),
                        ),
                        const Spacer(),
                      ],
                    );
                  }).toList(),
                ),
              ),
              if (pillSheetTypes.length > 1) ...[
                const SizedBox(height: 16),
                DotsIndicator(
                  controller: pageController,
                  itemCount: pillSheetTypes.length,
                  onDotTapped: (page) {
                    pageController.animateToPage(
                      page,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
