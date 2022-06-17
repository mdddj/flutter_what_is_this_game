import 'package:dataoke_sdk/network/util.dart';
import 'package:dataoke_sdk/public_api.dart';
import 'package:dd_check_plugin/dd_check_plugin.dart';
import 'package:flutter/material.dart';
import 'package:gesture/controller/app_controller.dart';
import 'package:gesture/widgets/create_room_dialog.dart';
import 'package:gesture/widgets/login_tip.dart';
import 'package:get/get.dart';
import 'utils.dart';
import 'widgets/inline_user_count_show.dart';
import 'widgets/rooms.dart';

// 首页
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      DdCheckPlugin.instance.init(DdTaokeUtil.instance.createInstance()!);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('你画我猜'),
        actions: [
          Obx(() {
            final user = AppController.instance.getUser;
            if (user != null) {
              return Center(child: Text('欢迎回来,${user.nickName}').mr);
            }
            return IconButton(onPressed: () {}, icon: const Icon(Icons.person)).mr;
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [const LoginTip(), actions(), const Rooms().wrap],
        ),
      ),
    );
  }

  // 操作区域
  Widget actions() {
    return Row(
      children: [
        // 创建房间的按钮,没有登录不能创建
        Obx(() {
          return ElevatedButton(
              onPressed: AppController.instance.getUser == null
                  ? null
                  : () async {
                      final roomName = await CreateRoomDialog.show();
                      if (roomName.isNotEmpty) {
                        createRoom(roomName);
                      }
                    },
              child: const Text('创建房间'));
        }).mr,
        TextButton(onPressed: AppController.instance.getAllRooms, child: const Text('刷新房间列表')).mr,
        const InlineCountShow().mr
      ],
    ).wrap;
  }

  // 创建房间逻辑
  Future<void> createRoom(String roomName) async {
    print('用户创建房间:$roomName');
    final newRoom =
        await PublicApi.req.createRoom(AppController.instance.getUser!.id, roomName, error: (c, m,d) {
      showToast(m);
    });
    if (newRoom != null) {
      // 插入到房间列表
      AppController.instance.addNewRoom(newRoom);

      // 进入房间对战
      toPkView(newRoom);

      // 设置当前维护的房间信息
      AppController.instance.setCurrentRoom(newRoom);
    }
  }
}
