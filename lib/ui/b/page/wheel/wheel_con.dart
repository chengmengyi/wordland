import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/enums/incent_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/no_wheel/no_wheel_dialog.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/num_utils.dart';

class WheelCon extends RootController{
  late AnimationController animationController;
  late Animation<double> animation;
  Timer? _timer;

  initInfo(vsync){
    animationController=AnimationController(duration: const Duration(milliseconds: 500),vsync: vsync);
    animation=Tween<double>(begin: 0,end: 1).animate(animationController);
  }

  @override
  void onInit() {
    super.onInit();
    print("onInit");
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
    FlutterMaxAd.instance.loadAdByType(AdType.inter);
  }

  @override
  void onReady() {
    super.onReady();
    print("onReady");
    if(RoutersUtils.getParams()["auto"]==true){
      clickPlay();
    }
  }

  clickClose(){
    RoutersUtils.back(backParams: {"back":true});
    NumUtils.instance.updateHasWheelCount();
  }

  clickPlay(){
    if(NumUtils.instance.wheelNum<=0){
      RoutersUtils.dialog(
        child: NoWheelDialog(
          addNumCall: (){
            clickPlay();
          },
        )
      );
      return;
    }
    animationController.repeat();
    _timer=Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      timer.cancel();
      animationController.stop();
      NumUtils.instance.updateWheelNum(-1);
      AdUtils.instance.showAd(
          adType: AdType.inter,
          adShowListener: AdShowListener(
            onAdHidden: (ad){
              RoutersUtils.showIncentDialog(incentFrom: IncentFrom.wheel);
            },
          )
      );
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    _timer=null;
    animationController.dispose();
    super.onClose();
  }

  @override
  bool initEventbus() => true;

  @override
  void receiveBusMsg(EventCode code) {
    switch(code){
      case EventCode.updateWheelNum:
        update(["bottom"]);
        break;
      default:

        break;
    }
  }
}