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
  Alignment? scaleAlignment;

  // 获取弹框内容的高度
  GlobalKey locationKey2 = GlobalKey();

  Offset? offset = Offset(0, 0);

  // 状态栏高度
  double topView = 0;

  /// 控件左上角坐标
  double dx = 0, dy = 0;

  // 控价宽高
  double width = 0, height = 0;
  // 弹框内容宽高
  double popWidth = 0, popHeight = 0;

  // 是否处于下半屏幕
  bool down = false;
  // 控件处于屏幕下半屏的应该设置的坐标
  double dx2 = 0, dy2 = 0;

  double triangleHeight = 10;
  double triangleLeft = 0;

  // 如果控件用了Transform平移旋转等, 获取到的坐标也会变化
  void _findRenderObject() {
    RenderBox renderBox =
        widget.locationKey.currentContext!.findRenderObject() as RenderBox;

    // offset.dx , offset.dy 就是控件的左上角坐标
    offset = renderBox.localToGlobal(Offset.zero);
    // print('sdkfjsd');
    // print(offset?.dx);
    // print(offset?.dy);
    final MediaQueryData data = MediaQuery.of(context);
    topView =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).padding.top;
    // print("状态栏高度${MediaQueryData.fromWindow(WidgetsBinding.instance!.window).padding.top}");

    // 点击区域宽度，高度
    width = renderBox.size.width;
    height = renderBox.size.height;

    // 弹框内容宽度，高度
    RenderBox renderBox2 =
        locationKey2.currentContext!.findRenderObject() as RenderBox;
    popWidth = renderBox2.size.width;
    popHeight = renderBox2.size.height;

    setState(() {
      //
      dx = offset!.dx;
      // 距离顶部的距离需要 - 状态栏高度
      // 获取距离顶部的距离，考虑到点击 APPbar 的情况，如果距离小于 APPbar 高度，则强制等于 APPbar 高度
      dy = offset!.dy - topView;

      dx2 = dx + width / 2 - popWidth / 2;

      triangleLeft = popWidth / 2;

      // 默认弹框和点击区域中间对齐
      // 如果弹框超出屏幕左边，弹框和点击区域左侧侧对齐
      if (dx2 < 0) {
        dx2 = dx;
        triangleLeft = width / 2;
      }
      // 如果弹框超出屏幕右边，弹框和点击区域右侧对齐
      if (dx2 + popWidth > MediaQuery.of(context).size.width) {
        dx2 = dx - (popWidth - width);
        triangleLeft = popWidth - (width / 2);
        // 参考微信，qq的做法，不会让三角形完全贴合右侧
        if (triangleLeft + dx2 > (MediaQuery.of(context).size.width - 30)) {
          triangleLeft = triangleLeft - 5;
        }
      }

      // 如果控件处于屏幕下半屏
      if (dy > MediaQuery.of(context).size.height / 2) {
        dy = dy - popHeight - triangleHeight;
      } else {
        down = true;
        dy = dy + height;
      }

      // 获取距离顶部的距离，考虑到点击 APPbar 的情况，如果距离小于 APPbar 高度，则强制等于 APPbar 高度
      dy = dy < 56 ? 56 : dy;

      if (dx2 < MediaQuery.of(context).size.width / 2 && down) {
        scaleAlignment = Alignment.topLeft;
      } else if (dx2 > MediaQuery.of(context).size.width / 2 && down) {
        scaleAlignment = Alignment.topRight;
      } else if (dx2 < MediaQuery.of(context).size.width / 2 && down) {
        scaleAlignment = Alignment.topLeft;
      } else if (dx2 < MediaQuery.of(context).size.width / 2 && !down) {
        scaleAlignment = Alignment.bottomLeft;
      } else {
        scaleAlignment = Alignment.bottomRight;
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
      setState(() {});
    });

    // 在控件渲染完成后执行的回调
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _findRenderObject();

      controller!.forward();
    });
  }

  @override
  void deactivate() async {
    // TODO: implement deactivate

    super.deactivate();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 三角形
    Widget triangle = Container(
      width: popWidth,
      height: triangleHeight,
      child: Stack(
        children: [
          Positioned(
            top: down ? 0 : null,
            bottom: down ? null : 10, // 这里 写 10 是因为这个三角形是旋转得到的，比实际上看上去要大
            left: triangleLeft,
            child: Container(
              width: 20,
              height: 20,
              transform: Matrix4.rotationZ(45 * 3.14 / 180),
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(2),
              ),
            ),
          )
        ],
      ),
    );
    return WillPopScope(
      onWillPop: () async {
        controller!.reverse();
        return true;
      },
      child: Scaffold(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0),
          body: SafeArea(
            child: Stack(
              children: [
                Positioned(
                    top: dy,
                    left: dx2,
                    child: Transform.scale(
                      alignment: scaleAlignment,
                      scale: fade!.value,
                      child: Column(
                        verticalDirection: down
                            ? VerticalDirection.down
                            : VerticalDirection.up, // 弹框在上面就倒过来
                        children: [
                          triangle,
                          Container(
                              key: locationKey2,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.white, width: 0), // 边色与边宽度
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_circle,
                                        color: Colors.grey,
                                      ),
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
                        ],
                      ),
                    )),
                // 这里的三角形是通过旋转正方形得到的
                // Positioned(
                //   top: down ? dy - height - 26 : dy,
                //   left: dx + width / 2,
                //   child: Column(
                //     children: [
                //       Transform.scale(
                //         // origin: Offset(dx, dy),
                //         alignment: Alignment.topRight,
                //         scale: 1,
                //         // scale: fade!.value,
                //         child: Opacity(
                //           opacity: 1,
                //           // opacity: opacity!.value,
                //           child: Container(
                //             width: 20,
                //             height: 20,
                //             transform: Matrix4.rotationZ(45 * 3.14 / 180),
                //             decoration: BoxDecoration(
                //               color: Colors.white,
                //               borderRadius: BorderRadius.circular(2),
                //             ),
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // 下面的弹框内容区域，要至少把上面旋转的正方形下半部分都遮住，才能得到三角形
                // Positioned(
                //     top: offset!.dy - topView,
                //     left: offset!.dx,
                //     child: Transform.scale(
                //       // origin: Offset(0, 0),
                //       alignment: Alignment.topRight,
                //       scale: 1,
                //       // scale: fade!.value,
                //       child: Opacity(
                //         opacity: 1,
                //         child: Container(
                //             key: locationKey2,
                //             width: 150,
                //             decoration: BoxDecoration(
                //                 color: Colors.white,
                //                 borderRadius: BorderRadius.circular(5)),
                //             child: Column(
                //               children: [
                //                 Row(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     Icon(Icons.add_circle),
                //                     SizedBox(
                //                       width: 10,
                //                     ),
                //                     Text(
                //                       "创建群聊",
                //                       style: TextStyle(fontSize: 16),
                //                     )
                //                   ],
                //                 )
                //               ],
                //             )),
                //       ),
                //     )
                //     ),
              ],
            ),
          )),
    );
  }
}
