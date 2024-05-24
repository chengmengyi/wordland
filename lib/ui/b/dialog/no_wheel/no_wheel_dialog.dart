import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/no_wheel/no_wheel_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/image_btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class NoWheelDialog extends RootDialog<NoWheelCon>{
  Function() addNumCall;
  NoWheelDialog({
    required this.addNumCall
  });

  @override
  NoWheelCon setController() => NoWheelCon();

  @override
  Widget contentWidget() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: EdgeInsets.only(right: 38.w),
          child: InkWell(
            onTap: (){
              RoutersUtils.back();
            },
            child: ImageWidget(image: "icon_close2",width: 32.w,height: 32.h,),
          ),
        ),
      ),
      ImageWidget(image: "wheel5",width: 80.w,height: 80.w,),
      Container(
        margin: EdgeInsets.only(left: 60.w,right: 60.w,top: 24.h),
        child: TextWidget(text: "Watch video to get three chances to enter the drawing", color: colorFFFFFF, size: 14.sp,textAlign: TextAlign.center,),
      ),
      SizedBox(height: 24.h,),
      ImageBtnWidget(
        text: "Get",
        showVideo: true,
        click: (){
          rootController.clickGet(addNumCall);
        },
      )
    ],
  );
}