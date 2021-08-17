import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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