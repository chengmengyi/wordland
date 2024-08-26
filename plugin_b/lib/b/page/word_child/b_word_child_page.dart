import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:plugin_b/b/page/word_child/b_word_child_con.dart';
import 'package:plugin_b/guide/new_guide_utils.dart';
import 'package:plugin_b/widget/bubble_widget.dart';
import 'package:plugin_b/widget/money_animator/money_animator_widget.dart';
import 'package:plugin_b/widget/top_money/top_money_widget.dart';
import 'package:plugin_base/enums/top_cash.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/root_child.dart';
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
            _signDownCountWidget(),
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
      const Spacer(),
      GetBuilder<BWordChildCon>(
        id: "level",
        builder: (_)=>InkWell(
          onTap: (){
            rootController.test();
          },
          child: StrokedTextWidget(
              text: "Level ${QuestionUtils.instance.bAnswerIndex}",
              fontSize: 26.sp,
              textColor: colorFFFFFF,
              strokeColor: color177200,
              strokeWidth: 2.w
          ),
        ),
      ),
      SizedBox(width: 12.w,),
    ],
  );

  _questionWidget()=>SizedBox(
    width: double.infinity,
    height: 308.h,
    child: Stack(
      children: [
        ImageWidget(image: "answer2",width: double.infinity,height: 308.h,fit: BoxFit.fill,),
        Container(
          margin: EdgeInsets.only(left: 36.w,right: 36.w,top: 32.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ImageWidget(image: "answer3",width: double.infinity,height: 120.h,fit: BoxFit.fill,),
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
              Container(
                width: double.infinity,
                height: 48,
                margin: EdgeInsets.only(left: 36.w,right: 36.w),
                child: GetBuilder<BWordChildCon>(
                  id: "answer",
                  builder: (_)=>StaggeredGridView.countBuilder(
                    itemCount: rootController.answerList.length,
                    crossAxisCount: 5,
                    shrinkWrap: true,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index){
                      var answer = rootController.answerList[index];
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ImageWidget(
                            image: answer.result.isEmpty?"answer4":answer.isRight?"answer5":"answer6",
                            width: 48.w,
                            height: 48.h,
                          ),
                          TextWidget(
                            text: null!=answer.hint?(answer.hint??""):answer.result,
                            color: null!=answer.hint?colorBB7000.withOpacity(0.4):colorFFFFFF,
                            size: 32.sp,
                            fontWeight: FontWeight.w600,
                          )
                        ],
                      );
                    },
                    staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                  ),
                ),
              ),
              SizedBox(height: 4.h,),
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
      id: "choose",
      builder: (_)=>StaggeredGridView.countBuilder(
        itemCount: rootController.chooseList.length,
        crossAxisCount: 5,
        shrinkWrap: true,
        mainAxisSpacing: 12.w,
        crossAxisSpacing: 12.w,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, index){
          var char = rootController.chooseList[index];
          return InkWell(
            onTap: (){
              rootController.clickAnswer(char.words);
            },
            child: Stack(
              alignment: Alignment.center,
              key: char.globalKey,
              children: [
                ImageWidget(image: "answer7",),
                TextWidget(text: char.words, color: colorBB7000, size: 32.sp),
              ],
            ),
          );
        },
        staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
      ),
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
      left: (rootController.guideOffset?.dx??0)+20.w,
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