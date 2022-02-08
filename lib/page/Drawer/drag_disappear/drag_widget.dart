// import 'package:flutter/material.dart';
// import './bezier_painter.dart';

// class DragCount extends StatefulWidget {
//   // Widget msgTime;
//   DragCount({Key? key}) : super(key: key);

//   @override
//   _DragCountState createState() => _DragCountState();
// }

// class _DragCountState extends State<DragCount> with TickerProviderStateMixin {
//   bool isMove = false;
//   AnimationController? _controller;
//   double appBarHeight = 10.0;
//   double statusBarHeight = 0.0;
//   double screenHeight = 0.0;
//   double screenWidth = 0.0;
//   Size? end;
//   Size? begin;
//   Offset? during1 = Offset(0, 0);
//   Offset? end1 = Offset(0, 0);
//   GlobalKey<State<StatefulWidget>>? anchorKey;
//   late Animation<Size?> movement;

//   @override
//   void initState() {
//     super.initState();

//     anchorKey = GlobalKey();

//     // 在控件渲染完成后执行的回调
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       RenderBox renderBox =
//           anchorKey!.currentContext!.findRenderObject() as RenderBox;
//       var icon = renderBox.localToGlobal(Offset.zero);
//       end = Size(icon.dx, icon.dy - 7);
//       end1 = Offset(icon.dx, icon.dy - 7);
//       during1 = Offset(icon.dx, icon.dy - 7);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: <Widget>[
//         Container(
//           key: anchorKey,
//           width: 30,
//           height: 30,
//           // color: Colors.yellowAccent,
//           // child: widget.msgTime,
//         ),
//         CustomPaint(foregroundPainter: BezierPainter(during1, end1!)),
//         Positioned(
//             top: 0,
//             left: 0,
//             child: GestureDetector(
//                 child: Container(
//                   width: 30,
//                   height: 30,
//                   color: Colors.transparent,
//                   child: Text('12313'),
//                 ),
//                 onPanStart: (details) {
                  
//                 },
//                 onPanUpdate: (d) {
//                   setState(() {
//                     double dx = d.globalPosition.dx - 350;
//                     var appBar = new AppBar(title: new Text("drag"));
//                     double dy = d.globalPosition.dy -
//                         appBar.preferredSize.height -
//                         MediaQuery.of(context).padding.top - 50;
//                     during1 = Offset(dx, dy);
//                     print(during1);
//                   });
//                 },
//                 onPanEnd: (d) {
//                   begin = Size(d., d.dy);
//                   comeBack();
//                   // print('onPanEnd : ' + d.toString());
//                 })),
//       ],
//     );
//   }

//   comeBack() {
//     _controller = AnimationController(
//         duration: Duration(milliseconds: 1000), vsync: this);
//     _controller!.value;
//     movement = (SizeTween(
//       begin: begin,
//       end: end,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller!,
//         // 动画执行时间所占比重
//         curve: ElasticOutCurve(0.6),
//       ),
//     )
//       ..addListener(() {
//         setState(() {
//           during1 = Offset(movement.value!.width, movement.value!.height);
//         });
//       })
//       ..addStatusListener((AnimationStatus status) {
//         print(status);
//       }));
//     _controller!.reset();
//     _controller!.forward();
//   }
// }
