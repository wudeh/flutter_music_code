import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Img extends StatefulWidget {

  String url; // 图片路径资源

  double w; // 宽

  double h; // 高

  Img({Key? key, required this.url, required this.w, required this.h}) : super(key: key);

  _ImgState createState() => _ImgState();
}

class _ImgState extends State<Img> {
  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      widget.url,
      width: widget.w,
      height: widget.h,
      fit: BoxFit.fill,
      cache: true,
      // border: Border.all(color: Colors.red, width: 1.0),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(30.0.w)),
      //cancelToken: cancellationToken,
    )
    ;
  }
}