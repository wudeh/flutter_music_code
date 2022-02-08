import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:test22/model/comment_floor.dart';
import 'package:test22/model/comment_num.dart';
import 'package:test22/model/recommend.dart';
import 'package:test22/model/song_detail.dart';
import 'package:test22/model/song_list.dart';
import 'package:test22/model/comment_floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../api/api.dart';
import '../http/http.dart';
import './common/sliver_app_bar.dart';
import './common/extended_image.dart';
import 'package:test22/util/num.dart';
import 'package:like_button/like_button.dart';
import './comment_floor.dart';
import 'package:oktoast/oktoast.dart';
import 'common/ExpandText.dart';

// 这是评论页面，需要请求封面，作者等相关信息，还有评论相关信息

class Comment extends StatefulWidget {
  final id;
  final type;

  Comment({Key? key, required this.id, required this.type}) : super(key: key);

  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  // 评论数
  int commentNum = 0;

  // 封面
  String img = '';

  // 标题
  String title = '';

  // 作者 或者 歌手
  String author = '';

  // 评论
  List<Comments> comment = [];

  // 热度排序 2，时间排序 3
  int sortType = 2;

  // 分页 页数
  int pageNo = 1;

  // 当按时间排序且不是第一页的时候需要传这个参数，是上一条响应数据的值
  String cursor = '';

  // 评论是否到底
  bool commentOver = false;
  // 是否正在请求评论
  bool commentLoading = false;

  bool isError = false;

  ScrollController _scrollController = ScrollController();

  // 评论流
  StreamController _commentStreamController = StreamController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController
      ..addListener(() {
        if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent - 50.w) {
          // 如果还差 50.w 滚动到底部，开始请求下一页评论
          if (!isError) {
            _GetCommentInfo();
          }
        }
      });

    _getInfo();
    _GetCommentInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  // 先请求封面相关信息
  void _getInfo() async {
    // print('开始请求封面');
    int now = new DateTime.now().millisecondsSinceEpoch;
    // type = 0 是歌曲，type = 2 是歌单
    if (widget.type == '0') {
      String a = await HttpRequest.getInstance()
          .get(Api.songDetail + 'timestamp=$now&ids=${widget.id}');
      var b = jsonDecode(a);
      songDetail c = songDetail.fromJson(b);
      img = c.songs![0].al!.picUrl!;
      author = c.songs![0].ar!.map((e) => e.name).join('/');
      title = c.songs![0].name!;
    }
    if (widget.type == '2') {
      String a = await HttpRequest.getInstance()
          .get(Api.songList + '${widget.id}&timestamp=$now');
      var b = jsonDecode(a);
      SongList c = SongList.fromJson(b);
      img = c.playlist!.coverImgUrl!;
      author = c.playlist!.creator!.nickname!;
      title = c.playlist!.name!;
    }
    setState(() {});
  }

  // 再请求评论
  void _GetCommentInfo() async {
    // print('评论请求');
    // 正在请求评论，不执行
    if (commentLoading) return;
    // 已经获取全部评论则不执行请求逻辑
    if (commentOver == true) return;

    commentLoading = true;

    int now = new DateTime.now().millisecondsSinceEpoch;
    String a = "";
    try {
      if (cursor != "" && sortType == 3) {
        a = await HttpRequest.getInstance().get(Api.comment +
            'id=${widget.id}&type=${widget.type}&pageNo=${pageNo}&pageSize=20&sortType=${sortType}&cursor=$cursor&timestamp=$now');
      } else {
        a = await HttpRequest.getInstance().get(Api.comment +
            'id=${widget.id}&type=${widget.type}&pageNo=${pageNo}&pageSize=20&sortType=${sortType}&timestamp=$now');
      }
    } catch (e) {
      setState(() {
        isError = true;
        commentLoading = false;
      });
      showToast('请求评论出错，请重试');
      return;
    }

    // print(a);
    var b = jsonDecode(a);
    commentModel c = commentModel.fromJson(b);
    if (c.code! != 200) {
      setState(() {
        isError = true;
        commentLoading = false;
      });
      showToast('请求评论出错，请重试');
      return;
    }
    comment.addAll(c.data!.comments!);
    cursor = c.data!.cursor!;
    // print(cursor);
    commentNum = c.data!.totalCount!;
    pageNo++;
    // 评论大于等于总数 则 认为已经获取全部评论
    if (comment.length >= commentNum) commentOver = true;
    // 请求评论完滑动最大距离为 0 ，则视为已经获取全部评论
    // if(_scrollController.position.maxScrollExtent == 0) commentOver = true;
    setState(() {
      commentLoading = false;
    });
  }

  Future<bool> onLikeButtonTapped(bool isLiked, int index) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;
    
    // setState(() {
      if (comment[index].liked!) {
        comment[index].likedCount =
            (comment[index].likedCount! -
                1);
      } else {
        comment[index].likedCount =
            (comment[index].likedCount! +
                1);
      }
      comment[index].liked = !comment[index].liked!;
    // });

    return !isLiked;
  }

  /// 点赞数量
  Widget likeCountWidget(int num) {
    if (num < 100000) {
      return AnimatedFlipCounter(
        duration: Duration(milliseconds: 500),
        value: num,
      );
    } else {
      return Text(
        playCountFilter(num),
        style: TextStyle(fontSize: 14.sp),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('评论($commentNum)'),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
                child: Container(
              height: 170.h,
              child: img == ''
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                        ),
                        // 封面
                        ExtenedImage(width: 120.w, height: 120.w, img: img),
                        SizedBox(
                          width: 8.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 标题
                            Container(
                              width: 220.w,
                              child: Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ),
                            // 作者
                            Row(
                              children: [
                                Text(
                                  'by ',
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                                Text(
                                  '$author',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.blueAccent),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
            )),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                  minHeight: 50.h,
                  maxHeight: 50.h,
                  child: Container(
                    height: 50.h,
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 8.w, right: 8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '评论区',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                pageNo = 1;
                                sortType = 2;
                                commentOver = false;
                                commentLoading = false;
                                isError = false;
                                cursor = "";
                                setState(() {
                                  comment.clear();
                                });
                                _GetCommentInfo();
                              },
                              child: Text(
                                '最热',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: sortType == 2
                                        ? Colors.black
                                        : Colors.black54),
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            InkWell(
                                onTap: () {
                                  pageNo = 1;
                                  sortType = 3;
                                  commentOver = false;
                                  commentLoading = false;
                                  isError = false;
                                  cursor = "";
                                  setState(() {
                                    comment.clear();
                                  });
                                  _GetCommentInfo();
                                },
                                child: Text(
                                  '最新',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: sortType == 3
                                          ? Colors.black
                                          : Colors.black54),
                                )),
                          ],
                        )
                      ],
                    ),
                  )),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return InkWell(
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 头像
                        ExtenedImage(
                          width: 30.w,
                          height: 30.w,
                          img: comment[index].user!.avatarUrl!,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 评论人
                                      Text(
                                        comment[index].user!.nickname!,
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                      // 评论时间
                                      Text(
                                        timeFilter(comment[index].time),
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black54),
                                      )
                                    ],
                                  ),
                                  // 点赞数量
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // likeCountWidget(
                                      //     comment[index].likedCount!),
                                      LikeButton(
                                          isLiked: comment[index].liked,
                                          // likeButton 自带的数量变化后不对齐
                                          likeCount: comment[index].likedCount,
                                          countPostion: CountPostion.left,
                                          onTap: (bool liked) async {
                                            return onLikeButtonTapped(liked, index);
                                          },
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // 评论内容
                            Container(
                              width: 320.w,
                              // child: Text(
                              //   comment[index].content!,
                              //   style: TextStyle(fontSize: 14.sp),
                              // ),
                              child: ExpandableText(
                                text: comment[index].content!,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                            // 楼层回复数量
                            comment[index].showFloorComment!.replyCount == 0
                                ? SizedBox()
                                : InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return commentFloorBottom(
                                                parentCommentId:
                                                    comment[index].commentId!,
                                                id: widget.id,
                                                type: widget.type,
                                                commentFloorNum: comment[index]
                                                    .showFloorComment!
                                                    .replyCount!,
                                                item: comment[index]);
                                          });
                                    },
                                    child: Text(
                                      '${comment[index].showFloorComment!.replyCount}条回复 >',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.blueAccent),
                                    ),
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
                  ),
                );
              }, childCount: comment.length),
            ),
            SliverToBoxAdapter(
              child: commentOver == false
                  ? isError == true
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              isError = false;
                            });
                            _GetCommentInfo();
                          },
                          child: Container(
                            height: 30.w,
                            child: Center(
                              child: Text('评论出错，请点击重试'),
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.only(top: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text('加载中...')
                            ],
                          ),
                        )
                  : Center(
                      child: Text('到底拉'),
                    ),
            )
          ],
        ));
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
