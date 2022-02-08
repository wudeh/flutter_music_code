import 'package:test22/page/common/extended_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';

// 图片放大
class ImageView extends StatefulWidget {
  String img;

  ImageView({Key? key, required this.img}) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  // 页面背景透明度
  double opacity = 1.0;

  // 垂直方向拖动距离
  double verticalDistance = 0.0;
  // 横向拖动距离
  double horizontalDistance = 0.0;

  // 垂直方向最大拖动距离，达到此距离后将返回退出
  double maxVerticalDistance = 300.0;

  // 拖动缩放对比的距离对比
  double scaleDistance = 500;

  // 缩放系数
  double scale = 1.0;

  // 拖动动画时间
  int animatedTime = 10;

  // 缩放动画时间
  int scaleAnimatedTime = 10;

  // 图片的高
  int height = 0;
  // 图片的宽
  int width = 0;

  Offset _lastFocalPoint = Offset(0.0, 0.0);
  Offset _deltaPoint = Offset(0, 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Image image = Image.network(widget.img);
    image.image
        .resolve(new ImageConfiguration())
        .addListener(new ImageStreamListener(
      (ImageInfo info, bool _) {
        print(widget.img);
        print('width======${info.image.width}');
        print('height======${info.image.height}');
        setState(() {
          height = info.image.height;
          width = info.image.width;
          print("${height / 2}");
        });
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    // 根据图片的宽高比算出居中应该移动的距离
    double ratitoHeight = height / width * MediaQuery.of(context).size.width;
    double centerDistance =
        MediaQuery.of(context).size.height / 2 - ratitoHeight / 2;
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, opacity),
      body: Container(
        child: Center(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              // 撑满屏幕用的
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                onScaleStart: (details) {
                  animatedTime = 10;
                  scaleAnimatedTime = 10;
                  _lastFocalPoint = details.focalPoint;
                },
                onScaleUpdate: (ScaleUpdateDetails details) {
                  setState(() {
                    //缩放倍数在0.8到2倍之间
                    scale = scale * details.scale.clamp(0.8, 2);

                    setState(() {
                      scale = details.scale;
                      // _defaultPictureWidth = _defaultPictureWidth + details.scale;
                      // _defaultPictureHeight = _defaultPictureHeight + details.scale;
                      if (details.scale == 1) {
                        _deltaPoint +=
                            (details.focalPoint - _lastFocalPoint); //偏移量
                        _lastFocalPoint = details.focalPoint; //保存最有一个Point
                        verticalDistance = _deltaPoint.dy;
                        horizontalDistance = _deltaPoint.dx;
                        opacity = 1 - _deltaPoint.dy.abs() / scaleDistance;
                        opacity = opacity <= 0 ? 0 : opacity;
                        scale = opacity;
                      }
                    });
                  });
                },
                onScaleEnd: (details) {
                  // 拖动结束判断垂直方向的拖动距离 是否 大于 最大拖动距离
                  setState(() {
                    if (_deltaPoint.dy.abs() >= maxVerticalDistance) {
                      Navigator.of(context).pop();
                    } else {
                      animatedTime = 100;
                      scaleAnimatedTime = 100;
                      _deltaPoint = Offset(0, 0);
                      verticalDistance = 0;
                      opacity = 1.0;
                      scale = 1.0;

                      horizontalDistance = 0.0;
                    }
                  });
                },
                child: Transform(
                    child: Container(
                      // width: MediaQuery.of(context).size.width,
                      width: 111,
                      height: 111,
                      // 这里需要给颜色才能响应点击事件不知道为啥子
                      color: Color.fromRGBO(10, 10, 10, opacity),
                    ),
                    transform: Matrix4.identity()
                    // ..scale(scale, scale)
                    // ..translate(_deltaPoint.dx, _deltaPoint.dy),
                    ),
              ),
              // 拖动的图片
              height == 0
                  ? Center(child: CircularProgressIndicator())
                  : AnimatedPositioned(
                      duration: Duration(milliseconds: animatedTime),
                      top: verticalDistance + centerDistance,
                      left: horizontalDistance,
                      child: AnimatedScale(
                          scale: scale,
                          duration: Duration(milliseconds: scaleAnimatedTime),
                          child: GestureDetector(
                            child: Hero(
                                tag: widget.img,
                                child: ExtendedImage.network(
                                  widget.img,
                                  width: MediaQuery.of(context).size.width,
                                )),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            onScaleStart: (details) {
                              animatedTime = 10;
                              scaleAnimatedTime = 10;
                              _lastFocalPoint = details.focalPoint;
                            },
                            onScaleUpdate: (ScaleUpdateDetails details) {
                              setState(() {
                                //缩放倍数在0.8到2倍之间
                                scale = scale * details.scale.clamp(0.8, 2);

                                setState(() {
                                  scale = details.scale;
                                  // _defaultPictureWidth = _defaultPictureWidth + details.scale;
                                  // _defaultPictureHeight = _defaultPictureHeight + details.scale;
                                  if (details.scale == 1) {
                                    _deltaPoint += (details.focalPoint -
                                        _lastFocalPoint); //偏移量
                                    _lastFocalPoint =
                                        details.focalPoint; //保存最有一个Point
                                    verticalDistance = _deltaPoint.dy;
                                    horizontalDistance = _deltaPoint.dx;
                                    opacity = 1 -
                                        _deltaPoint.dy.abs() / scaleDistance;
                                    opacity = opacity <= 0 ? 0 : opacity;
                                    scale = opacity;
                                  }
                                });
                              });
                            },
                            onScaleEnd: (details) {
                              // 拖动结束判断垂直方向的拖动距离 是否 大于 最大拖动距离
                              setState(() {
                                if (_deltaPoint.dy.abs() >=
                                    maxVerticalDistance) {
                                  Navigator.of(context).pop();
                                } else {
                                  animatedTime = 100;
                                  scaleAnimatedTime = 100;
                                  _deltaPoint = Offset(0, 0);
                                  verticalDistance = 0;
                                  opacity = 1.0;
                                  scale = 1.0;

                                  horizontalDistance = 0.0;
                                }
                              });
                            },
                          ))),
            ],
          ),
        ),
      ),
    );
  }
}
