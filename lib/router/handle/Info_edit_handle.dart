import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../../page/my/info_edit.dart';
var userInfoEditHandle = new Handler(
  handlerFunc: (BuildContext? context,Map<String,List<String>> params){
    return UserInfoEditPage();
  }
);