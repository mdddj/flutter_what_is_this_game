import 'package:dataoke_sdk/model/user.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

// 用户头像
class UserAva extends StatelessWidget {
  final User? user;

  const UserAva({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) return Container();
    return Container(
      child: ExtendedImage.network(
        user!.picture,
        width: 35,
        height: 35,
        borderRadius: BorderRadius.circular(100),
        shape: BoxShape.circle,
      ),
    );
  }
}
