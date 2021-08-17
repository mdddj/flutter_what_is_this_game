import 'package:flutter/material.dart';
import 'package:gesture/controller/app_controller.dart';
import 'package:gesture/screen/login.dart';
import 'package:get/get.dart';
import '../utils.dart';

/// 登录提示
class LoginTip extends StatelessWidget {
  const LoginTip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLogin = AppController.instance.getUser != null;
      if (isLogin) {
        return Container();
      }
      return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(.17),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          children: [
            Expanded(child: Text('请先登录再进行游戏')),
            TextButton(onPressed: (){
              Get.to(()=>LoginScreen());
            }, child: Text('前往登录'))
          ],
        ),
      ).wrap;
    });
  }
}
