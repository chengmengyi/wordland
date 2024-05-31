import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class CommentSuccessDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: Center(
      child: Container(
        width: double.infinity,
        height: 240.h,
        margin: EdgeInsets.only(left: 36.w,right: 36.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.w),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorFFFEFA,colorE8DEC8]
            )
        ),
        child: Column(
          children: [
            _closeWidget(),
            ImageWidget(image: "comment1",width: 80.w,height: 80.w,),
            SizedBox(height: 6.h,),
            TextWidget(text: "Thanks For Your Feedback", color: color421000, size: 18.sp,fontWeight: FontWeight.w700,),
            SizedBox(height: 6.h,),
            BtnWidget(text: "ok", click: (){RoutersUtils.back();})
          ],
        ),
      ),
    ),
  );


  _closeWidget()=>Align(
    alignment: Alignment.topRight,
    child: InkWell(
      onTap: (){
        RoutersUtils.back();
      },
      child: Padding(
        padding: EdgeInsets.all(7.w),
        child: ImageWidget(image: "icon_close",width: 24.w,height: 24.h,),
      ),
    ),
  );
}