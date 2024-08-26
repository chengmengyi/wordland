import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:plugin_b/guide/new_guide_utils.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/utils/withdraw_task_util.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:plugin_base/widget/text_widget.dart';

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
      NewGuideUtils.instance.hideGuideOver();
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
            child: TextWidget(text: "${WithdrawTaskUtils.instance.signDays+1}", color: colorBEBEBE, size: 10.sp,fontWeight: FontWeight.w700,),
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
                  text: "+${getOtherCountryMoneyNum(NewValueUtils.instance.getSignList()[WithdrawTaskUtils.instance.signDays].toDouble())}",
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