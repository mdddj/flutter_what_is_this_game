import 'package:flutter/material.dart';

typedef ColorSelectCallback = void Function(Color color);

/// 自定义颜色选择器组件
class ColorSelect extends StatefulWidget {
  final List<Color> colors;
  final double radius; // 选择的颜色圆角
  final ColorSelectCallback? onColorSelect; // 选中颜色时的回调
  final Color? defaultColor;

  const ColorSelect(
      {Key? key, required this.colors, this.radius = 5, this.onColorSelect, this.defaultColor})
      : super(key: key);

  @override
  _ColorSelectState createState() => _ColorSelectState();
}

class _ColorSelectState extends State<ColorSelect> {
  int _selectIndex = 0;

  Color get activeColor => widget.colors[_selectIndex];

  @override
  void initState() {
    super.initState();
    if (widget.defaultColor != null) {
      _selectIndex = widget.colors.indexOf(widget.defaultColor!);
    }
  }

  // 构建选择颜色的圈圈
  Widget renderItem(Color color) {
    return Container(
      width: widget.radius,
      height: widget.radius,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: activeColor == color ? renderWriteIndication() : null,
    );
  }

  // 构建白圆圈的指示器
  Widget renderWriteIndication() {
    return Container(
      width: widget.radius * 0.5,
      height: widget.radius * 0.5,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    );
  }

  // 执行选中方法,触发回调
  void _doeSelect(Color color) {
    int index = widget.colors.indexOf(color);
    if (index == _selectIndex) return;
    setState(() {
      _selectIndex = index;
    });
    widget.onColorSelect?.call(color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      child: Wrap(
        spacing: 20,
        children: widget.colors
            .map((e) => GestureDetector(
                  onTap: () => _doeSelect(e),
                  child: renderItem(e),
                ))
            .toList(),
      ),
    );
  }
}
