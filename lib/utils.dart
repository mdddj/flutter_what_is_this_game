import 'dart:convert';

import 'package:dataoke_sdk/model/room_model.dart';
import 'package:dataoke_sdk/public_api.dart';
import 'package:flutter/material.dart';
import 'package:gesture/demos/demo2/view.dart';
import 'package:get/get.dart';

extension WidgetExtensions on Widget {
  Widget get wrap => _wrap();
  Widget _wrap() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: this,
    );
  }
  Widget get mr => Padding(padding: EdgeInsets.only(right: 12),child: this);
  Widget get mt => Padding(padding: EdgeInsets.only(top: 12),child: this);
}

// api 扩展
extension PublicApiExtensions on PublicApi {

  /// 获取房间数据
  Future<GameRoomModel?> getRoomInfo(String roomName) async {
   final result = await  this.util.get('$userApiUrl/room-info',data: {
      'roomName':roomName
    },isTaokeApi: false);
    return result.isNotEmpty ? GameRoomModel.fromJson(jsonDecode(result)) : null;
  }

}



void showToast(String msg){
  ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text(msg)));
}

double get kBodyHeight => Get.height - Get.mediaQuery.padding.top - kToolbarHeight;

void toPkView(GameRoomModel room){
  Get.to(()=>WhitePaper(room: room));
}