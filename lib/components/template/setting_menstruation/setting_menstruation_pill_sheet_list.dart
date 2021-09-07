import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/molecules/dots_page_indicator.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/setting_pill_sheet_view.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class SettingMenstruationPillSheetList extends HookWidget {
  final List<PillSheetType> pillSheetTypes;
  final int? selectedPillNumber;
  final Function(int) onPageChanged;
  final Function(int) markSelected;

  SettingMenstruationPillSheetList({
    required this.pillSheetTypes,
    required this.selectedPillNumber,
    required this.onPageChanged,
    required this.markSelected,
  });

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(
        viewportFraction: (PillSheetViewLayout.width + 20) /
            MediaQuery.of(context).size.width);
    pageController.addListener(() {
      final page = pageController.page;
      if (page != null) {
        onPageChanged(page.toInt());
      }
    });
    return Column(
      children: [
        Container(
          height: PillSheetViewLayout.calcHeight(
              _mostLargePillSheetType.numberOfLineInPillSheet, true),
          child: PageView(
            clipBehavior: Clip.none,
            controller: pageController,
            scrollDirection: Axis.horizontal,
            children: List.generate(pillSheetTypes.length, (index) {
              return [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SettingPillSheetView(
                    pageIndex: index,
                    pillSheetType: pillSheetTypes[index],
                    selectedPillNumber: selectedPillNumber,
                    markSelected: (number) => markSelected(number),
                  ),
                ),
              ];
            }).expand((element) => element).toList(),
          ),
        ),
        if (pillSheetTypes.length > 1) ...[
          SizedBox(height: 16),
          DotsIndicator(
            controller: pageController,
            itemCount: pillSheetTypes.length,
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
