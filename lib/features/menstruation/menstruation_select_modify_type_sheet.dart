import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

enum MenstruationSelectModifyType { today, yesterday, begin }

extension _CellTypeFunction on MenstruationSelectModifyType {
  String get title {
    switch (this) {
      case MenstruationSelectModifyType.today:
        return "今日から生理";
      case MenstruationSelectModifyType.yesterday:
        return "昨日から生理";
      case MenstruationSelectModifyType.begin:
        return "生理開始日を選択";
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
      }
    }

    return SvgPicture.asset(name(), colorFilter: const ColorFilter.mode(PilllColors.primary, BlendMode.srcIn));
  }
}

const double _tileHeight = 48;

class MenstruationSelectModifyTypeSheet extends StatelessWidget {
  final Function(MenstruationSelectModifyType) onTap;

  const MenstruationSelectModifyTypeSheet({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 21, left: 16),
              child: Text("生理を記録",
                  style: TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: TextColor.main,
                  )),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: _tileHeight * MenstruationSelectModifyType.values.length,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
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
      height: _tileHeight,
      child: ListTile(
        title: Text(
          type.title,
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w300,
            fontSize: 14,
            color: TextColor.main,
          ),
        ),
        leading: type.icon,
        onTap: () {
          onTap(type);
        },
      ),
    );
  }
}
