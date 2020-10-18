import 'package:Pilll/main/components/ripple.dart';
import 'package:Pilll/model/pill_mark_type.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PillMark extends StatefulWidget {
  final PillMarkType type;
  final VoidCallback tapped;
  final bool hasRippleAnimation;
  const PillMark({
    Key key,
    this.hasRippleAnimation = false,
    @required this.type,
    @required this.tapped,
  }) : super(key: key);

  @override
  _PillMarkState createState() => _PillMarkState();
}

class _PillMarkState extends State<PillMark> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    if (widget.hasRippleAnimation) {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this,
      );
      // NOTE: This statement for avoid of tester.pumpAndSettle exception about timeout
      if (!Environment.isTest) {
        _controller.repeat();
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.hasRippleAnimation) {
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              width: 20,
              height: 20,
              child: Center(
                child: widget.type.image(),
              ),
              decoration: BoxDecoration(
                color: widget.type.color(),
                shape: BoxShape.circle,
              ),
            ),
            if (widget.hasRippleAnimation)
              Positioned(
                left: -30,
                top: -30,
                child: Container(
                  child: CustomPaint(
                    size: Size(80, 80),
                    painter: Ripple(
                      _controller,
                      color: PilllColors.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
        onTap: widget.tapped);
  }
}
