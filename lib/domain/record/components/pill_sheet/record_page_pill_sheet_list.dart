import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/organisms/pill/pill_sheet_view_layout.dart';
import 'package:pilll/domain/record/components/pill_sheet/record_page_pill_sheet.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordPagePillSheetList extends HookWidget {
  const RecordPagePillSheetList({
    Key? key,
    required this.state,
    required this.store,
    required this.setting,
  }) : super(key: key);

  final RecordPageState state;
  final RecordPageStore store;
  final Setting setting;

  @override
  Widget build(BuildContext context) {
    final pillSheetGroup = state.pillSheetGroup;
    if (pillSheetGroup == null) {
      return Container();
    }
    return Container(
      height: PillSheetViewLayout.calcHeight(
          pillSheetGroup.pillSheets.first.pillSheetType.numberOfLineInPillSheet,
          false),
      child: PageView(
        clipBehavior: Clip.none,
        controller: PageController(
            viewportFraction: (PillSheetViewLayout.width + 20) /
                MediaQuery.of(context).size.width),
        scrollDirection: Axis.horizontal,
        children: pillSheetGroup.pillSheets
            .map((pillSheet) {
              return [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: RecordPagePillSheet(
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
    );
  }
}
