import 'package:cloud_music/page/common/extended_image.dart';
import 'package:cloud_music/provider/user.dart';
import 'package:cloud_music/router/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// 我的资料
class UserInfoEditPage extends StatefulWidget {
  UserInfoEditPage({Key? key}) : super(key: key);

  @override
  _UserInfoEditPageState createState() => _UserInfoEditPageState();
}

class _UserInfoEditPageState extends State<UserInfoEditPage> {
  @override
  Widget build(BuildContext context) {
    int genderInt = Provider.of<UserModel>(context).userInfo!.profile!.gender!;
    String gender = genderInt == 0 ? "未设置" : genderInt == 1 ? "男" : "女";
    return Scaffold(
      appBar: AppBar(
        title: Text("我的资料"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("头像"),
            trailing: ExtenedImage(
              width: 30.w,
              height: 30.w,
              img: Provider.of<UserModel>(context).userInfo!.profile!.avatarUrl,
            ),
            onTap: () {
              // 点击后进入选择图片裁剪上传头像流程
              NavigatorUtil.gotoCropAvatarPage(context);
            },
          ),
          ListTile(
            title: Text("昵称"),
            trailing: Text(
              "${Provider.of<UserModel>(context).userInfo!.profile!.nickname}",
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            onTap: () {
              // NavigatorUtil.gotoCropAvatarPage(context);
            },
          ),
          ListTile(
            title: Text("性别"),
            trailing: Text(
              "$gender",
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            onTap: () {
              // NavigatorUtil.gotoCropAvatarPage(context);
            },
          ),
          ListTile(
            title: Text("二维码"),
            trailing: Icon(Icons.qr_code_2),
            onTap: () {
              // NavigatorUtil.gotoCropAvatarPage(context);
            },
          ),
          ListTile(
            title: Text("生日"),
            onTap: () {
              // NavigatorUtil.gotoCropAvatarPage(context);
            },
          ),
          ListTile(
            title: Text("地区"),
            onTap: () {
              // NavigatorUtil.gotoCropAvatarPage(context);
            },
          ),
          ListTile(
            title: Text("大学"),
            onTap: () {
              // NavigatorUtil.gotoCropAvatarPage(context);
            },
          ),
          ListTile(
            title: Text("音乐标签"),
            onTap: () {
              // NavigatorUtil.gotoCropAvatarPage(context);
            },
          ),
          ListTile(
            title: Text("简介"),
            onTap: () {
              // NavigatorUtil.gotoCropAvatarPage(context);
            },
          ),
          ListTile(
            title: Text("个人主页隐私设置"),
            onTap: () {
              // NavigatorUtil.gotoCropAvatarPage(context);
            },
          ),
          ListTile(
            title: Text("主页模块顺序设置"),
            onTap: () {
              // NavigatorUtil.gotoCropAvatarPage(context);
            },
          ),
          ListTile(
            title: Text("账号和绑定设置"),
            onTap: () {
              // NavigatorUtil.gotoCropAvatarPage(context);
            },
          ),
        ],
      ),
    );
  }
}
