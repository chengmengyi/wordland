import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/level/level_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/image_btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class LevelDialog extends RootDialog<LevelCon>{
  @override
  LevelCon setController() => LevelCon();

  @override
  Widget contentWidget()=> Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      TextWidget(
        text: "Congratulations on completing",
        color: colorFFE609,
        size: 20.sp
      ),
      SizedBox(height: 8.h,),
      TextWidget(text: "level 1", color: colorFFFFFF, size: 20.sp,fontWeight: FontWeight.w700,),
      SizedBox(height: 16.h,),
      ImageWidget(image: "icon_money1",width: 172.w,height: 172.h,),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextWidget(text: "+600000≈", color: colorFFFFFF, size: 16.sp,fontWeight: FontWeight.w700,),
          TextWidget(text: "\$60.00", color: colorFF490F, size: 24.sp,fontWeight: FontWeight.w700,),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _levelItemWidget(),
          SizedBox(width: 5.w,),
          _levelItemWidget(),
          SizedBox(width: 5.w,),
          _levelItemWidget(),
          SizedBox(width: 5.w,),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ImageWidget(image: "sign7",width: 52.w,),
              TextWidget(text: "level 2", color: colorF26910, size: 12.sp)
            ],
          )
        ],
      ),
      SizedBox(height: 26.h,),
      ImageBtnWidget(
        text: "Claim Double",
        bg: "icon_btn2",
      ),
      SizedBox(height: 12.h,),
      ImageBtnWidget(
        text: "Level 2",
      ),
      InkWell(
        onTap: (){
          RoutersUtils.back();
        },
        child: ImageWidget(image: "icon_close2",width: 32.w,height: 32.h,),
      ),
    ],
  );
  
  _levelItemWidget()=>ImageWidget(image: "sign5",width: 48.w,height: 8.h,);
}