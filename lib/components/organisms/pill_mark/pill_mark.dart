import 'package:pilll/components/molecules/ripple.dart';
import 'package:pilll/components/organisms/pill_mark/done_mark.dart';
import 'package:pilll/components/organisms/pill_mark/pill_marks.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class PillMarkConst {
  static const double edge = 20;
  static const double edgeOfRipple = 80;
}

class PillMark extends StatefulWidget {
  final PillMarkType pillMarkType;
  final bool showsCheckmark;
  final bool showsRippleAnimation;
  final int? remainingPillTakenCount;

  const PillMark({
    Key? key,
    required this.pillMarkType,
    required this.showsCheckmark,
    required this.showsRippleAnimation,
    required this.remainingPillTakenCount,
  }) : super(key: key);

  @override
  PillMarkState createState() => PillMarkState();
}

class PillMarkState extends State<PillMark> with TickerProviderStateMixin {
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
    final remainingPillTakenCount = widget.remainingPillTakenCount;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            () {
              // TODO: Rewrite to switch expression after upgrade dart version up to 3.0.1
              switch (widget.pillMarkType) {
                case PillMarkType.normal:
                  return const NormalPillMark();
                case PillMarkType.rest:
                  return const RestPillMark();
                case PillMarkType.fake:
                  return const FakePillMark();
                case PillMarkType.selected:
                  return const SelectedPillMark();
                case PillMarkType.done:
                  return const LightGrayPillMark();
              }
            }(),
            if (widget.showsCheckmark) const Align(alignment: Alignment.center, child: PillMarkDoneMark()),
            if (remainingPillTakenCount != null) Text("$remainingPillTakenCount", style: const TextStyle(color: PilllColors.gray, fontSize: 10)),
          ],
        ),
        if (widget.showsRippleAnimation)
          // NOTE: pill mark size is 20px. Ripple view final size is 80px.
          // Positined ripple animation equal to (80px - 20px) / 2(to center) = 30;
          Positioned(
            left: -30,
            top: -30,
            child: CustomPaint(
              size: const Size(PillMarkConst.edgeOfRipple, PillMarkConst.edgeOfRipple),
              painter: Ripple(
                _controller,
                color: PilllColors.secondary,
              ),
            ),
          ),
      ],
    );
  }
}
