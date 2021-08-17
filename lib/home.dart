import 'package:flutter/material.dart';
import 'package:gesture/controller/app_controller.dart';
import 'package:gesture/widgets/login_tip.dart';
import 'package:get/get.dart';
import 'utils.dart';

// 首页
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('你画我猜'),
        actions: [
          Obx((){
            final user = AppController.instance.getUser;
            if(user!=null){
              return Center(child: Text('欢迎回来,${user.nickName}').mr);
            }
            return IconButton(onPressed: (){}, icon: Icon(Icons.person)).mr;
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [LoginTip(),actions()],
        ),
      ),
    );
  }

  // 操作区域
  Widget actions() {
    return Row(
      children: [ElevatedButton(onPressed: () {}, child: Text('创建房间'))],
    ).wrap;
  }
}
