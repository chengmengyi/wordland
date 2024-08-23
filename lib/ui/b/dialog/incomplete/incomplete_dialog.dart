import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordland/bean/withdraw_task_bean.dart';
import 'package:wordland/language/local.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/incomplete/incomplete_con.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/widget/btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class IncompleteDialog extends RootDialog<IncompleteCon>{
  int chooseNum;
  WithdrawTaskBean bean;
  Function() clickGo;

  IncompleteDialog({
    required this.chooseNum,
    required this.bean,
    required this.clickGo,
  });

  @override
  IncompleteCon setController() => IncompleteCon();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    height: 332.h,
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
        _closeWidget(),
        Container(
          margin: EdgeInsets.only(left: 16.w,right: 16.w),
          child: TextWidget(text: Local.oneLast.tr, color: color421000, size: 16.sp,fontWeight: FontWeight.w700,),
        ),
        TextWidget(text: bean.text, color: colorDE832F, size: 12.sp,fontWeight: FontWeight.w600,),
        ImageWidget(image: getMoneyIcon(),width: 120.w,height: 120.h,),
        TextWidget(text: "${NewValueUtils.instance.getCoinToMoney(chooseNum)}", color: colorDE832F, size: 28.sp,fontWeight: FontWeight.w700,),
        SizedBox(height: 20.h,),
        BtnWidget(text: Local.go.tr, click: (){
          RoutersUtils.back();
          clickGo.call();
        })
      ],
    ),
  );

  _closeWidget()=>Align(
    alignment: Alignment.topRight,
    child: InkWell(
      onTap: (){
        TbaUtils.instance.appEvent(AppEventName.withdraw_task_pop_go_close);
        RoutersUtils.back();
      },
      child: Padding(
        padding: EdgeInsets.all(7.w),
        child: ImageWidget(image: "icon_close",width: 24.w,height: 24.h,),
      ),
    ),
  );
}