import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading {
  static bool isLoading = true;

  // 展示 loading
  static showLoading(context) {
    isLoading = true;
    showDialog(
        context: context,
        barrierDismissible: false, // 屏蔽点击对话框外部自动关闭
        builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              if (isLoading) {
                return Future.value(false);
              }
              return Future.value(true);
            },
            child: Center(
                child: Container(
              width: 150,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                  color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 10.w,
                  ),
                  Material(
                    child: Text(
                      "加载中...",
                      style: TextStyle(fontSize: 16, color: Colors.black38),
                    ),
                  )
                ],
              ),
            )),
          );
        });
  }

  // 关闭 loading
  static closeLoading(context) {
    isLoading = false;
    Navigator.of(context).pop();
  }
}
