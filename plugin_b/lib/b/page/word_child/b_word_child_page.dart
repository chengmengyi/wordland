import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:plugin_b/b/page/word_child/b_word_child_con.dart';
import 'package:plugin_b/guide/new_guide_utils.dart';
import 'package:plugin_b/utils/progress/progress_bean.dart';
import 'package:plugin_b/utils/progress/progress_utils.dart';
import 'package:plugin_b/widget/bubble_widget.dart';
import 'package:plugin_b/widget/money_animator/money_animator_widget.dart';
import 'package:plugin_b/widget/top_money/top_money_widget.dart';
import 'package:plugin_base/enums/top_cash.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/root_child.dart';
import 'package:plugin_base/routers/routers_data.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/question_utils.dart';
import 'package:plugin_base/utils/utils.dart';
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
            _progressWidget(),
            SizedBox(height: 6.h,),
            _questionWidget(),
              SizedBox(height: 6.h,),
            _chooseListWidget(),
            SizedBox(height: 10.h,),
            // _bottomWidget(),
            _signDownCountWidget(),
          ],
        ),
      ),
      _guideWidget(),
      GetBuilder<BWordChildCon>(
        id: "bubble",
        builder: (_)=>NewGuideUtils.instance.showBubble?BubbleWidget():Container(),
      ),
      MoneyAnimatorWidget(),
      _h5Widget(),
      _h5RightWidget(),
    ],
  );

  _topWidget()=>Row(
    children: [
      SizedBox(width: 12.w,),
      TopMoneyWidget(topCash: TopCash.word,),
      // const Spacer(),
      // GetBuilder<BWordChildCon>(
      //   id: "level",
      //   builder: (_)=>InkWell(
      //     onTap: (){
      //       rootController.test();
      //     },
      //     child: StrokedTextWidget(
      //         text: "Level ${QuestionUtils.instance.bAnswerIndex}",
      //         fontSize: 26.sp,
      //         textColor: colorFFFFFF,
      //         strokeColor: color177200,
      //         strokeWidth: 2.w
      //     ),
      //   ),
      // ),
      SizedBox(width: 12.w,),
    ],
  );

  _progressWidget()=>Container(
    width: double.infinity,
    height: 65.h,
    margin: EdgeInsets.only(left: 16.w,right: 16.w),
    child: Stack(
      children: [
        ImageWidget(image: "progress_bg",width: double.infinity,height: double.infinity,fit: BoxFit.fill,),
        Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: 65.h,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 14.w),
                child: GetBuilder<BWordChildCon>(
                  id: "pro",
                  builder: (_)=>ListView.builder(
                    itemCount: ProgressUtils.instance.proList.length,
                    scrollDirection: Axis.horizontal,
                    key: rootController.progressListGlobalKey,
                    controller: rootController.progressListController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      var bean = ProgressUtils.instance.proList[index];
                      return Container(
                        height: 65.h,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    bean.proStatus==ProStatus.current?
                                    Lottie.asset("assets/current_pro.json",width: 36.w,height: 36.w):
                                    ImageWidget(image: rootController.getProBg(bean),width: 36.w,height: 36.h),
                                    ImageWidget(
                                      image: rootController.getProIcon(bean),
                                      width: 32.w,
                                      height: 32.h,
                                    ),
                                  ],
                                ),
                                TextWidget(text: "${bean.index}", color: color8E3B00, size: 14.sp,fontWeight: FontWeight.w600,)
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 17.h),
                              child: ImageWidget(image: "line",width: 16.w,height: 2.h,),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                rootController.test();
              },
              child: ImageWidget(image: "pro_icon",width: 52.w,height: 52.h,),
            ),
          ],
        )
      ],
    ),
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
                child: GetBuilder<BWordChildCon>(
                  id: "wheel_text",
                  builder: (_)=>TextWidget(text: Local.reachLevelToEarn.tr.replaceNum(rootController.getNextWheelNum()), color: color8F7E53, size: 12.sp),
                ),
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
        SizedBox(width: 24.w,),
        InkWell(
          onTap: (){
            rootController.clickAch();
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ImageWidget(image: "home18",width: 80.w,height: 62.h,),
              GetBuilder<BWordChildCon>(
                id: "ach",
                builder: (_)=>Offstage(
                  offstage: rootController.achNum==0,
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
                      text: "${rootController.achNum}",
                      color: colorFFFFFF,
                      size: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: (){
            rootController.clickWheel();
          },
          child: SizedBox(
            width: 62.w,
            height: 62.h,
            key: rootController.wheelGlobalKey,
            child: Stack(
              children: [
                ImageWidget(image: "answer13",width: 60.w,height: 62.h,),
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
                      text: "${NumUtils.instance.wheelNum}",
                      color: colorFFFFFF,
                      size: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 24.w,),
      ],
    ),
  );

  _signDownCountWidget()=>Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: (){
          rootController.clickTopSign();
        },
        child: GetBuilder<BWordChildCon>(
          id: "sign_down_count",
          builder: (_)=>Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10.w),
                child: ImageWidget(image: "home20",width: 143.w,height: 65.h,),
              ),
              rootController.signDownCountTimer.isEmpty?
              Lottie.asset("assets/down_count.zip",width: 65.w,height: 65.h):
              ImageWidget(image: "home21",width: 65.w,height: 65.h,),
              Container(
                margin: EdgeInsets.only(left: 72.w),
                child: TextWidget(text: rootController.signDownCountTimer, color: Colors.white, size: 14.sp,fontWeight: FontWeight.w700,),
              ),
            ],
          ),
        ),
      ),
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


  _h5Widget()=>Positioned(
    bottom: 10,
    child: Offstage(
      offstage: NumUtils.instance.h5_show=="0",
      child: InkWell(
        onTap: (){
          RoutersUtils.toNamed(routerName: RoutersData.bH5,params: {"isLeftLucky":true});
        },
        child: Image.asset("images/h5.gif",width: 60,height: 60,),
      ),
    ),
  );

  _h5RightWidget()=>Positioned(
    bottom: 10,
    right: 0,
    child: Offstage(
      offstage: NumUtils.instance.homeRightH5.isEmpty,
      child: InkWell(
        onTap: (){
          RoutersUtils.toNamed(routerName: RoutersData.bH5,params: {"isLeftLucky":false});
        },
        child: ImageWidget(image: "h5",width: 80.w,height: 80.w,),
      ),
    ),
  );
}