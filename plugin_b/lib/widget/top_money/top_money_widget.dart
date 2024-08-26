import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plugin_b/widget/top_money/top_money_con.dart';
import 'package:plugin_base/enums/top_cash.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/base_widget.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:plugin_base/widget/text_widget.dart';

class TopMoneyWidget extends BaseWidget<TopMoneyCon>{
  TopCash topCash;
  Function()? clickCall;
  TopMoneyWidget({required this.topCash,this.clickCall});

  @override
  TopMoneyCon setController() => TopMoneyCon();

  @override
  Widget contentWidget() => Stack(
    children: [
      Container(
        height: 38.h,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 2.w,right: 2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.w),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [color785600,color865000]
          )
        ),
        child: Container(
          height: 34.h,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 4.w,right: 4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.w),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorF9E423,colorFFB00E]
            ),
          ),
          child: Container(
            height: 26.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [color785600,color865000]
                )
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 38.w,),
                GetBuilder<TopMoneyCon>(
                  id: "coin",
                  builder: (_)=>TextWidget(text: getOtherCountryMoneyNum(NumUtils.instance.userMoneyNum), color: colorFFE600, size: 12.sp,fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 10.w,),
                InkWell(
                  onTap: (){
                    rootController.clickCash(topCash, clickCall);
                  },
                  child: Container(
                    height: 24.h,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 1.w),
                    padding: EdgeInsets.only(left: 4.w,right: 4.w,),
                    decoration: BoxDecoration(
                        color: colorFFDD28,
                        borderRadius: BorderRadius.circular(12.w)
                    ),
                    child: TextWidget(text: Local.cash.tr, color: colorFF2B2B, size: 12.sp,fontWeight: FontWeight.w700,),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      ImageWidget(image: Platform.isAndroid?"icon_money4":"icon_money2",width: 42.w,height: 38.h,),
    ],
  );
}