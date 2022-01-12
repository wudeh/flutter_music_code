import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../../page/common/crop_image.dart';
var avatarUploadHandle = new Handler(
  handlerFunc: (BuildContext? context,Map<String,List<String>> params){
    return CropImage();
  }
);