import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../http/http.dart';
import '../../api/api.dart';
import '../../event_bus/event.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:convert';
import '../common/text_hight_color.dart';
import '../common/loading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchSong extends StatefulWidget {

  SearchSong({Key? key}) : super(key: key);

  _SearchSongState createState() => _SearchSongState();
}

class _SearchSongState extends State<SearchSong> {

  // 搜索单曲结果
  List songResult = [];
  // 单曲分页
  int songNum = 0;
  // 是否正在请求
  bool isRequestSong = false;
  // 搜索词
  String searchWordNow = '';

  ScrollController _scrollController = new ScrollController();

  var eventBusFn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 监听搜索广播事件
    eventBusFn = eventBus.on<SearchSongEvent>().listen((event) {
      print('触发了');
      setState(() {
        songNum = 0;
      songResult.clear();
      });
      searchWordNow = event.searchWordNow;
      getResult();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventBusFn.cancel();
  }

  // 搜索方法
  void getResult() async {
    
    // if(mounted) {
      setState(() {
        songResult.add('loading');
      });
      var res = await HttpRequest.getInstance().get(Api.searchSong + '?keywords=$searchWordNow&type=1&offset=${songNum*20}&limit=20');
      var info = json.decode(res.toString());
      if (info['code'] != 200) {
        showToast('请求错误');
        songResult.add('error');
        return;
      }
      songResult.removeLast();
      setState(() {
        songResult.addAll(info['result']['songs']);
        songNum ++;
        print(songNum * 20);
        isRequestSong = false;
      });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: songResult.length,
      itemBuilder: (context, int index) {
        if(songResult[index] == 'loading') {
          return Loading();
        }else {
          return Padding(
          padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.w),
          child: Container(
            padding: EdgeInsets.only(bottom: 8.w),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 1, color: Colors.grey))),
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
                    // 单曲名字
                    Container(
                      width: 330.w,
                      child: ColorWordText(
                        word: searchWordNow, text: songResult[index]['name'], size: 16,lowColor: Colors.black,),
                    ),
                    // 超清音质，原唱，独家，VIP，作者，专辑
                    Row(
                      children: [
                        // 超清音质
                        songResult[index]['privilege']['maxbr'] == 999000
                            ? Container(
                                padding: EdgeInsets.all(1),
                                margin: EdgeInsets.only(right: 1),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(width: 1, color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(3.w)),
                                child: Text(
                                  'SQ',
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Theme.of(context).primaryColor),
                                ),
                              )
                            : SizedBox(),
                        // 作者 和 专辑
                        Container(
                          width: 290.w,
                          child: ColorWordText(word: searchWordNow, text: songResult[index]['ar'].map((item) {
                            return item['name'];
                          }).join('/') + ' - ${songResult[index]['al']['name']}', size: 14, lowColor: Colors.grey),
                        ),
                        // Text(' - ', style: TextStyle(color: Colors.grey)),
                        // 专辑
                        // ColorWordText(
                        //     word: searchWordNow,
                        //     text: songResult[index]['al']['name'], size: 14, lowColor: Colors.grey)
                      ],
                    ),
                    // 可能会有额外的信息描述
                    songResult[index]['alia'].length > 0
                        ? Container(
                          width: 330.w, 
                          child: Text(songResult[index]['alia'][0],
                            style: TextStyle(color: Colors.grey,),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,),
                        )
                        : SizedBox()
                  ],
                ),
                ),
                // 右侧三点点击更多信息部分
                InkWell(
                  onTap: () {
                    print('弹出更多');
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        );
        }
        
      },
    );
  }
}

