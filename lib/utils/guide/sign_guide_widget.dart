import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/guide/guide_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class SignGuideWidget extends StatelessWidget{
  Offset offset;
  Function() hideCall;

  SignGuideWidget({
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
              child: _signItemWidget(),
            ),
            Positioned(
              top: offset.dy+40.w,
              left: offset.dx+30.w,
              child: Lottie.asset("assets/guide1.json",width: 52.w,height: 52.w),
            ),
          ],
        ),
      ),
    ),
  );

  _signItemWidget()=>InkWell(
    onTap: (){
      GuideUtils.instance.hideGuideOver();
      hideCall.call();
    },
    child: Container(
      width: 60.w,
      height: 72.w,
      margin: EdgeInsets.only(left: 2.w,right: 2.w),
      child: Stack(
        children: [
          ImageWidget(
            image: "sign9",
            width: 60.w,
            height: 72.w,
            fit: BoxFit.fill,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextWidget(text: "${NumUtils.instance.signDays+1}", color: colorBEBEBE, size: 10.sp,fontWeight: FontWeight.w700,),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8.h,),
                ImageWidget(
                  image: "icon_money2",
                  width: 32.w,
                  height: 32.w,
                ),
                TextWidget(
                  text: "+${ValueConfUtils.instance.getSignConfList()[NumUtils.instance.signDays]}",
                  color: colorFF490F,
                  size: 12.sp,
                  fontWeight: FontWeight.w700,
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}