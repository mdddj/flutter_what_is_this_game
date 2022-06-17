import 'package:dataoke_sdk/model/room_model.dart';
import 'package:dataoke_sdk/model/user.dart';
import 'package:dataoke_sdk/public_api.dart';
import 'package:gesture/box_util.dart';
import 'package:gesture/service/app_service.dart';
import 'package:get/get.dart';

import '../utils.dart';

// app 全局控制器
class AppController extends GetxController {


  static AppController get instance => Get.find<AppController>();

  //已登录用户
  final Rxn<User> _user = Rxn<User>();

  // 用户jwt token
  final RxnString _token = RxnString();

  // 已创建的游戏房间
  RxList<GameRoomModel> rooms = RxList<GameRoomModel>([]);

  // 维护一个当前用户所在的房间
  Rxn<GameRoomModel> currentRoom = Rxn<GameRoomModel>(null);

  // 在线人数
  RxInt inlineUserCount = RxInt(0);

  User? get getUser=> _user.value;



  void setCurrentRoom(GameRoomModel? room){
      currentRoom.value = room;
      update();
  }


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
        AppService.instance.startConnect();
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
    getAllRooms();
    getInlineCount();
  }

  // api获取已创建房间列表
  void getAllRooms(){
    rooms.clear();
    PublicApi.req.getAllRoom().then((value) {
      rooms.addAll(value);
      update();
    });
  }

  // api获取在线人数
  void getInlineCount(){
    PublicApi.req.getInlineUserCount().then((value) {
      if(value.isNotEmpty){
        showToast('刷新成功,当前在线用户:$value');
        inlineUserCount.value = int.parse(value);
        update();
      }
    });
  }

  // 手动设置在线人数
  void setInlineCount(int count){
    inlineUserCount.value = count;
    update();
  }

  // 插入一个新房间
  void addNewRoom(GameRoomModel model){
    if(rooms.indexWhere((element) => element.roomName==model.roomName)<0){
      rooms.insert(0, model);
      update();
    }
  }

  // 删除一个房间
  Future<void> removeRoom(String roomName) async {
    await PublicApi.req.removeRoom(roomName);
    rooms.removeWhere((element) => element.roomName == roomName);
    update();
  }

  // 修改一个房间
  void updateRoom(GameRoomModel model){
    final index = rooms.indexWhere((element) => element.roomName == model.roomName);
    if(index>=0){
      // 如果找到房间,进行更新
      rooms[index] = model;
      update();
    }
  }

}
