import 'package:Pilll/components/molecules/ripple.dart';
import 'package:Pilll/entity/pill_mark_type.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PillMark extends StatefulWidget {
  final PillMarkType type;
  final bool isDone;
  final VoidCallback tapped;
  final bool hasRippleAnimation;
  const PillMark({
    Key key,
    this.hasRippleAnimation = false,
    @required this.type,
    @required this.tapped,
    @required this.isDone,
  }) : super(key: key);

  @override
  _PillMarkState createState() => _PillMarkState();
}

class _PillMarkState extends State<PillMark> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    // NOTE: This statement for avoid of tester.pumpAndSettle exception about timeout
    if (!Environment.isTest) {
      _controller.repeat();
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
    return GestureDetector(
        child: Stack(
          overflow: Overflow.visible,
          children: [
            PillMarkTypeFunctions.create(widget.isDone, widget.type),
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
