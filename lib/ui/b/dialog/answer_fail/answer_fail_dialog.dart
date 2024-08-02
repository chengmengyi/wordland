import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordland/language/local.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/ui/b/dialog/answer_fail/answer_fail_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class AnswerFailDialog extends RootDialog<AnswerFailCon>{
  Function(bool) nextWordsCall;
  AnswerFailDialog({required this.nextWordsCall});

  @override
  AnswerFailCon setController() => AnswerFailCon();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    height: 332.h,
    alignment: Alignment.center,
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
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget(text: Local.guessWord.tr, color: color421000, size: 18.sp,fontWeight: FontWeight.w700,),
        SizedBox(height: 20.h,),
        ImageWidget(image: "icon_fail",width: 120.w,height: 120.h,),
        SizedBox(height: 20.h,),
        BtnWidget(
          text: Local.comeAgain.tr,
          showVideo: true,
          click: (){
            rootController.clickAgain(nextWordsCall);
          },
        ),
        SizedBox(height: 12.h,),
        InkWell(
          onTap: (){
            rootController.clickContinue(nextWordsCall);
          },
          child: TextWidget(text: Local.continueStr.tr, color: color8F7E53, size: 16.sp,fontWeight: FontWeight.w700,),
        )
      ],
    ),
  );
}