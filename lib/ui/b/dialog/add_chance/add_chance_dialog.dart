import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/add_chance/add_chance_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class AddChanceDialog extends RootDialog<AddChanceCon>{
  @override
  AddChanceCon setController() => AddChanceCon();

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
      Container(
        margin: EdgeInsets.only(left: 37.w,right: 37.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ImageWidget(image: "dialog_bg1",width: double.infinity,height: 236.h,fit: BoxFit.fill,),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageWidget(image: "add_chance",width: 72.w,height: 72.h,),
                SizedBox(height: 12.h,),
                Container(
                  margin: EdgeInsets.only(left: 24.w,right: 24.w),
                  child: TextWidget(
                    text: "No chance left to play，Watch ads and get free opportunities",
                    color: color421000,
                    size: 14.sp,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16.h,),
                InkWell(
                  child: ImageWidget(image: "icon_watch",width: 180.w,height: 36.h,),
                )
              ],
            ),
          ],
        ),
      ),
    ],
  );
}