import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 这是一个高亮关键词颜色的组件

class ColorWordText extends StatelessWidget {
  final String word;
  final String text;
  final double size;
  final Color lowColor;
  final int maxLine;


  ColorWordText({Key? key, required this.word, required this.text, required this.size, required this.lowColor,this.maxLine = 1,}) : super(key: key);


  
  // InlineSpan formSpan(String src, String pattern) {
  //   List<TextSpan> span = [];
  //   List<String> parts = src.split(pattern);
  //   if (parts.length > 1) {
  //     for (int i = 0; i < parts.length; i++) {
  //       span.add(TextSpan(text: parts[i]));
  //       if (i != parts.length - 1) {
  //         span.add(TextSpan(text: pattern, style: lightTextStyle));
  //       }
  //     }
  //   } else {
  //     span.add(TextSpan(text: src));
  //   }
  //   return TextSpan(children: span);
  // }


  @override
  Widget build(BuildContext context) {
    // final TextStyle lightTextStyle = const TextStyle(
    //   color: Theme.of(context).primaryColor,
    //   fontWeight: FontWeight.bold,
    // );
    // 如果包含搜索词
    if(text.contains(word)) {
      return RichText(
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
      text: text.indexOf(word) > 0 ? 
              TextSpan(
                text: '',
                children: [
                  // 如果不是以关键词开头的文字
                  TextSpan(
                    text: text.substring(0, text.indexOf(word)),
                    style: TextStyle(color: lowColor, fontSize: size.sp)
                  ),
                  TextSpan(
                    text: word,
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: size.sp)
                  ),
                  word.length + text.indexOf(word) + 1 == text.length ? 
                    TextSpan(text: '') : 
                    TextSpan(
                      text: text.substring(word.length + text.indexOf(word)),
                      style: TextStyle(color: lowColor, fontSize: size.sp)
                    )
                ]
              ) : 
              // 关键词在文本开头
              TextSpan(
                text: '', 
                children: [
                  TextSpan(
                    text: word, 
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: size.sp),
                  ),
                  TextSpan(
                    text: text.substring(word.length), 
                    style: TextStyle(color: lowColor, fontSize: size.sp),
                  )
                ]
              ),
    );
    }else {
      return Text(text,style: TextStyle(color: lowColor, fontSize: size.sp),maxLines: maxLine, overflow: TextOverflow.ellipsis,);
    }

    
    
  }
}