import 'dart:convert';

import 'package:cloud_music/api/api.dart';
import 'package:oktoast/oktoast.dart';

import '../../http/http.dart';

import '../../model/msg_private.dart';

class Controller {
  // 获取用户私信
  static Future<MsgPrivateModel?> getUserPrivateMsg(int offset) async {
    try {
      String res = await HttpRequest().get(Api.privateMsg + "?offset=${offset}");
      MsgPrivateModel data = MsgPrivateModel.fromJson(jsonDecode(res));
      return data;
    } catch (e) {
      showToast("获取私信出错");
    }
  }
}
