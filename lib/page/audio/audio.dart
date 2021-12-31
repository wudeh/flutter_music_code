import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_music/http/http.dart';
import 'package:cloud_music/page/common/extended_image.dart';
import 'package:cloud_music/page/common/play_list.dart';
// import 'package:download/download.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import '../../provider/music.dart';
import '../../provider/color.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;
import 'package:permission_handler/permission_handler.dart';
import '../../router/navigator_util.dart';
import '../common/more_info.dart';
import '../../api/api.dart';
import '../../model/comment_num.dart';

import 'package:path/path.dart' as p;

class Audio extends StatefulWidget {
  Audio({Key? key}) : super(key: key);

  _AudioState createState() => _AudioState();
}

class _AudioState extends State<Audio> with TickerProviderStateMixin {
  MusicModel _musicModel = new MusicModel();
  // 是否显示所有歌词
  bool _showAllLyric = false;
  // 音量
  double _volumn = 1.0;

  // 手指是否按在歌词上准备拖动
  bool fingerOnLyric = false;

  // 控制面条旋转的角度
  late AnimationController _degController;
  late Animation<double> animation;
  // 控制碟片旋转
  late AnimationController _bgController;

  // 控制歌词 position 的 top 距离，让歌词区域一开始是 stack 区域的一半
  double _lyricTop = 250.h;
  // 歌词能向上滑动的最大距离，根据歌词数量算出来，一条歌词高 20.h
  double maxDistance = 0.0;
  // 用来记录手指滑动歌词过程中滑动到的歌词，颜色比正在播放的歌词暗一些
  int tempNum = 0;

  // 进度时间
  double progress = 0.0;
  // 手指是否放在进度条上
  bool fingerOnProgress = false;

  //  评论数量
  String commentNum = '0';

  // bool get mounted => _element != null;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 初始化面条控制器动画
    _degController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _bgController =
        AnimationController(vsync: this, duration: Duration(seconds: 6));
    // ..addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     _degController.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     _degController.forward();
    //   }
    // });
    animation = Tween(begin: -pi / 9, end: 0.0).animate(_degController);
    _degController.forward();
    if (Provider.of<MusicModel>(context, listen: false).lyric.isEmpty ||
        Provider.of<MusicModel>(context, listen: false).lyric[0][1] ==
            '加载歌词中') {
      Provider.of<MusicModel>(context, listen: false).getLyric();
    }

    _getCommentNum();
    // 进入歌词页面
    Provider.of<ColorModel>(context, listen: false).changeAudioPageTrue();

    if (Platform.isAndroid) {
      // 设置状态栏背景及颜色
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      // SystemChrome.setEnabledSystemUIOverlays([]); //隐藏状态栏
    }
  }

  // 获取评论数量
  void _getCommentNum() async {
    // 这里只考虑获取歌曲评论，不考虑其他，所以 type 为0
    int now = new DateTime.now().millisecondsSinceEpoch;
    // print("当前时间：$now");
    String res = await HttpRequest.getInstance().get(Api.comment +
        'id=${Provider.of<MusicModel>(context, listen: false).info['id']}&type=0&pageNo=1&pageSize=20&sortType=3&timestamp=$now');
    var a = json.decode(res);
    commentModel b = commentModel.fromJson(a);
    // 如果用户还没获取到评论数量就退出这个页面，再 setstate 就会报错

    if (!mounted) return;

    if (mounted) {
      setState(() {
        if (b.data!.totalCount! > 999) commentNum = '999+';
        if (b.data!.totalCount! > 99) commentNum = '99+';
        if (b.data!.totalCount! <= 99)
          commentNum = b.data!.totalCount!.toString();
      });
    }
  }

  @override
  void dispose() {
    // _degController.dispose();
    // _bgController.dispose();
    // // 离开歌词页面
    // Provider.of<ColorModel>(context, listen: false).changeAudioPageFalse();
    // TODO: implement dispose
    super.dispose();
  }

  // @override
  // didChangeDependencies() {
  //   print('测试测试');
  // }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _degController.dispose();
    _bgController.dispose();
    // 离开歌词页面
    Provider.of<ColorModel>(context, listen: false).changeAudioPageFalse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black38,
      height: 667.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 撑满屏幕的图片
          Container(
            height: 667.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: new ExactAssetImage('assets/images/cover-bg-in.png'),
                  fit: BoxFit.cover),
            ),
            child: CachedNetworkImage(
              imageUrl: Provider.of<MusicModel>(context).info['img'],
              fit: BoxFit.cover,
              placeholder: (context, url) => Image.asset(
                'assets/images/cover-bg-in.png',
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),

            // Image.network(
            //   Provider.of<MusicModel>(context).info['img'],
            //   fit: BoxFit.cover,
            //   height: 667.h, // 要让图片充满屏幕要有确定的高度
            // )
          ),
          // Center(
          // child:
          ClipRect(
            // 可裁切矩形
            child: BackdropFilter(
              // 背景过滤器需要配合透明度组件使用
              filter: ImageFilter.blur(sigmaX: 55, sigmaY: 55),
              child: Opacity(
                opacity: 1,
                child: Container(
                    alignment: Alignment.topCenter,
                    height: 667.h,
                    width: 375.w,
                    child: Column(
                      children: [
                        // 顶部标题区域
                        volumn(),
                        SizedBox(
                          height: 8.w,
                        ),
                        // 音量控制条
                        _showAllLyric ? volumnSilder() : SizedBox(height: 30.w),
                        // 中间留声机 和 歌词区域
                        middle(),
                        SizedBox(
                          height: 10.h,
                        ),
                        // 第一份图标部分 主要用来下载
                        firstIcons(),
                        SizedBox(
                          height: 10.h,
                        ),
                        progressSlider(),
                        SizedBox(
                          height: 10.h,
                        ),
                        // 第二个图标部分，主要控制播放
                        secondIcons()
                      ],
                    )),
              ),
            ),
          ),
          // ),
        ],
      ),
    ));
  }

  // 顶部标题区域
  Widget volumn() {
    return Container(
      height: 50.w,
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 返回图标
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ),
          // 歌名和作者
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Provider.of<MusicModel>(context).info['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
              Text(
                Provider.of<MusicModel>(context).info['author'],
                style: TextStyle(fontSize: 12.sp, color: Colors.white70),
              ),
            ],
          ),
          InkWell(
            onTap: () {},
            child: Icon(
              Icons.share,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  // 音量控制条
  Widget volumnSilder() {
    return Container(
        height: 30.w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Icon(
                Icons.volume_down,
                color: Colors.white,
              ),
            ),
            Container(
                height: 20.w,
                width: 330.w,
                child: SliderTheme(
                    data: SliderThemeData(trackHeight: 1.h),
                    child: Slider(
                      value: _volumn,
                      onChanged: (value) {
                        setState(() {
                          _volumn = value;
                          Provider.of<MusicModel>(context, listen: false)
                              .setVolume(value);
                        });
                      },
                      activeColor: Colors.white,
                      inactiveColor: Colors.white,
                    )))
          ],
        ));
  }

  // 中间留声机
  Widget middle() {
    // 判断一下是否在播放状态
    if (Provider.of<MusicModel>(context).isPlaying) {
      _degController.forward();
      _bgController.forward();
    } else {
      _degController.reverse();
      _bgController.stop();
    }
    return InkWell(
        onTap: () {
          setState(() {
            _showAllLyric = !_showAllLyric;
          });
        },
        child: Container(
          height: 480.h,
          child: Stack(
            // clipBehavior: Clip.none,
            children: [
              // 旋转的碟片
              Positioned(
                  top: 150.h,
                  left: 40.w,
                  child: Visibility(
                      visible: !_showAllLyric,
                      child: RotationTransition(
                        turns: _bgController
                          ..addStatusListener((status) {
                            // 动画播放完成后重置，再重新播放动画
                            if (status == AnimationStatus.completed) {
                              _bgController.reset();
                              _bgController.forward();
                            }
                          }),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/cover-bg-in.png',
                            height: 280.h,
                          ),
                        ),
                      ))),
              // 音乐封面
              Positioned(
                  top: 185.h,
                  left: 75.w,
                  child: Visibility(
                      visible: !_showAllLyric,
                      child: RotationTransition(
                        turns: _bgController
                          ..addStatusListener((status) {
                            // 动画播放完成后重置，再重新播放动画
                            if (status == AnimationStatus.completed) {
                              _bgController.reset();
                              _bgController.forward();
                            }
                          }),
                        child: ClipOval(
                            child: ExtenedImage(
                          img: Provider.of<MusicModel>(context).info['img'],
                          height: 210.h,
                          width: 210.h,
                          isRectangle: false,
                        )),
                      ))),
              // 面条
              Positioned(
                  left: 150.w,
                  child: Visibility(
                    visible: !_showAllLyric,
                    child: AnimatedBuilder(
                      animation: animation,
                      builder: (context, widget) {
                        return Transform.rotate(
                          //旋转90度
                          alignment: Alignment.topLeft,
                          angle: animation.value,
                          child: Image.asset(
                            'assets/images/needle.png',
                            height: 200.h,
                          ),
                        );
                      },
                    ),
                  )),

              // 歌词区域
              lyric(),
              // 歌词指示线, 放在 stack 布局中的歌词区域下面，不然会被歌词区域挡住
              Positioned(
                  top: 240.h,
                  child: Visibility(
                      visible: fingerOnLyric,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white70,
                          ),
                          Container(
                            height: 1,
                            width: 300.w,
                            margin: EdgeInsets.only(left: 8.w, right: 8.w),
                            color: Colors.white70,
                          ),
                          Text(
                            Provider.of<MusicModel>(context).lyric[tempNum][2],
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ))),
            ],
          ),
        ));
  }

  // 歌词
  Widget lyric() {
    var tempIndex = -1;
    var tempList = Provider.of<MusicModel>(context).lyric;
    // 算出歌词区域高度
    maxDistance = 250.h - Provider.of<MusicModel>(context).lyric.length * 20.h;
    var tempCurrentTime = Provider.of<MusicModel>(context).numberTime;
    List<Widget> temp;
    if (tempList.length == 0) {
      temp = [
        GestureDetector(
            onLongPress: () async {
              await Clipboard.setData(ClipboardData(text: '加载歌词中'));
              showToast('已复制选中歌词');
            },
            child: Container(
              height: 20.h,
              child: Text(
                '加载歌词中',
                style: TextStyle(color: Colors.white54),
              ),
            ))
      ];
    } else {
      temp = tempList.map<Widget>((item) {
        tempIndex++;
        Color tempColor = Colors.white54;
        // 如果手指正在滑动的话，计算滑动到的歌词
        if (fingerOnLyric == true) {
          if (tempNum == tempIndex) tempColor = Colors.white70;
        }
        if (tempIndex == tempList.length - 1) {
          if (tempList[tempIndex][0] <= tempCurrentTime) {
            tempColor = Colors.white;
          }
        } else if ((tempList[tempIndex][0] <= tempCurrentTime) &&
            (tempIndex + 1 <= tempList.length - 1) &&
            (tempList[tempIndex + 1][0] > tempCurrentTime)) {
          // 判断正在播放的歌词高亮的依据是当前播放时间 大于等于当前循环到的歌词时间，小于下一条歌词时间
          tempColor = Theme.of(context).primaryColor;
          // 如果手指没有按下的话，歌词可以根据高亮歌词自动滑动
          if (fingerOnLyric == false) {
            _lyricTop = 250 - tempIndex * 20.h;
          }
        }
        return GestureDetector(
            onLongPress: () async {
              await Clipboard.setData(ClipboardData(text: item[1]));
              showToast('已复制选中歌词');
            },
            child: Container(
              height: 20.h,
              child: Text(
                item[1],
                style: TextStyle(color: tempColor),
              ),
            ));
      }).toList();
    }

    return AnimatedPositioned(
        top: _lyricTop,
        child: Visibility(
            visible: _showAllLyric,
            child: GestureDetector(
                child: Container(width: 375.w, child: Column(children: temp)),
                //手指按下时会触发此回调
                onPanDown: (DragDownDetails e) {
                  //打印手指按下的位置(相对于屏幕)

                  // print("用户手指按下：${e.globalPosition}");
                },
                //垂直方向拖动事件
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  // 如果正在加载歌词 或者 没有歌词的话不允许拖动
                  if (Provider.of<MusicModel>(context, listen: false).lyric[0]
                              [1] ==
                          '当前音乐暂无歌词' ||
                      Provider.of<MusicModel>(context, listen: false).lyric[0]
                              [1] ==
                          '加载歌词中') return;
                  fingerOnLyric = true;
                  setState(() {
                    _lyricTop += details.delta.dy;
                    if (_lyricTop >= 250.h) _lyricTop = 250.h;
                    if (_lyricTop <= maxDistance) _lyricTop = maxDistance;
                    // 算出滑动距离
                    var a = 250.h - _lyricTop;
                    // 算出滑到那一句了
                    tempNum = (a ~/ 20.h <= tempList.length - 1)
                        ? a ~/ 20.h
                        : tempList.length - 1;
                  });
                },
                onVerticalDragEnd: (e) {
                  // 如果正在加载歌词 或者 没有歌词的话不允许拖动
                  if (Provider.of<MusicModel>(context, listen: false).lyric[0]
                              [1] ==
                          '当前音乐暂无歌词' ||
                      Provider.of<MusicModel>(context, listen: false).lyric[0]
                              [1] ==
                          '加载歌词中') return;
                  // 算出滑动距离
                  var a = 250.h - _lyricTop;
                  // 算出滑到那一句了
                  int b = a ~/ 20.h;
                  Provider.of<MusicModel>(context, listen: false).seek(b);
                  setState(() {
                    fingerOnLyric = false;
                  });
                },
                onTapUp: (e) {
                  print('手指离开了');
                  setState(() {
                    _showAllLyric = false;
                    fingerOnLyric = false;
                  });
                })),
        duration: Duration(milliseconds: 80));
  }

  // 第一个图标部分
  Widget firstIcons() {
    return Container(
      width: 290.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 收藏
          InkWell(
            onTap: () {
              showToast('不支持收藏');
            },
            child: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
          ),
          InkWell(
            onTap: () async {
              if (kIsWeb == true) {
                showToast('web平台暂不支持下载');
                return;
              }
              int a = Provider.of<MusicModel>(context, listen: false)
                      .info['url']
                      .split('.')
                      .length -
                  1;
              String b = Provider.of<MusicModel>(context, listen: false)
                  .info['url']
                  .split('.')[a];
              // print(a);
              // print(b);
              // print('上面是下载的');
              bool status = await Permission.storage.isGranted;
              await Permission.storage.isDenied;
              await Permission.storage.isLimited;
              await Permission.storage.isPermanentlyDenied;
              //判断如果还没拥有读写权限就申请获取权限
              if (!status) {
                await Permission.storage.request().isGranted;
                await Permission.storage.request().isDenied;
                await Permission.storage.request().isLimited;
                await Permission.storage.request().isPermanentlyDenied;
              }

              // 调用下载方法 --------做该做的事

              // 这里是用 dio 自带的下载
              // HttpRequest.instance.download(
              //     Provider.of<MusicModel>(context, listen: false).info['url'],
              //     '/storage/emulated/0/${Provider.of<MusicModel>(context, listen: false).info['name']}.$b');

              var externalStorageDirPath;
              // if (Platform.isAndroid) {
              //   final directory = await getExternalStorageDirectory();
              //   externalStorageDirPath = directory?.path;
              // } else if (Platform.isIOS) {
                externalStorageDirPath =
                    (await getApplicationDocumentsDirectory()).path;
              // }

              print("第一个path${externalStorageDirPath}");

              var _localPath = externalStorageDirPath + "/Download";
              final savedDir = Directory(_localPath);
              bool hasExisted = await savedDir.exists();
              if (!hasExisted) {
                print(savedDir);
                savedDir.create();
              }

              // var taskId = FlutterDownloader.enqueue(
              //   url:
              //       Provider.of<MusicModel>(context, listen: false).info['url'],
              //   fileName: Provider.of<MusicModel>(context, listen: false)
              //           .info['name'] +
              //       ".mp3",
              //   // headers: {"auth": "test_for_sql_encoding"},
              //   savedDir: _localPath,
              //   showNotification: true,
              //   openFileFromNotification: true,
              //   saveInPublicStorage: true,
              // );
            },
            child: Icon(
              Icons.download,
              color: Colors.white,
            ),
          ),
          // 录音功能
          InkWell(
            onTap: () {
              showToast('暂不支持录音');
            },
            child: Icon(
              Icons.microwave_sharp,
              color: Colors.white,
            ),
          ),
          // 评论数量
          Stack(
            // 超出不做裁剪
            clipBehavior: Clip.none,
            children: [
              SvgPicture.asset(
                'assets/images/comment_num.svg',
                width: 20.w,
              ),
              Positioned(
                top: -8.w,
                right: -27.w,
                child: Center(
                    child: InkWell(
                  onTap: () {
                    // 跳转评论页面
                    NavigatorUtil.gotoCommentPage(
                        context,
                        Provider.of<MusicModel>(context, listen: false)
                            .info['id']
                            .toString(),
                        '0');
                  },
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    // color: Colors.greenAccent,
                    child: Text(
                      '$commentNum',
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ),
                )),
              )
            ],
          ),
          // 弹出当前播放歌曲信息
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  enableDrag: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  builder: (context) {
                    return MoreInfo(
                        item: Provider.of<MusicModel>(context, listen: false)
                            .info);
                  });
            },
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // 进度条
  Widget progressSlider() {
    // 只有手指不滑动进度条的时候，才让当前进度值为 provider 中的当前时间
    if (fingerOnProgress == false) {
      progress = Provider.of<MusicModel>(context, listen: false).numberTime;
    }
    return
        // 这里由于原生 slider 组件没找到表示缓存时间的属性，只能自己通过绝对定位来写了
        // 进度条
        Container(
      width: 330.w,
      height: 10.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 缓存时间
          Positioned(
              top: 5.2.w,
              left: 23.w,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 1.h,
                // 由于进度条在 container 中并不会撑满父 container的宽度，这里经过长时间调整，确定 284.w 宽度能较为完整的覆盖进度条
                width: Provider.of<MusicModel>(context).buffed /
                    Provider.of<MusicModel>(context).duration *
                    284.w,
                color: Colors.white70,
              )),
          SliderTheme(
              data: SliderThemeData(
                // 滑块高度
                trackHeight: 1.h,
                //已拖动的颜色
                activeTrackColor: Colors.white,
                //未拖动的颜色
                inactiveTrackColor: Colors.white60,

                //提示进度的气泡的背景色
                valueIndicatorColor: Color.fromRGBO(0, 0, 0, 0.2),
                //提示进度的气泡文本的颜色
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),

                //滑块中心的颜色
                thumbColor: Colors.white,
                //滑块边缘的颜色
                overlayColor: Colors.white60,

                //divisions对进度线分割后，断续线中间间隔的颜色
                inactiveTickMarkColor: Colors.white,
              ),
              child: Slider(
                  value: progress,
                  // 把进度条分成多少份，要想显示进度条拖动过程中的气泡，这个属性必须加上
                  divisions: 1000,
                  max: Provider.of<MusicModel>(context).duration,
                  // 要在气泡上显示的文字，这里经过了一番计算，补足了不足两位数时显示 00:00 的时间格式
                  label:
                      '当前滑动时间：${(progress / 60).floor() > 0 ? '0' + (progress / 60).floor().toString() : '00'}:${(progress % 60).floor() > 9 ? (progress % 60).floor() : '0' + (progress % 60).floor().toString()}',
                  onChanged: (value) {
                    setState(() {
                      fingerOnProgress = true;
                      progress = value;
                    });
                  },
                  // 滑动结束才改变进度
                  onChangeEnd: (value) {
                    fingerOnProgress = false;
                    // print(progress);
                    Provider.of<MusicModel>(context, listen: false)
                        .seetNum(progress);
                  })),
          // 当前播放时间
          Positioned(
            left: -15.w,
            top: -2.h,
            child: Text(
              Provider.of<MusicModel>(context).stringTime,
              style: TextStyle(color: Colors.white),
            ),
          ),
          // 当前播放音乐总时长
          Positioned(
            top: -2.h,
            left: 315.w,
            child: Text(Provider.of<MusicModel>(context).stringDuration,
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  // 第二个图标部分
  Widget secondIcons() {
    return Container(
      width: 290.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 播放模式
          Stack(
            children: [
              // 循环播放
              Visibility(
                  visible: Provider.of<MusicModel>(context).mode == 1,
                  child: InkWell(
                    onTap: () {
                      Provider.of<MusicModel>(context, listen: false)
                          .changeMode();
                    },
                    child: SvgPicture.asset(
                      'assets/images/circulate.svg',
                      width: 20.w,
                      color: Colors.white,
                    ),
                  )),
              // 随机播放
              Visibility(
                  visible: Provider.of<MusicModel>(context).mode == 2,
                  child: InkWell(
                    onTap: () {
                      Provider.of<MusicModel>(context, listen: false)
                          .changeMode();
                    },
                    child: SvgPicture.asset(
                      'assets/images/circulate_random.svg',
                      width: 20.w,
                      color: Colors.white,
                    ),
                  )),
              // 单曲循环
              Visibility(
                  visible: Provider.of<MusicModel>(context).mode == 3,
                  child: InkWell(
                    onTap: () {
                      Provider.of<MusicModel>(context, listen: false)
                          .changeMode();
                    },
                    child: SvgPicture.asset(
                      'assets/images/circulate_one.svg',
                      width: 20.w,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
          // 播放上一首
          InkWell(
            onTap: () {
              Provider.of<MusicModel>(context, listen: false).pre();
            },
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            ),
          ),
          // 暂停或者播放
          InkWell(
            onTap: () {
              context.read<MusicModel>().playOrStop();
            },
            child: Icon(
              Provider.of<MusicModel>(context).isPlaying
                  ? Icons.pause
                  : Icons.play_arrow_outlined,
              color: Colors.white,
            ),
          ),
          // 播放下一首
          InkWell(
            onTap: () {
              Provider.of<MusicModel>(context, listen: false).next();
            },
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
          ),
          // 当前播放列表
          InkWell(
            onTap: () {
              // 弹出播放列表
              showModalBottomSheet(
                  context: context,
                  builder: (build) {
                    return PlayList();
                  });
            },
            child: Icon(
              Icons.list,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskInfo {
  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String? name;
  final _TaskInfo? task;

  _ItemHolder({this.name, this.task});
}
