import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../../page/my/downloading.dart';
var downloadingHandle = new Handler(
  handlerFunc: (BuildContext? context,Map<String,List<String>> params){
    return DownloadingPage();
  }
);