import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_music/model/song_list_info.dart';
import 'package:cloud_music/page/play_list/ima_view.dart';
import 'package:cloud_music/provider/music.dart';
import 'package:cloud_music/router/navigator_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import '../../api/api.dart';
import '../../http/http.dart';
import '../../model/song_list.dart';
import '../../model/search_hot.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/loading.dart';
import '../common/audio_bar.dart';
import '../common/more_info.dart';
import '../common/extanded_img/Hero.dart';
import '../../util/num.dart';
import '../common/extended_image.dart';

class SongListPage extends StatefulWidget {
  var id;
  String img;

  SongListPage({Key? key, required this.img, required this.id})
      : super(key: key);

  _SongListPageState createState() => _SongListPageState(id: this.id);
}

class _SongListPageState extends State<SongListPage> {
  var id;

  _SongListPageState({this.id});

  // 歌单信息
  // 封面
  String img = '';
  // 歌单标题
  String title = '';
  // 作者名
  String creatorName = '';
  // 作者头像
  String creatorImg = '';
  // 歌单描述
  String des = '';
  // 歌单标签
  List<String> tags = [];

  // 收藏数量
  int likeCount = 0;
  // 评论数量
  int commentCount = 0;
  // 分享数量
  int shareCount = 0;

  // 歌曲信息
  List<Songs> songInfo = [];
  // 是否正在请求歌曲信息
  bool isRequestSongInfo = true;
  // 歌曲另一组信息，判断超清音质，vip试听，独家等
  // 这里由于后端数据接口字段 Privileges 重复了，在两个 json 序列化里面都有，导致无法定义数据类型，就不定义了
  // List<Privileges> songAnother = [];
  List songAnother = [];

  final StreamController<bool> rebuildSwiper =
      StreamController<bool>.broadcast();

  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();

  bool _showSwiper = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.img);
    _getInfo();
  }

  // 获取歌单数据
  Future<void> _getInfo() async {
    String response = await HttpRequest.getInstance().getMap(Api.songList + id);
    Map<String, dynamic> a = json.decode(response);
    SongList info = SongList.fromJson(a);
    if (mounted) {
      setState(() {
        img = info.playlist!.coverImgUrl!;
        title = info.playlist!.name!;
        creatorName = info.playlist!.creator!.nickname!;
        creatorImg = info.playlist!.creator!.avatarUrl!;
        des = info.playlist?.description ?? "";
        tags = info.playlist!.tags!;
        likeCount = info.playlist!.subscribedCount!;
        commentCount = info.playlist!.commentCount!;
        shareCount = info.playlist!.shareCount!;
      });
      // print('img是$img');
      // print('id是$id');

      // 根据 id 获取全部歌曲信息，可能有些歌单没有歌
      if (info.playlist!.trackIds!.isNotEmpty) {
        print("开始请求");
        String value = await HttpRequest.getInstance().post(
            Api.songDetail +
                '?timestamp=${DateTime.now().microsecondsSinceEpoch}',
            {
              'ids': info.playlist!.trackIds!.map((e) => e.id).join(','),
              'timestamp': DateTime.now().microsecondsSinceEpoch
            });
        var a = json.decode(value);
        var infoJson = SongListSongs.fromJson(a);
        // print('==========');
        // print(info.songs);
        setState(() {
          print("歌曲请求完毕");
          songInfo = infoJson.songs!;
          songAnother = infoJson.privileges!;
          isRequestSongInfo = false;
        });
      } else {
        setState(() {
          isRequestSongInfo = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("歌单")),
        body: ExtendedImageSlidePage(
          key: slidePagekey,
          child: Stack(
            children: [
              ExtenedImage(
                img: widget.img,
                width: 375.w,
                height: 230.h,
              ),
              BackdropFilter(
                // 背景过滤器需要配合透明度组件使用
                filter: ImageFilter.blur(sigmaX: 55, sigmaY: 55),
                child: Opacity(
                  opacity: 1,
                  child: Container(
                      width: 375.w,
                      child: CustomScrollView(
                        slivers: <Widget>[
                          _buildBanner(),
                          _buildStickyBar(),
                          _buildList(),
                        ],
                      )),
                ),
              ),
              // 底部音乐栏
              AudioBar()
            ],
          ),
          slideAxis: SlideAxis.both,
          slideType: SlideType.onlyImage,
          onSlidingPage: (state) {
            ///you can change other widgets' state on page as you want
            ///base on offset/isSliding etc
            //var offset= state.offset;
            var showSwiper = !state.isSliding;
            if (showSwiper != _showSwiper) {
              // do not setState directly here, the image state will change,
              // you should only notify the widgets which are needed to change
              // setState(() {
              // _showSwiper = showSwiper;
              // });

              _showSwiper = showSwiper;
              rebuildSwiper.add(_showSwiper);
            }
          },
        ));
  }

  Widget _buildBanner() {
    return SliverToBoxAdapter(
      child: Container(
          height: 220.h,
          padding: EdgeInsets.all(10.w),
          child: Column(
            children: [
              Row(
                children: [
                  // 歌单封面部分
                  InkWell(
                    onTap: () {
                        
                      Navigator.of(context).push(PageRouteBuilder(
                          //跳转背景透明路由
                          opaque: false,
                          pageBuilder: (context,_,__) {
                        return ExtendedImageSlidePage(
                          child: Scaffold(
                          body: GestureDetector(
                            child: Container(
                              color: Colors.black,
                              child: Center(
                                child: Hero(
                                  child: ExtendedImage.network(
                                    widget.img,
                                    fit: BoxFit.contain,
                                    enableSlideOutPage: true,
                                    // heroBuilderForSlidingPage: (widget) => ,
                                    cache: true,
                                    mode: ExtendedImageMode.gesture,
                                    initGestureConfigHandler: (state) {
                                      return GestureConfig(
                                        minScale: 0.9,
                                        animationMinScale: 0.7,
                                        maxScale: 3.0,
                                        animationMaxScale: 3.5,
                                        speed: 1.0,
                                        inertialSpeed: 100.0,
                                        initialScale: 1.0,
                                        inPageView: false,
                                        initialAlignment:
                                            InitialAlignment.center,
                                      );
                                    },
                                  ),
                                  // child: PhotoView(
                                  //   imageProvider: NetworkImage(img),
                                  // ),
                                  tag: widget.img,
                                  // slideType: SlideType.onlyImage,
                                  // slidePagekey: slidePagekey,
                                ),
                              ),
                            ),
                            onTap: () {
                              // slidePagekey.currentState!.popPage();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                          slideAxis: SlideAxis.both,
                          slideType: SlideType.onlyImage,
                          onSlidingPage: (state) {
                            ///you can change other widgets' state on page as you want
                            ///base on offset/isSliding etc
                            //var offset= state.offset;
                            var showSwiper = !state.isSliding;
                            if (showSwiper != _showSwiper) {
                              // do not setState directly here, the image state will change,
                              // you should only notify the widgets which are needed to change
                              // setState(() {
                              // _showSwiper = showSwiper;
                              // });

                              _showSwiper = showSwiper;
                              rebuildSwiper.add(_showSwiper);
                            }
                          },
                        );
                        
                        

                        // GestureDetector(
                        //   child: Hero(
                        //     child: ExtendedImage.network(
                        //       img,
                        //       fit: BoxFit.contain,
                        //       enableSlideOutPage: true,
                        //       cache: true,
                        //       //enableLoadState: false,
                        //       mode: ExtendedImageMode.gesture,
                        //       initGestureConfigHandler: (state) {
                        //         return GestureConfig(
                        //           minScale: 0.9,
                        //           animationMinScale: 0.7,
                        //           maxScale: 3.0,
                        //           animationMaxScale: 3.5,
                        //           speed: 1.0,
                        //           inertialSpeed: 100.0,
                        //           initialScale: 1.0,
                        //           inPageView: false,
                        //           initialAlignment:
                        //               InitialAlignment.center,
                        //         );
                        //       },
                        //     ),
                        //     // child: PhotoView(
                        //     //   imageProvider: NetworkImage(img),
                        //     // ),
                        //     tag: img,
                        //     // slideType: SlideType.onlyImage,
                        //     // slidePagekey: slidePagekey,
                        //   ),
                        //   onTap: () {
                        //     // slidePagekey.currentState!.popPage();
                        //     Navigator.pop(context);
                        //   },
                        // );
                      }));
                    },
                    child: HeroExtenedImage(
                        width: 130.w, height: 130.w, img: widget.img),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  // 歌单右侧信息部分
                  title == ''
                      ? Loading()
                      : Container(
                          height: 130.w,
                          width: 200.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 歌单标题
                              Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.sp),
                              ),
                              // 歌单创作者
                              Row(
                                children: [
                                  ExtenedImage(
                                      width: 20.w,
                                      height: 20.w,
                                      img: creatorImg),
                                  InkWell(
                                    child: Text(
                                      creatorName,
                                      style: TextStyle(color: Colors.white60),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          PageRouteBuilder(
                                              //跳转背景透明路由
                                              opaque: false,
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return ImageView(img:widget.img);
                                              }));
                                    },
                                  )
                                ],
                              ),
                              // 点击描述 弹出具体描述页面
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      //跳转背景透明路由
                                      opaque: false,
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return Scaffold(
                                          backgroundColor: Colors.black26,
                                          body: InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.all(10.w),
                                                  height: 667.h,
                                                  child: Center(
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        // crossAxisAlignment:
                                                        //     CrossAxisAlignment.center,
                                                        // mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          HeroExtenedImage(
                                                            img: widget.img,
                                                            width: 180.h,
                                                          ),

                                                          SizedBox(
                                                            height: 10.w,
                                                          ),
                                                          // 标签
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                '标签：',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: Colors
                                                                        .white60),
                                                              ),
                                                              Wrap(
                                                                children: tags
                                                                    .map<Widget>(
                                                                        (e) {
                                                                  return Container(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            3.w,
                                                                        top:
                                                                            1.w,
                                                                        right:
                                                                            3.w,
                                                                        bottom:
                                                                            1.w),
                                                                    margin: EdgeInsets.only(
                                                                        right: 10
                                                                            .w),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10
                                                                                .w)),
                                                                        color: Colors
                                                                            .white10),
                                                                    child: Text(
                                                                      e,
                                                                      style: TextStyle(
                                                                          fontSize: 12
                                                                              .sp,
                                                                          color:
                                                                              Colors.white60),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10.w,
                                                          ),
                                                          // 描述
                                                          Text(
                                                            des,
                                                            style: TextStyle(
                                                                fontSize: 12.sp,
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ))),
                                        );
                                      }));
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return Material(
                                  //           color: Colors.transparent,
                                  //           child: InkWell(
                                  //               onTap: () {
                                  //                 Navigator.of(context).pop();
                                  //               },
                                  //               child: Container(
                                  //                   padding:
                                  //                       EdgeInsets.all(10.w),
                                  //                   height: 667.h,
                                  //                   child: Center(
                                  //                     child:
                                  //                         SingleChildScrollView(
                                  //                       child: Column(
                                  //                         // crossAxisAlignment:
                                  //                         //     CrossAxisAlignment.center,
                                  //                         // mainAxisAlignment: MainAxisAlignment.center,
                                  //                         children: [
                                  //                           HeroExtenedImage(
                                  //                             img: widget.img,
                                  //                             width: 180.h,
                                  //                           ),

                                  //                           SizedBox(
                                  //                             height: 10.w,
                                  //                           ),
                                  //                           // 标签
                                  //                           Row(
                                  //                             mainAxisAlignment:
                                  //                                 MainAxisAlignment
                                  //                                     .center,
                                  //                             children: [
                                  //                               Text(
                                  //                                 '标签：',
                                  //                                 style: TextStyle(
                                  //                                     fontSize:
                                  //                                         12.sp,
                                  //                                     color: Colors
                                  //                                         .white60),
                                  //                               ),
                                  //                               Wrap(
                                  //                                 children: tags
                                  //                                     .map<Widget>(
                                  //                                         (e) {
                                  //                                   return Container(
                                  //                                     padding: EdgeInsets.only(
                                  //                                         left: 3
                                  //                                             .w,
                                  //                                         top: 1
                                  //                                             .w,
                                  //                                         right: 3
                                  //                                             .w,
                                  //                                         bottom:
                                  //                                             1.w),
                                  //                                     margin: EdgeInsets.only(
                                  //                                         right:
                                  //                                             10.w),
                                  //                                     decoration: BoxDecoration(
                                  //                                         borderRadius: BorderRadius.all(Radius.circular(10
                                  //                                             .w)),
                                  //                                         color:
                                  //                                             Colors.white10),
                                  //                                     child:
                                  //                                         Text(
                                  //                                       e,
                                  //                                       style: TextStyle(
                                  //                                           fontSize:
                                  //                                               12.sp,
                                  //                                           color: Colors.white60),
                                  //                                     ),
                                  //                                   );
                                  //                                 }).toList(),
                                  //                               )
                                  //                             ],
                                  //                           ),
                                  //                           SizedBox(
                                  //                             height: 10.w,
                                  //                           ),
                                  //                           // 描述
                                  //                           Text(
                                  //                             des,
                                  //                             style: TextStyle(
                                  //                                 fontSize:
                                  //                                     12.sp,
                                  //                                 color: Colors
                                  //                                     .white),
                                  //                           )
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   ))));
                                  //     });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 170.w,
                                      child: Text(
                                        des,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white60),
                                      ),
                                    ),
                                    Text(
                                      '>',
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          color: Colors.white60),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                ],
              ),
              // 收藏，评论，分享数量
              Container(
                padding: EdgeInsets.all(10.w),
                margin: EdgeInsets.only(top: 20.w),
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.all(Radius.circular(20.w))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 收藏
                    Row(
                      children: [
                        Icon(Icons.favorite_border),
                        Text(
                          '${playCountFilter(likeCount)}',
                          style: TextStyle(),
                        )
                      ],
                    ),
                    Text('|'),
                    // 评论
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            NavigatorUtil.gotoCommentPage(
                                context, id.toString(), '2');
                          },
                          child: Icon(Icons.comment),
                        ),
                        Text('${playCountFilter(commentCount)}')
                      ],
                    ),
                    Text('|'),
                    // 分享
                    Row(
                      children: [
                        Icon(Icons.share),
                        Text(
                          '${playCountFilter(shareCount)}',
                          style: TextStyle(),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _buildStickyBar() {
    if (!isRequestSongInfo) {
      return SliverPersistentHeader(
        pinned: true, //是否固定在顶部
        floating:
            true, // 为 true 时吸顶会定位到顶部，不管上面有没有存在另一个吸顶的组件；false 时会吸顶到上面吸顶组件的下面
        delegate: _SliverAppBarDelegate(
            minHeight: 50.h, //收起的高度
            maxHeight: 50.h, //展开的最大高度
            child: Container(
              padding: EdgeInsets.only(left: 16.w),
              color: Colors.white,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/playAll.svg',
                    width: 20.w,
                  ),
                  InkWell(
                    onTap: () {
                      // 点击播放歌单全部歌曲
                      List tempSongs = [];
                      songInfo.forEach((element) {
                        tempSongs.add({
                          "id": element.id,
                          "url": '',
                          "img": element.al!.picUrl,
                          "author": element.ar!
                              .map<String?>((e) {
                                return e.name!;
                              })
                              .toList()
                              .join('/'),
                          "name": element.name,
                          "album": element.al!.name
                        });
                      });
                      Provider.of<MusicModel>(context, listen: false)
                          .playListSongs(tempSongs);
                    },
                    child: Text("  播放全部(${songInfo.length})",
                        style: TextStyle(fontSize: 18.sp)),
                  )
                ],
              ),
            )),
      );
    } else {
      return SliverToBoxAdapter();
    }
  }

  Widget _buildList() {
    if (isRequestSongInfo) {
      print("歌曲请求中，不渲染");
      return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Column(
          children: [
            SizedBox(
              height: 5.w,
            ),
            Loading(),
            // Expanded(
            //   child: Container(
            //     color: Colors.white,

            //   ),)
          ],
        );
      }, childCount: 1));
    } else {
      print("歌曲请求完毕渲染");
      if (songInfo.isEmpty) {
        return Center(
          child: Text("当前歌单暂无歌曲"),
        );
      } else {
        return SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) {
            String author = songInfo[index]
                .ar!
                .map<String?>((e) {
                  return e.name!;
                })
                .toList()
                .join('/');
            return Container(
              width: 375.w,

              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.white, width: 0),
                    top: BorderSide(color: Colors.white, width: 0)),
                color: Colors.white,
              ),
              // padding: EdgeInsets.only(left: 8.w, right: 8.w),
              alignment: Alignment.center,
              child: Column(
                children: [
                  // Material(
                  // color: Colors.transparent,
                  // child:
                  Ink(
                    // color: Colors.transparent,
                    child: InkWell(
                      // 点击播放歌曲
                      onTap: () {
                        print(songInfo[index]);
                        var i = {
                          "id": songInfo[index].id,
                          "url": '',
                          "img": songInfo[index].al!.picUrl,
                          "author": author,
                          "name": songInfo[index].name,
                          "album": songInfo[index].al!.name
                        };
                        context.read<MusicModel>().playOneSong(i);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 索引
                          Container(
                            width: 35.w,
                            padding: EdgeInsets.only(left: 8.w),
                            child: Center(
                              child: songInfo[index].id ==
                                      Provider.of<MusicModel>(context)
                                          .info['id']
                                  ? Image.asset(
                                      'assets/images/loading.gif',
                                      width: 20.w,
                                    )
                                  : Text('${index + 1}',
                                      maxLines: 1,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          color: Colors.black)),
                            ),
                          ),
                          // 歌曲信息
                          Container(
                            width: 290.w,
                            padding: EdgeInsets.only(top: 8.w, bottom: 8.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // 歌曲名称
                                Container(
                                  width: 260.w,
                                  child: Text('${songInfo[index].name}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.black)),
                                ),
                                Row(
                                  children: [
                                    // 超清音质
                                    songAnother[index].maxbr >= 999000
                                        ? Container(
                                            padding: EdgeInsets.all(1),
                                            margin: EdgeInsets.only(right: 1),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(3.w)),
                                            child: Text(
                                              'SQ',
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          )
                                        : SizedBox(),
                                    // 作者 和 专辑
                                    Container(
                                      width: 260.w,
                                      child: Text(
                                        '$author - ${songInfo[index].al!.name}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12.sp),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          // 右侧三点点击更多信息部分
                          InkWell(
                            onTap: () {
                              var i = {
                                'img': songInfo[index].al!.picUrl,
                                'id': songInfo[index].id,
                                'name': songInfo[index].name,
                                'author': songInfo[index]
                                    .ar!
                                    .map((e) => e.name)
                                    .join(' / '),
                                "album": songInfo[index].al!.name
                              };
                              showModalBottomSheet(
                                  context: context,
                                  enableDrag: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.w),
                                  ),
                                  builder: (context) {
                                    return MoreInfo(item: i);
                                  });
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 8.w),
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // ),
                  index + 1 == songInfo.length
                      ? SizedBox(
                          height:
                              Provider.of<MusicModel>(context).info['id'] == ''
                                  ? 0
                                  : 50.w,
                          width: 375.w,
                        )
                      : SizedBox()
                ],
              ),
            );
          },
          childCount: songInfo.length,
        ));
      }
    }
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
