import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 可传入 widget 的对话弹框
class DialogWidgetShow extends StatefulWidget {
  String? title; // 一级对话框标题
  Widget child;
  Function yes; // 确定执行方法

  DialogWidgetShow(
      {Key? key,
      this.title,
      required this.child,
      required this.yes})
      : super(key: key);

  _DialogWidgetShowState createState() => _DialogWidgetShowState();
}

class _DialogWidgetShowState extends State<DialogWidgetShow> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min, // 对话框高度自适应
            children: <Widget>[
              Container(
                height: 10,
              ),
              widget.title != null ? Center(
                child: Text(
                  widget.title!,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 22),
                ),
              ) : const SizedBox(),
              widget.child,
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  MaterialButton(
                    child: Text('取消',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14.sp)),
                    color: Colors.white,
                    colorBrightness: Brightness.light,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  MaterialButton(
                    child: Text('确定',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14.sp)),
                    color: Colors.white,
                    colorBrightness: Brightness.light,
                    onPressed: () {
                      Navigator.pop(context);
                      widget.yes();
                    },
                  ),
                  SizedBox(
                    width: 30,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
