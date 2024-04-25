import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordland/enums/level_status.dart';
import 'package:wordland/root/root_page.dart';
import 'package:wordland/routers/routers_data.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/a/page/home/home_con.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/widget/coin_widget/coin_widget.dart';
import 'package:wordland/widget/head_widget/head_widget.dart';
import 'package:wordland/widget/image_widget.dart';

class HomePage extends RootPage<HomeCon>{
  @override
  String bgName() => "home7";

  @override
  HomeCon setController() => HomeCon();

  @override
  Widget contentWidget() => Column(
    children: [
      _topWidget(),
      SizedBox(height: 30.h,),
      _achWidget(),
      SizedBox(height: 30.h,),
      _listWidget(),
      const Spacer(),
      _bottomWidget(),
      SizedBox(height: 10.h,),
    ],
  );

  _listWidget()=>SizedBox(
    height: 356.h,
    child: GetBuilder<HomeCon>(
      id: "list",
      builder: (_)=>ListView.builder(
        itemCount: QuestionUtils.instance.getQuestionListLength(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index)=>_listItemWidget(index),
      ),
    ),
  );

  _listItemWidget(int largeIndex)=>SizedBox(
    width: 545.w,
    height: 356.h,
    child: Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15.w,top: 26.h),
          child: ImageWidget(image: "home3",width: 530.w,height: 310.h,fit: BoxFit.fill,),
        ),
        _stepWidget(largeIndex,0),
        Container(
          margin: EdgeInsets.only(top: 120.h),
          child: _stepWidget(largeIndex,1),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: EdgeInsets.only(left: 72.w,bottom: 92.h),
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
            margin: EdgeInsets.only(right: 206.w,top: 150.h),
            child: _stepWidget(largeIndex,6),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(right: 208.w),
            child: _stepWidget(largeIndex,7),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(right: 100.w,bottom: 32.h),
            child: _stepWidget(largeIndex,8),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(right: 48.w,top: 110.h),
            child: _stepWidget(largeIndex,9),
          ),
        ),
      ],
    ),
  );

  _stepWidget(int largeIndex,int smallIndex){
    var levelStatus = QuestionUtils.instance.getLevelStatus(largeIndex, smallIndex);
    return Offstage(
      offstage: !rootController.getShowOrHideLevel(largeIndex, smallIndex),
      child: InkWell(
        onTap: (){
          rootController.toAnswer(largeIndex,smallIndex,levelStatus);
        },
        child: ImageWidget(
          image: levelStatus==LevelStatus.current?"home9":levelStatus==LevelStatus.unlock?"home10":"home6",
          width: 66.w,
          height: levelStatus==LevelStatus.current?100.h:66.h,
        ),
      ),
    );
  }

  _bottomWidget()=>Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ImageWidget(image: "home4",width: 170.w,height: 66.h,),
      InkWell(
        onTap: (){
          RoutersUtils.toNamed(routerName: RoutersData.set);
        },
        child: ImageWidget(image: "home5",width: 69.w,height: 66.h,),
      ),
    ],
  );

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
              RoutersUtils.toNamed(routerName: RoutersData.achieve);
            },
            child: ImageWidget(image: "home12",width: 80.w,height: 60.h,),
          ),
        ),
      ],
    ),
  );

  _topWidget()=>Row(
    children: [
      HeadWidget(),
      CoinWidget(),
    ],
  );
}