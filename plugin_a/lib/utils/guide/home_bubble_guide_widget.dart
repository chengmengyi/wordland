import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:plugin_a/utils/guide/new_guide_utils.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:plugin_base/widget/stroked_text_widget.dart';
import 'package:plugin_base/widget/text_widget.dart';

class HomeBubbleGuideWidget extends StatelessWidget{
  Function(double) hideCall;

  var addNum=NewValueUtils.instance.getRewardAddNum();

  HomeBubbleGuideWidget({
    required this.hideCall,
  });

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: InkWell(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: color000000.withOpacity(0.6),
        child:InkWell(
          onTap: (){
            NewGuideUtils.instance.hideGuideOver();
            hideCall.call(addNum);
          },
          child: Stack(
            children: [
              Positioned(
                // top: offset.dy,
                // left: offset.dx,
                right: 16.w,
                top: 60.h,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ImageWidget(image: Platform.isAndroid?"home22":"home13",width: 60.h,height: 60.w,),
                    // TextWidget(text: "+$addNum", color: colorFFE600, size: 14.sp,fontWeight: FontWeight.w700,)
                    StrokedTextWidget(
                      text: "${getMoneyUnit()}$addNum",
                      fontSize: 14.sp,
                      textColor: colorFFE600,
                      strokeColor: color000000,
                    )
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 100.h,
                child: Lottie.asset("assets/guide1.json",width: 52.w,height: 52.w),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}