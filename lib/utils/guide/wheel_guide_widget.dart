import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wordland/language/local.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/guide/new_guide_utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class WheelGuideWidget extends StatelessWidget{
  Offset offset;
  Function() hideCall;

  WheelGuideWidget({
    required this.offset,
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
        child: Stack(
          children: [
            Positioned(
              top: offset.dy,
              left: offset.dx,
              child: InkWell(
                onTap: (){
                  NewGuideUtils.instance.hideGuideOver();
                  hideCall.call();
                },
                child: ImageWidget(image: "answer13",width: 60.w,height: 62.h,),
              ),
            ),
            Positioned(
              top: offset.dy+20.w,
              left: offset.dx+30.w,
              child: InkWell(
                onTap: (){
                  NewGuideUtils.instance.hideGuideOver();
                  hideCall.call();
                },
                child: Lottie.asset("assets/guide1.json",width: 52.w,height: 52.w),
              ),
            ),
            Positioned(
              right: 30.w,
              bottom: 30.h,
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: colorE8DEC8,
                  borderRadius: BorderRadius.circular(12.w),
                  border: Border.all(
                    width: 1.w,
                    color: colorFFAD65
                  )
                ),
                child: TextWidget(text: Local.daily3FreeSpins.tr, color: color421000, size: 16.sp,fontWeight: FontWeight.w500,height: 1.0,),
              ),
            )
          ],
        ),
      ),
    ),
  );
}