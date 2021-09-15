import 'package:pilll/components/molecules/ripple.dart';
import 'package:pilll/components/organisms/pill_mark/done_mark.dart';
import 'package:pilll/components/organisms/pill_mark/pill_marks.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class PillMarkConst {
  static final double edge = 20;
  static final double edgeOfRipple = 80;
}

class PillMark extends StatefulWidget {
  final PillMarkType pillMarkType;
  final bool isDone;
  final bool hasRippleAnimation;
  const PillMark({
    Key? key,
    this.hasRippleAnimation = false,
    required this.pillMarkType,
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
        _mark(widget.pillMarkType),
        if (widget.isDone) PillMarkDoneMark(),
        if (widget.hasRippleAnimation)
          // NOTE: pill mark size is 20px. Ripple view final size is 80px.
          // Positined ripple animation equal to (80px - 20px) / 2(to center) = 30;
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

  Widget _mark(PillMarkType type) {
    switch (type) {
      case PillMarkType.normal:
        return NormalPillMark();
      case PillMarkType.rest:
        return RestPillMark();
      case PillMarkType.fake:
        return FakePillMark();
      case PillMarkType.selected:
        return SelectedPillMark();
      case PillMarkType.done:
        return LightGrayPillMark();
    }
  }
}
