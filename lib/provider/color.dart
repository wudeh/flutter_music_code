import 'package:test22/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ColorModel with ChangeNotifier {
  List colorList = [
    [Colors.red, 0],
    [Colors.pink, 1],
    [Colors.purple, 2],
    [Colors.deepPurple, 3],
    [Colors.indigo, 4],
    [Colors.blue, 5],
    [Colors.lightBlue, 6],
    [Colors.cyan, 7],
    [Colors.green, 8],
    [Colors.lime, 9],
    [Colors.yellow, 10],
    [Colors.amber, 11],
    [Colors.orange, 12],
    [Colors.deepOrange, 13],
    [Colors.brown, 14],
    [Colors.blueGrey, 15],
    [Colors.grey, 16]
  ];

  late int colorIndex;

  bool isAudioPage = false;

  MaterialColor colorMain = Colors.red;

  ColorModel() {
    initThemeColor();
    // if(colorMain == null) {
    //   colorMain = Colors.red;
    // }
  }

  initThemeColor() async {
    // 初始化主题颜色
    final preferences = await StreamingSharedPreferences.instance;
    MyAppSettings settings = MyAppSettings(preferences);
    int colorIndex = settings.colorIndex.getValue();
    colorMain = colorList[colorIndex][0];
  }

  // 改变主题颜色
  void changeColor(num) {
    colorMain = colorList[num][0];
    colorIndex = num;
    notifyListeners();
  }

  // 进入歌词页面
  void changeAudioPageTrue() {
    // print("进入歌词页面");
    isAudioPage = true;
    // notifyListeners(); 在 inistatus 生命周期中通知可能会出错 setState() or markNeedsBuild() called during build.
  }

  // 离开歌词页面
  void changeAudioPageFalse() {
    // print("离开歌词页面");
    isAudioPage = false;
    // notifyListeners();
  }
}
