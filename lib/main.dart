import 'package:cloud_music/page/songList.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import './page/home.dart';
import 'package:oktoast/oktoast.dart';
import './api/api.dart';
import './http/http.dart';
import 'dart:convert';
import './page/search/search.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import './provider/music.dart';
import './provider/color.dart';
import './page/audio/audio.dart';
import './util/shared_preference.dart';
import './router/routes.dart';
import './router/application.dart';
import './router/navigator_util.dart';
import 'package:fluro/fluro.dart';
import './page/Drawer/Drawer.dart';

void main() async {

  // 路由配置
  var router = FluroRouter();
  Routes.configureRoutes(router);
  Application.router = router;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CounterModel(0)),
        ChangeNotifierProvider(create: (context) => MusicModel()),
        ChangeNotifierProvider(create: (context) => ColorModel()),
    //可以继续添加，语法如上，这样可以全局管理多个状态
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {

  MyApp({Key? key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getThemeColor();
    connectJudge();
    
  }

  //监测网络变化 
  void connectJudge() async {
    var subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.wifi) {
        // showToast('WiFi放心用', position: ToastPosition(align: Alignment.bottomCenter));
      }else if(result == ConnectivityResult.mobile) {
        // showToast('注意用的是自己的流量~~', position: ToastPosition(align: Alignment.bottomCenter));
      }else {
        showToast('网络好像出问题了', position: ToastPosition(align: Alignment.bottomCenter));
      }
    
  });
  }

  // 从本地获取主题颜色索引
  void getThemeColor() async {
    final preferences = await StreamingSharedPreferences.instance;
    MyAppSettings settings = MyAppSettings(preferences);
    int colorIndex = settings.colorIndex.getValue();
    Provider.of<ColorModel>(context,listen: false).changeColor(colorIndex);
    // if(kIsWeb == true) {
    //   showToast('当前为web平台');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 667),
      builder: () => OKToast(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '网易云音乐',
            theme: ThemeData(
              primarySwatch: Provider.of<ColorModel>(context).colorMain,
              //要支持下面这个需要使用第一种初始化方式
              textTheme: TextTheme(button: TextStyle(fontSize: 45.sp)),
            ),
            home: MyHomePage(title: '网易云音乐'),
            //注册路由表
            onGenerateRoute: Application.router.generator,),
      ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String word = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // 获取搜索词
  Future<void> _getWord() async {
    var res = await HttpRequest().get(Api.homePageWord);
    var info = json.decode(res);
    word = info['data']['showKeyword'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () {
              // 跳转搜索页
              NavigatorUtil.gotoSearchPage(context);
            },
            child: Container(
              width: 350.w,
              height: 30.w,
              padding: EdgeInsets.only(left: 10.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.w),
                  color: Colors.white),
              child: FutureBuilder(
                future: _getWord(),
                initialData: '期待今天的惊喜~~',
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Center(
                      child: Text(
                    word,
                    style: TextStyle(color: Colors.black38, fontSize: 16.sp),
                  ));
                },
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: InkWell(
                onTap: () {
                  if(kIsWeb) {
                    showToast('web 平台不支持下载');
                  }else {
                    showToast('敬请期待');
                  }
                }, 
                child: Icon(Icons.download),
              ),
            )
          ],
        ),
        drawer: DrawerPage(),
        body: Home(),
        );
  }
}
