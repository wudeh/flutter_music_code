import 'package:test22/model/msg_private.dart';
import 'package:test22/page/Drawer/controller.dart';
import 'package:test22/provider/user.dart';
import 'package:test22/router/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import '../../util/num.dart';

class MsgDrawer extends StatefulWidget {
  MsgDrawer({Key? key}) : super(key: key);

  @override
  _MsgDrawerState createState() => _MsgDrawerState();
}

class _MsgDrawerState extends State<MsgDrawer> {
  String? msgCount;

  @override
  void initState() {
    super.initState();
    if (Provider.of<UserModel>(context, listen: false).userInfo != null)
      getMsg();
  }

  // 获取私信
  Future<void> getMsg() async {
    MsgPrivateModel? res = await Controller.getUserPrivateMsg(0);
    setState(() {
      msgCount = res!.newMsgCount! > 99 ? "99+" : res.newMsgCount.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<UserModel>(context, listen: false).userInfo == null) {
      msgCount = null;
    }
    return ListTile(
      leading: Icon(Icons.mail),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("我的消息"),
          msgCount == null
              ? SizedBox()
              : Container(
                  height: 18.w,
                  padding: EdgeInsets.only(left: 3, right: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18.w)),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      msgCount ?? "",
                      style: TextStyle(fontSize: 12.sp, color: Colors.white),
                    ),
                  ),
                )
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
      onTap: () {
        if (Provider.of<UserModel>(context, listen: false).userInfo != null) {
          NavigatorUtil.gotoMsgPage(context);
        } else {
          showToast("请先登录");
        }
      },
    );
  }
}
