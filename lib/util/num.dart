// 过滤播放量函数
String playCountFilter(num) {
  if (num is String) num = int.parse(num);

  if (num >= 100000000) {
    num = (num / 100000000).toString();
    return '${num.substring(0, num.indexOf('.') + 2)}亿';
  } else if (num >= 100000) {
    num = (num / 10000).toString();
    return '${num.substring(0, num.indexOf('.') + 2)}万';
  }
  return num.toString();
}

// 时间过滤
String timeFilter(t) {
  String result = '';
  var temp = DateTime.now();
  var dd = DateTime.fromMillisecondsSinceEpoch(t);
  var now = temp.millisecondsSinceEpoch + (320 * 60 * 1000) - (1000 * 900);
  // 小于一分钟显示 刚刚
  if (now - t < (1000 * 60)) {
    result = '刚刚';
  } else if (now - t < (1000 * 60 * 60)) {
    // 小于一小时显示 **分钟前
    num a = (now - t) / (1000 * 60);
    result = '${a.ceil()}分钟前';
  } else if (DateTime.fromMillisecondsSinceEpoch(now).year ==
          DateTime.fromMillisecondsSinceEpoch(t).year &&
      DateTime.fromMillisecondsSinceEpoch(now).month ==
          DateTime.fromMillisecondsSinceEpoch(t).month &&
      DateTime.fromMillisecondsSinceEpoch(now).day ==
          DateTime.fromMillisecondsSinceEpoch(t).day) {
    // 如果是同一天的话，显示   小时:分钟
    result =
        '${DateTime.fromMillisecondsSinceEpoch(t).hour}:${DateTime.fromMillisecondsSinceEpoch(t).minute}';
  } else if ((now -
          (DateTime.fromMillisecondsSinceEpoch(now).millisecond) -
          (DateTime.fromMillisecondsSinceEpoch(now).second * 1000) -
          (DateTime.fromMillisecondsSinceEpoch(now).minute * 1000 * 60) -
          (DateTime.fromMillisecondsSinceEpoch(now).hour * 1000 * 60 * 60) -
          t <
      1000 * 60 * 60 * 24)) {
    // 如果是昨天，显示    昨天 小时:分钟
    result =
        '昨天 ${DateTime.fromMillisecondsSinceEpoch(t).hour}:${DateTime.fromMillisecondsSinceEpoch(t).minute}';
  } else {
    result =
        '${DateTime.fromMillisecondsSinceEpoch(t).year}年${DateTime.fromMillisecondsSinceEpoch(t).month}月${DateTime.fromMillisecondsSinceEpoch(t).day}日';
  }

  // return '${DateTime.fromMillisecondsSinceEpoch(t).year}:${DateTime.fromMillisecondsSinceEpoch(t).month}:${DateTime.fromMillisecondsSinceEpoch(t).day}:${DateTime.fromMillisecondsSinceEpoch(t).hour}:${DateTime.fromMillisecondsSinceEpoch(t).minute}:${DateTime.fromMillisecondsSinceEpoch(t).second}  ${now.hour}:${now.minute}';
  return result;
}
// 7288635
// 9643138