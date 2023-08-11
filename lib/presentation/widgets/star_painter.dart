import 'package:flutter/material.dart';
import 'dart:math' as math;

class StarPainter extends CustomPainter {
  final double size;
  final Color color;

  StarPainter({required this.size, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double halfSize = this.size / 2;

    Path path = Path();
    for (int i = 0; i < 5; i++) {
      double x = halfSize + math.cos(i * 0.4 * math.pi) * halfSize;
      double y = halfSize + math.sin(i * 0.4 * math.pi) * halfSize;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
