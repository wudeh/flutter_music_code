import 'package:test22/util/shared_preference.dart';
import 'package:flutter/material.dart';
import '../model/login_model.dart';

class UserModel with ChangeNotifier {
  LoginModel? userInfo;

  // 初始化用户信息
  initUserInfo(info) {
    userInfo = info;
    notifyListeners();
  }

  // 清空用户信息
  clearUserInfo() {
    userInfo = null;
    notifyListeners();
  }

  // 头像上传后改变头像地址
  changeAvatarUrl(String url) {
    userInfo?.profile?.avatarUrl = url;
    notifyListeners();
  }
}
