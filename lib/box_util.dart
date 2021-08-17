import 'package:hive/hive.dart';

/// 默认盒子名字
const defaultBoxName = 'appBox';

/// box 工具类
class BoxUtil {
  static BoxUtil get instance => BoxUtil._();

  BoxUtil._();

  factory BoxUtil() => BoxUtil._();
  Box? _box;

  /// 打开一个盒子
  Future<Box> openBox({String? name}) async {
    var box = await Hive.openBox(name ?? defaultBoxName);
    _box ??= box;
    return _box!;
  }

  /// 设置一个值
  Future<void> setValue(dynamic key, dynamic value) async {
    if (_box == null) {
      /// 如果盒子是空的,打开默认的盒子
      await openBox();
    }
    await _box!.put(key, value);
  }

  /// 获取一个值
  Future<dynamic> getValue(dynamic key) async {
    _box ??= await openBox();
    return _box!.get(key);
  }

  /// 关闭盒子
  void closeBox() => _box = null;
}
