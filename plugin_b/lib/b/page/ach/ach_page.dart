import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plugin_b/b/page/ach/ach_con.dart';
import 'package:plugin_b/widget/top_money/top_money_widget.dart';
import 'package:plugin_base/bean/ach_bean.dart';
import 'package:plugin_base/bean/task_bean.dart';
import 'package:plugin_base/enums/top_cash.dart';
import 'package:plugin_base/root/root_page.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:plugin_base/widget/text_widget.dart';

class AchPage extends RootPage<AchCon>{
  @override
  String bgName() => "answer1";

  @override
  AchCon setController() => AchCon();

  @override
  Widget contentWidget() => WillPopScope(
    child: Column(
      children: [
        _topWidget(),
        Expanded(
          child: GetBuilder<AchCon>(
            id: "list",
            builder: (_)=>ListView.builder(
              itemCount: rootController.taskList.length,
              itemBuilder: (context,index)=>_itemWidget(rootController.taskList[index]),
            ),
          ),
        )
      ],
    ),
    onWillPop: ()async{
      rootController.clickBack();
      return false;
    },
  );

  _itemWidget(AchBean bean)=>Container(
    width: double.infinity,
    height: 80.h,
    margin: EdgeInsets.only(left: 8.w,right: 8.w,top: 10.h),
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        ImageWidget(image: "achieve1",width: double.infinity,height: 80.h,fit: BoxFit.fill,),
        Row(
          children: [
            SizedBox(width: 18.w,),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ImageWidget(image: "achieve7",width: 51.w,height: 55.h,),
                TextWidget(text: "+${getOtherCountryMoneyNum(bean.addNum.toDouble())}", color: colorFFFFFF, size: 10.sp,fontWeight: FontWeight.w700,),
              ],
            ),
            SizedBox(width: 12.w,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(text: bean.text, color: color421000, size: 14.sp,fontWeight: FontWeight.w700,),
                  SizedBox(height: 6.h,),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.w),
                        child:  SizedBox(
                          width: 90.w,
                          child: LinearProgressIndicator(
                            value: rootController.getProgress(bean),
                            minHeight: 6.h,
                            color: colorCD7012,
                          ),
                        ),
                      ),
                      TextWidget(text: "(${bean.current}/${bean.total})", color: colorFF2B2B, size: 12.sp,fontWeight: FontWeight.w700,)
                    ],
                  )
                ],
              ),
            ),
            InkWell(
              onTap: (){
                rootController.clickBtn(bean);
              },
              child: ImageWidget(
                image: bean.current>=bean.total?"achieve3":"achieve4",
                width: 95.w,
                height: 36.h,
              ),
            ),
            SizedBox(width: 18.w,),
          ],
        )
      ],
    ),
  );

  _topWidget()=>Row(
    children: [
      SizedBox(width: 12.w,),
      InkWell(
        onTap: (){
          rootController.clickBack();
        },
        child: ImageWidget(image: "back",width: 36.w,height: 36.h,),
      ),
      SizedBox(width: 12.w,),
      TopMoneyWidget(
        
        topCash: TopCash.ach,
        clickCall: (){
          RoutersUtils.back();
        },
      ),
    ],
  );
}