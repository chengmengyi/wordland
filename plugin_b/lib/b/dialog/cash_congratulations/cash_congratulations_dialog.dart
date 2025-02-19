import 'package:flutter/material.dart';
import 'package:plugin_b/b/dialog/cash_congratulations/cash_congratulations_con.dart';
import 'package:plugin_base/export.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/root_dialog.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/widget/text_widget.dart';

class CashCongratulationsDialog extends RootDialog<CashCongratulationsCon>{
  Function() dismiss;
  CashCongratulationsDialog({required this.dismiss});

  @override
  CashCongratulationsCon setController() => CashCongratulationsCon();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    margin: EdgeInsets.only(left: 26.w,right: 26.w),
    padding: EdgeInsets.only(left: 12.w,right: 12.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14.w),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colorFFFEFA,colorE8DEC8],
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16.h,),
        TextWidget(text: Local.congratulation.tr, color: color000000, size: 16.sp,fontWeight: FontWeight.bold,),
        SizedBox(height: 6.h,),
        TextWidget(text: Local.weHaveCompletedThePayment.tr, color: color666666, size: 14.sp),
        SizedBox(height: 26.h,),
        InkWell(
          onTap: (){
            RoutersUtils.back();
            dismiss.call();
          },
          child: Container(
            width: double.infinity,
            height: 45.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                gradient: const LinearGradient(colors: [colorF7A300,colorEF6400])
            ),
            child: TextWidget(text: Local.instantlyCredited.tr, color: colorFFFFFF, size: 14.sp),
          ),
        ),
        SizedBox(height: 20.h,),
      ],
    ),
  );
}