import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

enum MenstruationSelectModifyType { today, yesterday, begin, edit }

extension _CellTypeFunction on MenstruationSelectModifyType {
  String get title {
    switch (this) {
      case MenstruationSelectModifyType.today:
        return "今日から生理";
      case MenstruationSelectModifyType.yesterday:
        return "昨日から生理";
      case MenstruationSelectModifyType.begin:
        return "開始日を日付から選択";
      case MenstruationSelectModifyType.edit:
        return "生理期間を編集";
    }
  }

  Widget get icon {
    String name() {
      switch (this) {
        case MenstruationSelectModifyType.today:
          return "images/menstruation_record_icon.svg";
        case MenstruationSelectModifyType.yesterday:
          return "images/menstruation_record_icon.svg";
        case MenstruationSelectModifyType.begin:
          return "images/menstruation_begin_record_icon.svg";
        case MenstruationSelectModifyType.edit:
          return "images/menstruation_edit_duration_icon.svg";
      }
    }

    return SvgPicture.asset(name(), color: PilllColors.secondary);
  }
}

class MenstruationSelectModifyTypeSheet extends StatelessWidget {
  final Function(MenstruationSelectModifyType) onTap;

  const MenstruationSelectModifyTypeSheet({Key? key, required this.onTap})
      : super(key: key);

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
                children: MenstruationSelectModifyType.values
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

  Widget _tile(MenstruationSelectModifyType type) {
    return SizedBox(
      height: 48,
      child: ListTile(
        title: Text(
          type.title,
          style: FontType.assisting.merge(TextColorStyle.main),
        ),
        leading: type.icon,
        onTap: () {
          onTap(type);
        },
      ),
    );
  }
}
