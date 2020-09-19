import 'package:Pilll/main/components/pill/pill_mark_model.dart';
import 'package:Pilll/main/components/pill/pill_sheet_model.dart';
import 'package:Pilll/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

enum PillMarkType {
  normal,
  notTaken,
  selected,
  done,
}

extension PillMarkTypeFunctions on PillMarkType {
  SvgPicture image() {
    switch (this) {
      case PillMarkType.normal:
        return null;
      case PillMarkType.notTaken:
        return null;
      case PillMarkType.selected:
        return null;
      case PillMarkType.done:
        return SvgPicture.asset("images/check_mark.svg");
      default:
        assert(false);
        return null;
    }
  }

  @override
  Color color() {
    switch (this) {
      case PillMarkType.normal:
        return PilllColors.potti;
      case PillMarkType.notTaken:
        return PilllColors.blank;
      case PillMarkType.selected:
        return PilllColors.enable;
      case PillMarkType.done:
        return PilllColors.lightGray;
      default:
        assert(false);
        return null;
    }
  }
}

class PillMark extends StatelessWidget {
  final PillMarkType type;
  final VoidCallback tapped;
  const PillMark({
    Key key,
    @required this.type,
    this.tapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          width: 20,
          height: 20,
          child: Center(
            child: type.image(),
          ),
          decoration: BoxDecoration(
            color: type.color(),
            shape: BoxShape.circle,
          ),
        ),
        onTap: tapped);
  }
}
