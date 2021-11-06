import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';
import './extended_image.dart';
import '../../provider/music.dart';
import 'package:provider/provider.dart';
import '../../api/api.dart';
import '../../http/http.dart';
import '../../model/comment_num.dart';
import '../../router/navigator_util.dart';

// 这个组件是点击右侧更多的三个点时会弹出的

class MoreInfo extends StatefulWidget {
  // 需要传进来歌曲必要的信息，包括歌曲封面，歌曲名称，作者，id等
  var item;

  MoreInfo({Key? key, required this.item}) : super(key: key);

  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {

  // 评论数量
  int commentNum = 0;

  @override
  void initState() { 
    super.initState();
    _getCommentNum();
  }

  // 获取评论数量
  void _getCommentNum() async {
    // 这里只考虑获取歌曲评论，不考虑其他，所以 type 为0
    int now = new DateTime.now().millisecondsSinceEpoch;
  // print("当前时间：$now");
    String res = await HttpRequest.getInstance().get(Api.comment + 'id=${widget.item['id']}&type=0&pageNo=1&pageSize=20&sortType=3&timestamp=$now');
    var a = json.decode(res);
    commentModel b = commentModel.fromJson(a);
    setState(() {
      commentNum = b.data!.totalCount!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
      padding: EdgeInsets.all(8.w),
      height: 330.h,
      child: ListView(
        children: [
          // 第一部分是歌曲封面，歌曲名字，歌曲作者
          Row(
            children: [
              // 歌曲封面
              ExtenedImage(width: 50.w, height: 50.w, img: widget.item['img']),
              SizedBox(
                width: 20.w,
              ),
              // 名字 作者
              Column(
                children: [
                  Container(
                    width: 280.w, 
                    child: Text(widget.item['name'],maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.sp),),
                  ),
                  Container(
                    width: 280.w, 
                    child: Text(widget.item['author'],maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, color: Colors.black26)),
                  ),
                ], 
              )
            ],
          ),
          // 下面是评论，添加到下一首
          ListTile(
            leading: ClipOval(
              child: Image.asset('assets/images/cover-bg-in.png', width: 20.w,), 
            ),
            title: Text('下一首播放'),
            onTap: () {
              Map info = {
                "id": widget.item['id'],
                "url": '',
                "img": widget.item['img'],
                "author": widget.item['author'],
                "name": widget.item['name'],
                "album": widget.item['album']
              };
              Provider.of<MusicModel>(context, listen: false).nextPlay(info);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.black,),
            title: Text('收藏到歌单'),
          ),
          ListTile(
            leading: Icon(Icons.comment, color: Colors.black,),
            title: Text('评论($commentNum)'),
            onTap: () {
              NavigatorUtil.gotoCommentPage(context, widget.item['id'].toString(), '0');
            },
          ),
          ListTile(
            leading: Icon(Icons.share, color: Colors.black,),
            title: Text('分享'),
          ),
          ListTile(
            leading: Icon(Icons.download, color: Colors.black,),
            title: Text('下载'),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black,),
            title: Text('歌手：${widget.item['author']}'),
          ),
          ListTile(
            leading: Icon(Icons.album, color: Colors.black,),
            title: Text('专辑：${widget.item['album']}'),
          ),
        ],
      ),
    )
    );
  }
}