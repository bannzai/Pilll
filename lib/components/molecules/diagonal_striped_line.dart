import 'package:flutter/material.dart';

class DiagonalStripedLine extends CustomPainter {
  final double _blockWidth = 8;
  final Color color;
  final bool isNecessaryBorder;

  DiagonalStripedLine({required this.color, required this.isNecessaryBorder});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = color);
    if (!isNecessaryBorder) {
      return;
    }

    final emptyWidth = _blockWidth * 0.25;
    const emptyOffset = 10.0;
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
    return true;
  }
}
