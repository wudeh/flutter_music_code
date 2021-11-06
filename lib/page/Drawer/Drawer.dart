import 'package:cloud_music/provider/color.dart';
import 'package:cloud_music/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../provider/color.dart';

class DrawerPage extends StatefulWidget {

  DrawerPage({Key? key}) : super(key: key);

  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: ClipOval(
              child: Image.asset('assets/images/img_user_head.png')
            ),
            accountName: Text(
              '这是个没有什么用的抽屉页'
            ), 
            accountEmail: Text('1650024814@qq.com'),
          ),
          ListTile(
            onTap: () async {
              await canLaunch('https://github.com/Binaryify/NeteaseCloudMusicApi')
                ? await launch('https://github.com/Binaryify/NeteaseCloudMusicApi')
                : showToast("网络错误");
            },
            leading: Icon(Icons.airline_seat_flat_angled,color: Theme.of(context).primaryColor),
            title: Text('点击查看本应用数据来源',style: TextStyle(color: Theme.of(context).primaryColor),),
            trailing: Icon(Icons.chevron_right,color: Theme.of(context).primaryColor),
          ),
          ExpansionTile(
            leading: Icon(Icons.accessibility),
            title: Text('主题颜色更换'),
            children: <Widget>[
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: Provider.of<ColorModel>(context, listen:  false).colorList.map((color){
                    return InkWell(
                      onTap: () async {
                        // 点击记录主体颜色索引，更换主体颜色
                        MyAppSettings settings;
                        final preferences = await StreamingSharedPreferences.instance;
                        settings = MyAppSettings(preferences);
                        // 往本地存储中储存主题颜色索引
                        settings.colorIndex.setValue(color[1]);
                        Provider.of<ColorModel>(context,listen: false).changeColor(color[1]);
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
        ],
      ),
    );
  }
}