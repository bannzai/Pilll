import 'package:pilll/analytics.dart';
import 'package:pilll/domain/record/components/adding/record_page_adding_pill_sheet_group_page.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RecordPageAddingPillSheet extends StatelessWidget {
  const RecordPageAddingPillSheet({
    Key? key,
    required this.context,
    required this.store,
    required this.setting,
  }) : super(key: key);

  final BuildContext context;
  final RecordPageStore store;
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
        analytics.logEvent(name: "adding_pill_sheet_tapped");
        Navigator.of(context)
            .push(RecordPageAddingPillSheetGroupPageRoute.route());
      },
    );
  }
}
