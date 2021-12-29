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

  int cacheSize = 0;

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){ // 设置状态栏背景及颜色
        SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.red);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
        // SystemChrome.setEnabledSystemUIOverlays([]); //隐藏状态栏
    }
    initCache();
  }

  // 更新获取缓存
  Future<void> initCache() async {
    /// 获取缓存大小
    int size = await CacheUtil.total();

    /// 复制变量
    setState(() {
      cacheSize = size;
    });
  }

  // 清除缓存
  Future<void> handleClearCache() async {
    try {
      if (cacheSize <= 0) {
        showToast("没有缓存可清理");
        return;
      }

      /// 给予适当的提示
      /// bool confirm = await showDialog();
      /// if (confirm != true) return;

      /// 执行清除缓存
      await CacheUtil.clear();

      /// 更新缓存
      await initCache();

      showToast('缓存清除成功');
    } catch (e) {
      showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        
        title: Text("个人页"),
        actions: [
          Icon(Icons.search),
          SizedBox(width: 8.w,)
        ],
      ),
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
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('本地缓存'),
            subtitle: Text('点击清除缓存'),
            // subtitle: Text('点击清除缓存，但不会清除已下载的歌曲'),
            trailing: Text(
                (cacheSize / 1024 / 1024).toStringAsFixed(2).toString() + "MB"),
            onTap: handleClearCache,
          )
        ],
      ),
      ),
    );
    
  }
}
