import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/widget/image_widget.dart';

class AnswerRightDialog extends StatelessWidget{
  Function() clickContinue;
  AnswerRightDialog({required this.clickContinue});

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: Center(
      child: SizedBox(
        width: double.infinity,
        height: 328.h,
        child: Stack(
          children: [
            ImageWidget(image: "answer_right5",width: double.infinity,height: 328.h,fit: BoxFit.fill,),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 50.h,left: 36.w,right: 36.w),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 23.h),
                      child: ImageWidget(image: "answer_right1",width: double.infinity,height: 184.h,fit: BoxFit.fill,),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageWidget(image: "answer_right2",width: 260.w,height: 46.h,),
                        SizedBox(height: 12.h,),
                        ImageWidget(image: "answer_right3",width: 60.w,height: 60.h,),
                        SizedBox(height: 20.h,),
                        InkWell(
                          onTap: (){
                            RoutersUtils.back();
                            clickContinue.call();
                          },
                          child: ImageWidget(image: "answer_right4",width: 150.w,height: 36.h,),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}