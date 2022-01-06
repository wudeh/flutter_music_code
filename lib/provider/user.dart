import 'package:cloud_music/util/shared_preference.dart';
import 'package:flutter/material.dart';
import '../model/login_model.dart';

class UserModel with ChangeNotifier {
  LoginModel? userInfo;

  initUserInfo(info) {
    userInfo = info;
    notifyListeners();
  }

  clearUserInfo() {
    userInfo = null;
    notifyListeners();
  }
}
