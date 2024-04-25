import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/widget/image_widget.dart';

class TimeOutDialog extends StatelessWidget{
  Function() clickCall;
  TimeOutDialog({required this.clickCall});

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(left: 36.w,right: 36.w,top: 20.h),
            child: ImageWidget(image: "time1",width: double.infinity,height: 184.h,fit: BoxFit.fill,),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageWidget(image: "time2",width: 260.w,height: 46.h,),
              ImageWidget(image: "time3",width: 100.w,height: 90.h,),
              SizedBox(height: 10.h,),
              InkWell(
                onTap: (){
                  RoutersUtils.back();
                  clickCall.call();
                },
                child: ImageWidget(image: "time4",width: 150.w,height: 36.h,),
              ),
            ],
          )
        ],
      ),
    ),
  );
}