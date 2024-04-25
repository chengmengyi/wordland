import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordland/root/base_widget.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/widget/coin_widget/coin_widget_con.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class CoinWidget extends BaseWidget<CoinWidgetCon>{

  @override
  CoinWidgetCon setController() => CoinWidgetCon();

  @override
  Widget contentWidget() => Stack(
    alignment: Alignment.centerLeft,
    children: [
      ImageWidget(image: "home1",width: 124.w,height: 38.h,),
      Container(
        margin: EdgeInsets.only(left: 45.w),
        child: GetBuilder<CoinWidgetCon>(
          id: "coin",
          builder: (_)=>TextWidget(text: "${NumUtils.instance.coinNum}", color: colorFFFFFF, size: 14.sp,fontWeight: FontWeight.w600,),
        ),
      )
    ],
  );
}