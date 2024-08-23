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

class WithdrawSignBtnGuideWidget extends StatelessWidget{
  Offset offset;
  Function() hideCall;

  WithdrawSignBtnGuideWidget({
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
        child:InkWell(
          onTap: (){
            NewGuideUtils.instance.hideGuideOver();
            hideCall.call();
          },
          child: Stack(
            children: [
              Positioned(
                top: offset.dy,
                left: offset.dx,
                child: Container(
                  width: 80.w,
                  height: 28.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.w),
                      color: colorF26910
                  ),
                  child: TextWidget(
                    text: Local.signIn.tr,
                    color: colorFFFFFF,
                    size: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                top: offset.dy+20.w,
                left: offset.dx+30.w,
                child: Lottie.asset("assets/guide1.json",width: 52.w,height: 52.w),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}