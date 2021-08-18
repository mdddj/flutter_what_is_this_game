import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils.dart';

/// 创建一个房间的弹窗
class CreateRoomDialog extends StatefulWidget {
  // 显示创建房间的弹窗
  static Future<String> show() async {
    return await Get.dialog<String>(CreateRoomDialog()) ?? '';
  }

  const CreateRoomDialog({Key? key}) : super(key: key);

  @override
  _CreateRoomDialogState createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("请输入房间名"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(hintText: ""),
            ),
            Text(
              '存在同名的房间会创建失败.',
              style: TextStyle(color: Colors.grey),
            ).mt
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: Get.back, child: Text('取消建房')),
        ElevatedButton(
            onPressed: () {
              Get.back(result: _textEditingController.text);
            },
            child: Text('创建房间'))
      ],
    );
  }
}
