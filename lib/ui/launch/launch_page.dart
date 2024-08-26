import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plugin_base/root/root_page.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:wordland/ui/launch/launch_con.dart';

class LaunchPage extends RootPage<LaunchCon>{
  @override
  String bgName() =>"launch1";

  @override
  LaunchCon setController() => LaunchCon();

  @override
  Widget contentWidget() => Column(
    children: [
      SizedBox(height: 180.h,),
      ImageWidget(image: Platform.isAndroid?"launch3":"launch2",width: 288.w,height: 156.h,),
      const Spacer(),
      _progressWidget(),
      SizedBox(height: 120.h,),
    ],
  );

  _progressWidget()=>
      Container(
        width: 160.w,
        height: 12.h,
        padding: EdgeInsets.only(left: 2.w,right: 2.w),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: color025800.withOpacity(0.8),
            borderRadius: BorderRadius.circular(6.w)
        ),
        child: GetBuilder<LaunchCon>(
          id: "progress",
          builder: (_)=> Container(
            width: (156.w)*rootController.progress,
            height: 8.h,
            decoration: BoxDecoration(
              color: colorFF9057,
              borderRadius: BorderRadius.circular(4.w),
            ),
          ),
        ),
      );
}