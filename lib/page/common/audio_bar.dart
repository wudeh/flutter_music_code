import 'package:cloud_music/model/song_list.dart';
import 'package:cloud_music/page/common/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provider/music.dart';
import 'package:provider/provider.dart';
import '../../provider/music.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../audio/audio.dart';
import './router_animation.dart';
import 'package:flutter_svg/svg.dart';
import '../../router/navigator_util.dart';
import './play_list.dart';

class AudioBar extends StatefulWidget {
  AudioBar({Key? key}) : super(key: key);

  _AudioBarState createState() => _AudioBarState();
}

class _AudioBarState extends State<AudioBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Visibility(
            visible: Provider.of<MusicModel>(context).info['name'] == '' ? false : true,
            child: InkWell(
                onTap: () {
                  // 点击跳转歌词页面
                  NavigatorUtil.gotoAudioPage(context, Provider.of<MusicModel>(context, listen: false).info['img']);
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      // 转圈的歌曲封面
                      Stack(
                        // 超出不做裁剪
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 8.w, right: 8.w),
                            height: 50.w,
                            width: 50.w,
                          ),
                          Positioned(top: -8.w, left: 8.w, child: ZhuanquanM())
                        ],
                      ),
                      // 歌名 和 作者
                      Container(
                        width: 250.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Provider.of<MusicModel>(context).info['name'],
                              style: TextStyle(
                                fontSize: 16.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '- ${Provider.of<MusicModel>(context).info['author']}',
                              style: TextStyle(fontSize: 12.sp),
                            )
                          ],
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.only(left: 150.w),
                        child: InkWell(
                          onTap: () {
                            context.read<MusicModel>().playOrStop();
                            setState(() {});
                          },
                          child: Provider.of<MusicModel>(context).isPlaying
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow_rounded),
                        ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            // 弹出播放列表
                            showModalBottomSheet(
                                context: context,
                                builder: (build) {
                                  return PlayList();
                                });
                          },
                          child: Icon(Icons.list),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}

// 音乐转圈
class ZhuanquanM extends StatefulWidget {
  @override
  _ZhuanquanMState createState() => _ZhuanquanMState();
}

class _ZhuanquanMState extends State<ZhuanquanM>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 6));
    // 时刻监听播放状态
    // _controller.addListener(() {

    // });
    _controller.forward();
  }

  Widget build(BuildContext context) {
    if (Provider.of<MusicModel>(context,listen: false).isPlaying) {
      _controller.forward();
    } else {
      _controller.stop();
    }
    return RotationTransition(
        child: ClipOval(
          child: ExtenedImage(
            img: "${Provider.of<MusicModel>(context).info['img']}",
            width: 50.w,
          ),
        ),
        turns: _controller
          ..addStatusListener((status) {
            // 动画播放完成后重置，再重新播放动画
            if (status == AnimationStatus.completed) {
              _controller.reset();
              _controller.forward();
            }
          }));
  }
}
