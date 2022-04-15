import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// 下载进度条
class DownloadProgress extends StatefulWidget {
  double progress;

  DownloadProgress({Key? key,required this.progress}) : super(key: key);

  @override
  _DownloadProgressState createState() => _DownloadProgressState();
}

class _DownloadProgressState extends State<DownloadProgress> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 140,
          height: 10,
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Shimmer.fromColors(
                baseColor: Colors.red,
                highlightColor: Colors.white70,
                child: Container(
                  width: 140 * widget.progress / 100 < 0 ? 0 : 140 * widget.progress / 100,
                  height: 10,
                  color: Theme.of(context).primaryColor,
                ),
              ),
        ),
        SizedBox(
          width: 140,
          height: 10,
          child: Center(
            child: widget.progress < 0 ? const SizedBox() :  Text("${widget.progress.toDouble()}%",style: TextStyle(fontSize: 10.sp),),
          )
        )
      ],
    );
  }
}
