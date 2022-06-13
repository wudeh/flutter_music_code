import 'dart:async';

import 'package:flutter/material.dart';

// 使用 pageview 自己封装轮播图
class PageSwiper extends StatefulWidget {
  final bool autoplay; // 是否自动轮播
  final int itemCount; // 轮播图个数
  final int duration; // 隔多长时间轮播下一图
  final int milliseconds; // 轮播过渡时间
  final Widget Function(BuildContext, int) itemBuilder;

  PageSwiper(
      {Key? key,
      required this.itemCount,
      required this.itemBuilder,
      this.autoplay = true,
      this.duration = 5,
      this.milliseconds = 300})
      : super(key: key);

  @override
  _PageSwiperState createState() => _PageSwiperState();
}

class _PageSwiperState extends State<PageSwiper> {
  PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 1);

  Timer? _timer;

  int index = 0;

  List<Widget> pageWidget = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // for (var i = 0; i < widget.itemCount; i++) {
    //   pageWidget.add(widget.itemBuilder(context, i));
    // }

    // 渲染完成后执行一次刷新方法
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.autoplay) {
        _timer = Timer.periodic(Duration(seconds: widget.duration), (Timer) {
          setState(() {
            index = index + 1 > widget.itemCount - 1 ? 0 : index + 1;
          });
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: widget.milliseconds),
              curve: Curves.ease);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget point() {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.itemCount, (i) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: i == index
                    ? Theme.of(context).primaryColor
                    : Colors.black54,
                borderRadius: BorderRadius.circular(10)),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemBuilder: widget.itemBuilder,
          itemCount: widget.itemCount,
          onPageChanged: (value) {
            setState(() {
              index = value;
            });
          },
        ),
        // 指示器
        point()
      ],
    );
  }
}
