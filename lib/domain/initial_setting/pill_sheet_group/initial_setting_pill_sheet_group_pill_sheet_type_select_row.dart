import 'package:pilll/domain/initial_setting/initial_setting_state.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_page.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class InitialSettingPillSheetGroupPillSheetTypeSelectRow
    extends StatelessWidget {
  const InitialSettingPillSheetGroupPillSheetTypeSelectRow({
    Key? key,
    required this.index,
    required this.pillSheetType,
    required this.state,
    required this.store,
  }) : super(key: key);

  final int index;
  final PillSheetType pillSheetType;
  final InitialSettingState state;
  final InitialSettingStateStore store;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${index + 1}枚目",
            style: TextStyle(
              color: TextColor.main,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: FontFamily.japanese,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            constraints: BoxConstraints(minWidth: 297),
            color: PilllColors.white,
            child: Text(
              pillSheetType.fullName,
              style: TextStyle(
                color: TextColor.main,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                fontFamily: FontFamily.japanese,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension InitialSettingPillSheetCountPageRoute
    on InitialSettingPillSheetGroupPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "InitialSettingPillSheetCountPage"),
      builder: (_) => InitialSettingPillSheetGroupPage(),
    );
  }
}
