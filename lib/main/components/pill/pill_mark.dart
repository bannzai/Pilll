import 'package:Pilll/model/pill_mark_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PillMark extends StatefulWidget {
  final PillMarkType type;
  final VoidCallback tapped;
  const PillMark({
    Key key,
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
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Stack(
          children: [
            // Positioned(
            //   left: 0,
            //   top: 0,
            //   child: CustomPaint(
            //       painter: CirclePainter(
            //         _controller,
            //         color: PilllColors.primary,
            //       ),
            //       child: Container(
            //         width: 100,
            //         height: 100,
            //       )),
            // ),
            Positioned(
              left: 0,
              top: 0,
              child: Container(
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
