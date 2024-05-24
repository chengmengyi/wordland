import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordland/root/base_widget.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/widget/heart/heart_con.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class HeartWidget extends BaseWidget<HeartCon>{
  @override
  HeartCon setController() => HeartCon();
  
  @override
  Widget contentWidget() => Stack(
    alignment: Alignment.center,
    children: [
      ImageWidget(image: "heart_bg",width: 84.w,height: 38.h,),
      GetBuilder<HeartCon>(
        id: "heart",
        builder: (_)=>TextWidget(text: "${NumUtils.instance.heartNum}", color: colorFFFFFF, size: 14.sp),
      )
    ],
  );
}