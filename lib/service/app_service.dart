import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gesture/controller/app_controller.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// app 服务类
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
          AppController.instance.setInlineCount(map['count']);
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
