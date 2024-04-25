import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/widget/image_widget.dart';

class RemoveNumDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(left: 36.w,right: 36.w,top: 40.h),
            child: ImageWidget(image: "remove2",width: double.infinity,height: 184.h,fit: BoxFit.fill,),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageWidget(image: "remove1",width: 74.w,height: 80.h,),
              SizedBox(height: 78.h,),
              InkWell(
                onTap: (){
                  RoutersUtils.back();
                },
                child: ImageWidget(image: "answer_right4",width: 150.w,height: 36.h,),
              ),
            ],
          )
        ],
      ),
    ),
  );
}