import 'dart:math';

import 'package:oktoast/oktoast.dart';
import 'package:test22/page/common/dialog.dart';
import 'package:test22/page/common/dialog_widget.dart';
import 'package:test22/page/my/download_progress.dart';
import 'package:test22/provider/download.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

// 正在下载中的页面，没做本地存储，所以退出清空
class DownloadingPage extends StatefulWidget {
  DownloadingPage({Key? key}) : super(key: key);

  @override
  _DownloadingPageState createState() => _DownloadingPageState();
}

class _DownloadingPageState extends State<DownloadingPage> {
  bool deleteLocalDownload = false;

  bool allPause = false;

  // 删除一首
  void deleteOne(BuildContext context, int index) {
    // 弹出是否删除对话框
    showDialog(
        context: context,
        builder: (context) {
          return DialogWidgetShow(
              title: '确定删除?',
              child: deleteCheck(),
              yes: () {
                Provider.of<DownloadProvider>(context, listen: false)
                    .deleteOne(index, deleteLocalDownload);
              });
        },
        barrierDismissible: false);
  }

  // 删除全部
  void deleteAll(BuildContext context) {
    if (Provider.of<DownloadProvider>(context,listen: false).downloadList.isNotEmpty) {
      // 弹出是否删除对话框
      showDialog(
          context: context,
          builder: (context) {
            return DialogWidgetShow(
                child: deleteCheck(),
                yes: () {
                  Provider.of<DownloadProvider>(context, listen: false)
                      .clearDownloadList(deleteLocalDownload);
                });
          },
          barrierDismissible: false);
    } else {
      showToast("列表为空");
    }
  }

  // 是否删除本地已下载文件 勾选框
  Widget deleteCheck() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 这里必须要 builder 包裹，不然复选框样式勾选后在对话框中不能改变
        // 通过Builder来获得构建Checkbox的`context`，
        // 这是一种常用的缩小`context`范围的方式
        Builder(
          builder: (BuildContext context) {
            return Checkbox(
              value: deleteLocalDownload,
              onChanged: (bool? value) {
                (context as Element).markNeedsBuild();
                deleteLocalDownload = value!;
              },
            );
          },
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          '是否同时删除本地已下载音乐?',
          style: TextStyle(fontSize: 14),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List downdList =
        Provider.of<DownloadProvider>(context, listen: false).downloadList;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('正在下载'),
          ),
          // 全部开始 ，清空
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
                minHeight: 50,
                maxHeight: 50,
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.download_for_offline,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {
                              if (Provider.of<DownloadProvider>(context,listen: false).downloadList.isNotEmpty){
                                if (allPause) {
                                  Provider.of<DownloadProvider>(context,
                                          listen: false)
                                      .pauseAll();
                                } else {
                                  Provider.of<DownloadProvider>(context,
                                          listen: false)
                                      .continueAll();
                                }
                                setState(() {
                                  allPause = !allPause;
                                });
                              }else {
                                showToast("列表为空");
                              }
                              
                            },
                            child: Text(
                              allPause ? '全部暂停' : '全部开始',
                              style: TextStyle(),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey,
                      ),
                      // 点击清空下载列表
                      InkWell(
                        onTap: () {
                          deleteAll(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.grey),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              '清空',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
          Provider.of<DownloadProvider>(context).downloadList.isNotEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      height: 60,
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.asset('assets/images/cover-bg-in.png',
                                width: 20),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              // 点击暂停，继续，重试下载
                              Provider.of<DownloadProvider>(context,
                                      listen: false)
                                  .changeDownload(index);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${downdList[index]['file_name']}"),
                                // 6 代表暂停下载， 2 代表 正在下载，3 代表完成下载，4 代表下载失败
                                Text.rich(
                                  TextSpan(children: [
                                    WidgetSpan(
                                      child: Visibility(
                                        visible: Provider.of<DownloadProvider>(
                                                        context)
                                                    .downloadList[index]
                                                ['status'] ==
                                            4,
                                        child: Text('下载失败，点击重试'),
                                      ),
                                    ),
                                    // 下载中
                                    WidgetSpan(
                                      child: Visibility(
                                        visible: Provider.of<DownloadProvider>(
                                                        context)
                                                    .downloadList[index]
                                                ['status'] ==
                                            2,
                                        child: Text(downdList[index]['size'] ==
                                                0
                                            ? '正在计算资源大小'
                                            : '${downdList[index]['DownloadSize']}/${downdList[index]['sizeStr']}'),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: Visibility(
                                        visible: Provider.of<DownloadProvider>(
                                                        context)
                                                    .downloadList[index]
                                                ['status'] ==
                                            6,
                                        child: Text('已暂停，点击继续下载'),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: Visibility(
                                        visible: Provider.of<DownloadProvider>(
                                                        context)
                                                    .downloadList[index]
                                                ['status'] ==
                                            3,
                                        child: Text(
                                            '下载完成，共${downdList[index]['DownloadSize']}'),
                                      ),
                                    ),
                                    // TextSpan(text: downdList[index]['DownloadSize']),
                                    // TextSpan(text: '/'),
                                    // TextSpan(text: downdList[index]['sizeStr']),
                                  ]),
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          )),
                          DownloadProgress(
                            progress: Provider.of<DownloadProvider>(context)
                                .downloadList[index]['progress'],
                          ),
                          // 末尾删除图标
                          InkWell(
                            onTap: () {
                              deleteOne(context, index);
                            },
                            child: Icon(Icons.delete),
                          )
                        ],
                      ),
                    );
                  },
                      childCount: Provider.of<DownloadProvider>(context)
                          .downloadList
                          .length),
                )
              : const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 400,
                    child: Center(
                      child: Text('你还没下载音乐'),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

// 吸顶组件
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
