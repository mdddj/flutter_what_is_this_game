import 'package:dd_taoke_sdk/network/util.dart';
import 'package:flutter/material.dart';
import 'package:gesture/service/app_service.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controller/app_controller.dart';
import 'home.dart';

void main() async{
  await Hive.initFlutter();
  Get.put(AppController());
  Get.put(AppService());
  DdTaokeUtil.instance.init('http://192.168.199.55', '80');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '典典你画我猜小游戏',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Home(),
    );
  }
}
