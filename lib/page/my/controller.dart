import 'dart:convert';

import 'package:oktoast/oktoast.dart';

import '../../http/http.dart';
import '../../api/api.dart';
import '../../model/user_list_model.dart';

class MyController {
  // 获取用户歌单
  static Future<UserPlayList?> getUserPlayList(uid) async {
    try {
      String res = await HttpRequest().get(Api.getUserPlaylist + uid.toString());
      UserPlayList data = UserPlayList.fromJson(jsonDecode(res));
      return data;
    } catch (e) {
      showToast("获取用户歌单出错");
    }
  }
}
