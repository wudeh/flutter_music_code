import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:test22/api/api.dart';
import 'package:test22/http/http.dart';
import 'package:test22/model/download_flac.dart';
import 'package:test22/model/song_url.dart';
import 'package:test22/provider/user.dart';
import 'package:test22/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../model/login_model.dart';

// 下载中的音乐信息
class DownloadProvider with ChangeNotifier {
  List downloadList = [];

  ReceivePort _port = ReceivePort();

  bool portListen = false;

  Map info = {
    "taskId": "",
    "id": "",
    "url": "",
    "file_name": "",
    "author": "",
    "album": "",
    "status": 2, // 是否正在下载 6 代表暂停下载， 2 代表 正在下载，3 代表完成下载，4 代表下载失败
    "DownloadSize": '0M', // 目前下载的总大小
    "size": 0, // 下载音乐大小
    "progress": 0, // 下载百分比进度
    "sizeStr": '0M', // 下载音乐大小
  };

  // 监听下载音乐
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

      String id = data[0];
      // print("这是歌曲print $id");
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setDownloadSecond(id, progress);
      // 下载完成
      if (status == DownloadTaskStatus.complete) {
        int length = downloadList.length;
        for (var e = 0; e < length; e++) {
          if (downloadList[e]['taskId'] == id) {
            downloadList[e]['status'] = 3;
            break;
          }
        }
        notifyListeners();
      }
      // 下载暂停
      if (status == DownloadTaskStatus.paused) {
        int length = downloadList.length;
        for (var e = 0; e < length; e++) {
          if (downloadList[e]['taskId'] == id) {
            downloadList[e]['status'] = 6;
            break;
          }
        }
        notifyListeners();
      }
      // 下载失败
      if (status == DownloadTaskStatus.failed) {
        int length = downloadList.length;
        for (var e = 0; e < length; e++) {
          if (downloadList[e]['taskId'] == id) {
            downloadList[e]['status'] = 4;
            break;
          }
        }
        notifyListeners();
      }
      // 下载中
      if (status == DownloadTaskStatus.complete) {
        int length = downloadList.length;
        for (var e = 0; e < length; e++) {
          if (downloadList[e]['taskId'] == id) {
            downloadList[e]['status'] = 2;
            break;
          }
        }
        notifyListeners();
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  // 下载一首
  downloadOne(BuildContext context, i) async {
    if (!portListen) {
      _bindBackgroundIsolate();
      portListen = true;
    }
    info = i;
    info['status'] = 2;
    info['size'] = 0;
    info['progress'] = 0.0;
    info['DownloadSize'] = '0M';
    downloadList.add(info);

    await getUrl(i['id'].toString());

    bool status = await Permission.storage.isGranted;
    await Permission.storage.isDenied;
    await Permission.storage.isLimited;
    await Permission.storage.isPermanentlyDenied;
    //判断如果还没拥有读写权限就申请获取权限
    if (!status) {
      await Permission.storage.request().isGranted;
      await Permission.storage.request().isDenied;
      await Permission.storage.request().isLimited;
      await Permission.storage.request().isPermanentlyDenied;
    }

    // 调用下载方法 --------做该做的事

    var externalStorageDirPath;
    // if (Platform.isAndroid) {
    //   final directory = await getExternalStorageDirectory();
    //   externalStorageDirPath = directory?.path;
    // } else if (Platform.isIOS) {
    externalStorageDirPath = (Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationSupportDirectory())!
        .path;
    // }

    print("第一个path${externalStorageDirPath}");

    var _localPath = externalStorageDirPath + "/Download";
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      print(savedDir);
      savedDir.create();
    }

    String? taskId = await FlutterDownloader.enqueue(
      url: info['url'],
      fileName: info['file_name'] + ".mp3",
      savedDir: _localPath,
      showNotification: true,
      openFileFromNotification: true,
      saveInPublicStorage: true,
      // headers: {'cookie': Provider.of<UserModel>(context,listen: false).userInfo?.cookie ?? ''}
    );

    print("下载的 taskI ${taskId.toString()}");

    info['taskId'] = taskId;

    notifyListeners();
  }

  // 获取 URL，size
  Future<void> getUrl(String id) async {
    var res;
    // 优先获取无损音质
    res = await HttpRequest().get('${Api.downloadUrl}&id=$id');

    var jsonInfo = json.decode(res.toString());
    DownloadFlacModel flacModel = DownloadFlacModel.fromJson(jsonInfo);

    // 无损音质可能会有获取不到 URL 的情况
    if (flacModel.data?.url != null) {
      // 算一下文件大小
      info['size'] = flacModel.data!.size!;
      info['sizeStr'] =
          (flacModel.data!.size! / (1024 * 1024)).toStringAsFixed(2) + 'M';
      info['url'] = flacModel.data!.url;
    } else {
      // 无损音质获取不到就获取普通音质
      res = await HttpRequest().get('${Api.songUrl}&id=$id');
      //
      // var res = await HttpRequest().get('${Api.downloadUrl}&id=$id');
      jsonInfo = json.decode(res.toString());
      SongUrlModel a = SongUrlModel.fromJson(jsonInfo);
      // 算一下文件大小
      info['size'] = a.data![0].size!;
      info['sizeStr'] =
          (a.data![0].size! / (1024 * 1024)).toStringAsFixed(2) + 'M';
      info['url'] = a.data![0].url;
    }
    // 下载列表中找一下赋予计算出来的文件大小
    int length = downloadList.length;
    for (var e = 0; e < length; e++) {
      if (downloadList[e]['id'] == id) {
        downloadList[e]['size'] = info['size'];
        downloadList[e]['sizeStr'] = info['sizeStr'];
        downloadList[e]['url'] = info['url'];
      }
    }

    notifyListeners();
  }

  // 设置每秒下载大小
  setDownloadSecond(String taskId, int progress) {
    int length = downloadList.length;
    for (var e = 0; e < length; e++) {
      if (downloadList[e]['taskId'] == taskId) {
        if (progress >= 100) showToast("${downloadList[e]['file_name']}下载完成");
        if (downloadList[e]['size'] != 0) {
          // 目前下载的大小
          downloadList[e]['DownloadSize'] =
              (downloadList[e]['size'] * (progress / 100) / (1024 * 1024))
                      .toStringAsFixed(2) +
                  "M";
          downloadList[e]['progress'] = progress.toDouble();
          // print(downloadList[e]['DownloadSize']);
          // print(progress);
        }

        break;
      }
    }
    notifyListeners();
  }

  // 设置下载大小
  void setSize(int size) {
    info['size'] = size;
    notifyListeners();
  }

  // 删除一项
  void deleteOne(int index, [bool deleteContent = true]) {
    // 默认会删除下载的本地文件
    FlutterDownloader.remove(
        taskId: downloadList[index]['taskId'],
        shouldDeleteContent: deleteContent);
    downloadList.removeAt(index);
    notifyListeners();
  }

  // 清空下载
  void clearDownloadList([bool deleteContent = true]) {
    if (deleteContent) {
      downloadList.forEach((e) {
        FlutterDownloader.remove(
            taskId: e['taskId'], shouldDeleteContent: deleteContent);
      });
    }

    downloadList.clear();

    notifyListeners();
  }

  /// 改变下载状态
  Future<void> changeDownload(int index) async {
    /// 暂停下载中要继续下载
    if (downloadList[index]['status'] == 6) continueDownload(index);

    /// 下载中要 暂停下载
    if (downloadList[index]['status'] == 2) pauseDownload(index);
    // 下载失败重试
    if (downloadList[index]['status'] == 4) retryDownload(index);
    notifyListeners();
  }

  /// description 暂停下载
  Future<void> pauseDownload(int index) async {
    FlutterDownloader.pause(taskId: downloadList[index]['taskId']);
    downloadList[index]['status'] = 6;
    notifyListeners();
  }

  /// 全部暂停下载
  Future<void> pauseAll() async {
    int length = downloadList.length;
    for (var e = 0; e < length; e++) {
      pauseDownload(e);
    }
    notifyListeners();
  }

  /// description 继续下载
  Future<void> continueDownload(int index) async {
    String oldId = downloadList[index]['taskId'];
    String? newId = await FlutterDownloader.resume(taskId: oldId);
    int length = downloadList.length;
    // 继续下载会返回一个新的 taskId ，要改一下
    for (var e = 0; e < length; e++) {
      if (downloadList[e]['taskId'] == oldId) {
        downloadList[e]['taskId'] = newId;
        downloadList[e]['status'] = 2;
        break;
      }
    }
    notifyListeners();
  }

  /// 全部继续下载
  Future<void> continueAll() async {
    int length = downloadList.length;
    for (var e = 0; e < length; e++) {
      continueDownload(e);
    }
    notifyListeners();
  }

  /// 重试失败的任务
  Future<void> retryDownload(int index) async {
    String oldId = downloadList[index]['taskId'];
    String? newId = await FlutterDownloader.retry(taskId: oldId);
    int length = downloadList.length;
    // 继续下载会返回一个新的 taskId ，要改一下
    for (var e = 0; e < length; e++) {
      if (downloadList[e]['taskId'] == oldId) {
        downloadList[e]['taskId'] = newId;
        downloadList[e]['status'] = 2;
        break;
      }
    }
    notifyListeners();
  }
}
