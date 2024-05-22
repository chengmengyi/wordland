import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/no_money/no_money_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class NoMoneyDialog extends RootDialog<NoMoneyCon>{
  @override
  NoMoneyCon setController() => NoMoneyCon();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    height: 212.h,
    margin: EdgeInsets.only(left: 36.w,right: 36.w),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.w),
        gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorFFFEFA,colorE8DEC8]
        )
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _closeWidget(),
        TextWidget(text: "Insufficient balance", color: color421000, size: 16.sp,fontWeight: FontWeight.w700,),
        SizedBox(height: 8.h,),
        Container(
          margin: EdgeInsets.only(left: 16.w,right: 16.w),
          child: TextWidget(text: "Your account balance is insufficient and withdrawal is temporarily unavailable.Go and earn cash！", color: colorDE832F, size: 12.sp,fontWeight: FontWeight.w600,),
        ),
        SizedBox(height: 8.h,),
        BtnWidget(text: "Earn More Cash", click: (){})
      ],
    ),
  );

  _closeWidget()=>Align(
    alignment: Alignment.topRight,
    child: InkWell(
      onTap: (){
        RoutersUtils.back();
      },
      child: Padding(
        padding: EdgeInsets.all(7.w),
        child: ImageWidget(image: "icon_close",width: 24.w,height: 24.h,),
      ),
    ),
  );
}