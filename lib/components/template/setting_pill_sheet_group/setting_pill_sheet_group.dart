import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/pill_sheet_type_add_button.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/setting_pill_sheet_group_pill_sheet_type_select_row.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class SettingPillSheetGroup extends StatelessWidget {
  const SettingPillSheetGroup({
    Key? key,
    required this.pillSheetTypes,
    required this.onAdd,
    required this.onChange,
    required this.onDelete,
  }) : super(key: key);

  final List<PillSheetType> pillSheetTypes;
  final Function(PillSheetType) onAdd;
  final Function(int, PillSheetType) onChange;
  final Function(int) onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < pillSheetTypes.length; i++) ...[
          const SizedBox(height: 16),
          SettingPillSheetGroupPillSheetTypeSelectRow(
            index: i,
            pillSheetType: pillSheetTypes[i],
            onSelect: onChange,
            onDelete: onDelete,
          ),
        ],
        if (pillSheetTypes.length < 7) ...[
          const SizedBox(height: 24),
          PillSheetTypeAddButton(
            pillSheetTypes: pillSheetTypes,
            onAdd: (pillSheetType) => onAdd(pillSheetType),
          ),
        ],
        const SizedBox(height: 80),
      ],
    );
  }
}

class SettingPillSheetTakesTwicePerDayToggle extends HookConsumerWidget {
  final ValueNotifier<bool> value;

  const SettingPillSheetTakesTwicePerDayToggle(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(children: [
      const Text("1日に2回服用する", style: TextStyle(color: TextColor.main, fontFamily: FontFamily.japanese, fontSize: 14, fontWeight: FontWeight.w500)),
      const Spacer(),
      Switch(value: value.value, onChanged: (value) => this.value.value = value),
    ]);
  }
}
