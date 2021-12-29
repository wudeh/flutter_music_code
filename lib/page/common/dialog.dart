import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './ExpandText.dart';

class DialogShow extends StatefulWidget {

  String title; // 一级对话框标题
  String subTitle;  // 二级标题
  String smallSubTitle; // 三级标题
  String description; // 对话框说明
  Function yes; // 确定执行方法

  DialogShow({Key? key,required this.title,required this.subTitle,required this.smallSubTitle,required  this.description,required this.yes}) : super(key: key);

  _DialogShowState createState() => _DialogShowState();
}

class _DialogShowState extends State<DialogShow> {

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,   // 对话框高度自适应
            children: <Widget>[
              Container(
                height: 10,
              ),
              Center(
                child: Text(widget.title,style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 27),),
              ),
              widget.subTitle != null 
                ? 
                ExpansionTile(
                  expandedAlignment: Alignment.topLeft,
                title: Text(widget.subTitle),
                subtitle: Text(widget.smallSubTitle != null ? widget.smallSubTitle : ''),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 15.w),
                    child: Text(widget.description),
                  )
                ],
              ) : 
                ExpandableText(text: widget.description,style: TextStyle()),
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  MaterialButton(
                    child: Text('取消',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14.sp)),
                    color: Colors.white,
                    colorBrightness: Brightness.light,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  MaterialButton(
                    child: Text('确定',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14.sp)),
                    color: Colors.white,
                    colorBrightness: Brightness.light,
                    onPressed: (){
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