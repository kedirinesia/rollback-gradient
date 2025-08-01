import 'package:flutter/material.dart';
import 'dart:math' as math;

class HalfCircle extends StatelessWidget {
  final double diameter;
  final Color color;

  HalfCircle({
    this.diameter = 200,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(color: this.color),
      size: Size(diameter, diameter),
    );
  }
}

class MyPainter extends CustomPainter {
  final Color color;

  MyPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi * 0,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
