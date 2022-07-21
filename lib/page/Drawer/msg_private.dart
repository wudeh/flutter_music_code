import 'dart:convert';

// import 'package:test22/page/Drawer/drag_disappear/drag_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:test22/page/common/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/msg_private.dart';
import './controller.dart';
import '../../util/num.dart';

// 获取私信等
class MsgPrivatePage extends StatefulWidget {
  MsgPrivatePage({Key? key}) : super(key: key);

  @override
  _MsgPrivatePageState createState() => _MsgPrivatePageState();
}

class _MsgPrivatePageState extends State<MsgPrivatePage> {
  // 私信
  List<Msgs> msgs = [];

  final EasyRefreshController _controller = EasyRefreshController(controlFinishLoad: true,);

  // 私信分页
  int offset = 0;

  bool noMsgs = false;

  String noMsgString = "暂无私信";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 渲染完成后执行一次刷新方法
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.callRefresh();
    });
  }

  // 获取私信
  Future<void> getMsg() async {
    MsgPrivateModel? res = await Controller.getUserPrivateMsg(offset);
    offset += 30; // 默认分页一次获取30个，下一页偏移30
    setState(() {
      msgs.addAll(res!.msgs!);
      if (!res.more!) {
        noMsgs = true;
        noMsgString = "没有更多私信啦";
        _controller.finishLoad(IndicatorResult.noMore);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("消息"),
        ),
        body: EasyRefresh(
          header: MaterialHeader(),
          footer: const ClassicFooter(
            noMoreText: '到底啦',
          ),
          // footer: MaterialFooter(),
          controller: _controller,
          onLoad: getMsg,
          onRefresh: () async {
            offset = 0;
            msgs.clear();
            await getMsg();
          },
          child: ListView(
            children: [
              // 私信
              Column(
                children: msgs.map<Widget>((e) {
                  // 处理一下消息类型
                  Map msg = jsonDecode(e.lastMsg!);
                  String msgReal = '';
                  if (msg['msg'].indexOf("专辑") > 0 &&
                      msg['album']?['name'] != null) {
                    msgReal = "专辑：" + msg['album']['name'];
                  } else if (msg['msg'].indexOf("MV") > 0) {
                    msgReal = "视频" + msg['mv']['name'];
                  } else {
                    msgReal = msg['msg'];
                  }
                  return Row(
                    children: [
                      // 头像
                      Container(
                          padding: EdgeInsets.all(8.w),
                          child: Stack(
                            children: [
                              ExtenedImage(
                                width: 50.w,
                                height: 50.w,
                                img: e.fromUser!.avatarUrl,
                                isRectangle: false,
                              ),
                              // 右下角图标
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: ExtenedImage(
                                  width: 20.w,
                                  height: 20.w,
                                  img:
                                      e.fromUser?.avatarDetail?.identityIconUrl,
                                  isRectangle: false,
                                ),
                              )
                            ],
                          )),
                      Container(
                        width: 300.w,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${e.fromUser!.nickname}",
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                Text(
                                  "${timeFilter(e.lastMsgTime)}",
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Colors.grey),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 260.w,
                                  child: Text(
                                    msgReal,
                                    style: TextStyle(
                                        fontSize: 12.sp, color: Colors.grey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight: e.newMsgCount != 0 ? 18.w : 0,
                                    minWidth: e.newMsgCount != 0 ? 18.w : 0,
                                  ),
                                  // height: e.newMsgCount != 0 ? 18.w : 0,
                                  padding: const EdgeInsets.only(left: 3, right: 3),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18.w)),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${e.newMsgCount! > 99 ? '99+' : e.newMsgCount != 0 ? e.newMsgCount : ''}",
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.white),
                                    ),
                                  ),
                                ),
                                // DragCount()
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
              // noMsgs
              //     ? Center(
              //         child: Text(noMsgString),
              //       )
              //     : SizedBox()
            ],
          ),
        ));
  }
}
