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

  const PillMark({
    super.key,
    required this.pillMarkType,
    required this.showsCheckmark,
    required this.showsRippleAnimation,
  });

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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            switch (widget.pillMarkType) {
              PillMarkType.normal => const NormalPillMark(),
              PillMarkType.rest => const RestPillMark(),
              PillMarkType.fake => const FakePillMark(),
              PillMarkType.selected => const SelectedPillMark(),
              PillMarkType.done => const LightGrayPillMark(),
            },
            if (widget.showsCheckmark) const Align(alignment: Alignment.center, child: PillMarkDoneMark()),
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
