import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../../page/audio/audio.dart';
var audioHandle = new Handler(
  handlerFunc: (BuildContext? context,Map<String,List<String>> params){
    String imgUrl = params['imgUrl']!.first;
    return Audio(img: imgUrl,);
  }
);