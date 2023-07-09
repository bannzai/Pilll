import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/pill_sheet_type_add_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/setting_pill_sheet_group_pill_sheet_type_select_row.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class SettingPillSheetGroup extends HookConsumerWidget {
  const SettingPillSheetGroup({
    Key? key,
    required this.pillSheetTypes,
    required this.onAdd,
    required this.onChange,
    required this.onDelete,
  }) : super(key: key);

  final List<PillSheetType> pillSheetTypes;
  final Function(PillSheetType, bool) onAdd;
  final Function(int, PillSheetType, bool) onChange;
  final Function(int) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillSheetIsTwoTaken = useState(false);
    return Column(
      children: [
        for (var i = 0; i < pillSheetTypes.length; i++) ...[
          const SizedBox(height: 16),
          SettingPillSheetGroupPillSheetTypeSelectRow(
            index: i,
            pillSheetType: pillSheetTypes[i],
            onSelect: (index, pillSheetType) => onChange(index, pillSheetType, pillSheetIsTwoTaken.value),
            onDelete: onDelete,
          ),
        ],
        if (pillSheetTypes.length < 7) ...[
          const SizedBox(height: 24),
          PillSheetTypeAddButton(
            pillSheetTypes: pillSheetTypes,
            onAdd: (pillSheetType) => onAdd(pillSheetType, pillSheetIsTwoTaken.value),
          ),
        ],
        Row(children: [
          const Text("1日に2回服用する"),
          const Spacer(),
          Switch(value: pillSheetIsTwoTaken.value, onChanged: (value) => pillSheetIsTwoTaken.value = value)
        ]),
        const SizedBox(height: 80),
      ],
    );
  }
}
