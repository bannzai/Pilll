import 'package:pilll/components/molecules/ripple.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/svg.dart';

abstract class PillMarkConst {
  static final double edge = 20;
  static final double edgeOfRipple = 80;
}

class PillMark extends StatefulWidget {
  final PillMarkType pillSheetType;
  final bool isDone;
  final bool hasRippleAnimation;
  const PillMark({
    Key? key,
    this.hasRippleAnimation = false,
    required this.pillSheetType,
    required this.isDone,
  }) : super(key: key);

  @override
  _PillMarkState createState() => _PillMarkState();
}

class _PillMarkState extends State<PillMark> with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    // NOTE: This statement for avoid of tester.pumpAndSettle exception about timeout
    if (!Environment.isTest && !Environment.disableWidgetAnimation) {
      _controller!.repeat();
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _mark(widget.isDone, widget.pillSheetType),
        if (widget.hasRippleAnimation)
          // NOTE: pill mark size is 20px. Ripple view final size is 80px.
          // Positined ripple animation equal to (80px - 20px) / 2(to center) = 28;
          Positioned(
            left: -30,
            top: -30,
            child: Container(
              child: CustomPaint(
                size: Size(
                    PillMarkConst.edgeOfRipple, PillMarkConst.edgeOfRipple),
                painter: Ripple(
                  _controller,
                  color: PilllColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  SvgPicture _checkImage() {
    return SvgPicture.asset(
      "images/checkmark.svg",
      color: PilllColors.potti,
      width: 11,
      height: 8.5,
    );
  }

  Widget _mark(bool isDone, PillMarkType type) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      padding: EdgeInsets.zero,
      color: type == PillMarkType.rest ? PilllColors.gray : Colors.transparent,
      strokeWidth: type == PillMarkType.rest ? 1 : 0,
      child: Container(
        width: 20,
        height: 20,
        child: Center(
          child: () {
            switch (type) {
              case PillMarkType.normal:
                return null;
              case PillMarkType.rest:
                return isDone ? _checkImage() : null;
              case PillMarkType.fake:
                return isDone ? _checkImage() : null;
              case PillMarkType.selected:
                return null;
              case PillMarkType.done:
                return isDone ? _checkImage() : null;
              default:
                throw ArgumentError.notNull("");
            }
          }(),
        ),
        decoration: BoxDecoration(
          color: () {
            switch (type) {
              case PillMarkType.normal:
                return PilllColors.potti;
              case PillMarkType.rest:
                return PilllColors.blank;
              case PillMarkType.fake:
                return PilllColors.blank;
              case PillMarkType.selected:
                return PilllColors.enable;
              case PillMarkType.done:
                return PilllColors.lightGray;
              default:
                throw ArgumentError.notNull("");
            }
          }(),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
