import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/dots_page_indicator.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/domain/record/components/pill_sheet/record_page_pill_sheet.dart';
import 'package:pilll/domain/record/record_page_state.codegen.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordPagePillSheetList extends HookConsumerWidget {
  const RecordPagePillSheetList({
    Key? key,
    required this.state,
    required this.store,
    required this.setting,
  }) : super(key: key);

  final RecordPageState state;
  final RecordPageStateNotifier store;
  final Setting setting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillSheetGroup = state.pillSheetGroup;
    if (pillSheetGroup == null) {
      return Container();
    }

    final pageController = usePageController(
        initialPage: state.initialPageIndex,
        viewportFraction: (PillSheetViewLayout.width + 20) /
            MediaQuery.of(context).size.width);
    return Column(
      children: [
        Container(
          height: PillSheetViewLayout.calcHeight(
            PillSheetViewLayout.mostLargePillSheetType(pillSheetGroup.pillSheets
                    .map((e) => e.pillSheetType)
                    .toList())
                .numberOfLineInPillSheet,
            false,
          ),
          child: PageView(
            clipBehavior: Clip.none,
            controller: pageController,
            scrollDirection: Axis.horizontal,
            children: pillSheetGroup.pillSheets
                .map((pillSheet) {
                  return [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: RecordPagePillSheet(
                        pillSheetGroup: pillSheetGroup,
                        pillSheet: pillSheet,
                        store: store,
                        state: state,
                        setting: setting,
                      ),
                    ),
                  ];
                })
                .expand((element) => element)
                .toList(),
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
              })
        ]
      ],
    );
  }
}
