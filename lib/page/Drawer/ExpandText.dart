import 'package:flutter/material.dart';

// 这是一个用于评论区展开收起的 widget
class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle style;
  final bool expand;
 
  const ExpandableText({Key? key,required this.text, this.maxLines = 2,required this.style, this.expand = false}) : super(key: key);
 
  @override
  State<StatefulWidget> createState() {
    return _ExpandableTextState(text, maxLines, style, expand);
  }
 
}
 
class _ExpandableTextState extends State<ExpandableText> {
  String text;
  int maxLines;
  TextStyle style;
  bool expand;
 
  _ExpandableTextState(this.text, this.maxLines, this.style, this.expand) {
    if (expand == null) {
      expand = false;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final span = TextSpan(text: text, style: style);
      final tp = TextPainter(
          text: span, maxLines: this.maxLines, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: size.maxWidth);
 
      if (tp.didExceedMaxLines) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            expand ?
            Text(text, style: style) :
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(text, maxLines: this.maxLines,
                  // overflow: TextOverflow.ellipsis,
                  style: style,
                  softWrap: true,
                ),
                // Text('......',)
              ],
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // 监听点击手势
                setState(() {
                  expand = !expand;
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 2),
                alignment: Alignment.bottomLeft,
                child: Text(expand ? '收起' : '展开', style: TextStyle(
                    fontSize: style != null ? style.fontSize : null,
                    color: Colors.blue)),
              ),
            ),
          ],
        );
      } else {
        return Text(text, style: style);
      }
    });
  }
}