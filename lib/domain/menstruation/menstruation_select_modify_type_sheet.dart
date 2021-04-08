import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

enum _CellType { today, yesterday, begin, edit }

extension _CellTypeFunction on _CellType {
  String get title {
    switch (this) {
      case _CellType.today:
        return "今日から生理";
      case _CellType.yesterday:
        return "昨日から生理";
      case _CellType.begin:
        return "開始日を日付から選択";
      case _CellType.edit:
        return "生理期間を編集";
    }
  }

  Widget icon(bool isSelected) {
    String name() {
      switch (this) {
        case _CellType.today:
          return "images/menstruation_record_icon.svg";
        case _CellType.yesterday:
          return "images/menstruation_record_icon.svg";
        case _CellType.begin:
          return "images/menstruation_begin_record_icon.svg";
        case _CellType.edit:
          return "images/menstruation_edit_duration_icon.svg";
      }
    }

    return SvgPicture.asset(name(),
        color: isSelected ? PilllColors.secondary : PilllColors.gray);
  }
}

class MenstruationSelectModifyTypeSheet extends StatefulWidget {
  @override
  _MenstruationSelectModifyTypeSheetState createState() =>
      _MenstruationSelectModifyTypeSheetState();
}

class _MenstruationSelectModifyTypeSheetState
    extends State<MenstruationSelectModifyTypeSheet> {
  _CellType? selectedCellType;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 21, left: 16),
              child: Text("生理を記録",
                  style: FontType.sBigTitle.merge(TextColorStyle.main)),
            ),
            SizedBox(height: 24),
            SizedBox(
              height: 192,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: _CellType.values
                    .map(
                      (e) => _tile(e),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(_CellType type) {
    // TODO:
    //     return SizedBox(
    //   height: 48,
    //   child: ListTile(
    //     title: Text(
    //       type.title,
    //       style: FontType.assisting.merge(selectedCellType == type
    //           ? TextColorStyle.main
    //           : TextColorStyle.gray),
    //     ),
    //     leading: type.icon(selectedCellType == type),
    //     selected: selectedCellType == type,
    //     selectedTileColor: PilllColors.secondary.withOpacity(0.08),
    //     onTap: () => setState(() => selectedCellType = type),
    //   ),
    // );
    return SizedBox(
      height: 48,
      child: GestureDetector(
        child: Container(
          color: selectedCellType == type
              ? PilllColors.secondary.withOpacity(0.08)
              : PilllColors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                type.icon(selectedCellType == type),
                SizedBox(width: 30),
                Text(
                  type.title,
                  style: FontType.assisting.merge(
                    selectedCellType == type
                        ? TextColorStyle.main
                        : TextColorStyle.gray,
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () => setState(() => selectedCellType = type),
      ),
    );
  }
}

void presentMenstruationSelectModify(
  BuildContext context,
) {
  showModalBottomSheet(
    context: context,
    builder: (context) => MenstruationSelectModifyTypeSheet(),
  );
}
