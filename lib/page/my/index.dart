import 'package:cloud_music/event_bus/event.dart';
import 'package:cloud_music/page/Drawer/Drawer.dart';
import 'package:cloud_music/page/common/extended_image.dart';
import 'package:cloud_music/provider/color.dart';
import 'package:cloud_music/provider/music.dart';
import 'package:cloud_music/provider/user.dart';
import 'package:cloud_music/router/navigator_util.dart';
import 'package:cloud_music/util/num.dart';
import 'package:cloud_music/util/shared_preference.dart';
import 'package:cloud_music/util/cacheUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../provider/color.dart';
import 'package:cloud_music/model/user_list_model.dart';
import './controller.dart';

class MySet extends StatefulWidget {
  MySet({Key? key}) : super(key: key);

  @override
  _MySetState createState() => _MySetState();
}

class _MySetState extends State<MySet> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 用户歌单
  List<Playlist>? userPlayList;
  // 用户创建的歌单
  List<Playlist>? userCreatePlayList;
  // 用户喜欢的歌单
  List<Playlist>? userlikePlayList;
  // 获取用户歌单
  Future<void> getUserPlayList() async {
    userCreatePlayList = null;
    userlikePlayList = null;
    if (Provider.of<UserModel>(context, listen: false).userInfo != null) {
      UserPlayList? data = await MyController.getUserPlayList(
          Provider.of<UserModel>(context, listen: false)
              .userInfo!
              .profile!
              .userId);
      // 获取到的歌单数组中，第一个歌单是用户喜欢的音乐，其他由自己创建的，和收藏的歌单组成
      setState(() {
        userPlayList = data!.playlist!;
        // 从喜欢的音乐歌单以后开始循环
        userCreatePlayList = [];
        userlikePlayList = [];
        userPlayList?.sublist(1).forEach((e) {
          if (e.userId ==
              Provider.of<UserModel>(context, listen: false)
                  .userInfo!
                  .profile!
                  .userId!) {
            userCreatePlayList?.add(e);
          } else {
            userlikePlayList?.add(e);
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 订阅用户登录事件，登录后重新请求用户的歌单
    eventBus.on<UserLoggedInEvent>().listen((event) {
      getUserPlayList();
    });
    // 订阅用户退出登录事件，清空用户的歌单
    eventBus.on<UserLoggedOutEvent>().listen((event) {
      setState(() {
        userCreatePlayList = null;
        userlikePlayList = null;
        userPlayList = null;
      });
    });
    getUserPlayList();
  }

  // 创建歌单
  Widget MyPlayList() {
    return // 创建歌单
        Container(
      padding: EdgeInsets.all(10.w),
      margin: EdgeInsets.only(bottom: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // 标题，创建歌单
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("创建歌单",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  )),
              Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Icon(Icons.more_vert, color: Colors.grey)
                ],
              )
            ],
          ),
          SizedBox(
            height: 10.w,
          ),
          // 用户创建的歌单
          userCreatePlayList == null
              ? SizedBox()
              : Column(
                  children: userCreatePlayList!.map<Widget>((e) {
                    return InkWell(
                      onTap: () {
                        NavigatorUtil.gotoSongListPage(
                            context, e.id.toString(), e.coverImgUrl!);
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 8.w),
                        child: Row(
                          children: [
                            HeroExtenedImage(
                              width: 50.w,
                              height: 50.w,
                              img: e.coverImgUrl,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 257.w,
                                  child: Text(e.name!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                      )),
                                ),
                                Text(
                                    "${e.trackCount}首，播放${playCountFilter(e.playCount)}次",
                                    style: TextStyle(
                                        fontSize: 12.sp, color: Colors.grey)),
                              ],
                            ),
                            Icon(
                              Icons.more_vert,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
          // 导入外部音乐
          Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                ),
                child: Center(
                  child: Icon(Icons.cloud_upload_outlined),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Text("一键导入外部音乐")
            ],
          )
        ],
      ),
    );
  }

  // 8 个 GridView
  Widget gridArea() {
    return Container(
      height: 140.w,
      padding: EdgeInsets.all(10.w),
      child: GridView(
        // 禁止滑动，避免出现拉扯波纹
        physics: NeverScrollableScrollPhysics(),
        //子布局排列方式
        //按照固定列数来排列
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //主方向的Item间隔 竖直方向
          mainAxisSpacing: 0,
          //次方向的Item间隔
          crossAxisSpacing: 0,
          //子Item 的宽高比
          childAspectRatio: 1.5,
          //每行4列
          crossAxisCount: 4,
        ),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.play_circle_filled,
                color: Theme.of(context).primaryColor,
              ),
              Text("最近播放")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.library_music,
                color: Theme.of(context).primaryColor,
              ),
              Text("本地/下载")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.cloud_upload,
                color: Theme.of(context).primaryColor,
              ),
              Text("云盘")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.shopping_cart,
                color: Theme.of(context).primaryColor,
              ),
              Text("已购")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.person_add,
                color: Theme.of(context).primaryColor,
              ),
              Text("我的好友")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.star_rounded,
                color: Theme.of(context).primaryColor,
              ),
              Text("收藏和赞")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.radio,
                color: Theme.of(context).primaryColor,
              ),
              Text("我的播客")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.music_note,
                color: Theme.of(context).primaryColor,
              ),
              Text("音乐罐子")
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.dehaze)),
        actions: [
          InkWell(
            onTap: () {
              // 跳转搜索页
              NavigatorUtil.gotoSearchPage(context);
            },
            child: Icon(Icons.search),
          ),
          SizedBox(
            width: 8.w,
          )
        ],
      ),
      body: Container(
        color: Color.fromRGBO(0, 0, 0, 0.05),
        padding: EdgeInsets.only(left: 8.w, right: 8.w),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // 用户信息
              InkWell(
                onTap: () {
                  if (Provider.of<UserModel>(context, listen: false).userInfo ==
                      null) {
                    NavigatorUtil.gotoLoginPage(context);
                  } else {
                    NavigatorUtil.gotoUserInfoEditPage(context);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Provider.of<UserModel>(context)
                                    .userInfo
                                    ?.profile
                                    ?.avatarUrl ==
                                null
                            ? ClipOval(
                                child: Image.asset(
                                'assets/images/img_user_head.png',
                                width: 40.w,
                              ))
                            : ExtenedImage(
                                img: Provider.of<UserModel>(context)
                                    .userInfo
                                    ?.profile
                                    ?.avatarUrl,
                                height: 40.w,
                                width: 40.w,
                                isRectangle: false,
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              Provider.of<UserModel>(context)
                                      .userInfo
                                      ?.profile
                                      ?.nickname ??
                                  "你还没登录呢",
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            Text("Lv.7")
                          ],
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              // 8 个 GridView
              Container(
                  // height: 140.w,
                  // padding: EdgeInsets.all(10.w),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      gridArea(),
                      // 下载列表
                      InkWell(
                        onTap: () {
                          NavigatorUtil.gotoDownloadingPage(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.download_for_offline_outlined),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "下载列表",
                                    style: TextStyle(fontSize: 14),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "下载暂停",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
              // 我喜欢的音乐 3136952023
              InkWell(
                onTap: () {
                  if (userPlayList != null) {
                    NavigatorUtil.gotoSongListPage(
                        context,
                        userPlayList![0].id.toString(),
                        userPlayList?[0].coverImgUrl ??
                            "https://p2.music.126.net/eAFWwRtFVUEt-DjcwFbuFQ==/109951166542584738.jpg");
                  } else {
                    NavigatorUtil.gotoSongListPage(context, "3136952023",
                        "https://p2.music.126.net/eAFWwRtFVUEt-DjcwFbuFQ==/109951166542584738.jpg");
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  margin: EdgeInsets.only(bottom: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          HeroExtenedImage(
                            width: 50.w,
                            height: 50.w,
                            img: userPlayList?[0].coverImgUrl ??
                                "https://p2.music.126.net/eAFWwRtFVUEt-DjcwFbuFQ==/109951166542584738.jpg",
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "我喜欢的音乐",
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              Text("${userPlayList?[0].trackCount ?? '∞'}首",
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Colors.grey))
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.w),
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 15,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text("心动模式", style: TextStyle(fontSize: 12.sp))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // 用户创建的歌单
              MyPlayList(),
              // 收藏歌单
              Container(
                  padding: EdgeInsets.all(10.w),
                  margin: EdgeInsets.only(bottom: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      // 标题，创建歌单
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("收藏歌单（${userlikePlayList?.length ?? '0'}）个",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              )),
                          Row(
                            children: [
                              SizedBox(
                                width: 10.w,
                              ),
                              Icon(Icons.more_vert, color: Colors.grey)
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      // 用户收藏的歌单
                      userlikePlayList == null
                          ? Text(
                              "暂无收藏歌单",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.grey),
                            )
                          : Column(
                              children: userlikePlayList!.map<Widget>((e) {
                                return InkWell(
                                  onTap: () {
                                    NavigatorUtil.gotoSongListPage(context,
                                        e.id.toString(), e.coverImgUrl!);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 8.w),
                                    child: Row(
                                      children: [
                                        HeroExtenedImage(
                                          width: 50.w,
                                          height: 50.w,
                                          img: e.coverImgUrl,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 257.w,
                                              child: Text(e.name!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                  )),
                                            ),
                                            Text(
                                                "${e.trackCount}首，播放${playCountFilter(e.playCount)}次",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                        Icon(Icons.more_vert,
                                            color: Colors.grey)
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  )),
              Provider.of<MusicModel>(context, listen: false).info['id'] == ''
                  ? SizedBox()
                  : SizedBox(
                      height: 50,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
