import 'package:test22/page/my/local_download.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../../page/my/downloading.dart';

var localDownloadHandle = new Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return LocalDownload();
});
