import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wordland/enums/top_cash.dart';
import 'package:wordland/root/root_child.dart';
import 'package:wordland/routers/routers_data.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/page/task_child/b_task_child_con.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/task_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/money_animator/money_animator_widget.dart';
import 'package:wordland/widget/stroked_text_widget.dart';
import 'package:wordland/widget/text_widget.dart';
import 'package:wordland/widget/top_money/top_money_widget.dart';

class BTaskChildPage extends RootChild<BTaskChildCon>{
  @override
  BTaskChildCon setController() => BTaskChildCon();

  @override
  Widget contentWidget() => SafeArea(
    top: true,
    bottom: true,
    child: Stack(
      children: [
        Column(
          children: [
            _topWidget(),
            _achWidget(),
            SizedBox(height: 16.h,),
            _listWidget(),
          ],
        ),
        MoneyAnimatorWidget(),
        // _fingerGuideWidget(),
      ],
    ),
  );

  _topWidget()=>Row(
    children: [
      SizedBox(width: 12.w,),
      TopMoneyWidget(topCash: TopCash.task,),
    ],
  );


  _listWidget()=>SizedBox(
    height: 416.h,
    child: GetBuilder<BTaskChildCon>(
      id: "list",
      builder: (_)=>ListView.builder(
        itemCount: rootController.getTaskLength(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index)=>_listItemWidget(index),
      ),
    ),
  );

  _listItemWidget(int largeIndex)=>SizedBox(
    width: 545.w,
    height: 416.h,
    child: Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(left: 15.w),
            child: ImageWidget(image: "home3",width: 530.w,height: 310.h,fit: BoxFit.fill,),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16.h),
          child: _stepWidget(largeIndex,0),
        ),
        Container(
          margin: EdgeInsets.only(top: 142.h),
          child: _stepWidget(largeIndex,1),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: EdgeInsets.only(left: 72.w,bottom: 112.h),
            child: _stepWidget(largeIndex,2),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: EdgeInsets.only(left: 183.w,bottom: 124.h),
            child: _stepWidget(largeIndex,3),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 45.h,left: 175.w),
          child: _stepWidget(largeIndex,4),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(right: 180.w,top: 40.h),
            child: _stepWidget(largeIndex,5),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(right: 170.w,top: 160.h),
            child: _stepWidget(largeIndex,6),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(right: 180.w,bottom: 20.h),
            child: _stepWidget(largeIndex,7),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(right: 100.w,bottom: 90.h),
            child: _stepWidget(largeIndex,8),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(top: 110.h,right: 50.w),
            child: _stepWidget(largeIndex,9),
          ),
        ),
      ],
    ),
  );

  _stepWidget(int largeIndex,int smallIndex){
    var show = rootController.getShowOrHideTask(largeIndex, smallIndex);
    var completeTask = rootController.getCompleteTask(largeIndex, smallIndex);
    // var currentTask = rootController.isCurrentTask(largeIndex, smallIndex);
    var canReceiveTaskBubble = TaskUtils.instance.canReceiveTaskBubble(largeIndex, smallIndex)&&(largeIndex*10+smallIndex+1)%5==0;
    var showLockReward = (largeIndex*10+smallIndex+1)%5==0&&!completeTask;

    // var completeTask = true;
    // var showBubble = true;
    // if(showBubble&&completeTask&&rootController.firstLargeIndex==-1&&rootController.firstSmallIndex==-1){
    //   rootController.firstLargeIndex=largeIndex;
    //   rootController.firstSmallIndex=smallIndex;
    // }
    var addNum=0.0,showReceiveBubble=canReceiveTaskBubble&&completeTask;
    if(showReceiveBubble||showLockReward){
      addNum=rootController.getAddNum(largeIndex, smallIndex);
    }
    return Offstage(
      offstage: !show,
      child: InkWell(
        onTap: (){
          rootController.clickItem(completeTask,largeIndex,smallIndex,addNum,canReceiveTaskBubble);
        },
        child: SizedBox(
          width: 100.h,
          height:  showLockReward?100.h:66.h,
          key: rootController.getGlobalKey(largeIndex, smallIndex),
          child: Stack(
            children: [
              Stack(
                children: [
                  ImageWidget(
                    image: showLockReward?"home16":completeTask?"home10":"home6",
                    width: 80.h,
                    height: showLockReward?100.h:80.h,
                  ),
                  Positioned(
                    top: 42.h,
                    left: 0,
                    right: 0,
                    child: Offstage(
                      offstage: !showLockReward,
                      child: StrokedTextWidget(
                        text: "+${getOtherCountryMoneyNum(addNum)}",
                        fontSize: 14.sp,
                        textColor: color2EFF2E,
                        strokeColor: color434343,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 6.w,
                child: Offstage(
                  offstage: !(canReceiveTaskBubble&&completeTask),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ImageWidget(image: Platform.isIOS?"icon_money1":"icon_money4",width: 20.h,height: 20.h,),
                      StrokedTextWidget(
                        text: "+${getOtherCountryMoneyNum(addNum)}",
                        fontSize: 12.sp,
                        textColor: colorFFDD28,
                        strokeColor: color434343,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Offstage(
                  offstage: !showReceiveBubble,
                  child: Container(
                    width: 66.h,
                    height: 24.h,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 6.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.w),
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [colorFFA800,colorDA2D2D]
                        )
                    ),
                    child: TextWidget(text: "Claim", color: Colors.white, size: 14.sp,fontWeight: FontWeight.w700,),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 30.w,
                child: Offstage(
                  offstage: completeTask||showLockReward,
                  child: StrokedTextWidget(
                    text: "${largeIndex*10+smallIndex+1}",
                    fontSize: 16.sp,
                    textColor: colorFFDD28,
                    strokeColor: color434343,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Offstage(
                  offstage: !showReceiveBubble,
                  child: Lottie.asset("assets/guide2.json",width: 56.w,height: 56.w),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _achWidget()=>SizedBox(
    width: double.infinity,
    height: 134.h,
    child: Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: ImageWidget(image: "home2",width: 115.w,height: 134.h,),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: InkWell(
            onTap: (){
              TbaUtils.instance.appEvent(AppEventName.task_page_achievement);
              RoutersUtils.toNamed(routerName: RoutersData.bAch);
            },
            child: Lottie.asset(
                "assets/receive_ach.json",
                width: 80.w,
                height: 60.h
            ),
          ),
        ),
      ],
    ),
  );

  // _fingerGuideWidget()=>GetBuilder<BTaskChildCon>(
  //   id: "finger",
  //   builder: (_)=>Offstage(
  //     offstage: null==rootController.firstFingerOffset,
  //     child: Container(
  //       color: Colors.red,
  //       margin: EdgeInsets.only(top: rootController.firstFingerOffset?.dy??0,left: (rootController.firstFingerOffset?.dx??0)+30.w),
  //       child: InkWell(
  //         onTap: (){
  //           rootController.clickFinger();
  //         },
  //         child: Lottie.asset("assets/guide2.json",width: 56.w,height: 56.w),
  //       ),
  //     ),
  //   ),
  // );
}