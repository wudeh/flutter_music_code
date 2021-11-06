import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../../page/songList.dart';

Handler songListHandle = Handler(
  handlerFunc: (BuildContext? context,Map<String,List<String>> params){
    var id = params['id']?.first;
    return SongListPage(id:id);
  }
);