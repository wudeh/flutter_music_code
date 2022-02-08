import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provider/music.dart';
import 'package:provider/provider.dart';
import '../../provider/music.dart';
import '../audio/audio.dart';
import './router_animation.dart';
import 'package:flutter_svg/svg.dart';
import '../../router/navigator_util.dart';

class PlayList extends StatefulWidget {
  PlayList({Key? key}) : super(key: key);

  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.w,
      padding: EdgeInsets.all(8.w),
      child: ListView(
        children: [
          Text('当前播放列表(${context.read<MusicModel>().musicList.length})'),
          // 列表循环
          Visibility(
              visible: context.read<MusicModel>().mode == 1,
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/images/circulate.svg',
                  width: 20.w,
                  color: Colors.grey,
                ),
                title: Text('列表循环'),
                // 全部删除
                trailing: InkWell(
                  onTap: () {
                    print('全部删除');
                    Provider.of<MusicModel>(context, listen: false)
                        .deleteAll(context);
                    setState(() {});
                  },
                  child: Icon(Icons.delete),
                ),
              )),
          // 随机循环
          Visibility(
              visible: context.read<MusicModel>().mode == 2,
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/images/circulate.svg',
                  width: 20.w,
                  color: Colors.grey,
                ),
                title: Text('随机循环'),
                // 全部删除
                trailing: InkWell(
                  onTap: () {
                    print('全部删除');
                    Provider.of<MusicModel>(context, listen: false)
                        .deleteAll(context);
                    setState(() {});
                  },
                  child: Icon(Icons.delete),
                ),
              )),
          // 单曲循环
          Visibility(
              visible: context.read<MusicModel>().mode == 3,
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/images/circulate.svg',
                  width: 20.w,
                  color: Colors.grey,
                ),
                title: Text('单曲循环'),
                // 全部删除
                trailing: InkWell(
                  onTap: () {
                    print('全部删除');
                    Provider.of<MusicModel>(context, listen: false)
                        .deleteAll(context);
                    setState(() {});
                  },
                  child: Icon(Icons.delete),
                ),
              )),
          // 播放列表
          Column(
            children:
                Provider.of<MusicModel>(context).musicList.map<Widget>((e) {
              return ListTile(
                  leading:
                      Provider.of<MusicModel>(context).info['id'] == e['id']
                          ? Image.asset(
                              'assets/images/loading.gif',
                              width: 20.w,
                            )
                          : SizedBox(),
                  // 歌名 和 作者
                  title: InkWell(
                    onTap: () {
                      // 点击播放列表里的歌曲
                      Provider.of<MusicModel>(context, listen: false).playOneSong(e);
                    },
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: e['name'],
                          style: TextStyle(
                              color:
                                  Provider.of<MusicModel>(context).info['id'] ==
                                          e['id']
                                      ? Theme.of(context).primaryColor
                                      : Colors.black),
                          children: [
                            TextSpan(
                              text: ' - ',
                              style: TextStyle(
                                  color: Provider.of<MusicModel>(context)
                                              .info['id'] ==
                                          e['id']
                                      ? Theme.of(context).primaryColor
                                      : Colors.black),
                            ),
                            TextSpan(
                              text: e['author'],
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Provider.of<MusicModel>(context)
                                              .info['id'] ==
                                          e['id']
                                      ? Theme.of(context).primaryColor
                                      : Colors.black),
                            )
                          ]),
                    ),
                  ),
                  // 点击根据 id 删除歌曲
                  trailing: InkWell(
                    onTap: () {
                      Provider.of<MusicModel>(context, listen: false)
                          .deleteOne(e['id'], context);
                      setState(() {});
                    },
                    child: Icon(Icons.clear),
                  ));
            }).toList(),
          )
        ],
      ),
    );
  }
}
