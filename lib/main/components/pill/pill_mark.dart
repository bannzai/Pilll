import 'package:Pilll/main/components/ripple.dart';
import 'package:Pilll/model/pill_mark_type.dart';
import 'package:Pilll/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PillMark extends StatefulWidget {
  final PillMarkType type;
  final VoidCallback tapped;
  final bool shoulAnimation;
  const PillMark({
    Key key,
    this.shoulAnimation = false,
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
    if (widget.shoulAnimation) {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this,
      )..repeat();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.shoulAnimation) {
      _controller.dispose();
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
            if (widget.shoulAnimation)
              Positioned(
                left: -30,
                top: -30,
                width: 80,
                height: 80,
                child: Container(
                  child: CustomPaint(
                    size: Size(80, 80),
                    painter: CirclePainter(
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

// Widget _rippleAnimation(Widget child) {
//   return AnimatedBuilder(
//     child: child,
//     animation: _controller,
//     builder: (BuildContext context, Widget child) {
//       final keyContext = stickyKey.currentContext;
//       if (keyContext != null) {
//         final box = keyContext.findRenderObject() as RenderBox;
//         final pos = box.localToGlobal(Offset.zero);
//         return Positioned(
//           top: pos.dy,
//           left: pos.dx,
//           height: box.size.height,
//           child: CustomPaint(
//             painter: CirclePainter(
//               _controller,
//               color: PilllColors.primary,
//             ),
//             child: Container(
//               width: box.size.width * 4.125,
//               height: box.size.height * 4.125,
//             ),
//           ),
//         );
//       }
//       return Container();
//     },
//   );
// }
