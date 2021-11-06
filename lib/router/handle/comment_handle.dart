import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../../page/comment.dart';

Handler commentHandle = Handler(
  handlerFunc: (BuildContext? context,Map<String,List<String>> params){
    var id = params['id']?.first;
    var type = params['type']?.first;
    return Comment(id:id, type: type,);
  }
);