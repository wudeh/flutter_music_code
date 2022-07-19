import 'dart:async';
import 'dart:convert';

import 'package:test22/api/api.dart';
import 'package:test22/event_bus/event.dart';
import 'package:test22/http/http.dart';
import 'package:test22/page/common/loading_controll.dart';
import 'package:test22/util/shared_preference.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../provider/user.dart';
import '../model/login_model.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _phone = "";

  String _number = ""; // 验证码
  Timer? _timer;
  int totalTime = 60; // 获取下一次验证码倒计时
  bool isGetChenckNum = false; // 是否正在获取验证码

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_timer != null) _timer!.cancel();
  }

  //每秒倒计时
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer) {
      //一分钟后可再次获取验证码
      if (totalTime == 0) {
        // print('时间到了');5
        _timer!.cancel();
        setState(() {
          isGetChenckNum = false;
        });
        return;
      }
      setState(() {
        totalTime--;
      });
    });
  }

  // 正则判断手机号
  bool checkPhoneRule(phoneNum) {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool matched = exp.hasMatch(phoneNum);
    return matched;
  }

  // 发送验证码
  Future<void> captchaSent() async {
    try {
      await HttpRequest.getInstance().get(Api.captchaSent + '$_phone');
    } catch (e) {
      showToast('验证码发送失败${e.toString()}');
      return;
    }
    showToast('验证码已发送');
  }

  // 验证码 手机号 登录
  Future<void> doLogin(context) async {
    Loading.showLoading(context);
    String res = '';

    try {
      res = await HttpRequest.getInstance()
          .get(Api.login + 'phone=$_phone&captcha=$_number');
    } catch (e) {
      showToast('登录失败${e.toString()}');
      Loading.closeLoading(context);
      return;
    }
    Loading.closeLoading(context);

    if (jsonDecode(res)['code'] != 200) {
      showToast(jsonDecode(res)['msg'].toString());
    } else {
      showToast("登录成功");
      LoginModel userInfo = LoginModel.fromJson(jsonDecode(res));
      // 把登录成功后 后端 返回的用户信息存起来
      MyAppSettings settings;
      final preferences = await StreamingSharedPreferences.instance;
      settings = MyAppSettings(preferences);
      // 往本地存储中储存用户信息
      settings.userInfo.setValue(userInfo.toString());
      Provider.of<UserModel>(context, listen: false).initUserInfo(userInfo);
      // 触发用户登录订阅事件
      eventBus.fire(UserLoggedInEvent());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("手机号登录"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.w,
            ),
            Text("登录体验更多精彩"),
            SizedBox(
              height: 8.w,
            ),
            Text("未注册手机号登录后将自动创建账号",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
            SizedBox(
              height: 30.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 输入手机号
                Container(
                  width: 280.w,
                  child: new TextField(
                    decoration: InputDecoration(
                        filled: true,
                        hintText: "请输入手机号码",
                        fillColor: Colors.transparent,
                        prefixIcon: Icon(Icons.phone_android)),
                    onChanged: (val) {
                      _phone = val;
                    },
                  ),
                ),
                // 输入验证码
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 180.w,
                      child: new TextField(
                        decoration: InputDecoration(
                            filled: true,
                            hintText: "请输入验证码",
                            fillColor: Colors.transparent,
                            prefixIcon: Icon(Icons.phone_android)),
                        onChanged: (val) {
                          _number = val;
                        },
                      ),
                    ),
                    Container(
                      width: 100.w,
                      child: MaterialButton(
                        color: Colors.white,
                        colorBrightness: Brightness.light,
                        child: isGetChenckNum == false
                            ? Text('验证码',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.sp))
                            : Text('倒计时${totalTime}s',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.sp)),
                        // color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (isGetChenckNum == true) {
                            return;
                          }
                          if (_phone == null || _phone.isEmpty) {
                            showToast('请输入手机号码');
                            return;
                          }
                          setState(() {
                            totalTime = 60;
                            isGetChenckNum = true;
                          });
                          // 先用正则检验手机号是否正确
                          if (checkPhoneRule(_phone) == false) {
                            showToast('请输入正确的手机号码');
                            setState(() {
                              isGetChenckNum = false;
                            });
                            return;
                          }
                          _startTimer();
                          isGetChenckNum = true;
                          captchaSent();
                        },
                      ),
                    )
                  ],
                ),
                // 登录按钮
                Container(
                    width: 100.w,
                    margin: EdgeInsets.only(top: 20.w),
                    height: 30.w,
                    child: MaterialButton(
                        onPressed: () {
                          doLogin(context);
                        },
                        textColor: Colors.white,
                        child: new Text(
                          "登录",
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        color: Theme.of(context).primaryColor,
                        shape: new StadiumBorder(
                            side: new BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.transparent,
                        ))))
              ],
            )
          ],
        ),
      ),
    );
  }
}
