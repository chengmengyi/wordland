import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/level/level_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';
import 'package:wordland/widget/image_btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class LevelDialog extends RootDialog<LevelCon>{
  bool upLevel;
  Function() closeCall;

  LevelDialog({
    required this.upLevel,
    required this.closeCall,
  });

  @override
  LevelCon setController() => LevelCon();

  @override
  Widget contentWidget()=> Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      TextWidget(
        text: "Congratulations on completing",
        color: colorFFE609,
        size: 20.sp
      ),
      SizedBox(height: 8.h,),
      TextWidget(
        text: "level ${rootController.getLevel()}",
        color: colorFFFFFF,
        size: 20.sp,
        fontWeight: FontWeight.w700,
      ),
      SizedBox(height: 16.h,),
      ImageWidget(image: "icon_money1",width: 172.w,height: 172.h,),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextWidget(text: "+${rootController.addNum}≈", color: colorFFFFFF, size: 16.sp,fontWeight: FontWeight.w700,),
          TextWidget(text: "\$${ValueConfUtils.instance.getCoinToMoney(rootController.addNum)}", color: colorFF490F, size: 24.sp,fontWeight: FontWeight.w700,),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _levelItemWidget(0),
          SizedBox(width: 5.w,),
          _levelItemWidget(1),
          SizedBox(width: 5.w,),
          _levelItemWidget(2),
          SizedBox(width: 5.w,),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ImageWidget(image: "sign7",width: 52.w,),
              TextWidget(text: "level ${rootController.getLevel()}", color: colorF26910, size: 12.sp)
            ],
          )
        ],
      ),
      SizedBox(height: 26.h,),
      ImageBtnWidget(
        text: "Claim Double",
        bg: "icon_btn2",
        click: (){
          rootController.clickDouble(closeCall);
        },
      ),
      SizedBox(height: 12.h,),
      Offstage(
        offstage: !upLevel,
        child: ImageBtnWidget(
          text: "Level ${rootController.getLevel()}",
          click: (){
            rootController.clickClose(closeCall);
          },
        ),
      ),
      Offstage(
        offstage: upLevel,
        child: InkWell(
          onTap: (){
            rootController.clickClose(closeCall);
          },
          child: ImageWidget(image: "icon_close2",width: 32.w,height: 32.h,),
        ),
      ),
    ],
  );
  
  _levelItemWidget(index)=>ImageWidget(
    image: rootController.getLevelItemIcon(index, upLevel),
    width: 48.w,
    height: 8.h,
  );
}