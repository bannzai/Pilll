import 'package:pilll/components/template/setting_pill_sheet_group/pill_sheet_group_select_pill_sheet_type_page.dart';

import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class PillSheetTypeAddButton extends StatelessWidget {
  final Function(PillSheetType) onAdd;
  final List<PillSheetTypeInfo> pillSheetTypeInfos;
  const PillSheetTypeAddButton({
    Key? key,
    required this.pillSheetTypeInfos,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (pillSheetTypeInfos.isEmpty) {
          showSettingPillSheetGroupSelectPillSheetTypePage(
            context: context,
            pillSheetType: null,
            onSelect: (pillSheetType) => onAdd(pillSheetType),
          );
        } else {
          onAdd(pillSheetTypeInfos.last);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: TextColor.noshime,
              size: 20,
            ),
            SizedBox(width: 4),
            Text(
              "ピルシートを追加",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
