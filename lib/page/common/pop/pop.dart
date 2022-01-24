import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';

// 弹框内容
class PopPage extends StatefulWidget {
  GlobalKey locationKey;

  PopPage({Key? key, required this.locationKey}) : super(key: key);

  @override
  _PopPageState createState() => _PopPageState();
}

class _PopPageState extends State<PopPage> with SingleTickerProviderStateMixin {
  AnimationController? controller; // 控制透明度和缩放动画
  Animation? fade;
  Animation? opacity;

  // 获取弹框内容的高度
  GlobalKey locationKey2 = GlobalKey();

  /// 控件左上角坐标
  double dx = 0, dy = 0;

  // 控价宽高
  double width = 0, height = 0;

  // 是否处于下半屏幕
  bool down = false;
  // 控件处于屏幕下半屏的应该设置的坐标
  double dx2 = 0, dy2 = 0;

  // 如果控件用了Transform平移旋转等, 获取到的坐标也会变化
  void _findRenderObject() {
    RenderBox renderBox =
        widget.locationKey.currentContext!.findRenderObject() as RenderBox;

    // offset.dx , offset.dy 就是控件的左上角坐标
    var offset = renderBox.localToGlobal(Offset.zero);

    width = renderBox.size.width;
    height = renderBox.size.height;

    setState(() {
      // dx = offset.dx + (renderBox.size.width / 2);
      // dx = offset.dx + (renderBox.size.width / 2);
      dx = offset.dx;
      // 获取距离顶部的距离，考虑到点击 APPbar 的情况，如果距离小于 APPbar 高度，则强制等于 APPbar 高度
      dy = offset.dy < 56 ? 56 : offset.dy;

      // 如果控件处于屏幕下半屏
      if (dy > MediaQuery.of(context).size.height / 2) {
        down = true;
        RenderBox renderBox2 =
            locationKey2.currentContext!.findRenderObject() as RenderBox;

        dy2 = dy - height - renderBox2.size.height - 8;

        dx2 = dx + 100 >= MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width - 150
            : dx;
      } else {
        dy2 = dy + 10;
        dx2 = dx + 100 >= MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width - 150
            : dx;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    fade = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: Curves.easeOut, parent: controller!));

    opacity = Tween<double>(begin: 0.0, end: 1).animate(
        CurvedAnimation(parent: controller!, curve: Interval(0, 0.65)));

    controller?.addListener(() {
      setState(() {
      });
      
    });

    // 在控件渲染完成后执行的回调
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _findRenderObject();

      controller!.forward();
    });
  }

  @override
  void deactivate() async {
    // TODO: implement deactivate
    await controller!.reverse();
    super.deactivate();
  }

  @override
  void dispose()  {
    
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller?.forward();
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.2),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black12,
          ),
          // 这里的三角形是通过旋转正方形得到的
          Positioned(
            top: down ? dy - height - 26 : dy,
            left: dx + width / 2,
            child: Column(
              children: [
                // Container(
                //   width: 20,
                //   height: 20,
                //   transform: Matrix4.rotationZ(45 * 3.14 / 180),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(2),
                //   ),
                // ),
                // AnimatedBuilder(
                //   animation: fade,
                //   builder: (BuildContext context, Widget child) {
                //     ///  这个transform有origin的可选构造参数，我们可以手动添加
                //     return Transform.scale(
                //       origin: widget.offset,
                //       scale: fade.value,
                //       child: Opacity(
                //         opacity: opacity.value,
                //         child: widget.child,
                //       ),
                //     );
                //   },
                // ),
                Transform.scale(
                  // origin: Offset(dx, dy),
                  alignment: Alignment.topRight,
                  scale: fade!.value,
                  child: Opacity(
                    opacity: opacity!.value,
                    child: Container(
                      width: 20,
                      height: 20,
                      transform: Matrix4.rotationZ(45 * 3.14 / 180),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // 下面的弹框内容区域，要至少把上面旋转的正方形下半部分都遮住，才能得到三角形
          Positioned(
              top: dy2,
              left: dx2,
              child: Transform.scale(
                // origin: Offset(0, 0),
                alignment: Alignment.topRight,
                scale: fade!.value,
                child: Opacity(
                  opacity: fade!.value,
                  child: Container(
                      key: locationKey2,
                      width: 150,
                      // height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "创建群聊",
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          )
                        ],
                      )),
                ),
              )

              // Container(
              //     key: locationKey2,
              //     width: 150,
              //     // height: 100,
              //     decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(5)),
              //     child: Column(
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Icon(Icons.add_circle),
              //             SizedBox(
              //               width: 10,
              //             ),
              //             Text(
              //               "创建群聊",
              //               style: TextStyle(fontSize: 16),
              //             )
              //           ],
              //         )
              //       ],
              //     )),
              ),
        ],
      ),
    );
  }
}
