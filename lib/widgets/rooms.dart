import 'package:dd_taoke_sdk/model/room_model.dart';
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
      return Container();
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
            Row(
              children: [
                Text('房主:').mr,
                if (room.roomCreateUser != null)
                  ExtendedImage.network(
                    room.roomCreateUser!.picture,
                    borderRadius: BorderRadius.circular(100),
                    shape: BoxShape.circle,
                    width: 50,
                    height: 50,
                  ).mr,
                if (room.roomCreateUser != null)
                  Text('${room.roomCreateUser!.nickName}')
              ],
            ),

            ElevatedButton(onPressed: (){}, child: Text('开始对战')).mt

          ],
        ),
      ),
    ).mt;
  }
}
