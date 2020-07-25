import 'package:Pilll/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

enum PillMarkState {
  none,
  fake,
  todo,
  done,
}

class PillMark extends StatelessWidget {
  final PillMarkState state;
  const PillMark({
    Key key,
    this.state,
  }) : super(key: key);

  Color _color() {
    switch (this.state) {
      case PillMarkState.none:
        return PilllColors.potti;
      case PillMarkState.fake:
        return PilllColors.blank;
      case PillMarkState.todo:
        return PilllColors.potti;
      case PillMarkState.done:
        return PilllColors.lightGray;
      default:
        assert(false);
        return null;
    }
  }

  SvgPicture _image() {
    switch (this.state) {
      case PillMarkState.none:
        return null;
      case PillMarkState.fake:
        return null;
      case PillMarkState.todo:
        return null;
      case PillMarkState.done:
        return SvgPicture.asset("images/check_mark.svg");
      default:
        assert(false);
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      child: Center(child: _image()),
      decoration: BoxDecoration(
        color: _color(),
        shape: BoxShape.circle,
      ),
    );
  }
}
