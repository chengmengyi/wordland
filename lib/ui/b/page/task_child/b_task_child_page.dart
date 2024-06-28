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
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/money_animator/money_animator_widget.dart';
import 'package:wordland/widget/stroked_text_widget.dart';
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
            _listWidget(),
          ],
        ),
        MoneyAnimatorWidget(),
        _fingerGuideWidget(),
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
            margin: EdgeInsets.only(left: 15.w,top: 26.h),
            child: ImageWidget(image: "home3",width: 530.w,height: 310.h,fit: BoxFit.fill,),
          ),
        ),
        _stepWidget(largeIndex,0),
        Container(
          margin: EdgeInsets.only(top: 120.h),
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
            margin: EdgeInsets.only(right: 166.w,top: 20.h),
            child: _stepWidget(largeIndex,5),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(right: 120.w,top: 150.h),
            child: _stepWidget(largeIndex,6),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(right: 120.w),
            child: _stepWidget(largeIndex,7),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(right: 20.w,bottom: 66.h),
            child: _stepWidget(largeIndex,8),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(top: 110.h),
            child: _stepWidget(largeIndex,9),
          ),
        ),
      ],
    ),
  );

  _stepWidget(int largeIndex,int smallIndex){
    var show = rootController.getShowOrHideTask(largeIndex, smallIndex);
    var completeTask = rootController.getCompleteTask(largeIndex, smallIndex);
    var currentTask = rootController.isCurrentTask(largeIndex, smallIndex);
    var showBubble = TaskUtils.instance.showBubble(largeIndex, smallIndex);
    // if(showBubble&&completeTask&&rootController.firstLargeIndex==-1&&rootController.firstSmallIndex==-1){
    //   rootController.firstLargeIndex=largeIndex;
    //   rootController.firstSmallIndex=smallIndex;
    // }
    var addNum=0.0;
    if(showBubble&&completeTask){
      addNum=rootController.getAddNum(largeIndex, smallIndex);
    }
    return Offstage(
      offstage: !show,
      child: SizedBox(
        width: 150.h,
        height: 106.h,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: (){
                  rootController.clickItem(completeTask,currentTask,largeIndex,smallIndex);
                },
                child: ImageWidget(
                  image: currentTask?"home9":completeTask?"home10":"home6",
                  width: 66.h,
                  height: currentTask?100.h:66.h,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Visibility(
                visible: showBubble&&completeTask,
                maintainAnimation: true,
                maintainState: true,
                maintainSize: true,
                child: SizedBox(
                  key: rootController.getGlobalKey(largeIndex, smallIndex),
                  child: InkWell(
                    onTap: (){
                      rootController.clickBubble(completeTask,currentTask,showBubble,largeIndex,smallIndex,addNum);
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ImageWidget(image: "task1",width: 92.h,height: 72.h,),
                        Positioned(
                          bottom: 6.h,
                          child: StrokedTextWidget(
                            text: "+\$$addNum",
                            fontSize: 14.sp,
                            textColor: colorFFDD28,
                            strokeColor: color434343,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 22.w,
              child: Offstage(
                offstage: completeTask||currentTask,
                child: StrokedTextWidget(
                  text: "${(largeIndex*10+smallIndex+1)*3}",
                  fontSize: 16.sp,
                  textColor: colorFFDD28,
                  strokeColor: color434343,
                ),
              ),
            )
          ],
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

  _fingerGuideWidget()=>GetBuilder<BTaskChildCon>(
    id: "finger",
    builder: (_)=>Offstage(
      offstage: null==rootController.firstFingerOffset,
      child: Container(
        margin: EdgeInsets.only(top: rootController.firstFingerOffset?.dy??0,left: (rootController.firstFingerOffset?.dx??0)+30.w),
        child: InkWell(
          onTap: (){
            rootController.clickFinger();
          },
          child: Lottie.asset("assets/guide2.json",width: 56.w,height: 56.w),
        ),
      ),
    ),
  );
}