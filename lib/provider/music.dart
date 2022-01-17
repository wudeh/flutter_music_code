import 'dart:math';

import 'package:cloud_music/page/Drawer/controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path/path.dart';
import '../api/api.dart';
import '../http/http.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import './color.dart';

//继承ChangeNotifier后，可以通知所有订阅者
class CounterModel with ChangeNotifier {
  int _count; //要保存的数据，我这里实现计数器，所以只有一个int变量
  CounterModel(this._count);

  void add() {
    //提供全局方法，让全局计数+1
    _count++;
    notifyListeners(); //当数值改变后，通知所有订阅者刷新ui
  }

  get count => _count; //提供全局get方法获取计数总值
}

class MusicModel with ChangeNotifier {
  final player = AudioPlayer();

  MusicModel() {
    player.positionStream.listen((event) {
      // print('正在监听播放时间');
      // print('分钟${event.inMinutes}秒${event.inSeconds}小数秒${event.inMilliseconds}');
      if (event.inMilliseconds / 1000 >= duration) {
        // print('大了拉拉拉阿里');
        numberTime = duration;
        stringTime = stringDuration;
      } else {
        numberTime = event.inMilliseconds / 1000;
        var a = event.toString();
        // print(a);
        stringTime = a.substring(2, 7).toString();
      }

      notifyListeners();
    });

    player.bufferedPositionStream.listen((event) {
      // print('正在监听缓冲');
      // print(event);
      buffed = event.inMilliseconds / 1000;
      // if(duration != 0) {
      //   print(buffed / duration * 284.w);
      // }
      // print('object');
    });

    player.playerStateStream.listen((state) async {
      if (state.playing) {
        print('正在播放音乐');
        // isPlaying = true;
        if (!isPlaying) {
          print("该暂停");
          await player.pause();
        }
      }
      switch (state.processingState) {
        // case ProcessingState.idle: ...
        case ProcessingState.loading:
          // print('正在加载音乐');
          return;
        case ProcessingState.buffering:
          // print('正在缓冲');
          return;
        case ProcessingState.ready:
          // print('可以播放音乐了');
          return;
        case ProcessingState.completed:
          // print('当前音乐播放完成' + player.playerState.toString());
          // seetNum(0.00);
          // 如果是单曲循环就重新播放
          if (mode == 3) {
            seetNum(0.00);
            return;
          }
          // 如果播放列表大于 1 首，播放下一首
          if (musicList.length > 1) {
            next();
            return;
          }
          isPlaying = false;
          numberTime = duration;
          stringTime = stringDuration;
          isOneSongAndNotPlaying = true;
          return;
        case ProcessingState.idle:
          // TODO: Handle this case.
          break;
      }
      notifyListeners();
    });
  }

  // 当前字符串时间
  String stringTime = '00:00';
  // 当前 number 时间
  double numberTime = 0.0;

  // 已缓冲时间
  double buffed = 0.0;
  // 默认不播放音乐
  bool isPlaying = false;

  bool get play => isPlaying;
  // 当前播放音乐时长
  double duration = 1.0;
  // 当前播放音乐字符串时长
  String stringDuration = '00:00';
  // 播放索引列表
  int index = 0;
  // 当前播放音乐的信息
  Map info = {
    "id": '',
    "url": '',
    "img": '',
    "author": '',
    "name": '',
    "SQ": 0,
    "alia": '', // 额外信息描述
  };

  // 当前音乐歌词
  List lyric = [];

  // 播放列表
  List musicList = [];

  // 存储播放过歌曲的列表索引，随机播放时点击上一首需要用到这个
  List<int> playedIndex = [];
  // 上一首播放列表的索引
  int oldIndex = 0;

  // 播放模式：1.列表循环；2.随机播放；3.单曲循环
  int mode = 1;

  // 只有一首且播放完毕
  bool isOneSongAndNotPlaying = false;

  // dispose 关闭再播放
  void closeAndPlay() async {
    // await player.setUrl(info['url']);
    // 更换为默认缓存播放的音乐的方式
    await player.setAudioSource(LockCachingAudioSource(Uri.parse(info['url'])));
  }

  // 改变播放模式
  void changeMode() {
    if (mode == 3) {
      mode = 1;
      notifyListeners();
      showToast("列表循环播放");
      return;
    }
    mode++;
    if (mode == 2) showToast("随机播放");
    if (mode == 3) showToast("单曲循环");
    notifyListeners();
  }

  // 播放或者暂停音乐
  void playOrStop() async {
    // 列表只有一首歌并且播放完毕的情况，直接跳到开头重新播放
    if (isOneSongAndNotPlaying) {
      print('重新播放');
      isOneSongAndNotPlaying = false;
      seetNum(0.00);
      return;
    }
    if (isPlaying) {
      // print('暂停');
      isPlaying = false;
      notifyListeners();
      await player.pause();
    } else {
      // print('播放');
      isPlaying = true;
      notifyListeners();
      // 列表中只有一首歌播放结束的时候，重新播放
      if (numberTime == duration) {
        if (musicList.length == 1) {
          closeAndPlay();
          return;
        }
      }
      await player.play();
    }
    notifyListeners();
  }

  // 播放一首音乐，传进来的参数是歌曲信息的对象
  void playOneSong(i) async {
    // 首先判断是不是和当前正在播放的是同一首
    if (i['id'] == info['id']) {
      playOrStop();
      return;
    }
    isPlaying = true;
    // 是新音乐就清空歌词
    lyric = [
      [0.0, '加载歌词中', '00:00'],
      [9999.9, '', '00:00']
    ];
    // 再判断要播放的新音乐是不是存在于播放列表中
    var tempIndex = -1;
    bool isListSong = false;
    musicList.forEach((element) {
      tempIndex++;
      if (element['id'] == i['id']) {
        // print('播放列表中的歌');
        isListSong = true;
        info = element;
        index = tempIndex;
        // 添加播放过的歌曲索引
        playedIndex.add(index);
        if (info['url'] == '') {
          // 获取音乐的 URL
          getUrl(i['id']);
          musicList[tempIndex]['url'] = info['url'];
          return;
        }
      }
    });

    // 如果已经播放存在于列表中的歌
    if (isListSong) {
      seetNum(0.00);
      getLyric();
      return;
    }

    // 如果是一首新音乐
    // print('是新音乐');
    info = i;
    if (i['url'] == '') getUrl(i['id']);

    // 把新歌的信息添加到播放列表末尾
    musicList.add(info);
    // 播放音乐
    // playNewSong(info['url']);
    index = musicList.length - 1;
    // 添加播放过的歌曲索引
    playedIndex.add(index);

    notifyListeners();
  }

  // 获取音乐 URL 534065323
  void getUrl(id) async {
    // 这个接口获取的可能不是无损音质
    var res = await HttpRequest().get('${Api.songUrl}&id=$id');
    //
    // var res = await HttpRequest().get('${Api.downloadUrl}&id=$id');
    var jsonInfo = json.decode(res.toString());
    info['url'] = jsonInfo['data'][0]['url'];
    // print('获取到的URL是${info['url']}');
    // print(jsonInfo);
    try {
      // print('要播放的URL是');
      // await player.pause();
      isPlaying = true;
      notifyListeners();
      // print(isPlaying);
      await player.pause();
      // Duration? time = await player.setUrl(info['url']);
      Duration? time = await player
          .setAudioSource(LockCachingAudioSource(Uri.parse(info['url'])));
      // 这里给歌曲总时长加 2 秒的原因是可能实际上的歌曲播放时长大于这里得到的时长
      // 滑动歌词页面的进度条显示时间发现播放过程中得到的时间最多大于得到的总时长 2 秒，有误差
      // duration = time!.inMilliseconds / 1000 + 2;
      duration = time!.inMilliseconds / 1000;
      stringDuration =
          '${time.inMinutes < 10 ? '0' + time.inMinutes.toString() : time.inMinutes}:${(time.inSeconds % 60) < 10 ? '0' + (time.inSeconds % 60).toString() : time.inSeconds % 60}';
      await player.play();
    } catch (e) {
      // Fallback for all errors
      // print(e);
      isPlaying = false;
      // print(e.toString());
      showToast("获取歌曲源出错");
    }
    notifyListeners();
  }

  // 设置音量
  void setVolume(i) async {
    await player.setVolume(i);
    notifyListeners();
  }

  // 进度跳转（用来手指滑动歌词的）
  void seek(i) async {
    // 传进来的是该跳到歌词数组中的哪一句歌词的索引，这里算出毫秒
    // print('跳转到第$i句');
    if (i >= lyric.length - 1) i = lyric.length - 1;
    // print(lyric[i][0]);
    int time = (lyric[i][0] * 1000).round();
    // print('跳转到$time');
    if (time / 1000 > duration) {
      showToast('当前歌曲可能为试听曲，超出试听范围');
      return;
    }
    await player.seek(Duration(milliseconds: time));
    notifyListeners();
  }

  // 直接传时间的进度跳转（手指滑动进度条的）
  void seetNum(i) async {
    // 滑动进度条传进来的是 double 类型的秒
    await player.seek(Duration(milliseconds: (i * 1000).floor()));
    notifyListeners();
  }

  void test() async {
    await player.setAudioSource(ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.parse(
          "http://m8.music.126.net/20210609211744/110660f09d6830c3fad1918705b7ccd6/ymusic/9c9f/15fa/51b4/aa935f7b9829ce1e0b8b0bd4eabfba50.mp3")),
      AudioSource.uri(Uri.parse(
          "http://m801.music.126.net/20210609211720/0d62dcb05dfa46a59d59b03208e1e930/jdymusic/obj/wo3DlMOGwrbDjj7DisKw/8987958550/c891/a2e0/eca3/ed5fd4591dc663ffff34871752d94a96.mp3")),
      AudioSource.uri(Uri.parse(
          "http://m8.music.126.net/20210609211656/6147536b88a284ad2c47a2c6c84714dc/ymusic/634d/966f/5144/7ea5eaa2b9ace4b4931cd8f750272dbe.mp3")),
    ]));
    await player.setLoopMode(LoopMode.all);
    // await player.setUrl("http://m7.music.126.net/20210609204534/6b670d7dcde4d4534e419ad072cbdbb9/ymusic/9c9f/15fa/51b4/aa935f7b9829ce1e0b8b0bd4eabfba50.mp3");
    await player.play();
  }

  // 下一首
  void next() async {
    // 播放列表只有一首歌不做处理
    if (musicList.length == 1 && musicList[0]["id"] == info["id"]) {
      showToast('当前播放列表只有一首歌');
      return;
    }
    seetNum(0.00);
    if (mode == 3) return;
    // 列表循环
    if (mode == 1 || mode == 3) {
      print('不是随机播放');
      index++;
      if (index > musicList.length - 1) {
        index = 0;
      }
      playedIndex.add(index);
      info = musicList[index];
      // print('要播放的歌曲信息');
      // print(musicList[index]);
    }
    // 随机播放
    if (mode == 2) {
      List temp = [];
      temp.addAll(musicList);
      temp.removeAt(index);
      var ran = new Random();
      int tempIndex = ran.nextInt(temp.length);
      playedIndex.add(tempIndex);
      info = temp[tempIndex];
    }
    notifyListeners();
    if (info['url'] == '') {
      // 如果没有歌曲播放地址就获取并播放
      getUrl(info['id']);
    } else {
      Duration? time = await player
          .setAudioSource(LockCachingAudioSource(Uri.parse(info['url'])));
      // 这里给歌曲总时长加一秒的原因是可能实际上的歌曲播放时长大于这里得到的时长
      duration = time!.inMilliseconds / 1000 + 1;
      // duration = time!.inMilliseconds / 1000;
      stringDuration =
          '${time.inMinutes < 10 ? '0' + time.inMinutes.toString() : time.inMinutes}:${(time.inSeconds % 60) < 10 ? '0' + (time.inSeconds % 60).toString() : time.inSeconds % 60}';
      notifyListeners();
      await player.play();
    }

    // 是新音乐就清空歌词
    lyric = [
      [0.0, '加载歌词中', '00:00'],
      [9999.9, '', '00:00']
    ];
    getLyric();
  }

  // 播放上一首
  void pre() async {
    // 播放列表只有一首歌不做处理
    if (musicList.length == 1) {
      showToast('当前播放列表只有一首歌');
      return;
    }
    seetNum(0.00);
    // 列表循环
    if (mode == 1) {
      index--;
      if (index < 0) {
        index = musicList.length - 1;
      }
      info = musicList[index];
    }
    // 随机播放，单曲循环和随机播放的上一首逻辑一样
    if (mode == 2 || mode == 3) {
      // 如果存储上一首播放过歌曲的索引的数组为空，逻辑就变成了播放下一首
      if (playedIndex.length == 0) {
        next();
        return;
      }
      info = musicList[playedIndex[oldIndex]];
      playedIndex.removeAt(oldIndex);
    }
    notifyListeners();
    if (info['url'] == '') {
      // 如果没有歌曲播放地址就获取并播放
      getUrl(info['id']);
    } else {
      Duration? time = await player
          .setAudioSource(LockCachingAudioSource(Uri.parse(info['url'])));
      // 这里给歌曲总时长加一秒的原因是可能实际上的歌曲播放时长大于这里得到的时长
      duration = time!.inMilliseconds / 1000 + 1;
      // duration = time!.inMilliseconds / 1000;
      stringDuration =
          '${time.inMinutes < 10 ? '0' + time.inMinutes.toString() : time.inMinutes}:${(time.inSeconds % 60) < 10 ? '0' + (time.inSeconds % 60).toString() : time.inSeconds % 60}';
      notifyListeners();
      await player.play();
    }
    // 是新音乐就清空歌词
    lyric = [
      [0.0, '加载歌词中', '00:00'],
      [9999.9, '', '00:00']
    ];
    getLyric();
  }

  // 获取歌词
  Future<String> getLyric() async {
    try {
      String res =
          await HttpRequest.getInstance().get('${Api.songLyric}${info['id']}');
      var jsonInfo = json.decode(res);

      if (jsonInfo['uncollected'] == true || jsonInfo['nolyric'] == true) {
        lyric = [
          [0.0, '当前音乐暂无歌词', '00:00'],
          [9999.9, '', '00:00']
        ];
        notifyListeners();
      } else {
        lyric = [];
        // 先把歌词时间和歌词分离开
        String a = jsonInfo['lrc']['lyric'];
        List b = a.split('[');
        b.forEach((element) {
          if (element != '') {
            String time = element.split(']')[0];
            // 得到分钟 秒 小数秒
            int min = int.parse(time.split(':')[0]);
            double sec = double.parse(time.split(':')[1]);
            String word = element.split(']')[1];
            if (word != '' && word != ' ')
              lyric.add([
                min * 60 + sec,
                word,
                time.split('.')[0]
              ]); // 第一个是用来比对当前高亮歌词的 double 形式的时间，第二个是歌词，第三个是时间的字符串形式
          }
        });
        // lyric.add([99999.999, 'wudeh']);
        // print(lyric);
        // print('这是歌词$lyric');
      }

      notifyListeners();
      // yes 代表获取歌词成功
      return 'yes';
    } catch (e) {
      return 'error';
      notifyListeners();
    }
  }

  // 添加到下一首播放
  void nextPlay(i) {
    // 如果没歌，直接播放
    if (musicList.length == 0) {
      playOneSong(i);
      return;
    }
    // 如果列表里面已经有这首歌就挪到当前播放歌曲的下一首
    if (musicList.indexOf(i) != -1) {
      musicList.removeAt(musicList.indexOf(i));
      musicList.insert(index + 1, i);
      notifyListeners();
      return;
    }
    musicList.insert(index + 1, i);
    notifyListeners();
  }

  // 根据 id 删除一首歌
  void deleteOne(id, context) async {
    int tempIndex = 0;
    for (var i = 0; i < musicList.length; i++) {
      if (musicList[i]['id'] == id) {
        tempIndex = i;
        break;
      }
    }
    musicList.removeAt(tempIndex);
    notifyListeners();
    // 如果删除之后播放列表没有歌了
    if (musicList.isEmpty) {
      isPlaying = false;
      info['id'] = '';
      info['name'] = '';
      info['author'] = '';
      notifyListeners();
      await player.pause();
      // 如果当前为歌词页面就要返回两次
      if (Provider.of<ColorModel>(context, listen: false).isAudioPage) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        // 不是就一次
        Navigator.of(context).pop();
      }
      return;
    }
    // 如果删除的是当前正在播放的歌曲
    if (id == info['id']) {
      next();
    }
  }

  // 删除全部歌曲
  void deleteAll(context) async {
    info['id'] = '';
    info['name'] = '';
    info['author'] = '';
    isPlaying = false;
    musicList = [];
    notifyListeners();
    await player.pause();
    seetNum(0.00);
    // 如果当前为歌词页面就要返回两次
    if (Provider.of<ColorModel>(context, listen: false).isAudioPage) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      // 不是就一次
      Navigator.of(context).pop();
    }
  }

  // 添加多首歌曲并播放，传进来数组
  void playListSongs(list) {
    musicList = [];
    info['id'] = '';
    info['name'] = '';
    info['author'] = '';
    musicList.addAll(list);
    notifyListeners();
    playOneSong(list[0]);
  }
}
