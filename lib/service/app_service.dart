import 'dart:convert';

import 'package:dd_taoke_sdk/model/room_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:gesture/controller/app_controller.dart';
import 'package:gesture/utils.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// app 服务类
///
/// 持久层
///
/// 将一直运行
class AppService extends GetxService {
  WebSocketChannel? channel;

  static AppService get instance => Get.find<AppService>();

  // 开始连接
  void startConnect() {
    final user = AppController.instance.getUser;
    if (user != null) {
      channel = WebSocketChannel.connect(
          Uri.parse('ws://192.168.199.55:12350/game/room?userId=${user.id}'));
      startListenMessage();
    }
  }

  // 监听socket返回的数据
  void startListenMessage() {
    channel?.stream.listen((message) {
      var map = <String, dynamic>{};
      final type = getKey(message.toString(), dataHandle: (v) => map = v);
      switch (type) {
        case 'inline-count-message-notify':
          // 有人登录更新人数通知
          AppController.instance.setInlineCount(map['count']);
          break;
        case 'room-by-remove':
          // 房间被销毁事件通知
          AppController.instance.removeRoom(map['name']);
          break;
        case 'new-room-by-created':
          // 新的房间被创建通知
          AppController.instance.addNewRoom(GameRoomModel.fromJson(map));
          break;
        case 'room-by-update':
          // 房间信息被更改通知
          AppController.instance.updateRoom(GameRoomModel.fromJson(map));
          break;
        case 'room-user-in':
          // 有人进入房间通知
          final roomModel = GameRoomModel.fromJson(map);
          final pkUser = roomModel.pkUser;
          if (pkUser != null) {
            showToast('${pkUser.nickName}进入了房间.');
            print('${pkUser.nickName}进入了房间');
          }

          break;
        default:
          print('收到无法解析的消息');
          break;
      }
    });
  }

  /// 获取消息类型
  String getKey(String message, {ValueChanged<Map<String, dynamic>>? dataHandle}) {
    try {
      final messageMap = jsonDecode(message);
      dataHandle?.call(jsonDecode(messageMap['json'].toString()));
      return messageMap['type'] ?? '';
    } catch (e) {
      return '';
    }
  }
}
