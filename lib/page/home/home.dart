import 'dart:async';
import 'dart:convert';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:test22/model/dicover_model.dart';
import 'package:test22/model/discover.dart';
import 'package:test22/page/Drawer/Drawer.dart';
import 'package:test22/page/common/pop/pop.dart';
import 'package:test22/page/common/pop/pop_widget.dart';
import 'package:test22/page/home/home_bone.dart';
import 'package:test22/page/play_list/songList.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
// import 'package:test22/model/discover.g.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import '../../api/api.dart';
import 'package:dio/dio.dart';
import '../../http/http.dart';
import '../../model/recommend.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oktoast/oktoast.dart';
import '../../util/num.dart';
import '../search/search.dart';
import '../common/audio_bar.dart';
import '../../provider/music.dart';
import 'package:provider/provider.dart';
import '../../router/navigator_util.dart';
import '../common/extended_image.dart';
import '../../model/discover.dart';
import '../common/page_view_swiper.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var data = {};
  var ballData;

  List temp = [];

  final EasyRefreshController _controller = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  String word = '';

  var cursor;

  int requestTime = 0; // 请求次数

  bool isLoading = true;

  bool badRequest = false;

  @override
  void initState() {
    super.initState();
    // _getWord();
    // 渲染完成后执行一次刷新方法
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // _controller.callRefresh();
      cursor = null;
      // temp.clear();
      requestTime = 0;
      // getData();
      Future.wait([getData(), getBallData(), _getWord()]).then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    //步骤五：关流
    super.dispose();
  }

  // 获取圆形图标区域数据
  Future getBallData() async {
    try {
      ballData = await HttpRequest().get(Api.homePageBall);
    } catch (e) {
      showToast('获取圆形图标错误');
      print('获取圆形图标错误');
      return;
    }
    ballData = json.decode(ballData);
    if (ballData['data'].length == 0) {
      ballData = null;
      showToast('未获取到圆形图标数据');
    }
    return 1;
  }

  // 获取首页数据
  Future getData() async {
    setState(() {
      badRequest = false;
    });
    try {
      // await getBallData();
      String params = "";
      if (cursor != null) params = "&cursor=${cursor.toString()}";
      String a = '';
      try {
        a = await HttpRequest().get(Api.homePage + params);
      } catch (e) {
        setState(() {
          badRequest = true;
        });
        return;
      }

      var b = json.decode(a);
      // DiscoverModel data = DiscoverModel.fromJson(b);
      // setState(() {
      requestTime += 1;
      temp = (b['data']['blocks']);
      // temp.addAll(b['data']['blocks']);
      cursor = b['data']['cursor'];
      setState(() {});
      _controller.finishRefresh();
    } catch (e) {
      _controller.finishLoad(IndicatorResult.noMore);
    }
    return 1;
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

  // 获取搜索词
  Future _getWord() async {
    var res = await HttpRequest.getInstance().get(Api.homePageWord);
    var info = json.decode(res);
    setState(() {
      word = info['data']['showKeyword'];
    });
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.dehaze)),
        title: InkWell(
          onTap: () {
            // 跳转搜索页
            NavigatorUtil.gotoSearchPage(context);
          },
          child: Container(
              width: 320,
              height: 29,
              padding: EdgeInsets.only(left: 10.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: Center(
                  child: Text(
                word,
                style: TextStyle(color: Colors.black38, fontSize: 16.sp),
              ))),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: PopWidget(
                child: Icon(
                  Icons.mic,
                ),
              ))
        ],
      ),
      // 返回一个铺满屏幕的 box
      body: isLoading
          ? const HomeBone()
          : badRequest
              ? GestureDetector(
                  child: Center(
                    child: Text('网络错误，点击重试'),
                  ),
                  onTap: () {
                    Future.wait([getData(), getBallData(), _getWord()])
                        .then((value) {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  },
                )
              :
              // 下拉刷新
              SmartRefresher(
                  onRefresh: () async {
                    cursor = null;
                    // temp.clear();
                    requestTime = 0;
                    await getData();
                    _controller.resetFooter();
                    _refreshController.refreshCompleted();
                  },
                  // onLoad: requestTime == 2 || cursor == null ? null : getData,
                  // enableControlFinishLoad: true,
                  // controller: _controller,
                  // header: MaterialHeader(),
                  // footer: const ClassicFooter(),
                  enablePullDown: true,
                  enablePullUp: false,
                  header: MaterialClassicHeader(),
                  controller: _refreshController,
                  child: ListView.builder(
                      itemCount: temp.length,
                      itemBuilder: (context, index) {
                        // 轮播图
                        if (temp[index]['blockCode'] == 'HOMEPAGE_BANNER') {
                          // return Container(
                          //   height: 160.w,
                          //   color: Colors.yellow,
                          //   width: 100,
                          // );
                          return Container(
                            height: 160.w,
                            padding: EdgeInsets.all(8.w),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: PageSwiper(
                                itemCount: temp[0]['extInfo']['banners'].length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    child: HeroExtenedImage(
                                        width: 340.w,
                                        height: 140.w,
                                        img: temp[0]['extInfo']['banners']
                                            [index]['pic']),
                                    onTap: () {
                                      bannerTap(
                                          temp[0]['extInfo']['banners'][index]);
                                    },
                                  );
                                },
                              ),
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
                                ballData != null
                                    ? Container(
                                        height: 70.w,
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
                                                  width: 40.w,
                                                  height: 40.w,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor.withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40.w)),
                                                  margin: EdgeInsets.only(
                                                      left: 8.w, right: 8.w),
                                                  child: Image.network(
                                                    ballData['data'][index]
                                                        ['iconUrl'],
                                                    width: 50.w,
                                                    height: 50.w,
                                                    color: Theme.of(context).primaryColor,
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
                                      )
                                    : SizedBox(),

                                // 推荐歌单 标题
                                Padding(
                                  padding: EdgeInsets.only(bottom: 3.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(left: 8.w),
                                          child: PopWidget(
                                            child: Text(
                                              temp[1]['uiElement']['subTitle']
                                                  ['title'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.sp),
                                            ),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            // 跳转搜索页
                                            NavigatorUtil.gotoSearchPage(
                                                context);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: 8.w),
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
                                              style: TextStyle(fontSize: 12.sp),
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
                                      itemCount:
                                          temp[tempIndex]['creatives'].length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                            onTap: () {
                                              NavigatorUtil.gotoSongListPage(
                                                  context,
                                                  temp[tempIndex]['creatives']
                                                      [index]['creativeId'],
                                                  temp[tempIndex]['creatives']
                                                                  [index]
                                                              ['resources'][0]
                                                          ['uiElement']['image']
                                                      ['imageUrl']);
                                            },
                                            child: Container(
                                              width: 110.w,
                                              margin: EdgeInsets.only(
                                                  left: index == 0 ? 8.w : 0,
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
                                                          child: HeroExtenedImage(
                                                              width: 110.w,
                                                              height: 110.w,
                                                              img: temp[tempIndex]['creatives']
                                                                              [
                                                                              index]
                                                                          ['resources'][0]
                                                                      ['uiElement']['image']
                                                                  ['imageUrl'])),
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
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 3.w),
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
                                                                  playCountFilter(temp[tempIndex]['creatives'][index]['resources']
                                                                              [
                                                                              0]
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
                                                                ['resources'][0]
                                                            ['uiElement']
                                                        ['mainTitle']['title'],
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                  color: Colors.black.withOpacity(0.1),
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
                                        child: PopWidget(
                                          child: Text(
                                            temp[index]['uiElement']['subTitle']
                                                ['title'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp),
                                          ),
                                        )),
                                    Container(
                                      margin:
                                          EdgeInsets.only(right: 8.w, top: 8.w),
                                      padding: EdgeInsets.only(
                                          left: 1.w, right: 6.w),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.black26),
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
                                                "author": item[
                                                            'resourceExtInfo']
                                                        ['artists']
                                                    .map((item) => item['name'])
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
                                              temp[index]['uiElement']['button']
                                                  ['text'],
                                              style: TextStyle(fontSize: 12.sp),
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
                                        children: temp[fatherIndex]['creatives']
                                                [index]['resources']
                                            .map<Widget>((item) {
                                          return InkWell(
                                              // 点击播放一首歌
                                              onTap: () {
                                                print(item);
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
                                                      ['mainTitle']['title'],
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
                                                          child: ExtenedImage(
                                                            img:
                                                                item['uiElement']
                                                                        [
                                                                        'image']
                                                                    [
                                                                    'imageUrl'],
                                                            width: 50.w,
                                                          )),
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
                                                            child: Text.rich(
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
                                                                        fontSize: 12
                                                                            .sp,
                                                                        color: Colors
                                                                            .black38),
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
                                                          Container(
                                                            width: 270.w,
                                                            child: Text.rich(
                                                              TextSpan(
                                                                  children: [
                                                                    // 超高音质
                                                                    item['resourceExtInfo']['songPrivilege']['maxbr'] >=
                                                                            999000
                                                                        ? WidgetSpan(
                                                                            child:
                                                                                Container(
                                                                            padding:
                                                                                EdgeInsets.all(1),
                                                                            margin:
                                                                                EdgeInsets.only(right: 1),
                                                                            decoration:
                                                                                BoxDecoration(border: Border.all(width: 1, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(3.w)),
                                                                            child:
                                                                                Text(
                                                                              'SQ',
                                                                              style: TextStyle(fontSize: 10.sp, color: Theme.of(context).primaryColor),
                                                                            ),
                                                                          ))
                                                                        : WidgetSpan(
                                                                            child:
                                                                                SizedBox()),
                                                                    // VIP
                                                                    item['resourceExtInfo']['songPrivilege']['fee'] ==
                                                                            1
                                                                        ? WidgetSpan(
                                                                            child:
                                                                                Container(
                                                                            padding:
                                                                                EdgeInsets.all(1),
                                                                            margin:
                                                                                EdgeInsets.only(right: 1),
                                                                            decoration:
                                                                                BoxDecoration(border: Border.all(width: 1, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(3.w)),
                                                                            child:
                                                                                Text(
                                                                              'vip',
                                                                              style: TextStyle(fontSize: 10.sp, color: Theme.of(context).primaryColor),
                                                                            ),
                                                                          ))
                                                                        : WidgetSpan(
                                                                            child:
                                                                                SizedBox()),
                                                                    // 试听
                                                                    item['resourceExtInfo']['songPrivilege']['fee'] ==
                                                                            1
                                                                        ? WidgetSpan(
                                                                            child:
                                                                                Container(
                                                                            padding:
                                                                                EdgeInsets.all(1),
                                                                            margin:
                                                                                EdgeInsets.only(right: 1),
                                                                            decoration:
                                                                                BoxDecoration(border: Border.all(width: 1, color: Colors.blueAccent), borderRadius: BorderRadius.circular(3.w)),
                                                                            child:
                                                                                Text(
                                                                              '试听',
                                                                              style: TextStyle(fontSize: 10.sp, color: Colors.blueAccent),
                                                                            ),
                                                                          ))
                                                                        : WidgetSpan(
                                                                            child:
                                                                                SizedBox()),
                                                                    // 独家
                                                                    item['resourceExtInfo']['songPrivilege']['fee'] ==
                                                                            1
                                                                        ? WidgetSpan(
                                                                            child:
                                                                                Container(
                                                                            padding:
                                                                                EdgeInsets.all(1),
                                                                            margin:
                                                                                EdgeInsets.only(right: 1),
                                                                            decoration:
                                                                                BoxDecoration(border: Border.all(width: 1, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(3.w)),
                                                                            child:
                                                                                Text(
                                                                              '独家',
                                                                              style: TextStyle(fontSize: 10.sp, color: Theme.of(context).primaryColor),
                                                                            ),
                                                                          ))
                                                                        : WidgetSpan(
                                                                            child:
                                                                                SizedBox()),
                                                                    // 副标题
                                                                    item['uiElement']['subTitle'] !=
                                                                            null
                                                                        ? TextSpan(
                                                                            text:
                                                                                item['uiElement']['subTitle']['title'],
                                                                            style:
                                                                                TextStyle(fontSize: 10.sp, color: item['uiElement']['subTitle']['titleType'] == 'songRcmdTag' ? Colors.yellow : Colors.black26),
                                                                          )
                                                                        : WidgetSpan(
                                                                            child:
                                                                                SizedBox())
                                                                  ]),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )));
                                        }).toList());
                                  },
                                ),
                              ),
                              Container(
                                height: 8.w,
                                color: Colors.black12,
                              ),
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
                                            margin: EdgeInsets.only(right: 8.w),
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
                                              style: TextStyle(fontSize: 12.sp),
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
                                      itemCount:
                                          temp[tempIndex]['creatives'].length,
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
                                                      [index]['creativeId'],
                                                  temp[tempIndex]['creatives']
                                                                  [index]
                                                              ['resources'][0]
                                                          ['uiElement']['image']
                                                      ['imageUrl']);
                                            },
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.w),
                                                        child: HeroExtenedImage(
                                                          img: temp[tempIndex][
                                                                              'creatives']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'resources']
                                                                  [
                                                                  0]['uiElement']
                                                              [
                                                              'image']['imageUrl'],
                                                          width: 110.w,
                                                        )),
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
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 3.w),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .play_arrow,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              Text(
                                                                playCountFilter(temp[tempIndex]['creatives'][index]
                                                                            [
                                                                            'resources'][0]
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
                                                              ['resources'][0]
                                                          ['uiElement']
                                                      ['mainTitle']['title'],
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
                              ],
                            ),
                          );
                        }
                        return SizedBox();
                      })),
    );
  }
}
