import 'package:flutter/material.dart';
import 'package:gesture/demos/demo2/point.dart';

class PaperPainter extends CustomPainter {
  final PaintModel model;

  PaperPainter(this.model) : super(repaint: model);

  Paint _paint = Paint(); // 画笔

  @override
  void paint(Canvas canvas, Size size) {
    model.lines.forEach((element) => element!.paint(canvas, _paint));
  }

  @override
  bool shouldRepaint(covariant PaperPainter oldDelegate) => oldDelegate.model != model;

  Path formPath() {
    Path path = Path();
    final points = model.activeLine!.points;
    for (int i = 0; i < points.length - 1; i++) {
      Point current = points[i];
      Point next = points[i + 1];
      if (i == 0) {
        path.moveTo(current.x, current.y);
        path.lineTo(next.x, next.y);
      } else if (i <= points.length - 2) {
        double xc = (points[i].x + points[i + 1].x) / 2;
        double yc = (points[i].y + points[i + 1].y) / 2;
        Point p2 = points[i];
        path.quadraticBezierTo(p2.x, p2.y, xc, yc);
      } else {
        path.moveTo(current.x, current.y);
        path.lineTo(next.x, next.y);
      }
    }
    return path;
  }
}
