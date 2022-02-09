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
  
  var now = temp.millisecondsSinceEpoch;

  int nowDay = DateTime.fromMillisecondsSinceEpoch(now).day;
  int nowMonth = DateTime.fromMillisecondsSinceEpoch(now).month;
  int nowYear = DateTime.fromMillisecondsSinceEpoch(now).year;
  int nowHour = DateTime.fromMillisecondsSinceEpoch(now).hour + 4 > 23 ? DateTime.fromMillisecondsSinceEpoch(now).hour + 4 - 24 : DateTime.fromMillisecondsSinceEpoch(now).hour + 4;
  int nowMinute = DateTime.fromMillisecondsSinceEpoch(now).minute;

  int tDay = DateTime.fromMillisecondsSinceEpoch(t).day;
  int tMonth = DateTime.fromMillisecondsSinceEpoch(t).month;
  int tYear = DateTime.fromMillisecondsSinceEpoch(t).year;
  int tHour = DateTime.fromMillisecondsSinceEpoch(t).hour - 5;
  int tMinute = DateTime.fromMillisecondsSinceEpoch(t).minute - 6;


  // 小于一分钟显示 刚刚
  if (DateTime.fromMillisecondsSinceEpoch(now).year ==
          DateTime.fromMillisecondsSinceEpoch(t).year &&
      DateTime.fromMillisecondsSinceEpoch(now).month ==
          DateTime.fromMillisecondsSinceEpoch(t).month &&
      DateTime.fromMillisecondsSinceEpoch(now).day ==
          DateTime.fromMillisecondsSinceEpoch(t).day &&
      nowHour ==
          DateTime.fromMillisecondsSinceEpoch(t).hour &&
      DateTime.fromMillisecondsSinceEpoch(now).minute <=
          DateTime.fromMillisecondsSinceEpoch(t).minute) {
    result = '刚刚 ${nowYear}/${nowMonth}/${nowDay} ${nowHour}:${nowMinute}';
  } else if (DateTime.fromMillisecondsSinceEpoch(now).year ==
          DateTime.fromMillisecondsSinceEpoch(t).year &&
      DateTime.fromMillisecondsSinceEpoch(now).month ==
          DateTime.fromMillisecondsSinceEpoch(t).month &&
      DateTime.fromMillisecondsSinceEpoch(now).day ==
          DateTime.fromMillisecondsSinceEpoch(t).day &&
      nowHour ==
          DateTime.fromMillisecondsSinceEpoch(t).hour &&
      DateTime.fromMillisecondsSinceEpoch(now).minute - DateTime.fromMillisecondsSinceEpoch(t).minute <
          60) {
    // 小于一小时显示 **分钟前
    num a = DateTime.now().difference(dd).inMinutes;
    result = '${a.ceil()}分钟前';
  } else if (DateTime.fromMillisecondsSinceEpoch(now).year ==
          DateTime.fromMillisecondsSinceEpoch(t).year &&
      DateTime.fromMillisecondsSinceEpoch(now).month ==
          DateTime.fromMillisecondsSinceEpoch(t).month &&
      DateTime.fromMillisecondsSinceEpoch(now).day ==
          DateTime.fromMillisecondsSinceEpoch(t).day) {
    // 如果是同一天的话，显示   小时:分钟
    String tempHour = DateTime.fromMillisecondsSinceEpoch(t).hour < 10 ? '0${DateTime.fromMillisecondsSinceEpoch(t).hour}' : '${DateTime.fromMillisecondsSinceEpoch(t).hour}';
    String tempMinute = DateTime.fromMillisecondsSinceEpoch(t).minute < 10 ? '0${DateTime.fromMillisecondsSinceEpoch(t).minute}' : '${DateTime.fromMillisecondsSinceEpoch(t).minute}';
    result =
        '${tempHour}:${tempMinute} ${nowYear}/${nowMonth}/${nowDay} ${nowHour}:${nowMinute}';
  } else if ((DateTime.fromMillisecondsSinceEpoch(now).year ==
          DateTime.fromMillisecondsSinceEpoch(t).year &&
      DateTime.fromMillisecondsSinceEpoch(now).month ==
          DateTime.fromMillisecondsSinceEpoch(t).month &&
      DateTime.fromMillisecondsSinceEpoch(now).day ==
          DateTime.fromMillisecondsSinceEpoch(t).day) || 
      (DateTime.fromMillisecondsSinceEpoch(now).year ==
          DateTime.fromMillisecondsSinceEpoch(t).year &&
      DateTime.fromMillisecondsSinceEpoch(now).month  ==
          DateTime.fromMillisecondsSinceEpoch(t).month &&
      DateTime.fromMillisecondsSinceEpoch(now).day ==  1 &&
          DateTime.fromMillisecondsSinceEpoch(t).year % 4 == 0 &&
          DateTime.fromMillisecondsSinceEpoch(t).month == 2 &&
          DateTime.fromMillisecondsSinceEpoch(t).day == 29) ||
      (DateTime.fromMillisecondsSinceEpoch(now).year ==
          DateTime.fromMillisecondsSinceEpoch(t).year &&
      DateTime.fromMillisecondsSinceEpoch(now).month ==
          DateTime.fromMillisecondsSinceEpoch(t).month &&
      DateTime.fromMillisecondsSinceEpoch(now).day ==  1 &&
          DateTime.fromMillisecondsSinceEpoch(t).year % 4 != 0 &&
          DateTime.fromMillisecondsSinceEpoch(t).month == 2 &&
          DateTime.fromMillisecondsSinceEpoch(t).day == 28) ||
      (DateTime.fromMillisecondsSinceEpoch(now).year ==
          DateTime.fromMillisecondsSinceEpoch(t).year &&
      DateTime.fromMillisecondsSinceEpoch(now).month ==
          DateTime.fromMillisecondsSinceEpoch(t).month &&
      DateTime.fromMillisecondsSinceEpoch(now).day ==  1 &&
          [1,3,5,7,8,10,12].contains(DateTime.fromMillisecondsSinceEpoch(t).month)  &&
          DateTime.fromMillisecondsSinceEpoch(t).day == 31) ||
      (DateTime.fromMillisecondsSinceEpoch(now).year ==
          DateTime.fromMillisecondsSinceEpoch(t).year &&
      DateTime.fromMillisecondsSinceEpoch(now).month ==
          DateTime.fromMillisecondsSinceEpoch(t).month &&
      DateTime.fromMillisecondsSinceEpoch(now).day ==  1 &&
          ![1,3,5,7,8,10,12].contains(DateTime.fromMillisecondsSinceEpoch(t).month)  &&
          DateTime.fromMillisecondsSinceEpoch(t).day == 30) ||
      (DateTime.fromMillisecondsSinceEpoch(now).year - 1 ==
          DateTime.fromMillisecondsSinceEpoch(t).year &&
      DateTime.fromMillisecondsSinceEpoch(now).month == 1 &&
          DateTime.fromMillisecondsSinceEpoch(t).month == 12 &&
      DateTime.fromMillisecondsSinceEpoch(now).day == 1 &&
          DateTime.fromMillisecondsSinceEpoch(t).day == 31)) {
    // 如果是昨天，显示    昨天 小时:分钟
    result =
        '昨天 ${DateTime.fromMillisecondsSinceEpoch(t).hour}:${DateTime.fromMillisecondsSinceEpoch(t).minute} ${nowYear}/${nowMonth}/${nowDay} ${nowHour}:${nowMinute}';
  } else {
    result =
        '${DateTime.fromMillisecondsSinceEpoch(t).year}年${DateTime.fromMillisecondsSinceEpoch(t).month}月${DateTime.fromMillisecondsSinceEpoch(t).day}日';
  }

  // return '${DateTime.fromMillisecondsSinceEpoch(t).year}:${DateTime.fromMillisecondsSinceEpoch(t).month}:${DateTime.fromMillisecondsSinceEpoch(t).day}:${DateTime.fromMillisecondsSinceEpoch(t).hour}:${DateTime.fromMillisecondsSinceEpoch(t).minute}:${DateTime.fromMillisecondsSinceEpoch(t).second}  ${now.hour}:${now.minute}';
  return result;
}
// 7288635
// 9643138