import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



// 这是评论页面，需要请求封面，作者等相关信息，还有评论相关信息

class Comment extends StatefulWidget {
  final id;
  final type;

  Comment({Key? key, required this.id, required this.type}) : super(key: key);

  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {


  // 评论数
  int commentNum = 0;


  ScrollController _scrollController = ScrollController();

  double hh = 0;

  Color _color = Colors.red;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController..addListener(() {
        print(_scrollController.offset);
        if(_scrollController.offset > 50) {
          commentNum = 100;
          _color = Colors.yellowAccent;
        }else {
          _color = Colors.red;
        }
        
        hh =_scrollController.offset;
        print(hh.toString() + '这是hh');
        print(_scrollController.position.maxScrollExtent.toString() + '这是最大滚动');
        print(_scrollController.position.pixels.toString() + '这是当前滚动');
        setState(() {
        });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  // 先请求封面相关信息
  void _getInfo() async {
    // type = 0 是歌曲，type = 2 是歌单
    if(widget.type == 0) {

    }
    if(widget.type == 2) {

    }
  }


  // 再请求评论
  void _GetCommentInfo() async {

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text('评论($commentNum)'), 
       ),
       body: Scrollbar(
         isAlwaysShown: false,
          child: CustomScrollView(
         controller: _scrollController,
         slivers: [
           SliverToBoxAdapter(
             child: AnimatedContainer(
                width: 100.w, 
                height: 300,
                color: Colors.blueAccent,
                // padding: EdgeInsets.only(top: 300),
                alignment: Alignment.bottomCenter,
                duration: Duration(milliseconds: 100),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Container(
                      width: double.infinity, 
                      height: hh,
                      color: Colors.red,
                      alignment: Alignment.bottomCenter,
                      child: Text('data1'),
                    ),
                    Expanded(
                      child: AnimatedContainer(
                        width: double.infinity, 
                        // height: hh,
                        color: _color,
                        duration: Duration(milliseconds: 500),
                        alignment: Alignment.topCenter,
                        child: InkWell(
                          onTap: () {
                            _scrollController.animateTo(0, duration: Duration(milliseconds: 50), curve: Curves.linear);
                          }, 
                          child: Text('data2'),
                        ),
                      ), 
                    )
                  ], 
                )
             ),
           ),
           SliverList(
             delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Text('data');
                },
                childCount: 100
             ), 
           )
         ],
       ), 
       ),
    );
  }
}