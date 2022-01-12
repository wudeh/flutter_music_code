import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_music/http/http.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../api/api.dart';
import 'package:cloud_music/provider/user.dart';

// 图片裁剪，上传头像
class CropImage extends StatefulWidget {
  CropImage();

  @override
  State<StatefulWidget> createState() {
    return CropImageState();
  }
}

class CropImageState extends State<CropImage> {
  final _controller = CropController();

  Uint8List imageByte = Uint8List(1);

  bool showCrop = false;

  @override
  void initState() {
    super.initState();
    changeToByte();
  }

  Future<void> changeToByte() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image == null) Navigator.of(context).pop();
    imageByte = await image!.readAsBytes();
    setState(() {
      showCrop = true;
    });
  }

  CropImage() {
    //确认裁剪时调用这个方法
    showToast("开始头像上传");
    _controller.crop();
  }

  //将回调拿到的Uint8List格式的图片转换为File格式
  SaveImage(Uint8List imageByte) async {
    // EasyLoading.show();

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/image.jpg').create();
    file.writeAsBytesSync(imageByte);
    print("${file.path}");
    // 获取裁剪出来的图片宽高
    Image image = Image.file(File.fromUri(Uri.parse(file.path)));
    // 预先获取图片信息
    image.image
        .resolve(new ImageConfiguration())
        .addListener(new ImageStreamListener((ImageInfo info, bool _) async {
      // m.width = info.image.width;
      // m.height = info.image.height;
      print("裁剪宽度${info.image.width}");
      // 上传头像
      FormData formdata = FormData.fromMap({
        "imgFile": await MultipartFile.fromFile(file.path),
      });
      String res = await HttpRequest()
          .post(Api.avatarUpload + "?imgSize=${info.image.width}", formdata);
      var resData = jsonDecode(res);
      if (resData['code'] == 200) {
        showToast("头像上传成功");
        // {"code":200,"data":{"url_pre":"https://p1.music.126.net/tqn0ImabLOAhZ2y0P1kGvw==/109951166923615118","url":"https://p1.music.126.net/--9VU0TWhAHzIcpihQbC9g==/109951166923605955.jpg","imgId":"109951166923605955","code":200}}
        // 上传成功后改变头像
        Provider.of<UserModel>(context, listen: false)
            .changeAvatarUrl(resData['data']['url_pre']);
        Navigator.of(context).pop();
      } else {
        showToast("头像上传失败");
      }
    }));

    // EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("头像裁剪"),
          elevation: 0,
          backgroundColor: Colors.black,
          actions: [
            InkWell(
              onTap: () {
                CropImage();
              },
              child: Center(
                child: Text(
                  "确认",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            )
          ]),
      body: Column(
        children: [
          showCrop
              ? Expanded(
                  //Crop是裁剪控件
                  child: Crop(
                  image: imageByte,
                  controller: _controller,
                  onCropped: (image) {
                    //裁剪完成的回调
                    SaveImage(image);
                  },
                  aspectRatio: 1,
                  initialSize: 0.8,
                  withCircleUi: true,
                  baseColor: Colors.black,
                  maskColor: Colors.black.withAlpha(150),
                  cornerDotBuilder: (size, edgeAlignment) =>
                      const DotControl(color: Colors.white54),
                ))
              : SizedBox(),
        ],
      ),
    );
  }
}
