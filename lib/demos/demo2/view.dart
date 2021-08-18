import 'package:dd_taoke_sdk/model/room_model.dart';
import 'package:dd_taoke_sdk/public_api.dart';
import 'package:flutter/material.dart';
import 'package:gesture/controller/app_controller.dart';
import 'package:gesture/demos/demo2/paper_painter.dart';
import 'package:gesture/demos/demo2/point.dart';
import 'package:gesture/demos/demo2/setting/dialog.dart';
import 'package:gesture/utils.dart';
import 'package:get/get.dart';

class WhitePaper extends StatefulWidget {
  final GameRoomModel room;

  const WhitePaper({Key? key, required this.room}) : super(key: key);

  @override
  _WhitePaperState createState() => _WhitePaperState();
}

class _WhitePaperState extends State<WhitePaper> {
  final PaintModel paintModel = PaintModel();
  Color lineColor = Colors.black;
  double strokeWidth = 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 如果是房主退出房间,需要发送请求把房间删除
        await back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.room.roomName),
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              height: kToolbarHeight,
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [Text('在线玩家')],
              ),
            ),
          ),
        ),
        body: Container(
          height: kBodyHeight,
          width: Get.width,
          child: GestureDetector(
            onPanDown: _initLineData,
            onPanUpdate: _collectPoint,
            onPanEnd: _doneALine,
            onPanCancel: paintModel.removeEmpty,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: PaperPainter(paintModel),
                );
              },
            ),
          ),
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

  // 退出房间逻辑,如果是房主退出房间,则删除房间
  Future<void> back() async {
    if (AppController.instance.getUser!.id == widget.room.roomCreateUser!.id) {
      // 发送http请求删除房间,如果存在对手,则发送socket通知对方,房主退出了游戏
      print('正在删除房间');
      AppController.instance.removeRoom(widget.room.roomName);
    }
  }

  @override
  void dispose() {
    super.dispose();
    paintModel.dispose();
  }
}
