import 'package:flutter/material.dart';

class DiagonalStripedLine extends CustomPainter {
  final double _blockWidth = 8;
  final Color color;

  DiagonalStripedLine(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final emptyWidth = _blockWidth * 0.25;
    final emptyOffset = 10.0;
    final count = size.width / _blockWidth;
    for (int i = 0; i < count; i++) {
      final offset = i.toDouble() * _blockWidth;
      final path = Path()
        ..moveTo(offset, size.height)
        ..lineTo(offset + emptyWidth, size.height)
        ..lineTo(offset + emptyWidth + emptyOffset, 0)
        ..lineTo(offset + emptyOffset, 0)
        ..close();
      canvas.drawPath(path, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
