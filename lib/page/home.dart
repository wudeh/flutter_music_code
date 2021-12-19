import 'dart:async';
import 'dart:convert';

import 'package:cloud_music/model/discover.dart';
import 'package:cloud_music/page/songList.dart';
import 'package:extended_image/extended_image.dart';
// import 'package:cloud_music/model/discover.g.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import '../http/http.dart';
import '../model/recommend.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oktoast/oktoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../util/num.dart';
import './search/search.dart';
import './common/audio_bar.dart';
import '../provider/music.dart';
import 'package:provider/provider.dart';
import '../router/navigator_util.dart';
import 'common/extended_image.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var data = {};
  var ballData;

  late StreamController _streamController;

  @override
  void initState() {
    super.initState();
    // this.focusItemModel = this.widget.focusItemModel;
    // this.focusType = this.widget.focusType;
    // this.index = this.widget.index;
    // this.studentId = this.widget.studentId;
    //步骤三实现 StreamController<FocuseItemModel>,FocuseItemModel是我的实体类
    // _streamController = StreamController.broadcast();
    //步骤四将数据添加到 _streamController

    getData();
  }

  @override
  void dispose() {
    //步骤五：关流
    _streamController.close();
    super.dispose();
  }

  // 获取首页数据
  Future<void> getData() async {
    _streamController = new StreamController.broadcast();
    // _streamController.stream;
    try {
      ballData = await HttpRequest().get(Api.homePageBall);
      ballData = json.decode(ballData);
      var a = await HttpRequest().get(Api.homePage);
      var b = json.decode(a);
      // Discover info = Discover.fromJson(b);
      // print(b);
      _streamController.sink.add(b);
    } catch (e) {
      // print('出错了');
      _streamController.addError(e);
    }
  }

  // 点击轮播图
  void bannerTap(item) async {
    if (item['url'] != null) {
      await canLaunch(item['url'])
          ? await launch(item['url'])
          : showToast("网络错误");
    } else {
      showToast("不能跳转");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      // initialData: initialData ,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('没有Stream');
          case ConnectionState.waiting:
            return Container(
              height: 100.w,
              child: Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              )),
            );
          case ConnectionState.active:
            if (snapshot.hasError) {
              return Center(
                child: InkWell(
                  child: Text('网络请求错误，请点击重试'),
                  onTap: () {
                    _streamController.sink.add('loading');
                    getData();
                  },
                ),
              );
            } else if (snapshot.data == 'loading') {
              return Container(
                height: 100.w,
                child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                )),
              );
            }
            List temp = snapshot.data['data']['blocks'];
            // 返回一个铺满屏幕的 box
            return ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Stack(
                children: [
                  // 下拉刷新
                  RefreshIndicator(
                      onRefresh: getData,
                      child: ListView.builder(
                          // physics: BouncingScrollPhysics(),
                          itemCount: temp.length,
                          itemBuilder: (context, index) {
                            // 轮播图
                            if (temp[index]['blockCode'] == 'HOMEPAGE_BANNER') {
                              return Container(
                                height: 150.w,
                                padding: EdgeInsets.all(8.w),
                                child: Swiper(
                                  autoplay: true,
                                  itemCount:
                                      temp[0]['extInfo']['banners'].length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      child: ExtenedImage(
                                          width: 340.w,
                                          height: 140.w,
                                          img: temp[0]['extInfo']['banners']
                                              [index]['pic']),
                                      onTap: () {
                                        bannerTap(temp[0]['extInfo']['banners']
                                            [index]);
                                      },
                                    );
                                  },
                                ),
                              );
                            }
                            // 推荐歌单
                            else if (temp[index]['blockCode'] ==
                                'HOMEPAGE_BLOCK_PLAYLIST_RCMD') {
                              var tempIndex = index;
                              return Container(
                                // height: 50.w,
                                child: Column(
                                  children: [
                                    // 圆形图标
                                    Container(
                                        height: 70.w,
                                        child: InkWell(
                                          onTap: () {
                                            // 跳转搜索页
                                            NavigatorUtil.gotoSearchPage(
                                                context);
                                          },
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            itemCount: ballData['data'].length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 50.w,
                                                    height: 50.w,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    50.w)),
                                                    margin: EdgeInsets.only(
                                                        left: 8.w, right: 8.w),
                                                    child: ExtenedImage(
                                                      img: ballData['data'][index]
                                                          ['iconUrl'],
                                                      width: 50.w,
                                                      height: 50.w,
                                                    ),
                                                  ),
                                                  Text(
                                                    ballData['data'][index]
                                                        ['name'],
                                                    style: TextStyle(
                                                        fontSize: 12.sp),
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        )),
                                    // 推荐歌单 标题
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 3.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.w),
                                            child: Text(
                                              temp[1]['uiElement']['subTitle']
                                                  ['title'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.sp),
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                // 跳转搜索页
                                                NavigatorUtil.gotoSearchPage(
                                                    context);
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 8.w),
                                                padding: EdgeInsets.only(
                                                    left: 8.w, right: 8.w),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black26),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.w)),
                                                child: Text(
                                                  temp[1]['uiElement']['button']
                                                          ['text'] +
                                                      ' >',
                                                  style: TextStyle(
                                                      fontSize: 12.sp),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                        height: 150.w,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics: BouncingScrollPhysics(),
                                          itemCount: temp[tempIndex]
                                                  ['creatives']
                                              .length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                                onTap: () {
                                                  NavigatorUtil.gotoSongListPage(
                                                      context,
                                                      temp[tempIndex]['creatives']
                                                          [index]['creativeId']);
                                                },
                                                child: Container(
                                                  width: 110.w,
                                                  margin: EdgeInsets.only(
                                                      left:
                                                          index == 0 ? 8.w : 0,
                                                      right: 8.w),
                                                  child: Column(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.w),
                                                              child: ExtenedImage(
                                                                  width: 110.w,
                                                                  height: 110.w,
                                                                  img: temp[tempIndex]['creatives'][index]['resources'][0]
                                                                              ['uiElement']
                                                                          ['image']
                                                                      [
                                                                      'imageUrl'])),
                                                          Positioned(
                                                              top: 3.w,
                                                              right: 3.w,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .black38,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.w)),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right: 3
                                                                            .w),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .play_arrow,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    Text(
                                                                      playCountFilter(temp[tempIndex]['creatives'][index]['resources'][0]
                                                                              [
                                                                              'resourceExtInfo']
                                                                          [
                                                                          'playCount']),
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                      Text(
                                                        temp[tempIndex]['creatives']
                                                                        [index][
                                                                    'resources']
                                                                [0]['uiElement']
                                                            [
                                                            'mainTitle']['title'],
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 12.w,
                                                            height: 1.5),
                                                      )
                                                    ],
                                                  ),
                                                ));
                                          },
                                        )),

                                    Container(
                                      height: 8.w,
                                      color: Colors.black12,
                                    )
                                  ],
                                ),
                              );
                            }
                            // 长名字区域
                            else if (temp[index]['blockCode'] ==
                                'HOMEPAGE_BLOCK_STYLE_RCMD') {
                              int fatherIndex = index;
                              return Column(
                                children: [
                                  // 长名字标题
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 3.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.w, top: 8.w),
                                          child: Text(
                                            temp[index]['uiElement']['subTitle']
                                                ['title'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: 8.w, top: 8.w),
                                          padding: EdgeInsets.only(
                                              left: 1.w, right: 6.w),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black26),
                                              borderRadius:
                                                  BorderRadius.circular(12.w)),
                                          child: InkWell(
                                            // 点击播放长信息区域的 12 首歌
                                            onTap: () {
                                              List tempSongs = [];
                                              temp[fatherIndex]['creatives']
                                                  .forEach((i) {
                                                i['resources'].forEach((item) {
                                                  tempSongs.add({
                                                    "id": item['resourceId'],
                                                    "url": '',
                                                    "img": item['uiElement']
                                                        ['image']['imageUrl'],
                                                    "author":
                                                        item['resourceExtInfo']
                                                                ['artists']
                                                            .map((item) =>
                                                                item['name'])
                                                            .join('/'),
                                                    "name": item['uiElement']
                                                        ['mainTitle']['title'],
                                                  });
                                                });
                                              });
                                              context
                                                  .read<MusicModel>()
                                                  .playListSongs(tempSongs);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.play_arrow),
                                                Text(
                                                  temp[index]['uiElement']
                                                      ['button']['text'],
                                                  style: TextStyle(
                                                      fontSize: 12.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  // 长名字信息区
                                  Container(
                                    height: 170.w,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      itemCount:
                                          temp[fatherIndex]['creatives'].length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: temp[fatherIndex]
                                                        ['creatives'][index]
                                                    ['resources']
                                                .map<Widget>((item) {
                                              return InkWell(
                                                  // 点击播放一首歌
                                                  onTap: () {
                                                    var i = {
                                                      "id": item['resourceId'],
                                                      "url": '',
                                                      "img": item['uiElement']
                                                          ['image']['imageUrl'],
                                                      "author":
                                                          item['resourceExtInfo']
                                                                  ['artists']
                                                              .map((item) =>
                                                                  item['name'])
                                                              .join('/'),
                                                      "name": item['uiElement']
                                                              ['mainTitle']
                                                          ['title'],
                                                    };
                                                    context
                                                        .read<MusicModel>()
                                                        .playOneSong(i);
                                                  },
                                                  child: Container(
                                                      width: 360.w,
                                                      padding: EdgeInsets.only(
                                                          left: 8.w),
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.w),
                                                              child: Hero(
                                                                  tag: item['uiElement']
                                                                          [
                                                                          'image']
                                                                      [
                                                                      'imageUrl'],
                                                                  child:
                                                                      ExtenedImage(
                                                                    img: item['uiElement']
                                                                            [
                                                                            'image']
                                                                        [
                                                                        'imageUrl'],
                                                                    width: 50.w,
                                                                    height:
                                                                        50.w,
                                                                  ))),
                                                          SizedBox(
                                                            width: 8.w,
                                                          ),
                                                          // 歌曲信息部分
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // 歌曲名称和歌手
                                                              Container(
                                                                width: 270.w,
                                                                child:
                                                                    Text.rich(
                                                                  TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            '${item['uiElement']['mainTitle']['title']}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15.sp),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' - ${item['resourceExtInfo']['artists'].map((item) => item['name']).toList().join('/')}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12.sp,
                                                                            color: Colors.black38),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                              // 副标题区域
                                                              Row(
                                                                children: [
                                                                  // 超高音质
                                                                  item['resourceExtInfo']['songPrivilege']
                                                                              [
                                                                              'maxbr'] >=
                                                                          999000
                                                                      ? Container(
                                                                          padding:
                                                                              EdgeInsets.all(1),
                                                                          margin:
                                                                              EdgeInsets.only(right: 1),
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                                                              borderRadius: BorderRadius.circular(3.w)),
                                                                          child:
                                                                              Text(
                                                                            'SQ',
                                                                            style:
                                                                                TextStyle(fontSize: 12.sp, color: Theme.of(context).primaryColor),
                                                                          ),
                                                                        )
                                                                      : SizedBox(),
                                                                  // 副标题
                                                                  item['uiElement']
                                                                              [
                                                                              'subTitle'] !=
                                                                          null
                                                                      ? Text(
                                                                          item['uiElement']['subTitle']
                                                                              [
                                                                              'title'],
                                                                          style: TextStyle(
                                                                              fontSize: 12.sp,
                                                                              color: item['uiElement']['subTitle']['titleType'] == 'songRcmdTag' ? Colors.yellow : Colors.black26),
                                                                        )
                                                                      : SizedBox()
                                                                ],
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      )));
                                            }).toList());
                                      },
                                    ),
                                  )
                                ],
                              );
                            }
                            // 雷达歌单
                            else if (temp[index]['blockCode'] ==
                                'HOMEPAGE_BLOCK_MGC_PLAYLIST') {
                              var tempIndex = index;
                              return Container(
                                // height: 50.w,
                                child: Column(
                                  children: [
                                    // 标题
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 3.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.w),
                                            child: Text(
                                              temp[tempIndex]['uiElement']
                                                  ['subTitle']['title'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.sp),
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                // 跳转搜索页
                                                NavigatorUtil.gotoSearchPage(
                                                    context);
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 8.w),
                                                padding: EdgeInsets.only(
                                                    left: 8.w, right: 8.w),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black26),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.w)),
                                                child: Text(
                                                  '${temp[tempIndex]['uiElement']['button']['text']} >',
                                                  style: TextStyle(
                                                      fontSize: 12.sp),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),

                                    Container(
                                        height: 150.w,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics: BouncingScrollPhysics(),
                                          itemCount: temp[tempIndex]
                                                  ['creatives']
                                              .length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              height: 110.w,
                                              width: 110.w,
                                              margin: EdgeInsets.only(
                                                  left: index == 0 ? 8.w : 0,
                                                  right: 8.w),
                                              child: InkWell(
                                                onTap: () {
                                                  NavigatorUtil.gotoSongListPage(
                                                      context,
                                                      temp[tempIndex]['creatives']
                                                          [index]['creativeId']);
                                                },
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.w),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: temp[tempIndex]['creatives']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'resources'][0]
                                                                    [
                                                                    'uiElement']
                                                                [
                                                                'image']['imageUrl'],
                                                            fit: BoxFit.contain,
                                                            height: 110.w,
                                                            width: 110.w,
                                                            placeholder: (context,
                                                                    url) =>
                                                                Image.asset(
                                                                    'assets/images/loading.png'),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                        ),
                                                        Positioned(
                                                            top: 3.w,
                                                            right: 3.w,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black38,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.w)),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          3.w),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .play_arrow,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  Text(
                                                                    playCountFilter(temp[tempIndex]['creatives'][index]['resources'][0]
                                                                            [
                                                                            'resourceExtInfo']
                                                                        [
                                                                        'playCount']),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  )
                                                                ],
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                    Text(
                                                      temp[tempIndex]['creatives']
                                                                      [index]
                                                                  ['resources']
                                                              [0]['uiElement'][
                                                          'mainTitle']['title'],
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 12.w,
                                                          height: 1.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )),

                                    Container(
                                      height: 8.w,
                                      color: Colors.black12,
                                    ),
                                    Visibility(
                                      visible: Provider.of<MusicModel>(context)
                                                  .info['id'] ==
                                              ''
                                          ? false
                                          : true,
                                      child: Container(
                                        height: 50.w,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                            return SizedBox();
                          })),
                  // 底部音乐栏
                  AudioBar()
                ],
              ),
            );

          case ConnectionState.done:
            return Text('Stream已关闭');
        }
      },
    );
  }
}
