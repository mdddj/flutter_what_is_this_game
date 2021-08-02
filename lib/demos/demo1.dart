import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double kSpringWidth = 30; // 弹簧的宽度
const double kSpringDefaultHeight = 100; // 弹簧的高度
const double kRateOfMove = 1.5; // 移动距离和形变量比值

class Demo1 extends StatefulWidget {
  const Demo1({Key? key}) : super(key: key);

  @override
  _Demo1State createState() => _Demo1State();
}

class _Demo1State extends State<Demo1> with SingleTickerProviderStateMixin {
  ValueNotifier<double> height = ValueNotifier(kSpringDefaultHeight);
  double s = 0; // 移动距离
  late AnimationController _animationController;
  double laseMoveLen = 0;
  final Duration animationDuration = const Duration(milliseconds: 10000);
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: animationDuration)
      ..addListener(updateHeightByAnimation);
    animation = CurvedAnimation(parent: _animationController, curve: Curves.bounceOut);
  }

  void updateHeightByAnimation() {
    s = laseMoveLen * (1 - animation.value);
    print(s);
    height.value = kSpringDefaultHeight + (-s / kRateOfMove);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onVerticalDragUpdate: onUpdate,
        onVerticalDragEnd: animationToDefault,
        child: Container(
          width: kSpringWidth,
          height: 100,
          color: Colors.grey.shade200,
          child: CustomPaint(
            painter: SpringWidget(20, height),
          ),
        ),
      ),
    );
  }

  double get dx => -s / kRateOfMove;

  // 拖动开始
  void onUpdate(DragUpdateDetails details) {
    s += details.delta.dy;
    // print('开始拖动,距离为:$s');
    height.value = kSpringDefaultHeight + dx;
  }

  // 动画还原弹簧
  void animationToDefault(_) {
    laseMoveLen = s;
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    super.dispose();
    height.dispose();
    _animationController.removeListener(updateHeightByAnimation);
    _animationController.dispose();
  }
}

class SpringWidget extends CustomPainter {
  final int count; // 节数
  ValueListenable<double> height;

  SpringWidget(this.count, this.height) : super(repaint: height); // 组件高度

  Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    // 移动画板位置到底部
    canvas.translate(30, size.height);
    Path springPath = Path();
    springPath.relativeLineTo(-kSpringWidth, 0);
    final space = height.value / (count - 1); // 每一节弹簧的高度
    for (var i = 0; i < count; i++) {
      if (i == 0) {
        springPath.relativeLineTo(kSpringWidth, -space);
      }
      if (i % 2 == 1) {
        springPath.relativeLineTo(kSpringWidth, -space);
      } else {
        springPath.relativeLineTo(-kSpringWidth, -space);
      }
    }
    springPath.relativeLineTo(count.isOdd ? kSpringWidth : -kSpringWidth, 0);
    canvas.drawPath(springPath, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
