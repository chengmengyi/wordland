import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/root/base_widget.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/head_widget/head_con.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class HeadWidget extends BaseWidget<HeadCon>{

  @override
  HeadCon setController() => HeadCon();

  @override
  Widget contentWidget() =>SizedBox(
    width: 160.w,
    height: 44.h,
    child: Stack(
      alignment: Alignment.bottomLeft,
      children: [
        ImageWidget(image: "home8",width: 160.w,height: 38.h,fit: BoxFit.fill,),
        ImageWidget(image: rootController.headName,width: 44.w,height: 44.h,),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(left: 48.w,top: 6.h),
            child: TextWidget(text: rootController.userName, color: colorFFFFFF, size: 14.sp,fontWeight: FontWeight.w600,),
          ),
        )
      ],
    ),
  );
}