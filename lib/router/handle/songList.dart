import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../../page/play_list/songList.dart';

Handler songListHandle = Handler(
  handlerFunc: (BuildContext? context,Map<String,List<String>> params){
    var id = params['id']?.first;
    String imgUrl = params['imgUrl']!.first;
    return SongListPage(id:id,img: imgUrl,);
  }
);