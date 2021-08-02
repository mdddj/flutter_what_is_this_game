import 'package:flutter/material.dart';
import 'package:gesture/demos/demo2/setting/custom_color_widget.dart';
import 'package:gesture/demos/demo2/setting/custom_line_width.dart';
import 'package:get/get.dart';

/// 定义默认可选择的配置
const List<Color> kDefaultSettingColors = [
  Colors.black,
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.cyan
];

/// 定义可选择的线条
const kDefaultSettingWidth = [1.0, 3.0, 5.0, 6.0, 8.0, 9.0, 12.0, 25.0];

class SettingDialog extends StatelessWidget {
  final ColorSelectCallback colorSelectCallback;
  final LineWidthOnSelect lineWidthOnSelect;

  const SettingDialog(
      {Key? key, required this.colorSelectCallback, required this.lineWidthOnSelect})
      : super(key: key);

  static void show(
      {required ColorSelectCallback colorSelectCallback,
      required LineWidthOnSelect lineWidthOnSelect}) {
    Get.bottomSheet(
        SettingDialog(
            colorSelectCallback: colorSelectCallback, lineWidthOnSelect: lineWidthOnSelect),
        backgroundColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ColorSelect(
            colors: kDefaultSettingColors,
            onColorSelect: colorSelectCallback,
            radius: 30,
          ),
          Divider(),
          CustomLineWidth(
            numbers: kDefaultSettingWidth,
            onSelect: lineWidthOnSelect,
          )
        ],
      ),
    );
  }
}
