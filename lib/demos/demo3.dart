import 'package:flutter/material.dart';

const w = 200.0;
const h = 100.0;

class Demo3 extends StatefulWidget {
  const Demo3({Key? key}) : super(key: key);

  @override
  _Demo3State createState() => _Demo3State();
}

class _Demo3State extends State<Demo3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: w,
          height: h,
          color: Colors.grey.shade50,
          child: ClipPath(
            clipper: CustomChipPath(),
            child: Container(
              width: w,
              height: h,
              color: Colors.green,
              child: Text('1'),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomChipPath extends CustomClipper<Path> {
  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;

  @override
  Path getClip(Size size) {
    print(size);
    Path path = Path();

    path.lineTo(0, h * 0.5);

    const p1 = Offset(w/2, h);
    const p2 = Offset(w, h*0.5);
    path.quadraticBezierTo(p1.dx, p1.dy,p2.dx,p2.dy);

    path.lineTo(w, 0);

    return path;
  }
}
