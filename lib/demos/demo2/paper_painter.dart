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
}
