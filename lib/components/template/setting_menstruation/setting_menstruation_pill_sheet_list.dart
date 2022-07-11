import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/dots_page_indicator.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/setting_pill_sheet_view.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';

class SettingMenstruationPillSheetList extends HookConsumerWidget {
  final List<PillSheetType> pillSheetTypes;
  final int? Function(int pageIndex) selectedPillNumber;
  final PillSheetAppearanceMode appearanceMode;
  final Function(int pageIndex, int pillNumber) markSelected;

  const SettingMenstruationPillSheetList({
    Key? key,
    required this.pillSheetTypes,
    required this.selectedPillNumber,
    required this.appearanceMode,
    required this.markSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(
        viewportFraction: (PillSheetViewLayout.width + 20) /
            MediaQuery.of(context).size.width);
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: PillSheetViewLayout.calcHeight(
              PillSheetViewLayout.mostLargePillSheetType(pillSheetTypes)
                  .numberOfLineInPillSheet,
              true,
            ),
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
                      appearanceMode: appearanceMode,
                      pillSheetTypes: pillSheetTypes,
                      selectedPillNumberIntoPillSheet:
                          selectedPillNumber(pageIndex),
                      markSelected: (pageIndex, number) =>
                          markSelected(pageIndex, number),
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
          )
        ]
      ],
    );
  }
}
