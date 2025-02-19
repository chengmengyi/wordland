import 'package:flutter/material.dart';
import 'package:plugin_b/b/dialog/cash_task/cash_task_con.dart';
import 'package:plugin_b/utils/cash_task/cash_task_utils.dart';
import 'package:plugin_b/utils/cash_task/cask_task_bean.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/export.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/root_dialog.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:plugin_base/widget/text_widget.dart';

class CashTaskDialog extends RootDialog<CashTaskCon>{
  CaskTaskBean caskTaskBean;
  CashTaskDialog({
    required this.caskTaskBean,
});

  @override
  CashTaskCon setController() => CashTaskCon();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    margin: EdgeInsets.only(left: 26.w,right: 26.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14.w),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colorFFFEFA,colorE8DEC8],
      ),
    ),
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(left: 12.w,right: 12.w,top: 16.h,bottom: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(text: Local.withdrawalUnlock.tr, color: color000000, size: 16.sp,fontWeight: FontWeight.bold,),
              SizedBox(height: 6.h,),
              TextWidget(text: Local.abnormalActivityDetected.tr, color: color666666, size: 14.sp,textAlign: TextAlign.center,),
              SizedBox(height: 6.h,),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorFFFFFF,
                  borderRadius: BorderRadius.circular(18.w),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: caskTaskBean.taskName!=CashTaskName.sign,
                      child: _taskItemWidget(),
                    ),
                    _signItemWidget(),
                  ],
                ),
              ),
              SizedBox(height: 26.h,),
              InkWell(
                onTap: (){
                  RoutersUtils.back();
                  EventCode.showWordChild.sendMsg();
                },
                child: Container(
                  width: double.infinity,
                  height: 45.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.w),
                      gradient: const LinearGradient(colors: [colorF7A300,colorEF6400])
                  ),
                  child: TextWidget(text: Local.complete.tr, color: colorFFFFFF, size: 14.sp),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 5.w,
          right: 5.w,
          child: InkWell(
            onTap: (){
              RoutersUtils.back();
            },
            child: ImageWidget(image: "icon_close",width: 24.w,height: 24.w,),
          ),
        )
      ],
    ),
  );

  _taskItemWidget()=>Container(
    width: double.infinity,
    height: 60.h,
    alignment: Alignment.centerLeft,
    child: Row(
      children: [
        SizedBox(width: 12.w,),
        ImageWidget(image: rootController.getTaskIcon(caskTaskBean),width: 35.w,height: 35.h,),
        SizedBox(width: 12.w,),
        Expanded(child: TextWidget(text: rootController.getTaskContent(caskTaskBean), color: color000000, size: 14.sp,fontWeight: FontWeight.bold,)),
        TextWidget(text: "${caskTaskBean.taskPro??0}/${CashTaskUtils.instance.getMaxTaskBean(caskTaskBean.taskName)?.maxTask??10}", color: colorF5610C, size: 14.sp,fontWeight: FontWeight.bold,),
        SizedBox(width: 12.w,),
      ],
    ),
  );

  _signItemWidget()=>Container(
    width: double.infinity,
    height: 60.h,
    alignment: Alignment.centerLeft,
    child: Row(
      children: [
        SizedBox(width: 12.w,),
        ImageWidget(image: "task_sign",width: 35.w,height: 35.h,),
        SizedBox(width: 12.w,),
        Expanded(child: TextWidget(text: caskTaskBean.taskName==CashTaskName.sign?Local.timeRewards10.tr:Local.timeRewards2.tr, color: color000000, size: 14.sp,fontWeight: FontWeight.bold,)),
        TextWidget(text: "${caskTaskBean.signPro??0}/${CashTaskUtils.instance.getMaxTaskBean(caskTaskBean.taskName)?.maxSign??2}", color: colorF5610C, size: 14.sp,fontWeight: FontWeight.bold,),
        SizedBox(width: 12.w,),
      ],
    ),
  );
}