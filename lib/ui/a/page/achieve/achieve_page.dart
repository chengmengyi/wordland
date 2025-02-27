import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordland/bean/task_bean.dart';
import 'package:wordland/root/root_page.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/a/page/achieve/achieve_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/coin_widget/coin_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class AchievePage extends RootPage<AchieveCon>{
  @override
  String bgName() => "answer1";

  @override
  AchieveCon setController() => AchieveCon();

  @override
  Widget contentWidget() => Column(
    children: [
      _topWidget(),
      Expanded(
        child: GetBuilder<AchieveCon>(
          id: "list",
          builder: (_)=>ListView.builder(
            itemCount: rootController.taskList.length,
            itemBuilder: (context,index)=>_itemWidget(rootController.taskList[index]),
          ),
        ),
      )
    ],
  );

  _itemWidget(TaskBean bean)=>Container(
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
                ImageWidget(image: "achieve2",width: 51.w,height: 55.h,),
                TextWidget(text: "+${bean.addNum}", color: colorFFFFFF, size: 14.sp,fontWeight: FontWeight.w700,),
              ],
            ),
            SizedBox(width: 12.w,),
            Expanded(
              child: TextWidget(text: bean.text, color: color421000, size: 14.sp,fontWeight: FontWeight.w700,),
            ),
            InkWell(
              onTap: (){
                rootController.clickBtn(bean);
              },
              child: ImageWidget(
                image: bean.canReceive?"achieve3":"achieve4",
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
          RoutersUtils.back();
        },
        child: ImageWidget(image: "back",width: 36.w,height: 36.h,),
      ),
      SizedBox(width: 12.w,),
      CoinWidget(),
    ],
  );
}