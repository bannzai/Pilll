import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/dots_page_indicator.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/setting_pill_sheet_view.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state.codegen.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';

class SelectTodayPillNumberPillSheetList extends HookConsumerWidget {
  final InitialSettingState state;
  final InitialSettingStateNotifier store;

  const SelectTodayPillNumberPillSheetList({
    Key? key,
    required this.state,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(viewportFraction: (PillSheetViewLayout.width + 20) / MediaQuery.of(context).size.width);
    return Column(
      children: [
        SizedBox(
          height: PillSheetViewLayout.calcHeight(
            PillSheetViewLayout.mostLargePillSheetType(state.pillSheetTypes).numberOfLineInPillSheet,
            true,
          ),
          child: PageView(
            clipBehavior: Clip.none,
            controller: pageController,
            scrollDirection: Axis.horizontal,
            children: List.generate(state.pillSheetTypes.length, (index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SettingPillSheetView(
                      pageIndex: index,
                      appearanceMode: PillSheetAppearanceMode.number,
                      pillSheetTypes: state.pillSheetTypes,
                      selectedPillNumberIntoPillSheet: state.selectedTodayPillNumberIntoPillSheet(pageIndex: index),
                      markSelected: (pageIndex, number) {
                        analytics.logEvent(name: "selected_today_number_initial_setting", parameters: {
                          "pill_number": number,
                          "page": pageIndex,
                        });
                        store.setTodayPillNumber(
                          pageIndex: pageIndex,
                          pillNumberIntoPillSheet: number,
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              );
            }).toList(),
          ),
        ),
        if (state.pillSheetTypes.length > 1) ...[
          const SizedBox(height: 16),
          DotsIndicator(
            controller: pageController,
            itemCount: state.pillSheetTypes.length,
            onDotTapped: (page) {
              pageController.animateToPage(
                page,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          )
        ]
      ],
    );
  }
}
