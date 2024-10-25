import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:plugin_a/page/word_child/b_word_child_con.dart';
import 'package:plugin_a/utils/guide/new_guide_utils.dart';
import 'package:plugin_a/widget/bubble_widget.dart';
import 'package:plugin_a/widget/money_animator/money_animator_widget.dart';
import 'package:plugin_a/widget/top_money/top_money_widget.dart';
import 'package:plugin_base/enums/top_cash.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/root_child.dart';
import 'package:plugin_base/utils/question_utils.dart';
import 'package:plugin_base/widget/text_widget.dart';
import 'package:get/get.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:plugin_base/widget/stroked_text_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class BWordChildPage extends RootChild<BWordChildCon>{
  @override
  BWordChildCon setController() => BWordChildCon();

  @override
  Widget contentWidget() => Stack(
    children: [
      SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            SizedBox(height: 6.h,),
            _topWidget(),
            SizedBox(height: 6.h,),
            _levelWidget(),
            SizedBox(height: 6.h,),
            _questionWidget(),
              SizedBox(height: 6.h,),
            _chooseListWidget(),
            SizedBox(height: 10.h,),
            _bottomWidget(),
          ],
        ),
      ),
      _guideWidget(),
      GetBuilder<BWordChildCon>(
        id: "bubble",
        builder: (_)=>NewGuideUtils.instance.showBubble?BubbleWidget():Container(),
      ),
      MoneyAnimatorWidget(),
    ],
  );

  _topWidget()=>Row(
    children: [
      SizedBox(width: 12.w,),
      TopMoneyWidget(topCash: TopCash.word,),
    ],
  );

  _questionWidget()=>SizedBox(
    width: double.infinity,
    height: 280.h,
    child: Stack(
      children: [
        ImageWidget(image: "answer2",width: double.infinity,height: double.infinity,fit: BoxFit.fill,),
        Container(
          margin: EdgeInsets.only(left: 36.w,right: 36.w,top: 32.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ImageWidget(image: "answer3",width: double.infinity,height: 155.h,fit: BoxFit.fill,),
              Container(
                margin: EdgeInsets.only(left: 12.w,right: 12.w),
                child: GetBuilder<BWordChildCon>(
                  id: "question",
                  builder: (_)=>TextWidget(
                    text: rootController.currentQuestion?.question??"",
                    color: color8B3B00,
                    size: 18.sp,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 288.w,
                height: 36.h,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ImageWidget(image: "home14", width: 288.w, height: 20.h,fit: BoxFit.fill,),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GetBuilder<BWordChildCon>(
                        id: "wheel_pro",
                        builder: (_)=>Container(
                          width: (284.w)*rootController.getWheelProgress(),
                          height: 16.h,
                          margin: EdgeInsets.only(left: 2.w,right: 2.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.w),
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [colorFFDF37,colorF35F1C]
                              )
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ImageWidget(image: "answer13",width: 36.w,height: 36.h,),
                    )
                  ],
                ),
              ),
              SizedBox(height: 4.h,),
              Container(
                margin: EdgeInsets.only(left: 36.w,right: 36.w),
                child: TextWidget(text: Local.pass9Level.tr, color: color8F7E53, size: 12.sp),
              ),
              SizedBox(height: 32.h,)
            ],
          ),
        )
      ],
    ),
  );

  _chooseListWidget()=>Container(
    margin: EdgeInsets.only(left: 36.w,right: 36.w),
    child: GetBuilder<BWordChildCon>(
      id: "answer",
      builder: (_)=> ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context,index){
          return InkWell(
            onTap: (){
              rootController.clickAnswer(index);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              child: Stack(
                key: index==0?rootController.answerAGlobalKey:rootController.answerBGlobalKey,
                alignment: Alignment.center,
                children: [
                  ImageWidget(image: rootController.getAnswerBg(index),width: double.infinity,height: 58.h,fit: BoxFit.fill,),
                  TextWidget(
                    text: index==0?rootController.currentQuestion?.a??"":rootController.currentQuestion?.b??"",
                    color: rootController.getAnswerTextColor(index),
                    size: 28.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ],
              ),
            ),
          );
        },
      )
    ),
  );

  _bottomWidget()=>GetBuilder<BWordChildCon>(
    id: "bottom",
    builder: (_)=>Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _bottomItemWidget(0),
        // SizedBox(width: 40.w,),
        // _bottomItemWidget(1),
        SizedBox(width: 40.w,),
        _bottomItemWidget(2),
      ],
    ),
  );

  _bottomItemWidget(index)=>InkWell(
    onTap: (){
      rootController.clickBottom(index);
    },
    child: SizedBox(
      width: 50.w,
      height: 50.h,
      child: Stack(
        children: [
          ImageWidget(image:  rootController.getBottomFuncIcon(index),width: 50.w,height: 50.h,),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 24.w,
              height: 24.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.w),
                  color: color2FCB37,
                  border: Border.all(
                      width: 3.w,
                      color: colorE7FDAA
                  )
              ),
              child: TextWidget(
                text: "${index==0?NumUtils.instance.tipsNum:index==1?NumUtils.instance.addTimeNum:NumUtils.instance.wheelNum}",
                color: colorFFFFFF,
                size: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Offstage(
              offstage: index!=1,
              child: ImageWidget(image: "answer11",width: 36.w,height: 18.h,),
            ),
          )
        ],
      ),
    ),
  );

  _levelWidget()=>Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // SizedBox(width: 12.w,),
      // GetBuilder<BWordChildCon>(
      //   id: "time",
      //   builder: (_)=>Container(
      //     margin: EdgeInsets.only(right: 14.w),
      //     child: Stack(
      //       alignment: Alignment.center,
      //       children: [
      //         ImageWidget(image: "home11",width: 46.w,height: 46.w,),
      //         TextWidget(text: "${rootController.downCountTime}s", color: colorFFFFFF, size: 16.sp,fontWeight: FontWeight.w600,),
      //         Container(
      //           width: 46.w,
      //           height: 46.w,
      //           padding: EdgeInsets.all(2.5.w),
      //           child: CircularProgressIndicator(
      //             value: rootController.getTimeProgress(),
      //             color: colorFF490F,
      //             strokeWidth: 2.w,
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      // const Spacer(),
      GetBuilder<BWordChildCon>(
        id: "level",
        builder: (_)=>InkWell(
          onTap: (){
            rootController.test();
          },
          child: StrokedTextWidget(
              text: "Level ${QuestionUtils.instance.bAnswerIndex+1}",
              fontSize: 26.sp,
              textColor: colorFFFFFF,
              strokeColor: color177200,
              strokeWidth: 2.w
          ),
        ),
      ),
      // const Spacer(),
      // SizedBox(width: 60.w,),
      // SizedBox(width: 12.w,),
    ],
  );
  
  _guideWidget()=>GetBuilder<BWordChildCon>(
    id: "guide",
    builder: (_)=>Positioned(
      top: (rootController.guideOffset?.dy??0)+20.w,
      left: (rootController.guideOffset?.dx??0)+230.w,
      child: Offstage(
        offstage: null==rootController.guideOffset,
        child: InkWell(
          onTap: (){
            rootController.clickGuide();
          },
          child: Lottie.asset("assets/guide2.json",width: 56.w,height: 56.w),
        ),
      ),
    ),
  );
}