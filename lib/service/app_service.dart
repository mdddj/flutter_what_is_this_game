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
      print(message);
    });
  }
}
