import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/molecules/dots_page_indicator.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/setting_pill_sheet_view.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class SettingMenstruationPillSheetList extends HookWidget {
  final int pillSheetCount;
  final PillSheetType pillSheetType;
  final int? selectedPillNumber;
  final Function(int) markSelected;

  SettingMenstruationPillSheetList({
    required this.pillSheetCount,
    required this.pillSheetType,
    required this.selectedPillNumber,
    required this.markSelected,
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
                    pageIndex: index,
                    pillSheetType: pillSheetType,
                    selectedPillNumber: selectedPillNumber,
                    markSelected: (number) => markSelected(number),
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
