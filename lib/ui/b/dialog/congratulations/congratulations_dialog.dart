import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/congratulations/congratulations_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class CongratulationsDialog extends RootDialog<CongratulationsCon>{
  double addNum;
  Function() call;
  CongratulationsDialog({required this.addNum,required this.call});

  @override
  CongratulationsCon setController() => CongratulationsCon();

  @override
  Widget contentWidget(){
    rootController.call=call;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(left: 36.w,right: 36.w),
      decoration: BoxDecoration(
        color: color000000.withOpacity(0.8),
        borderRadius: BorderRadius.circular(28.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageWidget(image: "c1",height: 40.h,),
          SizedBox(height: 16.h,),
          Stack(
            alignment: Alignment.center,
            children: [
              ImageWidget(image: "c2",width: 200.w,height: 200.w,),
              ImageWidget(image: getMoneyIcon(),width: 172.w,height: 172.w,),
            ],
          ),
          SizedBox(height: 16.h,),
          TextWidget(text: "+${getMoneyUnit()}$addNum", color: colorFF490F, size: 28.sp,fontWeight: FontWeight.w700,)
        ],
      ),
    );
  }
}