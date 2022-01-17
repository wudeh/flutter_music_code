

import 'package:cloud_music/page/Drawer/msg_private.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
var MsgPageHandle = new Handler(
  handlerFunc: (BuildContext? context,Map<String,List<String>> params){
    return MsgPrivatePage();
  }
);