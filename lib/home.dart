import 'package:flutter/material.dart';
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
        title: Text('典典你画我猜小游戏'),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.person)).mr
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [actions()],
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
