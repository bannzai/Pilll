import 'package:pilll/components/template/setting_pill_sheet_group/pill_sheet_type_add_button.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/setting_pill_sheet_group_pill_sheet_type_select_row.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class SettingPillSheetGroup extends StatelessWidget {
  const SettingPillSheetGroup({
    Key? key,
    required this.pillSheetTypeInfos,
    required this.onAdd,
    required this.onChange,
    required this.onDelete,
  }) : super(key: key);

  final List<PillSheetTypeInfo> pillSheetTypeInfos;
  final Function(PillSheetType) onAdd;
  final Function(int, PillSheetType) onChange;
  final Function(int) onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < pillSheetTypeInfos.length; i++) ...[
          const SizedBox(height: 16),
          SettingPillSheetGroupPillSheetTypeSelectRow(
            index: i,
            pillSheetType: pillSheetTypeInfos[i],
            onSelect: onChange,
            onDelete: onDelete,
          ),
        ],
        if (pillSheetTypeInfos.length < 7) ...[
          const SizedBox(height: 24),
          PillSheetTypeAddButton(
            pillSheetTypeInfos: pillSheetTypeInfos,
            onAdd: (pillSheetType) => onAdd(pillSheetType),
          ),
        ],
        const SizedBox(height: 80),
      ],
    );
  }
}
