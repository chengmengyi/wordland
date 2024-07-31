import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordland/enums/top_cash.dart';
import 'package:wordland/root/root_page.dart';
import 'package:wordland/root/root_page_statefull.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/page/wheel/wheel_con.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/widget/image_btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/money_animator/money_animator_widget.dart';
import 'package:wordland/widget/text_widget.dart';
import 'package:wordland/widget/top_money/top_money_widget.dart';
import 'package:wordland/widget/wheel_widget.dart';

class WheelPage extends RootPage<WheelCon>{

  @override
  String bgName() => "bg";

  @override
  WheelCon setController() => WheelCon();

  @override
  Widget contentWidget() => WillPopScope(
    child: Stack(
      children: [
        Column(
          children: [
            _topWidget(),
            SizedBox(height: 30.h,),
            ImageWidget(image: "wheel1",height: 52.h,),
            Container(
              margin: EdgeInsets.only(left: 40.w,right: 40.w),
              child: TextWidget(text: "20000 users have successfully withdrawn money", color: colorFFFFFF, size: 12.sp,fontWeight: FontWeight.w700,textAlign: TextAlign.center,),
            ),
            _wheelWidget(),
            SizedBox(height: 14.h,),
            _btnWidget(),
          ],
        ),
        MoneyAnimatorWidget(),
      ],
    ),
    onWillPop: ()async{
      return true;
    },
  );

  _topWidget()=>Row(
    children: [
      SizedBox(width: 12.w,),
      InkWell(
        onTap: (){
         rootController.clickClose(true);
        },
        child: ImageWidget(image: "back",width: 36.w,height: 36.h,),
      ),
      SizedBox(width: 12.w,),
      TopMoneyWidget(
        topCash: TopCash.wheel,
        clickCall: (){
          rootController.clickClose(false);
        },
      ),
    ],
  );
  
  _wheelWidget()=>Stack(
    alignment: Alignment.center,
    children: [
      ImageWidget(image: "wheel2",width: 328.w,height: 360.h,),
      WheelWidget(),
      InkWell(
        onTap: (){
          TbaUtils.instance.appEvent(AppEventName.wheel_pop_go);
          rootController.clickPlay();
        },
        child: ImageWidget(image: "wheel4",width: 148.w,height: 148.h,),
      ),
    ],
  );

  _btnWidget()=>GetBuilder<WheelCon>(
    id: "bottom",
    builder: (_)=>Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageBtnWidget(
          text: NumUtils.instance.wheelNum>0?"Free To Play":"Get More Chance",
          click: (){
            TbaUtils.instance.appEvent(AppEventName.wheel_pop_go);
            rootController.clickPlay();
          },
        ),
        TextWidget(text: "today remaining times : ${NumUtils.instance.wheelNum}", color: colorFFFFFF, size: 10.sp)
      ],
    ),
  );
}