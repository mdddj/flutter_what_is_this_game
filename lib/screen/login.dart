import 'package:dataoke_sdk/public_api.dart';
import 'package:flutter/material.dart';
import 'package:gesture/controller/app_controller.dart';
import 'package:get/get.dart';
import '../utils.dart';

/// 登录页面
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController loginNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          child: Column(
            children: [
              TextField(
                controller: loginNameController,
                decoration: const InputDecoration(hintText: '用户名'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(hintText: '密码'),
                keyboardType: TextInputType.visiblePassword ,
                obscureText: true,
              ),
              ElevatedButton(onPressed: submit, child: const Text('登录')).mt
            ],
          ),
        ),
      ),
    );
  }

  // 尝试登录
  Future<void> submit() async {
    final loginName = loginNameController.text;
    final password = passwordController.text;
    if (loginName.isEmpty || password.isEmpty) {
      showToast('请输入用户名或者密码');
      return;
    }
    final success = await PublicApi.req.login(loginName, password,
        loginFail: showToast, tokenHandle: AppController.instance.setJwtToken);
    if (success) {
      Get.back();
    }
  }
}
