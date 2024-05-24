import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/export.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:wordland/enums/incent_from.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/guide/guide_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';

class IncentCon extends RootController{
  GlobalKey globalKey=GlobalKey();
  var progressMarginLeft=0.0;
  var addNum=ValueConfUtils.instance.getCommonAddNum();
  IncentFrom _incentFrom=IncentFrom.other;

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
  }

  @override
  void onReady() {
    super.onReady();
    _getProgressMarginLeft();
  }

  _getProgressMarginLeft(){
    var allWidth = 238.w;
    var renderBox = globalKey.currentContext?.findRenderObject() as RenderBox;
    var width = renderBox.size.width;
    var progressWidth = allWidth*ValueConfUtils.instance.getWithdrawProgress();
    if(progressWidth<=width/2){
      progressMarginLeft=0.0;
    }else if(width>=allWidth-progressWidth){
      progressMarginLeft=allWidth-width;
    }else{
      progressMarginLeft=progressWidth-width/2;
    }
    update(["progressMarginLeft"]);
  }

  setInfo(IncentFrom incentFrom,int addNum){
    _incentFrom=incentFrom;
    if(addNum>0){
      this.addNum=addNum;
    }
  }

  clickClose(Function()? dismissDialog){
    RoutersUtils.back();
    NumUtils.instance.updateCoinNum(addNum);
    switch(_incentFrom){
      case IncentFrom.newUserGuide:
        NumUtils.instance.updateHasUserCount();
        GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showSignDialog);
        break;
      case IncentFrom.wheel:
        NumUtils.instance.updateHasWheelCount();
        break;
      default:

        break;
    }
    dismissDialog?.call();
  }

  clickDouble(Function()? dismissDialog){
    AdUtils.instance.showAd(
        adType: AdType.reward,
        adShowListener: AdShowListener(
            onAdHidden: (MaxAd? ad) {
              RoutersUtils.back();
              NumUtils.instance.updateCoinNum(addNum*2);
              if(_incentFrom==IncentFrom.newUserGuide){
                GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showSignDialog);
              }
              dismissDialog?.call();
            })
    );
  }
}