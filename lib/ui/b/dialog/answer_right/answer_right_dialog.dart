import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/answer_right/answer_right_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/stroked_text_widget.dart';

class AnswerRightDialog extends RootDialog<AnswerRightCon>{
  var addNum=NewValueUtils.instance.getRewardAddNum();
  Function(double) call;
  AnswerRightDialog({required this.call});

  @override
  AnswerRightCon setController() => AnswerRightCon();

  @override
  Widget contentWidget() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ImageWidget(image: "c1",height: 40.h,),
      SizedBox(height: 16.h,),
      Stack(
        alignment: Alignment.center,
        children: [
          ImageWidget(image: "c2",width: 200.w,height: 200.w,),
          ImageWidget(image: "icon_money1",width: 172.w,height: 172.w,),
        ],
      ),
      InkWell(
        onTap: (){
          RoutersUtils.back();
          call.call(NewValueUtils.instance.getDoubleNum(addNum));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ImageWidget(image: "icon_btn2",width: 180.w,height: 48.h,fit: BoxFit.fill,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageWidget(image: "icon_video",width: 16.w,height: 16.w,),
                SizedBox(width: 6.w,),
                StrokedTextWidget(
                  text: "Claim",
                  fontSize: 16.sp,
                  textColor: Colors.white,
                  strokeColor: color2D5B00,
                ),
                SizedBox(width: 6.w,),
                StrokedTextWidget(
                  text: "\$${NewValueUtils.instance.getDoubleNum(addNum)}",
                  fontSize: 24.sp,
                  textColor: Colors.white,
                  strokeColor: color2D5B00,
                ),
              ],
            )
          ],
        ),
      ),
      SizedBox(height: 24.h,),
      InkWell(
        onTap: (){
          RoutersUtils.back();
          call.call(addNum);
        },
        child: StrokedTextWidget(
          text: "\$$addNum",
          fontSize: 16.sp,
          textColor: Colors.white,
          strokeColor: color5B2600,
        ),
      ),
    ],
  );
}