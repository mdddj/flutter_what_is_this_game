import 'package:flutter/material.dart';
import 'package:gesture/demos/demo2/paper_painter.dart';
import 'package:gesture/demos/demo2/point.dart';
import 'package:gesture/demos/demo2/setting/dialog.dart';

class WhitePaper extends StatefulWidget {
  const WhitePaper({Key? key}) : super(key: key);

  @override
  _WhitePaperState createState() => _WhitePaperState();
}

class _WhitePaperState extends State<WhitePaper> {
  final PaintModel paintModel = PaintModel();
  Color lineColor = Colors.black;
  double strokeWidth = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                SettingDialog.show(colorSelectCallback: (c) {
                  lineColor = c;
                }, lineWidthOnSelect: (w) {
                  strokeWidth = w;
                });
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: GestureDetector(
        onPanDown: _initLineData,
        onPanUpdate: _collectPoint,
        onPanEnd: _doneALine,
        onPanCancel: paintModel.removeEmpty,
        child: CustomPaint(
          size: MediaQuery.of(context).size,
          painter: PaperPainter(paintModel),
        ),
      ),
    );
  }

  // 当拖动按下时执行
  void _initLineData(DragDownDetails details) {
    // 创建一个line对象.通过pushLine维护到paintModel 中, line默认的状态是doing
    Line line = Line(color: lineColor, strokeWidth: strokeWidth);
    paintModel.pushLine(line);
  }

  // 拖动更新时执行
  void _collectPoint(DragUpdateDetails details) {
    /// paintModel#pushPoint 将一个点对象添加到doing的线中,就是[#_initLineData]创建的线对象中
    paintModel.pushPoint(Point.fromOffset(details.localPosition));
  }

  // 拖动结束时执行
  void _doneALine(DragEndDetails details) {
    // 将doing状态的线设置为done
    paintModel.doneLine();
  }

  @override
  void dispose() {
    super.dispose();
    paintModel.dispose();
  }
}
