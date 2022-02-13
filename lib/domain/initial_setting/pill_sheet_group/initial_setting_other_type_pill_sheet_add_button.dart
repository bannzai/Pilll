import 'package:pilll/analytics.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/pill_sheet_group_select_pill_sheet_type_page.dart';
import 'package:pilll/domain/initial_setting/initial_setting_state.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/domain/record/components/adding/record_page_adding_pill_sheet_group_page.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InitialSettingOtherTypePillSheetAddButton extends StatelessWidget {
  const InitialSettingOtherTypePillSheetAddButton({
    Key? key,
    required this.state,
    required this.store,
  }) : super(key: key);

  final InitialSettingState state;
  final InitialSettingStateStore store;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        width: 316,
        height: 316,
        child: Stack(
          children: <Widget>[
            Center(
              child: SvgPicture.asset(
                "images/empty_frame.svg",
              ),
            ),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add, color: TextColor.noshime),
                Text("ピルシートを追加",
                    style: FontType.assisting.merge(TextColorStyle.noshime)),
              ],
            )),
          ],
        ),
      ),
      onTap: () async {
        analytics.logEvent(name: "tap_initial_setting_other_type_add");
        showSettingPillSheetGroupSelectPillSheetTypePage(
          context: context,
          pillSheetType: null,
          onSelect: (pillSheetType) {
            store.addPillSheetType(pillSheetType);
          },
        );
      },
    );
  }
}
