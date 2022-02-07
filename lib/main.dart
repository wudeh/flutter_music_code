import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_music/model/login_model.dart';
import 'package:cloud_music/page/common/audio_bar.dart';
import 'package:cloud_music/page/my/index.dart';
import 'package:cloud_music/provider/download.dart';
import 'package:cloud_music/provider/user.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import './page/home.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import './provider/music.dart';
import './provider/color.dart';
import './util/shared_preference.dart';
import './router/routes.dart';
import './router/application.dart';
import 'package:fluro/fluro.dart';
import './page/Drawer/Drawer.dart';

void main() {
  PaintingBinding.instance?.imageCache?.maximumSizeBytes = 1000 << 20;

  // print("计算 ${1000 << 20}");

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
        ChangeNotifierProvider(create: (context) => DownloadProvider()),
        ChangeNotifierProvider(create: (context) => UserModel()),
        //可以继续添加，语法如上，这样可以全局管理多个状态
      ],
      child: MyApp(),
    ),
  );

  // if(Platform.isAndroid){ // 设置状态栏背景及颜色
  //       SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.red);
  //       SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  //       // SystemChrome.setEnabledSystemUIOverlays([]); //隐藏状态栏
  //   }
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getWrite();
    getThemeColor();
    getUserInfo();
    connectJudge();
  }

  //监测网络变化
  void connectJudge() async {
    var subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi) {
        // showToast('WiFi放心用', position: ToastPosition(align: Alignment.bottomCenter));
      } else if (result == ConnectivityResult.mobile) {
        // showToast('注意用的是自己的流量~~', position: ToastPosition(align: Alignment.bottomCenter));
      } else {
        showToast('网络好像出问题了',
            position: ToastPosition(align: Alignment.bottomCenter));
      }
    });
  }

  // 获取读写权限
  void getWrite() async {}

  // 从本地获取主题颜色索引
  void getThemeColor() async {
    final preferences = await StreamingSharedPreferences.instance;
    MyAppSettings settings = MyAppSettings(preferences);
    int colorIndex = settings.colorIndex.getValue();
    Provider.of<ColorModel>(context, listen: false).changeColor(colorIndex);
    // if(kIsWeb == true) {
    //   showToast('当前为web平台');
    // }
  }

  // 从本地获取用户信息
  void getUserInfo() async {
    final preferences = await StreamingSharedPreferences.instance;
    MyAppSettings settings = MyAppSettings(preferences);
    String userInfo = settings.userInfo.getValue();
    if (userInfo != "") {
      LoginModel userInfoData = LoginModel.fromJson(jsonDecode(userInfo));
      Provider.of<UserModel>(context, listen: false).initUserInfo(userInfoData);
    }
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
                  primaryColor: Colors.red,
                  primarySwatch: Provider.of<ColorModel>(context).colorMain,
                  //要支持下面这个需要使用第一种初始化方式
                  textTheme: TextTheme(button: TextStyle(fontSize: 45.sp)),
                ),
                home: MyHomePage(title: '网易云音乐'),
                //注册路由表
                onGenerateRoute: Application.router.generator,
              ),
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
  // 索引页面
  List<Widget> pageWidget = [Home(), MySet()];

  PageController _pageController = PageController(initialPage: 0);

  // 底部图标
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
  ];

  // 首页索引
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDownload();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  void initDownload() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
        );

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerPage(),
        body: Stack(
          children: [
            PageView(
              children: pageWidget,
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
            ),
            // AudioBar()
          ],
        ),
        bottomNavigationBar: Container(
          height:
              Provider.of<MusicModel>(context).info['id'] == '' ? 60 : 110.w,
          child: Column(
            children: [
              Expanded(
                child: AudioBar(),
              ),
              BottomNavigationBar(
                  onTap: (index) {
                    _pageController.animateToPage(index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease);
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  currentIndex: currentIndex,
                  items: bottomItems),
            ],
          ),
        ));
  }
}
