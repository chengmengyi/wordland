import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:wordland/root/root_child.dart';
import 'package:wordland/ui/b/page/withdraw_child/b_withdraw_child_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';
import 'package:wordland/widget/btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class BWithdrawChildPage extends RootChild<BWithdrawChildCon>{
  @override
  BWithdrawChildCon setController() => BWithdrawChildCon();

  @override
  Widget contentWidget() =>GetBuilder<BWithdrawChildCon>(
    id: "child",
    builder: (_)=>Column(
      children: [
        _topWidget(),
        _payTypeList(),
        _lineWidget(),
        _payNumList(),
        _taskWidget(),
        _cashBtnWidget(),
      ],
    ),
  );

  _topWidget()=>Container(
    width: double.infinity,
    height: 282.h,
    alignment: Alignment.bottomCenter,
    padding: EdgeInsets.only(bottom: 12.h),
    margin: EdgeInsets.only(left: 12.w,right: 12.w),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageWidget(image: "cash1",width: 102.w,height: 32.h,),
        SizedBox(height: 16.h,),
        Container(
          width: double.infinity,
          height: 32.h,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 12.w,right: 12.w),
          decoration: BoxDecoration(
            color: color2B2D2B,
            borderRadius: BorderRadius.circular(16.w),
          ),
          child: Row(
            children: [
              ImageWidget(image: "cash3",width: 24.w,height: 24.h,),
              SizedBox(width: 4.w,),
              Expanded(
                child: Marquee(
                  text: rootController.marqueeStr,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorAAAAAA,
                  ),
                  scrollAxis: Axis.horizontal,
                  blankSpace: 20.0,
                  velocity: 100.0,
                  startPadding: 10.0,
                  accelerationCurve: Curves.linear,
                  decelerationCurve: Curves.easeOut,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 16.h,),
        SizedBox(
          width: double.infinity,
          height: 136.h,
          child: Stack(
            children: [
              ImageWidget(image: "cash2",width: double.infinity,height: 136.h,fit: BoxFit.fill,),
              Container(
                margin: EdgeInsets.only(left: 8.w,top: 4.h),
                child: TextWidget(text: "100% Winning", color: colorFFFFFF, size: 10.sp,fontWeight: FontWeight.w700,),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SizedBox(width: 20.w,),
                    TextWidget(text: "My Cash", color: colorDFC78B, size: 24.sp,fontWeight: FontWeight.w700,),
                    const Spacer(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidget(text: "\$${ValueConfUtils.instance.getCoinToMoney(NumUtils.instance.coinNum)}", color: color73562D, size: 36.sp,fontWeight: FontWeight.w700,),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(text: "≈", color: colorDE832F, size: 16.sp),
                            ImageWidget(image: "icon_money2",width: 24.w,height: 24.h,),
                            TextWidget(text: "${NumUtils.instance.coinNum}", color: colorDE832F, size: 16.sp,fontWeight: FontWeight.w700,),
                          ],
                        )
                      ],
                    ),
                    SizedBox(width: 20.w,),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ),
  );

  _payTypeList()=>Container(
    width: double.infinity,
    height: 68.h,
    margin: EdgeInsets.only(top: 12.h,left: 12.w),
    child: ListView.builder(
      itemCount: 6,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context,index)=>InkWell(
        onTap: (){
          rootController.clickPayType(index);
        },
        child: Container(
          width: 112.w,
          height: 68.h,
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 8.w),
          decoration: BoxDecoration(
            color: colorFFFFFF,
            borderRadius: BorderRadius.circular(8.w),
            border: Border.all(
              width: 2.w,
              color: NumUtils.instance.payType==index?colorFBAD16:colorFFFFFF
            )
          ),
          child: ImageWidget(image: "cash_pay${index+1}",width: 100.w,height: 40.h,),
        ),
      ),
    ),
  );

  _payNumList()=>Container(
    width: double.infinity,
    height: 120.h,
    margin: EdgeInsets.only(left: 12.w),
    child: ListView.builder(
      itemCount: rootController.withdrawNumList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context,index){
        var num = rootController.withdrawNumList[index];
        return InkWell(
          onTap: (){
            rootController.clickWithdrawNumItem(index);
          },
          child: Container(
            width: 112.w,
            height: 120.h,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 8.w),
            child: Stack(
              children: [
                ImageWidget(
                  image: rootController.chooseIndex==index?"cash_num_sel${NumUtils.instance.payType+1}":"cash_num_uns${NumUtils.instance.payType+1}",
                  width: 112.w,
                  height: 120.h,
                  fit: BoxFit.fill,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 18.h),
                    child: TextWidget(
                      text: "\$$num",
                      color: color111111,
                      size: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 4.h),
                    width: 112.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(text: "≈", color: colorDE832F, size: 16.sp),
                            ImageWidget(image: "icon_money2",width: 20.w,height: 20.h,),
                            TextWidget(text: "${ValueConfUtils.instance.getMoneyToCoin(num)}", color: colorDE832F, size: 12.sp,fontWeight: FontWeight.w700,),
                          ],
                        ),
                        SizedBox(height: 4.h,),
                        Container(
                          width: 104.w,
                          height: 16.h,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: color000000.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.w)
                          ),
                          child: Container(
                            width: (104.w)*rootController.getCashPro(num),
                            height: 16.h,
                            decoration: BoxDecoration(
                                color: color35A7D8,
                                borderRadius: BorderRadius.circular(8.w)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ),
  );

  _taskWidget()=>Container(
    width: double.infinity,
    height: 88.5.h,
    padding: EdgeInsets.only(left: 12.w,right: 12.w),
    margin: EdgeInsets.only(left: 12.w,right: 12.w,top: 12.h),
    decoration: BoxDecoration(
      color: colorFBF9F1,
      borderRadius: BorderRadius.circular(8.w)
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 44.h,
          child: Row(
            children: [
              TextWidget(text: "Check in for ", color: color333333, size: 14.sp,fontWeight: FontWeight.w700,),
              TextWidget(text: "7", color: colorF26910, size: 14.sp,fontWeight: FontWeight.w700,),
              TextWidget(text: " days: ${NumUtils.instance.signDays}/7", color: color333333, size: 14.sp,fontWeight: FontWeight.w700,),
              const Spacer(),
              InkWell(
                onTap: (){
                  rootController.clickSign();
                },
                child: Container(
                  width: 80.w,
                  height: 28.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.w),
                    color: NumUtils.instance.todaySigned?colorBEBEBE:colorF26910
                  ),
                  child: TextWidget(text: "Check-in", color: colorFFFFFF, size: 14.sp,fontWeight: FontWeight.w700,),
                ),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 0.5.h,
          color: colorDFDAC9,
        ),
        SizedBox(
          width: double.infinity,
          height: 44.h,
          child: Row(
            children: [
              TextWidget(text: "Pass ", color: color333333, size: 14.sp,fontWeight: FontWeight.w700,),
              TextWidget(text: "10", color: colorF26910, size: 14.sp,fontWeight: FontWeight.w700,),
              TextWidget(text: " level: ${QuestionUtils.instance.getLevel()}/10", color: color333333, size: 14.sp,fontWeight: FontWeight.w700,),
              const Spacer(),
              InkWell(
                onTap: (){
                  rootController.clickLevel();
                },
                child: Container(
                  width: 80.w,
                  height: 28.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.w),
                      color: colorF26910
                  ),
                  child: TextWidget(text: "Go", color: colorFFFFFF, size: 14.sp,fontWeight: FontWeight.w700,),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
  
  _cashBtnWidget()=>Container(
    margin: EdgeInsets.only(left: 12.w,right: 12.w,top: 12.h),
    child: BtnWidget(
        text: "Cash Out",
        width: double.infinity,
        height: 44.h,
        click: (){
          rootController.clickWithdraw();
        }),
  );

  _lineWidget()=>Container(
    width: double.infinity,
    height: 0.5.h,
    color: colorDFDAC9,
    margin: EdgeInsets.only(top: 16.h,bottom: 16.h,left: 12.w,right: 12.w ),
  );
}