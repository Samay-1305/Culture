import 'package:culture/constants/color_contants.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class StockPainter extends CustomPainter {
  double x;
  bool isPressed;
  List<Offset> points;
  Color midlineColor;
  Color graphColor;
  StockPainter({this.x, this.isPressed, this.points, this.midlineColor, this.graphColor});

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = PointMode.polygon;

    final verticalLinePoints = [
      Offset(x, 0),
      Offset(x, 250)
    ];

    final paint = Paint()
      ..color = graphColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintVertical = Paint()
      ..color = midlineColor.withOpacity(0.8)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    final midLinePaint = Paint()
      ..color = midlineColor.withOpacity(0.8)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    var max = 300; // size gets to width
    var dashWidth = 5;
    var dashSpace = 5;
    double startX = 0;
    final space = (dashSpace + dashWidth);

    while (startX < max) {
      canvas.drawLine(Offset(startX, 125.0), Offset(startX + dashWidth, 125.0), midLinePaint);
      startX += space;
    }

    canvas.drawPoints(pointMode, points, paint);
    if (isPressed) {
      canvas.drawPoints(pointMode, verticalLinePoints, paintVertical);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}