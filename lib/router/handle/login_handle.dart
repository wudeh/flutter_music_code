import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../../page/Login.dart';
var loginHandle = new Handler(
  handlerFunc: (BuildContext? context,Map<String,List<String>> params){
    return LoginPage();
  }
);