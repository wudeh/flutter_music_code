  
  import 'dart:async';

/// 函数防抖
  ///
  /// [func]: 要执行的方法
  /// [delay]: 要迟延的时长
  void Function() debounce(
    Function func, [
    Duration delay = const Duration(milliseconds: 500),
  ]) {
    Timer? timer;
    void Function() target = () {
      print("99");
      timer?.cancel();
      timer = Timer(delay, () {
        print("9449");
        func.call();
      });
    };
    return target;
  }

  /// 也可以采用类的方式
class Debouncer {
  final Duration? delay;
  Timer? _timer;

  Debouncer({this.delay});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay ?? const Duration(milliseconds: 1000), action);
  }
}

  /// 节流
  ///
  /// [func]: 要执行的方法
  /// [delay]: 要迟延的时长
  Function throttle(
    Function func, [
    Duration delay = const Duration(milliseconds: 500),
  ]) {
    Timer? timer;
    return () {
      if (timer != null) return;
      timer = Timer(delay, () {
        func.call();
      });
    };
  }

class Throttle {
  final Duration delay;
  Timer? timer;

  Throttle({this.delay = const Duration(milliseconds: 500)});

  void call(Function callBack) {
    if (timer != null) return;
    timer = Timer(delay, () {
      callBack.call();
    });
  }
}

