import 'package:flutter/material.dart';

/// 选中回调
typedef LineWidthOnSelect = void Function(double width);

/// 自定义线的粗细设置
class CustomLineWidth extends StatefulWidget {
  final List<double> numbers; // 线的宽度可配置列表
  final double width;
  final LineWidthOnSelect? onSelect;
  final double? currentWidth;

  const CustomLineWidth(
      {Key? key, required this.numbers, this.width = 25, this.onSelect, this.currentWidth})
      : super(key: key);

  @override
  _CustomLineWithState createState() => _CustomLineWithState();
}

class _CustomLineWithState extends State<CustomLineWidth> {
  int _selectIndex = 0;

  double get activeWidth => widget.numbers[_selectIndex];

  @override
  void initState() {
    super.initState();
    if (widget.currentWidth != null) {
      _selectIndex = widget.numbers.indexOf(widget.currentWidth!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Wrap(
        spacing: 20,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: widget.numbers
            .map((e) => GestureDetector(
                  onTap: () => _onSelect(e),
                  child: renderItem(e),
                ))
            .toList(),
      ),
    );
  }

  /// 渲染一个项目
  Widget renderItem(double item) {
    return Container(
      alignment: Alignment.center,
      height: widget.width,
      width: widget.width,
      padding: EdgeInsets.all(5),
      decoration: activeWidth == item
          ? BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(5))
          : null,
      child: Container(
        height: item,
        decoration: BoxDecoration(color: Colors.black),
      ),
    );
  }

  /// 选中事件
  void _onSelect(double width) {
    int index = widget.numbers.indexOf(width);
    if (index == _selectIndex) return;
    setState(() {
      _selectIndex = index;
    });
    widget.onSelect?.call(width);
  }
}
