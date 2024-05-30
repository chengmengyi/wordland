import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_data.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/notifi/notifi_id.dart';
import 'package:wordland/utils/notifi/notifi_utils.dart';
import 'package:wordland/utils/utils.dart';

class LaunchCon extends RootController with WidgetsBindingObserver{
  var progress=0.0,_count=0,_totalCount=60,_onResume=true;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.open);
  }

  @override
  void onReady() {
    super.onReady();
    _startTimer();
    _checkNotifi();
  }

  _startTimer(){
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if(_onResume){
        _count++;
        progress=_count/_totalCount;
        update(["progress"]);
      }
      if(_count>=_totalCount){
        timer.cancel();
        _checkResult();
      }
    });
  }

  _checkResult()async{
    var checkType = FlutterCheckAdjustCloak.instance.checkType();
    if(!checkType){
      _toHome(checkType);
      return;
    }

    var hasCache = FlutterMaxAd.instance.checkHasCache(AdType.open);
    if(hasCache){
      FlutterMaxAd.instance.showAd(
        adType: AdType.open,
        adShowListener: AdShowListener(
          onAdHidden: (ad){
            _toHome(checkType);
          },
          showAdFail: (ad,error){
            _toHome(checkType);
          }
        ),
      );
    }
  }

  _toHome(bool checkType){
    RoutersUtils.offNamed(router: checkType?RoutersData.bHome:RoutersData.home);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _onResume=true;
        break;
      case AppLifecycleState.paused:
        _onResume=false;
        break;
      default:
        break;
    }
  }

  _checkNotifi(){
    Future.delayed(const Duration(milliseconds: 2300),(){
      var nId = RoutersUtils.getParams()["n_id"];
      if(null==nId&&NotifiUtils.instance.fromBackgroundId!=-1){
        nId=NotifiUtils.instance.fromBackgroundId;
      }
      if(null==nId){
        return;
      }

      NotifiUtils.instance.fromBackgroundId=-1;
      if(NotifiUtils.instance.hasBuyHome){
        RoutersUtils.back();
        switch(nId){
          case NotifiId.qiandao:
            EventCode.showSignDialog.sendMsg();
            break;
          case NotifiId.renwu:
            EventCode.showTaskChild.sendMsg();
            break;
          case NotifiId.tixian:
            EventCode.showWithdrawChild.sendMsg();
            break;
        }
      }else{
        _toHome(FlutterCheckAdjustCloak.instance.getUserType());
      }
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}