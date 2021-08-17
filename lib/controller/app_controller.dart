import 'package:dd_taoke_sdk/model/user.dart';
import 'package:dd_taoke_sdk/public_api.dart';
import 'package:gesture/box_util.dart';
import 'package:get/get.dart';

import '../utils.dart';

// app 全局控制器
class AppController extends GetxController {


  static AppController get instance => Get.find<AppController>();

  //已登录用户
  Rxn<User> _user = Rxn<User>();
  RxnString _token = RxnString();

  User? get getUser=> _user.value;
  // 设置已登录用户
  set user(User user) {
    _user.value = user;
    update();
  }

  // 获取本地缓存的token数据
  Future<void> getJwtCatch() async {
    final catchToken = await BoxUtil.instance.getValue('token');
    if (catchToken != null) {
      _token.value = catchToken;
    }
  }

  // 尝试使用token进行登录
  Future<void> jwtTokenGetUser() async {
    final _userToken = _token.value;
    if (_userToken != null) {
      final tryLoginUser = await PublicApi.req.getUser(_userToken);
      if (tryLoginUser != null) {
        user = tryLoginUser;
        showToast('欢迎回来');
      }
    }
  }

  // 设置token
  void setJwtToken(String token){
    _token.value = token;
    BoxUtil.instance.setValue('token', token);
    jwtTokenGetUser();
  }

  @override
  void onReady() async {
    await getJwtCatch();
    await jwtTokenGetUser();
  }
}
