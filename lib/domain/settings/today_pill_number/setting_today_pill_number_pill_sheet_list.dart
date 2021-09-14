import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/dots_page_indicator.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/setting_pill_sheet_view.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class SettingTodayPillNumberPillSheetList extends HookWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activedPillSheet;
  final SettingStateStore store;

  List<PillSheetType> get pillSheetTypes =>
      pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();

  const SettingTodayPillNumberPillSheetList({
    Key? key,
    required this.pillSheetGroup,
    required this.activedPillSheet,
    required this.store,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(
        viewportFraction: (PillSheetViewLayout.width + 20) /
            MediaQuery.of(context).size.width);

    return Column(
      children: [
        Container(
          height: PillSheetViewLayout.calcHeight(
            PillSheetViewLayout.mostLargePillSheetType(pillSheetTypes)
                .numberOfLineInPillSheet,
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SettingPillSheetView(
                      pageIndex: pageIndex,
                      pillSheetTypes: pillSheetTypes,
                      selectedPillNumberPageIndex: activedPillSheet.groupIndex,
                      selectedPillNumberIntoPillSheet:
                          _pillNumberIntoPillSheet(pageIndex),
                      markSelected: (pageIndex, number) {
                        analytics.logEvent(
                            name: "selected_today_number_initial_setting",
                            parameters: {
                              "pill_number": number,
                              "page": pageIndex,
                            });
                        store.modifyBeginingDate(
                            pageIndex: pageIndex,
                            pillNumberIntoPillSheet: number);
                      },
                    ),
                  ),
                  Spacer(),
                ],
              );
            }).toList(),
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

  int _pillNumberIntoPillSheet(int pageIndex) {
    final _pastedTotalCount =
        pastedTotalCount(pillSheetTypes: pillSheetTypes, pageIndex: pageIndex);
    if (_pastedTotalCount >= activedPillSheet.todayPillNumber) {
      return activedPillSheet.todayPillNumber;
    }
    return activedPillSheet.todayPillNumber - _pastedTotalCount;
  }
}
