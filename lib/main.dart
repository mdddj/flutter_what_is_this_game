import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '典典你画我猜小游戏',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Home(),
    );
  }
}
