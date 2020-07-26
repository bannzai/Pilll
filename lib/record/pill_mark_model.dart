import 'package:Pilll/color.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/record/pill_mark.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract class PillMarkModel {
  Color color();
  SvgPicture image();
}

class MainPillMarkModel extends PillMarkModel {
  final PillMarkState state;
  final PillSheetType pillSheetType;
  MainPillMarkModel(this.state, this.pillSheetType);

  @override
  Color color() {
    switch (state) {
      case PillMarkState.none:
        return PilllColors.potti;
      case PillMarkState.notTaken:
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

  @override
  SvgPicture image() {
    switch (state) {
      case PillMarkState.none:
        return null;
      case PillMarkState.notTaken:
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
}

class InitialSettingPillMarkModel extends PillMarkModel {
  final int index;
  final bool isSelected;
  final PillSheetType pillSheetType;
  InitialSettingPillMarkModel(
      {this.index, this.isSelected, this.pillSheetType});

  @override
  Color color() {
    if (isSelected) {
      return PilllColors.selected;
    }
    if (index >= pillSheetType.beginingWithoutTakenPeriod) {
      return PilllColors.blank;
    }
    return PilllColors.lightGray;
  }

  @override
  SvgPicture image() {
    return null;
  }
}
