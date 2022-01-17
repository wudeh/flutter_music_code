import 'package:cloud_music/api/api.dart';
import 'package:cloud_music/http/http.dart';
import 'package:cloud_music/page/Drawer/Download.dart';
import 'package:cloud_music/page/Drawer/msg.dart';
import 'package:cloud_music/page/common/crop_image.dart';
import 'package:cloud_music/page/common/extended_image.dart';
import 'package:cloud_music/provider/color.dart';
import 'package:cloud_music/provider/user.dart';
import 'package:cloud_music/router/navigator_util.dart';
import 'package:cloud_music/util/shared_preference.dart';
import 'package:cloud_music/util/cacheUtil.dart';
import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../provider/color.dart';

class DrawerPage extends StatefulWidget {
  DrawerPage({Key? key}) : super(key: key);

  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  int cacheSize = 0;

  String version = "";

  @override
  void initState() {
    super.initState();
    initCache();
    GetVersion();
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

  // 获取当前应用版本
  void GetVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      // 得到当前应用版本号
      setState(() {
        version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        color: Color.fromRGBO(0, 0, 0, 0.05),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 28,
            ),
            // 抽屉页 可以点击上传头像
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                  color: Colors.red),
              currentAccountPicture: Provider.of<UserModel>(context)
                          .userInfo
                          ?.profile
                          ?.avatarUrl ==
                      null
                  ? ClipOval(
                      child: Image.asset(
                      'assets/images/img_user_head.png',
                      width: 40.w,
                    ))
                  : InkWell(
                      child: ExtenedImage(
                        img: Provider.of<UserModel>(context)
                            .userInfo
                            ?.profile
                            ?.avatarUrl,
                        height: 40.w,
                        width: 40.w,
                        isRectangle: false,
                      ),
                      onTap: () async {
                        NavigatorUtil.gotoCropAvatarPage(context);
                      },
                    ),
              accountName: Text('这是个没有什么用的抽屉页：版本$version'),
              accountEmail: Text('1650024814@qq.com'),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                  color: Colors.white),
              child: MsgDrawer(),
            ),
            // 主要进行一些设置类操作
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                  color: Colors.white),
              margin: EdgeInsets.only(top: 10.w),
              child: Column(
                children: [
                  // 网易云 api
                  ListTile(
                    onTap: () async {
                      await canLaunch(
                              'https://github.com/Binaryify/NeteaseCloudMusicApi')
                          ? await launch(
                              'https://github.com/Binaryify/NeteaseCloudMusicApi')
                          : showToast("网络错误");
                    },
                    leading: Icon(Icons.airline_seat_flat_angled,
                        color: Theme.of(context).primaryColor),
                    title: Text(
                      '点击查看本应用数据来源',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    trailing: Icon(Icons.chevron_right,
                        color: Theme.of(context).primaryColor),
                  ),
                  // 更换主题
                  ExpansionTile(
                    leading: Icon(Icons.accessibility),
                    title: Text('主题颜色更换'),
                    children: <Widget>[
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children:
                            Provider.of<ColorModel>(context, listen: false)
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
                  // 清除缓存
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('本地缓存'),
                    subtitle: Text('点击清除缓存'),
                    // subtitle: Text('点击清除缓存，但不会清除已下载的歌曲'),
                    trailing: Text((cacheSize / 1024 / 1024)
                            .toStringAsFixed(2)
                            .toString() +
                        "MB"),
                    onTap: handleClearCache,
                  ),
                  // 更新版本
                  DownloadPage(),
                ],
              ),
            ),
            
            // 退出登录
            Provider.of<UserModel>(context, listen: false).userInfo == null
                ? SizedBox()
                : InkWell(
                    onTap: () async {
                      HttpRequest().get(Api.logout);
                      final preferences =
                          await StreamingSharedPreferences.instance;
                      MyAppSettings settings = MyAppSettings(preferences);
                      settings.userInfo.clear();
                      Provider.of<UserModel>(context, listen: false)
                          .clearUserInfo();
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
                      margin: EdgeInsets.only(top: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.w)),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text("退出登录"),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
