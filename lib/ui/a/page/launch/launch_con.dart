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
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/notifi/notifi_id.dart';
import 'package:wordland/utils/notifi/notifi_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';

class LaunchCon extends RootController with WidgetsBindingObserver{
  Timer? _timer;
  var progress=0.0,_count=0,_totalCount=100,_onResume=true;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
    _tbaPoint();
    TbaUtils.instance.sessionEvent();
    FlutterMaxAd.instance.loadAdByType(AdType.open);
    NotifiUtils.instance.launchShowing=true;
    NotifiUtils.instance.checkPermission();
    TbaUtils.instance.appEvent(AppEventName.wpdnd_ad_chance,params: {"ad_pos_id":AdPosId.wpdnd_launch.name});
    Future((){
      _startTimer();
    });
  }

  _startTimer(){
    _timer=Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if(_onResume){
        _count++;
        progress=_count/_totalCount;
        update(["progress"]);
        _checkResult(false);
      }
      if(_count>=_totalCount){
        FlutterCheckAdjustCloak.instance.checkType();
        _checkResult(true);
      }
    });
  }

  _checkResult(bool end)async{
    var userType = FlutterCheckAdjustCloak.instance.getUserType();
    if(end){
      _toHome(userType);
      return;
    }
    var hasCache = FlutterMaxAd.instance.checkHasCache(AdType.open);
    if(hasCache&&userType){
      _toHome(userType);
      AdUtils.instance.showOpenAd(
        adShowListener: AdShowListener(
          onAdHidden: (ad){

          },
        ),
        hasAdCache: (has){

        },
      );
    }
  }

  _toHome(bool checkType){
    _stopTimer();
    var nId = RoutersUtils.getParams()["n_id"];
    if(null==nId&&NotifiUtils.instance.fromBackgroundId!=-1){
      nId=NotifiUtils.instance.fromBackgroundId;
    }
    NotifiUtils.instance.fromBackgroundId=-1;
    if(checkType&&NotifiUtils.instance.hasBuyHome){
      RoutersUtils.back();
      if(null!=nId&&nId>=0){
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
      }
      return;
    }
    RoutersUtils.offNamed(router: checkType?RoutersData.bHome:RoutersData.home);
  }

  _tbaPoint(){
    var nId = RoutersUtils.getParams()["n_id"];
    if(null==nId&&NotifiUtils.instance.fromBackgroundId!=-1){
      nId=NotifiUtils.instance.fromBackgroundId;
    }
    TbaUtils.instance.appEvent(
        AppEventName.qs_launch_page,
        params: {"launch_from":null!=nId?"inform":"icon"}
    );
    switch(nId){
      case NotifiId.guding:
        TbaUtils.instance.appEvent(AppEventName.wl_fix_inform_c);
        break;
      case NotifiId.qiandao:
        TbaUtils.instance.appEvent(AppEventName.wl_sign_inform_c);
        break;
      case NotifiId.renwu:
        TbaUtils.instance.appEvent(AppEventName.wl_task_inform_c);
        break;
      case NotifiId.tixian:
        TbaUtils.instance.appEvent(AppEventName.wl_paypel_inform_c);
        break;
    }
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

  _stopTimer(){
    _timer?.cancel();
    _timer=null;
  }

  @override
  void onClose() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    NotifiUtils.instance.launchShowing=false;
    super.onClose();
  }

  @override
  bool initEventbus() => true;

  @override
  void receiveBusMsg(EventCode code) {
    if(code==EventCode.resetLaunchUI){
      _count=0;
      _startTimer();
    }
  }
}