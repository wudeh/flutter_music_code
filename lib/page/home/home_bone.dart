import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// 首页骨架
class HomeBone extends StatelessWidget {
  const HomeBone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.white,
        child: Column(
        children: [
          /// 轮播
          Container(
            height: 160.w,
            padding: EdgeInsets.all(8.w),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          /// 圆形图标
          Container(
            child: Column(
              children: [
                // 圆形图标
                Container(
                    height: 70.w,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor,
                                    borderRadius:
                                        BorderRadius.circular(
                                            40.w)),
                                margin: EdgeInsets.only(
                                    left: 8.w, right: 8.w),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/images/loading.png",
                                    fit: BoxFit.contain,
                                    width: 50.w,
                                    height: 50.w,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3,),
                              Container(height: 10,width: 50.w,color: Colors.grey[300]),
                            ],
                          );
                        },
                      ),
                    ),
                // 推荐歌单 标题
                Padding(
                  padding: EdgeInsets.only(bottom: 3.w),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Container(height: 20,width: 80.w,color: Colors.grey[300]),
                          ),
                    ],
                  ),
                ),
                Container(
                    height: 150.w,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              
                            },
                            child: Container(
                              width: 110.w,
                              margin: EdgeInsets.only(
                                  left: index == 0 ? 8.w : 0,
                                  right: 8.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(8.w),
                                          child: Image.asset(
                                            "assets/images/loading.png",
                                            fit: BoxFit.contain,
                                            width: 110.w,
                                            height: 110.w,
                                          )),
                                      
                                    ],
                                  ),
                                  const SizedBox(height: 3,),
                                  Container(height: 10,width: 110.w,color: Colors.grey[300]),
                                  const SizedBox(height: 3,),
                                  Container(height: 10,width: 70.w,color: Colors.grey[300]),
                                ],
                              ),
                            ));
                      },
                    )),

                Container(
                  height: 8.w,
                  color: Colors.black12,
                )
              ],
            ),
          ),
          /// 长标题
          Column(
            children: [
              // 长名字标题
              Padding(
                padding: EdgeInsets.only(bottom: 3.w),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding:
                            EdgeInsets.only(left: 8.w, top: 8.w),
                        child: Container(height: 20,width: 150.w,color: Colors.grey[300]),
                        ),
                  ],
                ),
              ),
              // 长名字信息区
              Container(
                height: 170.w,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount:
                      2,
                  itemBuilder: (context, index) {
                    return Column(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                                  width: 360.w,
                                  padding:
                                      EdgeInsets.only(left: 8.w),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(8.w),
                                          child: Image.asset(
                                            "assets/images/loading.png",
                                            fit: BoxFit.contain,
                                            width: 50.w,
                                            height: 50.w,
                                          )),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      // 歌曲信息部分
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          // 歌曲名称和歌手
                                          Container(
                                            width: 270.w,
                                            child: Container(height: 14,width: 150.w,color: Colors.grey[300]),
                                          ),
                                          SizedBox(height: 3,),
                                          // 副标题区域
                                          Container(
                                            width: 270.w,
                                            child: Container(height: 14,width: 120.w,color: Colors.grey[300]),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                          ),
                          Container(
                                  width: 360.w,
                                  padding:
                                      EdgeInsets.only(left: 8.w),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(8.w),
                                          child: Image.asset(
                                            "assets/images/loading.png",
                                            fit: BoxFit.contain,
                                            width: 50.w,
                                            height: 50.w,
                                          )),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      // 歌曲信息部分
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          // 歌曲名称和歌手
                                          Container(
                                            width: 270.w,
                                            child: Container(height: 14,width: 150.w,color: Colors.grey[300]),
                                          ),
                                          SizedBox(height: 3,),
                                          // 副标题区域
                                          Container(
                                            width: 270.w,
                                            child: Container(height: 14,width: 120.w,color: Colors.grey[300]),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                          ),
                          Container(
                                  width: 360.w,
                                  padding:
                                      EdgeInsets.only(left: 8.w),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(8.w),
                                          child: Image.asset(
                                            "assets/images/loading.png",
                                            fit: BoxFit.contain,
                                            width: 50.w,
                                            height: 50.w,
                                          )),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      // 歌曲信息部分
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        
                                        children: [
                                          // 歌曲名称和歌手
                                          Container(
                                            width: 270.w,
                                            child: Container(height: 14,width: 150.w,color: Colors.grey[300]),
                                          ),
                                          SizedBox(height: 3,),
                                          // 副标题区域
                                          Container(
                                            width: 270.w,
                                            child: Container(height: 14,width: 120.w,color: Colors.grey[300]),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                          ),
                        ]);
                        
                        
                  },
                ),
              ),
              Container(
                height: 8.w,
                color: Colors.black12,
              ),
              /// 雷达歌单
              Padding(
                  padding: EdgeInsets.only(bottom: 3.w),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Container(height: 20,width: 80.w,color: Colors.grey[300]),
                          ),
                    ],
                  ),
                ),
                Container(
                    height: 150.w,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              
                            },
                            child: Container(
                              width: 110.w,
                              margin: EdgeInsets.only(
                                  left: index == 0 ? 8.w : 0,
                                  right: 8.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(8.w),
                                          child: Image.asset(
                                            "assets/images/loading.png",
                                            fit: BoxFit.contain,
                                            width: 110.w,
                                            height: 110.w,
                                          )),
                                      
                                    ],
                                  ),
                                  const SizedBox(height: 3,),
                                  Container(height: 10,width: 110.w,color: Colors.grey[300]),
                                  const SizedBox(height: 3,),
                                  Container(height: 10,width: 70.w,color: Colors.grey[300]),
                                ],
                              ),
                            ));
                      },
                    )),
            ],
          )
        ],
      ),
      ),
    );
  }
}
