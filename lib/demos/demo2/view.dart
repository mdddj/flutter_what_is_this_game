import 'package:dataoke_sdk/model/room_model.dart';
import 'package:dataoke_sdk/public_api.dart';
import 'package:fbroadcast_nullsafety/fbroadcast_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:gesture/controller/app_controller.dart';
import 'package:gesture/demos/demo2/paper_painter.dart';
import 'package:gesture/demos/demo2/point.dart';
import 'package:gesture/demos/demo2/setting/dialog.dart';
import 'package:gesture/service/app_service.dart';
import 'package:gesture/utils.dart';
import 'package:gesture/widgets/user_avator.dart';
import 'package:get/get.dart';

// 对战房间
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
  void initState() {
    super.initState();
    Future.microtask(() async {
      final user = AppController.instance.getUser;
      if (user != null && user.id != widget.room.roomCreateUser!.id) {
        // 表示我是参战选手
        await PublicApi.req.inRoom(user.id.toString(), widget.room.roomName);

        // 获取房间最新的信息
        final roomInfo = await PublicApi.req.getRoomInfo(widget.room.roomName);

        if (roomInfo == null) {
          showToast('房间不存在');
          Get.back();
        }
        // 设置当前所在房间
        AppController.instance.setCurrentRoom(roomInfo);
      }



      FBroadcast.instance(Get.context)!.register('refresh', (value, callback) {
        // 刷新画板

        final point = Point.fromMap(value as Map<String,dynamic>);
        print('刷新画板回调:${point.toJSON()}');
        Line line = Line(color: lineColor, strokeWidth: strokeWidth);
        paintModel.pushLine(line);
        paintModel.pushPoint(point);
        paintModel.doneLine();
      });


    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 如果是房主退出房间,需要发送请求把房间删除
        await backHandle();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.room.roomName),
          actions: [
            // 开始对战按钮
            Obx(() {
              final currRoom = AppController.instance.currentRoom.value;
              final user = AppController.instance.getUser;
              final isCheck = currRoom != null &&
                  user != null &&
                  currRoom.roomCreateUser != null &&
                  currRoom.roomCreateUser!.id == user.id;
              return isCheck
                  ? ElevatedButton(onPressed: () {}, child: Text('开始对战')).wrap
                  : Container(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('准备'),
                      ),
                    ).wrap;
            }),

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
              padding: EdgeInsets.symmetric(horizontal: 12),
              height: kToolbarHeight,
              decoration: BoxDecoration(color: Colors.white),
              child: Obx(() {
                final currentRoom = AppController.instance.currentRoom.value;
                if (currentRoom == null) {
                  return Container();
                }
                return Row(
                  children: [
                    UserAva(
                      user: currentRoom.roomCreateUser,
                    ).mr,
                    UserAva(
                      user: currentRoom.pkUser,
                    ).mr,
                  ],
                );
              }),
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
    final point = Point.fromOffset(details.localPosition);
    paintModel.pushPoint(point);

    if (isRoomUser) {
      // 如果房主在画画
      AppService.instance.sendMessage(
          AppController.instance.currentRoom.value!.pkUser!.id.toString(), 'brush', point.toJSON());
    }
  }

  /// 判断是否为房主
  bool get isRoomUser =>
      AppController.instance.currentRoom.value!.roomCreateUser!.id ==
      AppController.instance.getUser!.id;

  // 拖动结束时执行
  void _doneALine(DragEndDetails details) {
    // 将doing状态的线设置为done
    paintModel.doneLine();
  }

  // 退出房间逻辑,如果是房主退出房间,则删除房间
  Future<void> backHandle() async {
    if (AppController.instance.getUser!.id == widget.room.roomCreateUser!.id) {
      // 发送http请求删除房间,如果存在对手,则发送socket通知对方,房主退出了游戏
      print('正在删除房间');
      AppController.instance.removeRoom(widget.room.roomName);
    }
  }

  @override
  void dispose() {
    FBroadcast.instance(Get.context)!.clear('refresh');
    paintModel.dispose();
    super.dispose();
  }
}
