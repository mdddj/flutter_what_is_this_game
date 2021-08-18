import 'package:flutter/material.dart';
import 'package:gesture/controller/app_controller.dart';
import 'package:get/get.dart';

// 显示在线人数的组件
class InlineCountShow extends StatelessWidget {
  const InlineCountShow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx((){
        final count = AppController.instance.inlineUserCount.value;
        return Container(
          child: TextButton(
            onPressed: AppController.instance.getInlineCount,
            child: Text('当前在线:$count '),
          ),
        );
      }
      ),
    );
  }
}
