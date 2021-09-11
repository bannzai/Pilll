import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/dots_page_indicator.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/setting_pill_sheet_view.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class SelectTodayPillNumberPillSheetList extends HookWidget {
  final InitialSettingState state;
  final InitialSettingStateStore store;

  SelectTodayPillNumberPillSheetList({
    required this.state,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(
        viewportFraction: (PillSheetViewLayout.width + 20) /
            MediaQuery.of(context).size.width);
    return Column(
      children: [
        Container(
          height: PillSheetViewLayout.calcHeight(
            PillSheetViewLayout.mostLargePillSheetType(state.pillSheetTypes)
                .numberOfLineInPillSheet,
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SettingPillSheetView(
                      pageIndex: index,
                      isOnSequenceAppearance: state.isOnSequenceAppearance,
                      pillSheetType: state.pillSheetTypes[index],
                      selectedPillNumber: state.todayPillNumber,
                      markSelected: (number) {
                        analytics.logEvent(
                            name: "selected_today_number_initial_setting",
                            parameters: {"pill_number": number});
                        store.setTodayPillNumber(number);
                      },
                    ),
                  ),
                  Spacer(),
                ],
              );
            }).toList(),
          ),
        ),
        if (state.pillSheetTypes.length > 1) ...[
          SizedBox(height: 16),
          DotsIndicator(
            controller: pageController,
            itemCount: state.pillSheetTypes.length,
            onDotTapped: (page) {
              pageController.animateToPage(
                page,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          )
        ]
      ],
    );
  }
}
