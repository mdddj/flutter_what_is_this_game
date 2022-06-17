import 'package:dataoke_sdk/model/room_model.dart';
import 'package:dataoke_sdk/model/user.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesture/controller/app_controller.dart';
import 'package:get/get.dart';
import '../utils.dart';

class Rooms extends StatelessWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rooms = AppController.instance.rooms;
      if (rooms.isNotEmpty) {
        return ListView.builder(
          itemBuilder: (_, i) => renderItem(rooms[i]),
          itemCount: rooms.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        );
      }
      return Card(
        child: Container(
          height: 200,
          alignment: Alignment.center,
          child: Text('暂无房间.速去创建一个吧'),
        ),
      );
    });
  }

  // 渲染房间布局
  Widget renderItem(GameRoomModel room) {
    return PhysicalModel(
      color: Colors.white,
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('房间名:${room.roomName}'),
            Divider(),
            if (room.roomCreateUser != null) renderUserInfo('房主', room.roomCreateUser!),
            if (room.pkUser != null) renderUserInfo('对手', room.pkUser!),
            Row(
              children: [
                ElevatedButton(
                        onPressed: () {
                          toPkView(room);
                        },
                        child: Text('开始对战'))
                    .mr,
                OutlinedButton(onPressed: (){
                  showToast('暂不支持');
                }, child: Text('观战')).mr
              ],
            ).mt,
          ],
        ),
      ),
    ).mt;
  }

  Widget renderUserInfo(String title, User user) {
    return Row(
      children: [
        Text('$title:').mr,
        ExtendedImage.network(
          user.picture,
          borderRadius: BorderRadius.circular(100),
          shape: BoxShape.circle,
          width: 50,
          height: 50,
        ).mr,
        Text('${user.nickName}')
      ],
    ).mt;
  }
}
