import 'package:dd_taoke_sdk/model/room_model.dart';
import 'package:flutter/cupertino.dart';
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


void showToast(String msg){
  ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text(msg)));
}

double get kBodyHeight => Get.height - Get.mediaQuery.padding.top - kToolbarHeight;

void toPkView(GameRoomModel room){
  Get.to(()=>WhitePaper(room: room));
}