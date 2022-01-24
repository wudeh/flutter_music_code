import 'package:cloud_music/util/num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

// 本地已下载
class LocalDownload extends StatefulWidget {
  LocalDownload({Key? key}) : super(key: key);

  @override
  _LocalDownloadState createState() => _LocalDownloadState();
}

class _LocalDownloadState extends State<LocalDownload> {
  List<DownloadTask> localTask = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLocalDownload();
  }

  Future<void> loadLocalDownload() async {
    final tasks = await FlutterDownloader.loadTasks();
    setState(() {
      localTask.addAll(tasks!);
    });
    print(tasks);
  }

  item(context, index) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 60,
      child: Row(
        children: [
          ClipOval(
            child: Image.asset('assets/images/cover-bg-in.png', width: 20),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: InkWell(
            onTap: () {
              // 点击播放
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${localTask[index].filename}"),
                // 6 代表暂停下载， 2 代表 正在下载，3 代表完成下载，4 代表下载失败
                Text.rich(
                  TextSpan(children: [
                    TextSpan(text: localTask[index].status != DownloadTaskStatus.complete ? "未下载完毕" : ""),
                    TextSpan(text: timeFilter(localTask[index].timeCreated)),
                  ]),
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          )),
          // 末尾删除图标
          InkWell(
            onTap: () async {
              setState(() {
                localTask.remove(index);
              });
              await FlutterDownloader.remove(
                  taskId: localTask[index].taskId, shouldDeleteContent: true);
            },
            child: Icon(Icons.delete),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("本地下载"),
        ),
        body: localTask.length > 0
            ? ListView.builder(
                itemCount: localTask.length,
                itemBuilder: (context, index) => item(context, index),
              )
            : Center(
                child: Text("未找到下载音乐"),
              ));
  }
}

class LocalTask {
  final String? id;
  final String? link;
  final String? url;
  final String? file_name;
  final String? saved_dir;
  final String? headers;
  final String? task_id;
  final int? status;
  final int? progress;
  final int? resumable;
  final int? show_notification;
  final int? open_file_from_notification;
  final int? time_created;

  LocalTask(
      {this.id,
      this.link,
      this.url,
      this.status,
      this.progress,
      this.file_name,
      this.saved_dir,
      this.resumable,
      this.headers,
      this.show_notification,
      this.open_file_from_notification,
      this.time_created,
      this.task_id});
}
