import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/dots_page_indicator.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/setting_pill_sheet_view.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class SelectTodayPillNumberPillSheet extends HookWidget {
  final InitialSettingState state;
  final InitialSettingStateStore store;

  SelectTodayPillNumberPillSheet({
    required this.state,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final pillSheetType = state.pillSheetType;
    if (pillSheetType == null) {
      throw AssertionError("PillSheetType should be selected");
    }
    final pillSheetCount = state.pillSheetCount;
    final pageController = usePageController(
        viewportFraction: (PillSheetViewLayout.width + 20) /
            MediaQuery.of(context).size.width);
    return Column(
      children: [
        Container(
          height: PillSheetViewLayout.calcHeight(
              pillSheetType.numberOfLineInPillSheet, true),
          child: PageView(
            clipBehavior: Clip.none,
            controller: pageController,
            scrollDirection: Axis.horizontal,
            children: List.generate(pillSheetCount, (index) {
              return [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SettingPillSheetView(
                    pillSheetType: pillSheetType,
                    selectedPillNumber: state.todayPillNumber,
                    markSelected: (number) {
                      analytics.logEvent(
                          name: "selected_today_number_initial_setting",
                          parameters: {"pill_number": number});
                      store.setTodayPillNumber(number);
                    },
                  ),
                ),
              ];
            }).expand((element) => element).toList(),
          ),
        ),
        if (pillSheetCount > 1) ...[
          SizedBox(height: 16),
          DotsIndicator(
            controller: pageController,
            itemCount: pillSheetCount,
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
