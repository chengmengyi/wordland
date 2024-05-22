import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/loading/loading_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class LoadingDialog extends RootDialog<LoadingCon>{
  AdType adType;
  Function(bool) result;
  LoadingDialog({
    required this.adType,
    required this.result,
  });

  @override
  LoadingCon setController() => LoadingCon();
  
  @override
  Widget contentWidget(){
    rootController.setInfo(adType, result);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20.h),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ImageWidget(image: "load2",width: 286.w,height: 260.h,fit: BoxFit.fill,),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget(text: "Get Coins After Watching video！", color: color421000, size: 14.sp,fontWeight: FontWeight.w700,),
                  SizedBox(height: 16.h,),
                  ImageWidget(image: "icon_money2",width: 100.w,height: 100.h,),
                  SizedBox(height: 16.h,),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      ImageWidget(image: "icon_pro",width: 238.w,height: 8.h,fit: BoxFit.fill,),
                      GetBuilder<LoadingCon>(
                        id: "pro",
                        builder: (_)=>ImageWidget(
                          image: "icon_pro_bg",
                          width: 238.w-(238.w)*rootController.getProgress(),
                          height: 8.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h,),
                  TextWidget(text: "Watch AD for 30s", color: color8F7E53, size: 12.sp),
                  SizedBox(height: 24.h,),
                ],
              )
            ],
          ),
        ),
        ImageWidget(image: "load1",width: 260.w,height: 48.h,fit: BoxFit.fill,),
      ],
    );
  }
}
