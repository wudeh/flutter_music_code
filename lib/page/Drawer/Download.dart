import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../common/dialog.dart';
import '../../api/api.dart';
import 'package:package_info/package_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:isolate';

class DownloadPage extends StatefulWidget {
  DownloadPage({Key? key}) : super(key: key);

  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  ReceivePort _port = ReceivePort();

  String version = "";

  String downloadPath = "";

  // 获取当前应用版本
  void GetVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      // 得到当前应用版本号
      setState(() {
        version = packageInfo.version;
      });
    });
  }

  // 检查应用是否需要更新版本
  void CheckVersion() async {
    showToast("检查更新中");
    // 先获取线上应用的版本信息
    var data;
    var dataKey = {'_api_key': Api.API_KEY, 'appKey': Api.APP_KEY};
    Response response;
    Dio dio = new Dio();
    response = await dio.post(Api.checkVersion, queryParameters: dataKey);
    data = json.decode(response.toString());
    data = data['data'];
    // 进行版本号比对
    var checek = version.compareTo(data['buildVersion']);
    // 当前版本小于线上版本就要更新了
    if (checek == -1) {
      // 获取线上安装包大小 这里的请求要用 使用application/x-www-form-urlencoded编码
      response = await dio.post(Api.appSize,
          data: dataKey,
          options: Options(contentType: Headers.formUrlEncodedContentType));
      var dataSize = json.decode(response.toString());
      dataSize = dataSize['data'];
      dataSize = dataSize['buildFileSize'];
      // 计算安装包大小
      int Size = int.parse(dataSize);
      double appSize = Size / 1024 / 1024;
      String finalSize = appSize.toStringAsFixed(2);
      // 拼接一下更新描述说明
      String description = data['buildUpdateDescription'];
      // 弹出是否更新对话框
      showDialog(
          context: context,
          builder: (context) {
            return DialogShow(
                title: '确定更新？',
                subTitle: '更新说明：',
                smallSubTitle: '新版本安装包大小为' + finalSize + 'MB',
                description: description,
                yes: download);
          },
          barrierDismissible: false);
    } else {
      showToast('已经是最新版本');
    }
  }

  // 更新下载安装
  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      print('UI Isolate Callback: $data');
      print("这是安装包print");
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      // 下载完成 关闭进度条对话框，打开安装包
      if (status == DownloadTaskStatus.complete) {
        // flutter_downloader的open方法不能再下载完成后打开
        // 解决方法：由于下载太快，某些通知没有完成，所以实际上并没完成收尾工作，所以打不开。只需要Sleep 1s就可以了
        //程序休眠1s,保证下载事项处理完成
        // sleep(Duration(seconds: 1));
        showToast('下载完成咯');
        // FlutterDownloader.open(taskId: id).then((value) => null);

        await OpenFile.open(downloadPath);
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  // 下载
  Future<void> download() async {
    // 记得下载之前一定要申请存储权限，而且在 main 目录下的 AndroidManifest 中加配置，不然不行
    _checkPermission();
    // 获取文件存储路径，记得去 AndroidManifest 配置
    final appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    // final folderName="some_name";
    // final path= Directory("storage/emulated/0/$folderName"); // 这种写法可以在根目录创建文件夹
    String appDocPath = appDocDir!.path; // 这种存到根目录
    var _localPath = appDocPath + "/apk";
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      print(savedDir);
      print("创建文件夹");
      savedDir.create();
    }
    downloadPath = _localPath;
    String? taskId = await FlutterDownloader.enqueue(
        url:
            Api.install + '?_api_key=' + Api.API_KEY + '&appKey=' + Api.APP_KEY,
        savedDir: _localPath,
        saveInPublicStorage: true,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
        fileName: '简单音乐.apk');

  }

  // 申请权限
  Future<void> _checkPermission() async {
    await Permission.storage.request();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bindBackgroundIsolate();

    // 获取当前版本
    GetVersion();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        CheckVersion();
      },
      leading: Icon(Icons.system_update, color: Theme.of(context).primaryColor),
      title: Text(
        '检查更新',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      subtitle: Text(
        '当前版本 $version',
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
