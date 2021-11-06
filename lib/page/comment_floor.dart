import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/comment_num.dart';
import '../model/comment_floor.dart';
import '../http/http.dart';
import '../api/api.dart';
import './common/extended_image.dart';
import 'package:like_button/like_button.dart';
import '../util/num.dart';


class commentFloorBottom extends StatefulWidget {
  final parentCommentId;
  final id;
  final type;
  int commentFloorNum; // 总回复数量可能会变，就不用 final 了

  final Comments item;

  commentFloorBottom(
      {Key? key,
      required this.parentCommentId,
      required this.id,
      required this.type,
      required this.commentFloorNum,
      required this.item})
      : super(key: key);

  _commentFloorBottomState createState() => _commentFloorBottomState();
}

class _commentFloorBottomState extends State<commentFloorBottom> {

  TapGestureRecognizer _tapGestureRecognizer= new TapGestureRecognizer();


  // 楼层评论 id
  var parentCommentId = 0;

  // 楼层评论
  List<Comments2> commentFloor = [];

  // 楼层评论是否到底
  bool commentFloorOver = false;

  // 是否正在请求楼层评论
  bool commentFloorLoading = false;

  // 楼层请求出错
  bool commentFloorError = false;

  // 楼层评论获取下一页评论数据需要带上这个
  var time = 1;


  // 楼层评论控制器
  ScrollController _scrollFloorController = ScrollController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollFloorController
      ..addListener(() {
        if (_scrollFloorController.position.pixels >
            _scrollFloorController.position.maxScrollExtent - 50.w) {
          // 如果还差 50.w 滚动到底部，开始请求下一页评论
          _getCommentFloor();
        }
      });
      _getCommentFloor();
      _tapGestureRecognizer..onTap = _handelLittleTapGes;
  }


  void _handelLittleTapGes() {
    print('点击了人名');
  }

  // 请求楼层评论
  void _getCommentFloor() async {
    // print('楼层评论请求');
    // 正在请求评论，不执行
    if (commentFloorLoading) return;
    // 已经获取全部评论则不执行请求逻辑
    if (commentFloorOver == true) return;

    setState(() {
      commentFloorLoading = true;
    });



    int now = new DateTime.now().millisecondsSinceEpoch;
    String a = await HttpRequest.getInstance().get(Api.commentFloor +
        'parentCommentId=${widget.parentCommentId}&id=${widget.id}&type=${widget.type}&time=$time&timestamp=$now');
    var b = jsonDecode(a);
    commentFloorModel c = commentFloorModel.fromJson(b);
    if (c.code != 200) {
      setState(() {
        commentFloorLoading = false;
        commentFloorError = true;
      });
      return;
    }
    commentFloor.addAll(c.data!.comments!);
    time = c.data!.time!;
    if(commentFloor.length > widget.commentFloorNum) widget.commentFloorNum = commentFloor.length;
    // 评论大于等于总数 则 认为已经获取全部评论
    if (c.data!.hasMore == false) commentFloorOver = true;
    // 请求评论完滑动最大距离为 0 ，则视为已经获取全部评论
    // if(_scrollController.position.maxScrollExtent == 0) commentOver = true;
    setState(() {
      commentFloorLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      child: ListView(
        controller: _scrollFloorController,
        children: [
          // 原楼层的评论
          Container(
            padding: EdgeInsets.all(8.w),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 头像
                ExtenedImage(
                  width: 30.w,
                  height: 30.w,
                  img: widget.item.user!.avatarUrl!,
                  isRectangle: false,
                ),
                SizedBox(
                  width: 8.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 评论作者，时间，点赞数
                    Container(
                      width: 320.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 评论人
                              Text(
                                widget.item.user!.nickname!,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              // 评论时间
                              Text(
                                timeFilter(widget.item.time),
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.black54),
                              )
                            ],
                          ),
                          // 点赞数量
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                playCountFilter(widget.item.likedCount),
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    widget.item.liked =
                                        !widget.item.liked!;
                                  });
                                },
                                child: LikeButton(
                                  isLiked: widget.item.liked,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    // 评论内容
                    Container(
                      width: 320.w,
                      child: Text(
                        widget.item.content!,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    Container(
                      width: 320.w,
                      height: 1,
                      margin: EdgeInsets.only(top: 8.w),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.grey))),
                    )
                  ],
                )
              ],
            ),
          ),
          // 楼层分割
          Container(
            height: 8.w,
            color: Colors.grey,
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            child: Text('回复 (${widget.commentFloorNum})'),
          ),
          // 以下是回复楼层的
          Column(
            children: commentFloor.map<Widget>((e) {
              return Container(
                padding: EdgeInsets.all(8.w),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 头像
                    ExtenedImage(
                      width: 30.w,
                      height: 30.w,
                      img: e.user!.avatarUrl!,
                      isRectangle: false,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 评论作者，时间，点赞数
                        Container(
                          width: 320.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 评论人
                                  Text(
                                    e.user!.nickname!,
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  // 评论时间
                                  Text(
                                    timeFilter(e.time),
                                    style: TextStyle(
                                        fontSize: 12.sp, color: Colors.black54),
                                  )
                                ],
                              ),
                              // 点赞数量
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    playCountFilter(e.likedCount),
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        e.liked = !e.liked!;
                                      });
                                    },
                                    child: LikeButton(
                                      isLiked: e.liked,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        // 评论内容
                        Container(
                          width: 320.w,
                          child: Text(
                            e.content!,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                        // 如果有给别人回复
                        Visibility(
                          visible: e.beReplied![0].beRepliedCommentId != widget.parentCommentId,
                          child: Container(
                            width: 320.w, 
                            padding: EdgeInsets.all(8.w),
                            child: RichText(
                            text: TextSpan(
                              text: '@ ${e.beReplied![0].user!.nickname!}：',
                              style: TextStyle(color: Colors.blueAccent),
                              recognizer: _tapGestureRecognizer,
                              children: [
                                TextSpan(
                                text: '${e.beReplied![0].content == null ? '该评论已被删除' : e.beReplied![0].content}' ,
                                style: TextStyle(color: Colors.black26),
                              )
                              ]
                            ),
                          ),
                          )
                        ),
                        Container(
                          width: 320.w,
                          height: 1,
                          margin: EdgeInsets.only(top: 8.w),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey))),
                        )
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
          ),
          commentFloorLoading == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text('加载中...')
                  ],
                )
              : Center(
                child: Text('到底啦'), 
              ),
          Visibility(
            visible: commentFloorError,
            child: InkWell(
              onTap: () {
                commentFloorError = false;
                _getCommentFloor();
              },
              child: Center(
                child: Text('请求出错，点击重新加载'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
