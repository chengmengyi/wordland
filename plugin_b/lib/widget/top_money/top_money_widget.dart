import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plugin_b/guide/guide_step.dart';
import 'package:plugin_b/guide/new_guide_utils.dart';
import 'package:plugin_b/guide/top_cash_guide_widget.dart';
import 'package:plugin_base/enums/top_cash.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/event/event_utils.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:plugin_base/widget/text_widget.dart';


class TopMoneyWidget extends StatefulWidget{
  TopCash topCash;
  Function()? clickCall;
  TopMoneyWidget({required this.topCash,this.clickCall});
  @override
  State<StatefulWidget> createState() => _TopMoneyWidgetState();
}


class _TopMoneyWidgetState extends State<TopMoneyWidget>{
  late StreamSubscription<EventCode>? bus;
  GlobalKey topMoneyGlobalKey=GlobalKey();

  @override
  void initState() {
    super.initState();
    bus=EventUtils.getInstance()?.on<EventCode>().listen((data) {
      receiveBusMsg(data);
    });
  }


  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Container(
        height: 38.h,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 2.w,right: 2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.w),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [color785600,color865000]
          )
        ),
        child: Container(
          height: 34.h,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 4.w,right: 4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.w),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorF9E423,colorFFB00E]
            ),
          ),
          child: Container(
            height: 26.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [color785600,color865000]
                )
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 38.w,),
                TextWidget(text: getOtherCountryMoneyNum(NumUtils.instance.userMoneyNum), color: colorFFE600, size: 12.sp,fontWeight: FontWeight.w700),
                SizedBox(width: 10.w,),
                InkWell(
                  onTap: (){
                    clickCash();
                  },
                  child: Container(
                    height: 24.h,
                    alignment: Alignment.center,
                    key: topMoneyGlobalKey,
                    margin: EdgeInsets.only(right: 1.w),
                    padding: EdgeInsets.only(left: 4.w,right: 4.w,),
                    decoration: BoxDecoration(
                        color: colorFFDD28,
                        borderRadius: BorderRadius.circular(12.w)
                    ),
                    child: TextWidget(text: Local.cash.tr, color: colorFF2B2B, size: 12.sp,fontWeight: FontWeight.w700,),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      ImageWidget(image: Platform.isAndroid?"icon_money4":"icon_money2",width: 42.w,height: 38.h,),
    ],
  );

  void receiveBusMsg(EventCode code) {
    if(code==EventCode.updateCoinNum){
      setState(() {});
    }else if(code==EventCode.showHomeTopCashGuide){
      _showTopCashGuideOverlay();
    }
  }

  _showTopCashGuideOverlay(){
    TbaUtils.instance.appEvent(AppEventName.home_guide_cash_s);
    var renderBox = topMoneyGlobalKey.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    NewGuideUtils.instance.showGuideOver(
      context: context,
      widget: TopCashGuideWidget(
        offset: offset,
        hideCall: (){
          TbaUtils.instance.appEvent(AppEventName.home_guide_cash_c);
          NewGuideUtils.instance.updatePlanBNewUserStep(BPackageNewUserGuideStep.rightAnswerGuide);
        },
      ),
    );
  }


  clickCash(){
    switch(widget.topCash){
      case TopCash.word:
        TbaUtils.instance.appEvent(AppEventName.word_page_cash);
        break;
      default:

        break;
    }

    widget.clickCall?.call();
    EventCode.showWithdrawChild.sendMsg();
  }

  @override
  void dispose() {
    super.dispose();
    bus?.cancel();
  }
}