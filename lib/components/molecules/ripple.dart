import 'package:flutter/material.dart';
import 'dart:math' as math;

class Ripple extends CustomPainter {
  Ripple(
    this._animation, {
    required this.color,
  }) : super(repaint: _animation);

  final Color color;
  final Animation<double>? _animation;

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 2.0)).clamp(0.0, 1.0);
    final Color color = color.withOpacity(opacity);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      final animationValue = _animation?.value;
      if (animationValue == null) break;
      circle(canvas, rect, wave + animationValue);
    }
  }

  @override
  bool shouldRepaint(Ripple oldDelegate) => true;
}
