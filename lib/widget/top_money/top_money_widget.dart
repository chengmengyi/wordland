import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordland/enums/top_cash.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/base_widget.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';
import 'package:wordland/widget/top_money/top_money_con.dart';

class TopMoneyWidget extends BaseWidget<TopMoneyCon>{
  TopCash topCash;
  Function()? clickCall;
  TopMoneyWidget({required this.topCash,this.clickCall});

  @override
  TopMoneyCon setController() => TopMoneyCon();

  @override
  Widget contentWidget() => SizedBox(
    width: 200.w,
    height: 38.h,
    child: Stack(
      children: [
        ImageWidget(image: "top_money_bg",width: 200.w,height: 38.h,fit: BoxFit.fill,),
        Align(
          alignment: Alignment.centerLeft,
          child: GetBuilder<TopMoneyCon>(
            id: "coin",
            builder: (_)=>Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 44.w,),
                TextWidget(text: "${NumUtils.instance.coinNum}≈", color: colorFFFFFF, size: 10.sp,fontWeight: FontWeight.w700,),
                TextWidget(text: "\$${ValueConfUtils.instance.getCoinToMoney(NumUtils.instance.coinNum)}", color: colorFFE600, size: 12.sp,fontWeight: FontWeight.w700),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: (){
              rootController.clickCash(topCash, clickCall);
            },
            child: Container(
              width: 36.w,
              height: 24.h,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: colorFFDD28,
                borderRadius: BorderRadius.circular(12.w)
              ),
              child: TextWidget(text: "Cash", color: colorFF2B2B, size: 12.sp,fontWeight: FontWeight.w700,),
            ),
          ),
        )
      ],
    ),
  );
}