import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/add_hint/add_hint_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class AddHintDialog extends RootDialog<AddHintCon>{
  // Function() addNumCall;
  // AddHintDialog({required this.addNumCall});

  @override
  AddHintCon setController() => AddHintCon();

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
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 37.w,right: 37.w),
            child: ImageWidget(image: "dialog_bg1",width: double.infinity,height: 236.h,fit: BoxFit.fill,),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(text: "Do you need to use hint?", color: color421000, size: 18.sp,fontWeight: FontWeight.w700,),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ImageWidget(image: "add_hint1",width: 68.w,height: 72.h,),
                  ImageWidget(image: "add_hint2",width: 28.w,),
                ],
              ),
              SizedBox(height: 28.h,),
              InkWell(
                onTap: (){
                  rootController.clickGet();
                },
                child: ImageWidget(image: "icon_watch",width: 180.w,height: 36.h,),
              )
            ],
          ),
        ],
      ),
    ],
  );
}