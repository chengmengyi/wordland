import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordland/root/root_page.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/a/page/answer/answer_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/widget/coin_widget/coin_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/stroked_text_widget.dart';
import 'package:wordland/widget/text_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AnswerPage extends RootPage<AnswerCon>{
  @override
  String bgName() => "answer1";

  @override
  AnswerCon setController() => AnswerCon();

  @override
  Widget contentWidget() => Column(
    children: [
      _topWidget(),
      SizedBox(height: 10.h,),
      _levelWidget(),
      SizedBox(height: 10.h,),
      _questionWidget(),
      SizedBox(height: 10.h,),
      _chooseListWidget(),
      SizedBox(height: 20.h,),
      _bottomWidget(),
    ],
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

  _questionWidget()=>SizedBox(
    width: double.infinity,
    height: 308.h,
    child: Stack(
      children: [
        ImageWidget(image: "answer2",width: double.infinity,height: 308.h,fit: BoxFit.fill,),
        Container(
          margin: EdgeInsets.only(left: 36.w,right: 36.w,top: 32.h),
          child: SizedBox(
            width:double.infinity,
            height: 178.h,
            child: Stack(
              children: [
                ImageWidget(image: "answer3",width: double.infinity,height: 178.h,fit: BoxFit.fill,),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.all(10.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GetBuilder<AnswerCon>(
                          id: "question_index",
                          builder: (_)=>TextWidget(
                            text: "${rootController.smallAnswerIndex+1}",
                            color: color8B3B00,
                            size: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextWidget(text: "/3", color: color8B3B00, size: 12.sp,),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(left: 12.w,right: 12.w),
                    child: GetBuilder<AnswerCon>(
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
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 48,
            margin: EdgeInsets.only(left: 36.w,right: 36.w,bottom: 36.h),
            child: GetBuilder<AnswerCon>(
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
                        text: answer.result,
                        color: colorFFFFFF,
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
        )
      ],
    ),
  );

  _chooseListWidget()=>Container(
    margin: EdgeInsets.only(left: 36.w,right: 36.w),
    child: GetBuilder<AnswerCon>(
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
              rootController.clickAnswer(char,index);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ImageWidget(image: "answer7",),
                TextWidget(text: char, color: colorBB7000, size: 32.sp),
              ],
            ),
          );
        },
        staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
      ),
    ),
  );

  _bottomWidget()=>GetBuilder<AnswerCon>(
    id: "bottom",
    builder: (_)=>Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _bottomItemWidget(0),
        SizedBox(width: 40.w,),
        _bottomItemWidget(1),
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
      width: 60.w,
      height: 60.h,
      child: Stack(
        children: [
          ImageWidget(image:  rootController.getBottomFuncIcon(index),width: 60.w,height: 60.h,),
          Align(
            alignment: Alignment.topRight,
            child: Offstage(
              offstage: index==0,
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
                  text: "${index==0?"":index==1?NumUtils.instance.removeFailNum:NumUtils.instance.addTimeNum}",
                  color: colorFFFFFF,
                  size: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Offstage(
              offstage: index!=2,
              child: ImageWidget(image: "answer11",width: 36.w,height: 18.h,),
            ),
          )
        ],
      ),
    ),
  );
  
  _levelWidget()=>Stack(
    alignment: Alignment.center,
    children: [
      GetBuilder<AnswerCon>(
        id: "level",
        builder: (_)=>StrokedTextWidget(
            text: "Level ${rootController.getLevel()}",
            fontSize: 26.sp,
            textColor: colorFFFFFF,
            strokeColor: color177200,
            strokeWidth: 2.w
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: GetBuilder<AnswerCon>(
          id: "time",
          builder: (_)=>Container(
            margin: EdgeInsets.only(right: 14.w),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ImageWidget(image: "home11",width: 46.w,height: 46.w,),
                TextWidget(text: "${rootController.downCountTime}s", color: colorFFFFFF, size: 16.sp,fontWeight: FontWeight.w600,),
                Container(
                  width: 46.w,
                  height: 46.w,
                  padding: EdgeInsets.all(2.5.w),
                  child: CircularProgressIndicator(
                    value: rootController.getTimeProgress(),
                    color: colorFF490F,
                    strokeWidth: 2.w,
                  ),
                )
              ],
            ),
          ),
        ),
      )
    ],
  );
}