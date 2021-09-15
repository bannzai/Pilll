import 'package:pilll/components/organisms/pill_mark/pill_mark.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dotted_border/dotted_border.dart';

class NormalPillMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: PillMarkConst.edge,
      height: PillMarkConst.edge,
      decoration: BoxDecoration(
        color: PilllColors.potti,
        shape: BoxShape.circle,
      ),
    );
  }
}

class RestPillMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      padding: EdgeInsets.zero,
      color: PilllColors.gray,
      strokeWidth: 1,
      child: Container(
        width: PillMarkConst.edge,
        height: PillMarkConst.edge,
        decoration: BoxDecoration(
          color: PilllColors.blank,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class FakePillMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: PillMarkConst.edge,
      height: PillMarkConst.edge,
      decoration: BoxDecoration(
        color: PilllColors.blank,
        shape: BoxShape.circle,
      ),
    );
  }
}

class SelectedPillMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: PillMarkConst.edge,
      height: PillMarkConst.edge,
      decoration: BoxDecoration(
        color: PilllColors.enable,
        shape: BoxShape.circle,
      ),
    );
  }
}

class LightGrayPillMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: PillMarkConst.edge,
      height: PillMarkConst.edge,
      decoration: BoxDecoration(
        color: PilllColors.lightGray,
        shape: BoxShape.circle,
      ),
    );
  }
}
