import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading extends StatelessWidget {

  Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );


    // Container(
    //   height: 70.h,
    //   child: Center(
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Image.asset('assets/images/loading.gif', width: 20.w,),
    //         SizedBox(width: 8.w,),
    //         Text('加载中...')
    //       ], 
    //     ), 
    //   ),
    // )
  }
}