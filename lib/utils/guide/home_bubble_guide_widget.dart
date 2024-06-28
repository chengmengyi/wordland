import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/guide/new_guide_utils.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

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
                    ImageWidget(image: "home13",width: 60.h,height: 60.w,),
                    TextWidget(text: "+$addNum", color: colorFFE600, size: 14.sp,fontWeight: FontWeight.w700,)
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