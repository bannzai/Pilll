import 'package:pilll/analytics.dart';
import 'package:pilll/features/record/components/add_pill_sheet_group/add_pill_sheet_group_page.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddPillSheetGroupEmptyFrame extends StatelessWidget {
  const AddPillSheetGroupEmptyFrame({
    Key? key,
    required this.context,
    required this.pillSheetGroup,
    required this.setting,
  }) : super(key: key);

  final BuildContext context;
  final PillSheetGroup? pillSheetGroup;
  final Setting setting;

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
              children: const <Widget>[
                Icon(Icons.add, color: TextColor.noshime),
                Text("ピルシートを追加",
                    style: TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: TextColor.noshime,
                    )),
              ],
            )),
          ],
        ),
      ),
      onTap: () async {
        analytics.logEvent(name: "adding_pill_sheet_tapped");
        Navigator.of(context).push(AddPillSheetGroupPageRoute.route(
          pillSheetGroup: pillSheetGroup,
          setting: setting,
        ));
      },
    );
  }
}
