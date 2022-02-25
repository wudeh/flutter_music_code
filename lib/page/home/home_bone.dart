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
            height: 160,
            padding: EdgeInsets.all(8),
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
                    height: 70,
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
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor,
                                    borderRadius:
                                        BorderRadius.circular(
                                            40)),
                                margin: EdgeInsets.only(
                                    left: 8, right: 8),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/images/loading.png",
                                    fit: BoxFit.contain,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3,),
                              Container(height: 10,width: 50,color: Colors.grey[300]),
                            ],
                          );
                        },
                      ),
                    ),
                // 推荐歌单 标题
                Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Container(height: 20,width: 80,color: Colors.grey[300]),
                          ),
                    ],
                  ),
                ),
                Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              
                            },
                            child: Container(
                              width: 110,
                              margin: EdgeInsets.only(
                                  left: index == 0 ? 8 : 0,
                                  right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(8),
                                          child: Image.asset(
                                            "assets/images/loading.png",
                                            fit: BoxFit.contain,
                                            width: 110,
                                            height: 110,
                                          )),
                                      
                                    ],
                                  ),
                                  const SizedBox(height: 3,),
                                  Container(height: 10,width: 110,color: Colors.grey[300]),
                                  const SizedBox(height: 3,),
                                  Container(height: 10,width: 70,color: Colors.grey[300]),
                                ],
                              ),
                            ));
                      },
                    )),

                Container(
                  height: 8,
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
                padding: EdgeInsets.only(bottom: 3),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding:
                            EdgeInsets.only(left: 8, top: 8),
                        child: Container(height: 20,width: 150,color: Colors.grey[300]),
                        ),
                  ],
                ),
              ),
              // 长名字信息区
              Container(
                height: 170,
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
                                  width: 360,
                                  padding:
                                      EdgeInsets.only(left: 8),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(8),
                                          child: Image.asset(
                                            "assets/images/loading.png",
                                            fit: BoxFit.contain,
                                            width: 50,
                                            height: 50,
                                          )),
                                      SizedBox(
                                        width: 8,
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
                                            width: 270,
                                            child: Container(height: 14,width: 150,color: Colors.grey[300]),
                                          ),
                                          SizedBox(height: 3,),
                                          // 副标题区域
                                          Container(
                                            width: 270,
                                            child: Container(height: 14,width: 120,color: Colors.grey[300]),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                          ),
                          Container(
                                  width: 360,
                                  padding:
                                      EdgeInsets.only(left: 8),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(8),
                                          child: Image.asset(
                                            "assets/images/loading.png",
                                            fit: BoxFit.contain,
                                            width: 50,
                                            height: 50,
                                          )),
                                      SizedBox(
                                        width: 8,
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
                                            width: 270,
                                            child: Container(height: 14,width: 150,color: Colors.grey[300]),
                                          ),
                                          SizedBox(height: 3,),
                                          // 副标题区域
                                          Container(
                                            width: 270,
                                            child: Container(height: 14,width: 120,color: Colors.grey[300]),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                          ),
                          Container(
                                  width: 360,
                                  padding:
                                      EdgeInsets.only(left: 8),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(8),
                                          child: Image.asset(
                                            "assets/images/loading.png",
                                            fit: BoxFit.contain,
                                            width: 50,
                                            height: 50,
                                          )),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      // 歌曲信息部分
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        
                                        children: [
                                          // 歌曲名称和歌手
                                          Container(
                                            width: 270,
                                            child: Container(height: 14,width: 150,color: Colors.grey[300]),
                                          ),
                                          SizedBox(height: 3,),
                                          // 副标题区域
                                          Container(
                                            width: 270,
                                            child: Container(height: 14,width: 120,color: Colors.grey[300]),
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
                height: 8,
                color: Colors.black12,
              ),
              /// 雷达歌单
              Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Container(height: 20,width: 80,color: Colors.grey[300]),
                          ),
                    ],
                  ),
                ),
                Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              
                            },
                            child: Container(
                              width: 110,
                              margin: EdgeInsets.only(
                                  left: index == 0 ? 8 : 0,
                                  right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(8),
                                          child: Image.asset(
                                            "assets/images/loading.png",
                                            fit: BoxFit.contain,
                                            width: 110,
                                            height: 110,
                                          )),
                                      
                                    ],
                                  ),
                                  const SizedBox(height: 3,),
                                  Container(height: 10,width: 110,color: Colors.grey[300]),
                                  const SizedBox(height: 3,),
                                  Container(height: 10,width: 70,color: Colors.grey[300]),
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
