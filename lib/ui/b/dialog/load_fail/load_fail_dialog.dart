import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/load_fail/load_fail_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/image_btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class LoadFailDialog extends RootDialog<LoadFailCon>{
  Function(bool) result;
  LoadFailDialog({required this.result});

  @override
  LoadFailCon setController() => LoadFailCon();

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
              result.call(false);
            },
            child: ImageWidget(image: "icon_close2",width: 32.w,height: 32.h,),
          ),
        ),
      ),
      ImageWidget(image: "icon_money1",width: 120.w,height: 120.h,),
      SizedBox(height: 12.h,),
      TextWidget(text: "Ads are loading, please try again later", color: colorFFFFFF, size: 16.sp),
      SizedBox(height: 36.h,),
      ImageBtnWidget(
        text: "Try Again",
        click: (){
          RoutersUtils.back();
          result.call(true);
        },
      )
    ],
  );
}