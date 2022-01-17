import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 带路由过渡动画的图片
class HeroExtenedImage extends StatefulWidget {
  double width;
  double? height;
  String? img;
  bool isRectangle;

  HeroExtenedImage({Key? key,required this.width,this.height, this.img, this.isRectangle = true}) : super(key: key);

  _HeroExtenedImageState createState() => _HeroExtenedImageState();
}

class _HeroExtenedImageState extends State<HeroExtenedImage> {

  @override
  Widget build(BuildContext context) {
    return widget.img == null 
      ? SizedBox() 
      : Hero(
          tag: widget.img!,
          child: ExtendedImage.network(          
                widget.img ?? "http://p1.music.126.net/OjlAjd43ajVIns8-M98ugA==/109951165177312849.jpg",
                width: widget.width,
                height: widget.height ?? widget.width,
                cache: true,
                shape: widget.isRectangle ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: BorderRadius.all(Radius.circular(10.0.w)),
                loadStateChanged: (ExtendedImageState state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return Image.asset(
                        "assets/images/loading.png",
                        fit: BoxFit.contain,
                      );
                      // return Shimmer.fromColors(
                      //   child: Image.asset(
                      //       "assets/images/loading.png",
                      //       fit: BoxFit.contain,
                      //   ),
                      //   baseColor: Colors.grey,
                      //   highlightColor: Colors.white,
                      // );
                      break;
                    ///if you don't want override completed widget
                    ///please return null or state.completedWidget
                    //return null;
                    //return state.completedWidget;
                    case LoadState.completed:
                      return ExtendedRawImage(
                          image: state.extendedImageInfo?.image,
                          width: widget.width,
                          height: widget.height == null ? widget.width : widget.height,
                        );
                      break;
                    case LoadState.failed:
                      return GestureDetector(
                        child: Icon(Icons.error),
                        onTap: () {
                          state.reLoadImage();
                        },
                      );
                      break;
                  }
                },
              ),
        );
  }
}


/// 不带路由过渡动画的图片
class ExtenedImage extends StatefulWidget {
  double width;
  double? height;
  String? img;
  bool isRectangle;

  ExtenedImage({Key? key,required this.width,this.height, this.img, this.isRectangle = true}) : super(key: key);

  _ExtenedImageState createState() => _ExtenedImageState();
}

class _ExtenedImageState extends State<ExtenedImage> {

  @override
  Widget build(BuildContext context) {
    return widget.img == null 
      ? SizedBox() 
      : ExtendedImage.network(          
                widget.img ?? "http://p1.music.126.net/OjlAjd43ajVIns8-M98ugA==/109951165177312849.jpg",
                width: widget.width,
                height: widget.height ?? widget.width,
                cache: true,
                shape: widget.isRectangle ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: BorderRadius.all(Radius.circular(10.0.w)),
                loadStateChanged: (ExtendedImageState state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return Image.asset(
                        "assets/images/loading.png",
                        fit: BoxFit.contain,
                      );
                      // return Shimmer.fromColors(
                      //   child: Image.asset(
                      //       "assets/images/loading.png",
                      //       fit: BoxFit.contain,
                      //   ),
                      //   baseColor: Colors.grey,
                      //   highlightColor: Colors.white,
                      // );
                      break;
                    ///if you don't want override completed widget
                    ///please return null or state.completedWidget
                    //return null;
                    //return state.completedWidget;
                    case LoadState.completed:
                      return ExtendedRawImage(
                          image: state.extendedImageInfo?.image,
                          width: widget.width,
                          height: widget.height == null ? widget.width : widget.height,
                        );
                      break;
                    case LoadState.failed:
                      return GestureDetector(
                        child: Icon(Icons.error),
                        onTap: () {
                          state.reLoadImage();
                        },
                      );
                      break;
                  }
                },
          );
  }
}