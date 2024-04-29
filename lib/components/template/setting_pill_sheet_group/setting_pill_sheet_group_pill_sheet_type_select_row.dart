import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/pill_sheet_group_select_pill_sheet_type_page.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class SettingPillSheetGroupPillSheetTypeSelectRow extends StatelessWidget {
  const SettingPillSheetGroupPillSheetTypeSelectRow({
    Key? key,
    required this.index,
    required this.pillSheetType,
    required this.onSelect,
    required this.onDelete,
  }) : super(key: key);

  final int index;
  final PillSheetType pillSheetType;
  final Function(int, PillSheetType) onSelect;
  final Function(int) onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              "${index + 1}枚目",
              style: const TextStyle(
                color: TextColor.main,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.japanese,
              ),
            ),
            if (index != 0) ...[
              const Spacer(),
              SizedBox(
                width: 20,
                height: 20,
                child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      onDelete(index);
                    },
                    icon: SvgPicture.asset(
                      "images/minus_icon.svg",
                      width: 20,
                      height: 20,
                    )),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            showSettingPillSheetGroupSelectPillSheetTypePage(
                context: context,
                pillSheetType: pillSheetType,
                onSelect: (pillSheetType) {
                  onSelect(index, pillSheetType);
                });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 80),
            decoration: BoxDecoration(
              color: PilllColors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(width: 1, color: PilllColors.border),
            ),
            child: Text(
              pillSheetType.fullName,
              style: const TextStyle(
                color: TextColor.main,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                fontFamily: FontFamily.japanese,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
