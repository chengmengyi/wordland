import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/export.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:plugin_base/enums/incent_from.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/ad/ad_utils.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';

class IncentCon extends RootController{
  GlobalKey globalKey=GlobalKey();
  var progressMarginLeft=0.0;
  var addNum=0.0;
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
    var progressWidth = allWidth*NewValueUtils.instance.getCashProgress();
    if(progressWidth<=width/2){
      progressMarginLeft=0.0;
    }else if(width>=allWidth-progressWidth){
      progressMarginLeft=allWidth-width;
    }else{
      progressMarginLeft=progressWidth-width/2;
    }
    update(["progressMarginLeft"]);
  }

  setInfo(IncentFrom incentFrom,double addNum){
    _incentFrom=incentFrom;
    this.addNum=addNum;
    TbaUtils.instance.appEvent(AppEventName.double_pop, params: {"word_from": _getTabValueByFrom()});
  }

  clickClose(Function()? dismissDialog){
    TbaUtils.instance.appEvent(AppEventName.double_pop_continue, params: {"word_from": _getTabValueByFrom()});
    AdUtils.instance.showAd(
      adType: AdType.inter,
      adPosId: AdPosId.wpdnd_int_close_spin,
      adShowListener: AdShowListener(
        onAdHidden: (ad){
          RoutersUtils.back();
          NumUtils.instance.updateUserMoney(addNum, (){
            dismissDialog?.call();
          });
        },
      ),
    );
  }

  clickDouble(Function()? dismissDialog){
    TbaUtils.instance.appEvent(AppEventName.double_pop_c, params: {"word_from": _getTabValueByFrom()});
    AdUtils.instance.showAd(
        adType: AdType.reward,
        adPosId: _getAdPosID(),
        adShowListener: AdShowListener(
          onAdHidden: (MaxAd? ad) {
            RoutersUtils.back();
            // if(_incentFrom==IncentFrom.newUserGuide){
            //   GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showSignDialog);
            // }
            NumUtils.instance.updateUserMoney(NewValueUtils.instance.getDoubleNum(addNum), (){
              dismissDialog?.call();
            });
          },
          showAdFail: (ad,error){
            // if(_incentFrom==IncentFrom.newUserGuide){
            //   RoutersUtils.back();
            //   NumUtils.instance.updateUserMoney(addNum, (){
            //     GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showSignDialog);
            //   });
            // }
          }
        )
    );
  }

  AdPosId _getAdPosID(){
    switch(_incentFrom){
      // case IncentFrom.newUserGuide: return AdPosId.wpdnd_rv_get_double;
      case IncentFrom.ach: return AdPosId.wpdnd_rv_ach_double;
      case IncentFrom.wheel: return AdPosId.wpdnd_rv_spin_double;
      case IncentFrom.task: return AdPosId.wpdnd_rv_task_double;
      default: return AdPosId.other;
    }
  }

  String _getTabValueByFrom(){
    switch(_incentFrom){
      // case IncentFrom.newUserGuide: return "new";
      case IncentFrom.wheel: return "wheel";
      case IncentFrom.task: return "task";
      default:return "other";
    }
  }
}