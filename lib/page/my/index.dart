import 'package:cloud_music/page/common/extended_image.dart';
import 'package:cloud_music/provider/color.dart';
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

class MySet extends StatefulWidget {
  MySet({Key? key}) : super(key: key);

  @override
  _MySetState createState() => _MySetState();
}

class _MySetState extends State<MySet> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Icon(Icons.search),
          SizedBox(width: 8.w,)
        ],
      ),
      drawer: Drawer(),
      body: Container(
        color: Color.fromRGBO(0, 0, 0, 0.05),
        padding: EdgeInsets.all(8.w),
        child: Column(
        children: <Widget>[
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipOval(child: Image.asset('assets/images/img_user_head.png', width: 40.w,)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("wudeh", style: TextStyle(fontSize: 16.sp),),
                      Text("Lv.7")
                    ],
                  )
                ],
              ),
              Icon(Icons.arrow_forward_ios,color: Colors.grey,)
            ],
          ),
          SizedBox(
            height: 10.w,
          ),
          // 8 个 GridView
          Container(
            height: 140.w,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              color: Colors.white,
            ),
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
                    Icon(Icons.play_circle_filled,color: Theme.of(context).primaryColor,),
                    Text("最近播放")
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.library_music,color: Theme.of(context).primaryColor,),
                    Text("本地/下载")
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.cloud_upload,color: Theme.of(context).primaryColor,),
                    Text("云盘")
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.shopping_cart,color: Theme.of(context).primaryColor,),
                    Text("已购")
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.person_add,color: Theme.of(context).primaryColor,),
                    Text("我的好友")
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.star_rounded,color: Theme.of(context).primaryColor,),
                    Text("收藏和赞")
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.radio,color: Theme.of(context).primaryColor,),
                    Text("我的播客")
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.music_note,color: Theme.of(context).primaryColor,),
                    Text("音乐罐子")
                  ],
                ),
                
              ],
            )
          ),
          ExpansionTile(
            leading: Icon(Icons.accessibility),
            title: Text('主题颜色更换'),
            children: <Widget>[
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: Provider.of<ColorModel>(context, listen: false)
                    .colorList
                    .map((color) {
                  return InkWell(
                    onTap: () async {
                      // 点击记录主体颜色索引，更换主体颜色
                      MyAppSettings settings;
                      final preferences =
                          await StreamingSharedPreferences.instance;
                      settings = MyAppSettings(preferences);
                      // 往本地存储中储存主题颜色索引
                      settings.colorIndex.setValue(color[1]);
                      Provider.of<ColorModel>(context, listen: false)
                          .changeColor(color[1]);
                    },
                    child: Container(
                      margin: EdgeInsets.all(2.w),
                      width: ScreenUtil().setWidth(10.w),
                      height: ScreenUtil().setWidth(10.w),
                      color: color[0],
                    ),
                  );
                }).toList(),
              )
            ],
          ),
          // 我喜欢的音乐
          Container(
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
                    ExtenedImage(
                      width: 50.w,
                      height: 50.w,
                      img: "https://p2.music.126.net/eAFWwRtFVUEt-DjcwFbuFQ==/109951166542584738.jpg",
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("我喜欢的音乐",style: TextStyle(fontSize: 16.sp),),
                        Text("1首",style: TextStyle(fontSize: 12.sp, color: Colors.grey))
                      ],
                    ),
                    
                  ],
                ),
                Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w),
                        border: Border.all(width: 1,color: Colors.grey)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border,size: 15,),
                          SizedBox(width: 4.w,),
                          Text("心动模式",style: TextStyle(fontSize: 12.sp))
                        ],
                      ),
                    )
              ],
            ),
          ),
          // 创建歌单
          Container(
            padding: EdgeInsets.all(10.w),
            margin: EdgeInsets.only(bottom: 10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("创建歌单", style: TextStyle(fontSize: 12.sp,color: Colors.grey,)),
                    Row(
                      children: [
                        Icon(Icons.add, color: Colors.grey,),
                        SizedBox(width: 10.w,),
                        Icon(Icons.more_vert, color: Colors.grey)
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10.w,),
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
                    SizedBox(width: 20.w,),
                    Text("一键导入外部音乐")
                  ],
                )
              ],
            ),
          ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("收藏歌单", style: TextStyle(fontSize: 12.sp,color: Colors.grey,)),
                    Row(
                      children: [
                        SizedBox(width: 10.w,),
                        Icon(Icons.more_vert, color: Colors.grey)
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10.w,),
                Center(
                  child: Text("暂无收藏的歌单", style: TextStyle(fontSize: 12.sp,color: Colors.grey,)),
                )
                
              ],
            ),
          ),
        ],
      ),
      ),
    );
    
  }
}
