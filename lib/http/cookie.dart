import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

// 管理 cookie
class MyCookie {
  static String? _cookiePath;
  static Future<String> get cookiePath async {
    if (_cookiePath == null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      _cookiePath = appDocDir.path;
    }
    return _cookiePath!;
  }

  static PersistCookieJar? _cookieJar;
  static Future<PersistCookieJar> get cookieJar async {
    if (_cookieJar == null) {
      String path = await cookiePath;
      _cookieJar = PersistCookieJar(storage: FileStorage(path));
    }
    return _cookieJar!;
  }
}