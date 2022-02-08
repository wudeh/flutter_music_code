// import 'dart:convert';
// import 'dart:io';
// import 'dart:isolate';
// import 'dart:math';
// import 'dart:ui';

// import 'package:test22/http/http.dart';
// import 'package:test22/page/common/extended_image.dart';
// import 'package:test22/page/common/play_list.dart';
// import 'package:download/download.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:oktoast/oktoast.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../provider/music.dart';
// import '../../provider/color.dart';
// import 'package:provider/provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:math' as math;
// import 'package:permission_handler/permission_handler.dart';
// import '../../router/navigator_util.dart';
// import '../common/more_info.dart';
// import '../../api/api.dart';
// import '../../model/comment_num.dart';

// class Download {
//   Future<void> _retryRequestPermission() async {
//     final hasGranted = await _checkPermission();

//     if (hasGranted) {
//       await _prepareSaveDir();
//     }

//     // setState(() {
//     //   _permissionReady = hasGranted;
//     // });
//   }

//   void _requestDownload(_TaskInfo task) async {
//     task.taskId = await FlutterDownloader.enqueue(
//       url: task.link!,
//       headers: {"auth": "test_for_sql_encoding"},
//       savedDir: _localPath,
//       showNotification: true,
//       openFileFromNotification: true,
//       saveInPublicStorage: true,
//     );
//   }

//   void _cancelDownload(_TaskInfo task) async {
//     await FlutterDownloader.cancel(taskId: task.taskId!);
//   }

//   void _pauseDownload(_TaskInfo task) async {
//     await FlutterDownloader.pause(taskId: task.taskId!);
//   }

//   void _resumeDownload(_TaskInfo task) async {
//     String? newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
//     task.taskId = newTaskId;
//   }

//   void _retryDownload(_TaskInfo task) async {
//     String? newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
//     task.taskId = newTaskId;
//   }

//   Future<bool> _openDownloadedFile(_TaskInfo? task) {
//     if (task != null) {
//       return FlutterDownloader.open(taskId: task.taskId!);
//     } else {
//       return Future.value(false);
//     }
//   }

//   void _delete(_TaskInfo task) async {
//     await FlutterDownloader.remove(
//         taskId: task.taskId!, shouldDeleteContent: true);
//     await _prepare();
//     setState(() {});
//   }

//   Future<bool> _checkPermission() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     if (widget.platform == TargetPlatform.android &&
//         androidInfo.version.sdkInt <= 28) {
//       final status = await Permission.storage.status;
//       if (status != PermissionStatus.granted) {
//         final result = await Permission.storage.request();
//         if (result == PermissionStatus.granted) {
//           return true;
//         }
//       } else {
//         return true;
//       }
//     } else {
//       return true;
//     }
//     return false;
//   }

//   Future<Null> _prepare() async {
//     final tasks = await FlutterDownloader.loadTasks();

//     int count = 0;
//     _tasks = [];
//     _items = [];

//     _tasks!.addAll(_documents.map((document) =>
//         _TaskInfo(name: document['name'], link: document['link'])));

//     _items.add(_ItemHolder(name: 'Documents'));
//     for (int i = count; i < _tasks!.length; i++) {
//       _items.add(_ItemHolder(name: _tasks![i].name, task: _tasks![i]));
//       count++;
//     }

//     _tasks!.addAll(_images
//         .map((image) => _TaskInfo(name: image['name'], link: image['link'])));

//     _items.add(_ItemHolder(name: 'Images'));
//     for (int i = count; i < _tasks!.length; i++) {
//       _items.add(_ItemHolder(name: _tasks![i].name, task: _tasks![i]));
//       count++;
//     }

//     _tasks!.addAll(_videos
//         .map((video) => _TaskInfo(name: video['name'], link: video['link'])));

//     _items.add(_ItemHolder(name: 'Videos'));
//     for (int i = count; i < _tasks!.length; i++) {
//       _items.add(_ItemHolder(name: _tasks![i].name, task: _tasks![i]));
//       count++;
//     }

//     tasks!.forEach((task) {
//       for (_TaskInfo info in _tasks!) {
//         if (info.link == task.url) {
//           info.taskId = task.taskId;
//           info.status = task.status;
//           info.progress = task.progress;
//         }
//       }
//     });

//     _permissionReady = await _checkPermission();

//     if (_permissionReady) {
//       await _prepareSaveDir();
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   Future<void> _prepareSaveDir() async {
//     _localPath = (await _findLocalPath())!;
//     final savedDir = Directory(_localPath);
//     bool hasExisted = await savedDir.exists();
//     if (!hasExisted) {
//       savedDir.create();
//     }
//   }

//   Future<String?> _findLocalPath() async {
//     var externalStorageDirPath;
//     if (Platform.isAndroid) {
      
//         final directory = await getExternalStorageDirectory();
//         externalStorageDirPath = directory?.path;
      
//     } else if (Platform.isIOS) {
//       externalStorageDirPath =
//           (await getApplicationDocumentsDirectory()).absolute.path;
//     }
//     return externalStorageDirPath;
//   }
// }