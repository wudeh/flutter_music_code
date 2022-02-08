import 'dart:convert';

import 'package:test22/router/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../http/http.dart';
import '../../api/api.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../../util/debounce.dart';
import '../../util/shared_preference.dart';
import '../../util/num.dart';
import '../common/audio_bar.dart';
import '../common/text_hight_color.dart';
import 'package:oktoast/oktoast.dart';
import '../common/text_hight_color.dart';
import '../common/loading.dart';
import '../../event_bus/event.dart';
import 'package:provider/provider.dart';
import '../../provider/music.dart';
import '../common/more_info.dart';
import '../../model/search_list_model.dart';
import '../../model/search_singer_model.dart';
import '../common/extended_image.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _selectionController = TextEditingController();

  Object data = {};
  List hotData = [];
  List<String> searchHistory = [];

  late MyAppSettings settings;
  var preferences;

  ScrollController _scrollController = new ScrollController();

  // 控制是否显示搜索建议
  bool showSearchAd = false;

  // 控制是否显示搜索结果
  bool showResult = false;

  // 文本框是否失去焦点
  bool isFocus = false;

  // 搜索词
  String searchWordNow = '';
  // 搜索建议
  List<String> adviceWord = [];

  // 重新搜索
  bool reset = true;

  // 搜索单曲结果
  List songResult = [];
  // 单曲分页
  int songNum = 0;
  // 是否正在请求
  bool isRequestSong = false;

  // 搜索歌单结果
  List<Playlists> listResult = [];
  // 歌单分页
  int listNum = 0;
  // 是否正在请求
  bool isRequestList = false;
  // 正在请求，到底，出错
  String listText = 'loading';

  ScrollController _scrollListController = new ScrollController();

  // 搜索歌手结果
  List<singerArtists> singerResult = [];
  // 歌手分页
  int singerNum = 0;
  // 歌手请求状态
  String singerText = '';
  // 是否正在请求
  bool isRequestSinger = false;

  ScrollController _scrollSingerController = new ScrollController();

  late TabController _tabController = new TabController(vsync: this, length: 2);

  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    _tabController.dispose();
    _scrollListController.dispose();
    _scrollController.dispose();
    _scrollSingerController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getHistory();
    getHot();
    // 单曲到底加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50.w) {
        if (isRequestSong == true) {
          return;
        }
        // print('到底了');
        isRequestSong = true;
        _seachRequest();
      }
    });
    // 歌单到底加载更多
    _scrollListController.addListener(() {
      if (_scrollListController.position.pixels >=
          _scrollListController.position.maxScrollExtent - 50.w) {
        if (isRequestList == true) {
          return;
        }
        isRequestList = true;
        _seachRequest();
      }
    });

    // 歌手到底加载更多
    _scrollSingerController.addListener(() {
      if (_scrollSingerController.position.pixels >=
          _scrollSingerController.position.maxScrollExtent - 50.w) {
        // 在快滑动到底的时候请求
        if (isRequestSinger == true) {
          return;
        }
        isRequestSinger = true;
        _seachRequest();
      }
    });

    _tabController.addListener(() {
      switch (_tabController.index) {
        case 0:
          if (songResult.isEmpty && !songResult.contains('over')) {
            isRequestSong = true;
            _seachRequest();
          }
          ;
          break;
        case 1:
          if (listResult.isEmpty &&
              listText != 'over' &&
              isRequestList != true) {
            isRequestList = true;
            _seachRequest();
          }
          break;
        case 2:
          if (singerResult.isEmpty &&
              singerText != 'over' &&
              isRequestSinger != true) {
            isRequestList = true;
            _seachRequest();
          }
          break;
      }
    });

    // 监听文本获取焦点和失去焦点
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // print('得到焦点');
        setState(() {
          isFocus = true;
        });
      } else {
        // print('失去焦点');
        setState(() {
          isFocus = false;
        });
      }
    });
  }

  // 获取热搜
  getHot() async {
    var hot = await HttpRequest().get(Api.searchHotWord);
    setState(() {
      hotData = (json.decode(hot)['data']);
      // print('============');
      // print(hotData);
    });
  }

  /// 获取本地历史搜索
  getHistory() async {
    final preferences = await StreamingSharedPreferences.instance;
    settings = MyAppSettings(preferences);
    searchHistory = settings.seachHistory.getValue();
    setState(() {});
  }

  /// 点击热门搜索 或 搜索历史，记录搜索历史并搜索结果
  _getSearchResult(word) async {
    songResult.clear();
    listResult.clear();
    singerResult.clear();
    songNum = listNum = singerNum = 0;
    searchWordNow = word;
    _selectionController.text = word;
    List<String> temp = settings.seachHistory.getValue();
    List<String> tempOne = [];
    listText = 'loading';
    singerText = 'loading';
    // 重复的搜索历史要删掉
    if (temp.contains(word)) {
      temp.removeAt(temp.indexOf(word));
    }
    // 搜索历史大于 10 条要删掉
    if (temp.length >= 10) {
      temp.removeLast();
    }
    tempOne.add(word);
    tempOne.addAll(temp);

    settings.seachHistory.setValue(tempOne);

    // 搜索的时候要隐藏搜索建议
    setState(() {
      showSearchAd = false;
    });

    _seachRequest();
  }

  /// 搜索结果
  _seachRequest() async {
    showSearchAd = false;
    showResult = true;
    int now = new DateTime.now().millisecondsSinceEpoch;
    // 搜索单曲
    if (_tabController.index == 0) {
      // 包含 over 就说明没有更多数据了
      if (songResult.contains('over')) return;
      setState(() {
        songResult.add('loading');
      });
      var res = await HttpRequest.getInstance().get(Api.searchSong +
          '?keywords=$searchWordNow&type=1&offset=${songNum * 20}&limit=20&timestamp=$now');
      songResult.removeLast();
      var info = json.decode(res.toString());
      if (info['code'] != 200) {
        showToast('请求错误');
        songResult.add('error');
        return;
      }

      songResult.addAll(info['result']['songs']);

      if (info['result']['songCount'] == songResult.length) {
        setState(() {
          songResult.add('over');
        });
        return;
      }

      setState(() {
        songNum++;
        isRequestSong = false;
      });
    } else if (_tabController.index == 1) {
      // 搜索歌单
      // 包含 over 就说明没有更多数据了
      if (listText == 'over') return;
      // print('请求歌单');
      var res = await HttpRequest.getInstance().get(Api.searchResult +
          '?keywords=$searchWordNow&type=1000&offset=${listNum * 20}&limit=20&timestamp=$now');
      var info = json.decode(res.toString());
      searchListModel a = searchListModel.fromJson(info);
      if (a.code != 200) {
        showToast('请求错误');
        listText = 'error';
        return;
      }

      listResult.addAll(a.result!.playlists!);

      if (a.result!.hasMore! == false) {
        setState(() {
          listText = 'over';
        });
        return;
      }

      setState(() {
        listNum++;
        isRequestList = false;
      });
    } else if (_tabController.index == 2) {
      // 搜索歌手
      // 包含 over 就说明没有更多数据了
      if (singerText == 'over') return;
      // print('请求歌手');
      var res = await HttpRequest.getInstance().get(Api.searchResult +
          '?keywords=$searchWordNow&type=100&offset=${singerNum * 20}&limit=20&timestamp=$now');
      var info = json.decode(res.toString());
      searchSingerModel a = searchSingerModel.fromJson(info);
      if (a.code != 200) {
        showToast('请求错误');
        singerText = 'error';
        return;
      }

      // 当歌手不足一页的时候会同时触发滑动控制的请求，和 tab 控制的请求，这里做一下判断
      if (singerText != 'over') {
        singerResult.addAll(a.result!.artists!);
      }

      if (a.result!.hasMore! == false) {
        setState(() {
          singerText = 'over';
        });
        return;
      }

      setState(() {
        singerNum++;
        isRequestSinger = false;
      });
    }
  }

  /// 获取搜索建议
  _getSearchAdvice(String v) async {
    searchWordNow = v;
    if (v != '') {
      var res = await HttpRequest().get(Api.searchAd + v);
      var temp = json.decode(res.toString());
      // print(temp);
      adviceWord = [];
      if (temp['result']['allMatch'] != null &&
          temp['result']['allMatch'].length > 0) {
        temp['result']['allMatch'].forEach((item) {
          adviceWord.add(item['keyword']);
        });
      }
      if (adviceWord.length > 0) {
        setState(() {
          showSearchAd = true;
        });
      } else {
        setState(() {
          showSearchAd = false;
        });
      }
      if (searchWordNow == '') {
        setState(() {
          showSearchAd = false;
        });
      }
    } else {
      setState(() {
        showSearchAd = false;
        showResult = false;
        _tabController.animateTo(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // 展示搜索结果时禁止回到首页，搜索结果消失
          if (showResult) {
            setState(() {
              // print('监听到了返回');
              _tabController.animateTo(0);
              showResult = false;
              searchWordNow = '';
              _selectionController.clear();
              showSearchAd = false;
            });
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0, // 不设置阴影
              leading: InkWell(
                onTap: () {
                  if (showResult) {
                    setState(() {
                      showResult = false;
                      _tabController.animateTo(0);
                      searchWordNow = '';
                      _selectionController.clear();
                      showSearchAd = false;
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              title: Container(
                height: 30.w,
                child: TextField(
                  // autofocus: true,
                  focusNode: focusNode,
                  controller: _selectionController,
                  decoration: InputDecoration(
                    // labelText: "请输入搜索词",
                    // prefixIcon: Icon(Icons.person),
                    // 未获得焦点下划线设为灰色
                    // enabledBorder: UnderlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.grey),
                    // ),
                    //获得焦点下划线设为蓝色

                    fillColor: Colors.white,
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onChanged: (v) {
                    // 获取搜索建议没做防抖处理
                      _getSearchAdvice(v);
                  },

                  onSubmitted: (value) {
                    if (value == '') {
                      showToast('搜索词不能为空');
                      return;
                    }
                    setState(() {
                      searchWordNow = value;
                    });
                    _getSearchResult(value);
                  },
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectionController.clear();
                        searchWordNow = '';
                        _tabController.animateTo(0);
                        showResult = false;
                      });
                    },
                    child: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
              // bottom: ,
            ),
            bottomNavigationBar: AudioBar(),
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 搜索历史
                    Visibility(
                      visible: searchHistory.length != 0,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.w, bottom: 8.w),
                        child: Text(
                          '历史搜索',
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: searchHistory.length != 0,
                        child: Wrap(
                          children: searchHistory.map<Widget>((item) {
                            return InkWell(
                              onTap: () {
                                // 点击历史搜索
                                _getSearchResult(item);
                              },
                              child: Container(
                                height: 30.h,
                                padding: EdgeInsets.only(
                                    top: 3.w,
                                    bottom: 3.w,
                                    left: 6.w,
                                    right: 6.w),
                                margin: EdgeInsets.only(left: 8.w, bottom: 8.w),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(8.w)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      item,
                                      textAlign: TextAlign.justify,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )),
                    SizedBox(
                      height: 8.w,
                    ),
                    // 热门搜索
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Text(
                        '热门搜索',
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                    Container(
                      height: 430.h,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, //每行2列
                                  childAspectRatio: 5 //显示区域宽高相等
                                  ),
                          itemCount: hotData.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.w),
                                  child: Text(
                                    '${index + 1}${index + 1 < 10 ? '  ' : ''}',
                                    style: TextStyle(
                                        color: index + 1 <= 3
                                            ? Theme.of(context).primaryColor
                                            : Colors.black38),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // 点击热门搜索
                                    _getSearchResult(
                                        hotData[index]['searchWord']);
                                  },
                                  child: Container(
                                    child: Text(
                                      ' ${hotData[index]['searchWord']} ',
                                      style: TextStyle(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                hotData[index]['iconUrl'] == null
                                    ? SizedBox()
                                    : Image.network(
                                        hotData[index]['iconUrl'],
                                        height: 12.w,
                                      )
                              ],
                            );
                          }),
                    ),
                  ],
                ),
                // 搜索结果
                Visibility(
                  visible: showResult,
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Container(
                        color: Colors.white,
                        child: TabBar(
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.label,
                            labelColor: Theme.of(context).primaryColor,
                            unselectedLabelColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.white),
                            tabs: <Widget>[
                              Tab(text: '单曲'),
                              Tab(text: '歌单'),
                              // Tab(text: '歌手'),
                            ]),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child:
                              TabBarView(controller: _tabController, children: [
                            searchSong(),
                            songList(),
                            // singerList()
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
                // 搜索建议
                Visibility(
                    visible: showSearchAd && adviceWord.isNotEmpty && isFocus,
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            setState(() {
                              showSearchAd = false;
                            });
                          },
                          child: Container(
                            color: Colors.black26,
                            child: ListView.builder(
                              itemCount: adviceWord.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1, color: Colors.grey),
                                          top: BorderSide.none)),
                                  child: ListTile(
                                    onTap: () {
                                      // print('点击了');
                                      _getSearchResult(adviceWord[index]);
                                    },
                                    leading: Icon(Icons.search),
                                    // title: RichText(
                                    //     text: TextSpan(
                                    //         text: adviceWord[index].substring(
                                    //             0, searchWordNow.trim().length),
                                    //         style: TextStyle(
                                    //             color: Colors.black,
                                    //             fontWeight: FontWeight.bold),
                                    //         children: [
                                    //       TextSpan(
                                    //           text: adviceWord[index].substring(
                                    //               searchWordNow.trim().length),
                                    //           style:
                                    //               TextStyle(color: Colors.grey))
                                    //     ])),
                                    title: ColorWordText(
                                        word: searchWordNow,
                                        text: adviceWord[index],
                                        size: 12.sp,
                                        lowColor: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                        ))
                      ],
                    )),
                // 底部音乐栏
                // AudioBar()
              ],
            )));
  }

  // 搜索单曲结果
  Widget searchSong() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: songResult.length,
      itemBuilder: (context, int index) {
        if (songResult[index] == 'error') {
          return Container(
            height: 50.w,
            child: Center(
              child: InkWell(
                onTap: () {
                  print('错误点击重新请求');
                },
                child: Text('网络错误，点击重新加载'),
              ),
            ),
          );
        }
        if (songResult[index] == 'over') {
          return Container(
            height: 30.w,
            child: Center(
              child: Text('已经到底啦'),
            ),
          );
        }
        if (songResult[index] == 'loading') {
          return Column(
            children: [
              SizedBox(
                height: 5.w,
              ),
              Loading()
            ],
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            child: Material(
                child: Ink(
              color: Colors.white,
              child: InkWell(
                // 点击播放音乐
                onTap: () {
                  var i = {
                    "id": songResult[index]['id'],
                    "url": '',
                    "img": songResult[index]['al']['picUrl'],
                    "author": songResult[index]['ar']
                        .map((item) => item['name'])
                        .join('/'),
                    "name": songResult[index]['name'],
                    "album": songResult[index]['al']['name']
                  };
                  context.read<MusicModel>().playOneSong(i);
                },
                // 长按复制歌曲名字
                onLongPress: () async {
                  await Clipboard.setData(
                      ClipboardData(text: songResult[index]['name']));
                  showToast('已复制歌曲名字');
                },
                child: Container(
                  padding: EdgeInsets.only(top: 8.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 单曲信息部分
                      Container(
                        width: 330.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 单曲名字，热搜榜
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: ColorWordText(
                                    word: searchWordNow,
                                    text: songResult[index]['name'],
                                    size: 16,
                                    lowColor: Colors.black,
                                  ),
                                ),
                                // 热搜榜
                                songResult[index]['officialTags'] != null &&
                                        songResult[index]['officialTags']
                                                .length >
                                            0
                                    ? Text(
                                        "${songResult[index]['officialTags'][0]}",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.yellow),
                                      )
                                    : SizedBox()
                              ],
                            ),

                            // 超清音质，原唱，独家，VIP，作者，专辑
                            Container(
                              width: 320.w,
                              child: Text.rich(
                                TextSpan(children: [
                                  // 原唱
                                  songResult[index]['originCoverType'] == 1
                                      ? WidgetSpan(
                                          child: Container(
                                          padding: EdgeInsets.all(1),
                                          margin: EdgeInsets.only(right: 2),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(3.w)),
                                          child: Text(
                                            '原唱',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.white),
                                          ),
                                        ))
                                      : WidgetSpan(child: SizedBox()),
                                  // 超高音质
                                  songResult[index]['privilege']['maxbr'] >=
                                          999000
                                      ? WidgetSpan(
                                          child: Container(
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
                                        ))
                                      : WidgetSpan(child: SizedBox()),
                                  // VIP
                                  songResult[index]['fee'] == 1
                                      ? WidgetSpan(
                                          child: Container(
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
                                            'vip',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ))
                                      : WidgetSpan(child: SizedBox()),
                                  // 试听
                                  songResult[index]['fee'] == 1
                                      ? WidgetSpan(
                                          child: Container(
                                          padding: EdgeInsets.all(1),
                                          margin: EdgeInsets.only(right: 1),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.blueAccent),
                                              borderRadius:
                                                  BorderRadius.circular(3.w)),
                                          child: Text(
                                            '试听',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.blueAccent),
                                          ),
                                        ))
                                      : WidgetSpan(child: SizedBox()),
                                  // 独家
                                  songResult[index]['privilege']['fee'] == 1
                                      ? WidgetSpan(
                                          child: Container(
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
                                            '独家',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ))
                                      : WidgetSpan(child: SizedBox()),
                                  // 作者 和 专辑
                                  WidgetSpan(
                                      child: ColorWordText(
                                          word: searchWordNow,
                                          text: songResult[index]['ar']
                                                  .map((item) {
                                                return item['name'];
                                              }).join('/') +
                                              ' - ${songResult[index]['al']['name']}',
                                          size: 14,
                                          lowColor: Colors.grey))
                                ]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // 可能会有额外的信息描述
                            songResult[index]['alia'].length > 0
                                ? Container(
                                    width: 330.w,
                                    child: Text(
                                      songResult[index]['alia'][0],
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                      // 右侧三点点击更多信息部分
                      InkWell(
                        onTap: () {
                          var i = {
                            "id": songResult[index]['id'],
                            "img": songResult[index]['al']['picUrl'],
                            "author": songResult[index]['ar']
                                .map((item) => item['name'])
                                .join('/'),
                            "name": songResult[index]['name'],
                            "album": songResult[index]['al']['name'],
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
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
          );
        }
      },
    );
  }

  // 搜索歌单结果
  Widget songList() {
    return ListView(
      controller: _scrollListController,
      children: [
        Column(
          children: listResult.map<Widget>((e) {
            return Material(
              child: Ink(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    // 点击去歌单
                    NavigatorUtil.gotoSongListPage(
                        context, e.id.toString(), e.coverImgUrl!);
                  },
                  child: Container(
                    height: 80.w,
                    padding: EdgeInsets.all(8.w),
                    child: Row(
                      children: [
                        // 歌单封面
                        HeroExtenedImage(
                            width: 50.w, height: 50.w, img: e.coverImgUrl!),
                        SizedBox(
                          width: 8.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // 歌单标题
                            Container(
                              width: 280.w,
                              child: ColorWordText(
                                word: searchWordNow,
                                size: 14.sp,
                                lowColor: Colors.black,
                                text: e.name!,
                                maxLine: 2,
                              ),
                            ),
                            // 歌曲数量，播放量，歌单作者
                            Text(
                              '${e.trackCount}首，by ${e.creator!.nickname!}，播放${playCountFilter(e.playCount)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black26),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Visibility(
            visible: listText == 'loading',
            child: Column(
              children: [
                SizedBox(
                  height: 5.w,
                ),
                Loading()
              ],
            )),
        Visibility(
          visible: listText == 'over',
          child: Center(
            child: Text('到底啦'),
          ),
        )
      ],
    );
  }

  // 搜索歌手结果
  Widget singerList() {
    return ListView(
      controller: _scrollSingerController,
      children: [
        Column(
          children: singerResult.map<Widget>((e) {
            return InkWell(
              onTap: () {
                showToast('敬请期待~~');
              },
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // 歌手头像
                        ExtenedImage(
                            width: 50.w,
                            height: 50.w,
                            img: e.img1v1Url!,
                            isRectangle: false),
                        SizedBox(
                          width: 10.w,
                        ),
                        // 歌手名字
                        ColorWordText(
                            word: searchWordNow,
                            text: e.name!,
                            size: 16.sp,
                            lowColor: Colors.black)
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 3.w, bottom: 3.w, left: 6.w, right: 6.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20.w),
                          color: Theme.of(context).primaryColor),
                      child: Text('+ 关注',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        Visibility(
          visible: singerText == 'loading',
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 5.w,
                ),
                Loading()
              ],
            ),
          ),
        ),
        Visibility(
          visible: singerText == 'over',
          child: Center(
            child: Text('到底啦'),
          ),
        )
      ],
    );
  }
}
