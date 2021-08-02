import 'dart:ui';

import 'package:flutter/material.dart';

class Point {
  final double x;
  final double y;

  Point({required this.x, required this.y});

  factory Point.fromOffset(Offset offset) {
    return Point(x: offset.dx, y: offset.dy);
  }

  Offset toOffset() => Offset(x, y);
}

// 画线的三种状态
enum PaintState {
  doing, // 正在绘制
  done, // 绘制完毕
  hide // 隐藏
}

// 线条
class Line {
  List<Point> points = [];
  PaintState state;
  double strokeWidth;
  Color color;

  Line({this.color = Colors.black, this.strokeWidth = 1, this.state = PaintState.doing});

  // 执行画线的方法
  void paint(Canvas canvas, Paint paint) {
    paint
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth;
    canvas.drawPoints(PointMode.polygon, points.map((e) => e.toOffset()).toList(), paint);
  }
}

class PaintModel extends ChangeNotifier {
  List<Line?> _lines = []; // 线条的列表
  List<Line?> get lines => _lines;

  Line? get activeLine =>
      _lines.firstWhere((element) =>element!=null && element.state == PaintState.doing,orElse: ()=>null);

  //添加一个点
  void pushPoint(Point point){
    if(activeLine==null){
      return;
    }
    activeLine!.points.add(point);
    notifyListeners();
  }

  // 添加一条线
  void pushLine(Line line){
    _lines.add(line);
  }

  // 完成一条线的绘制
  void doneLine(){
    if(activeLine==null) return ;
    activeLine!.state = PaintState.done;
    notifyListeners();
  }

  // 清空
  void clear(){
    _lines.forEach((element) => element!.points.clear());// 清空点
    _lines.clear(); // 清空线
    notifyListeners();
  }

  // 清空点为零的线
  void removeEmpty(){
    _lines.removeWhere((element) => element!.points.length==0);
  }

}
