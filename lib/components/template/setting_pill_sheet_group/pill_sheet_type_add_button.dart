import 'package:pilll/components/template/setting_pill_sheet_group/pill_sheet_group_select_pill_sheet_type_page.dart';

import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/localizations/l.dart';

class PillSheetTypeAddButton extends StatelessWidget {
  final Function(PillSheetType) onAdd;
  final List<PillSheetType> pillSheetTypes;
  const PillSheetTypeAddButton({
    super.key,
    required this.pillSheetTypes,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (pillSheetTypes.isEmpty) {
          showSettingPillSheetGroupSelectPillSheetTypePage(
            context: context,
            pillSheetType: null,
            onSelect: (pillSheetType) => onAdd(pillSheetType),
          );
        } else {
          onAdd(pillSheetTypes.last);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: TextColor.noshime,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              L.addPillSheet,
              style: const TextStyle(
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
