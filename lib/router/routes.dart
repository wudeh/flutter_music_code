import 'package:cloud_music/router/handle/songList.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../page/404.dart';

// handle
import './handle/audio_handle.dart';
import './handle/search_handle.dart';
import './handle/comment_handle.dart';
import './handle/login_handle.dart';
import './handle/avatarUpload_handle.dart';
// handle ---end

class Routes {
  static String root = '/'; // 首页
  static String audio = '/audio'; // 进入音乐播放歌词页面
  static String search = '/search'; // 进入音乐播放歌词页面
  static String songList = '/songList'; // 进入音乐播放歌词页面
  static String comment = '/comment'; // 进入评论页面
  static String login = '/login'; // 进入登录页面
  static String avatarUpload = '/avatarUpload'; // 进入登录页面
  static String error = '/error'; // 错误

  static void configureRoutes(FluroRouter router) {
    // 定义404
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print("进入错误页面");
      print(params);
      return NotFoundPage();
    });

    // 定义路由
    router.define(search, handler: searchHandle);
    router.define(audio, handler: audioHandle);
    router.define(songList, handler: songListHandle);
    router.define(comment, handler: commentHandle);
    router.define(login, handler: loginHandle);
    router.define(avatarUpload, handler: avatarUploadHandle);
  }
}
