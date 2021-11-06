import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../../page/search/search.dart';
var searchHandle = new Handler(
  handlerFunc: (BuildContext? context,Map<String,List<String>> params){
    return SearchPage();
  }
);