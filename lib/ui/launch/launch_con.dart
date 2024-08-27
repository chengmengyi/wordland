import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_data.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/ad/ad_utils.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/notifi/notifi_id.dart';
import 'package:plugin_base/utils/notifi/notifi_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';

class LaunchCon extends RootController with WidgetsBindingObserver{
  Timer? _timer;
  var progress=0.0,_count=0,_totalCount=120,_onResume=true;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
    _tbaPoint();
    FlutterMaxAd.instance.loadAdByType(AdType.inter);
    NotifiUtils.instance.launchShowing=true;
    NotifiUtils.instance.checkPermission();
  }

  @override
  void onReady() {
    super.onReady();
    _startTimer();
  }

  _startTimer(){
    _timer=Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if(_onResume){
        _count++;
        progress=_count/_totalCount;
        update(["progress"]);
      }
      if(_count>=_totalCount){
        _checkResult();
      }
    });
  }

  _checkResult()async{
    var hasCache = FlutterMaxAd.instance.checkHasCache(AdType.inter);
    if(hasCache){
      AdUtils.instance.showOpenAd(
        closeAd: (){
          _toHome();
        }
      );
    }else{
      _toHome();
    }
  }

  _toHome(){
    _stopTimer();
    var checkType = FlutterCheckAdjustCloak.instance.checkType();
    NewValueUtils.instance.initValue();
    RoutersUtils.offNamed(router: checkType?RoutersData.bHome:RoutersData.aHome);
  }

  _tbaPoint(){
    TbaUtils.instance.appEvent(
        AppEventName.qs_launch_page,
        params: {"launch_from":NotifiUtils.instance.fromBackgroundId!=-1?"inform":"icon"}
    );
    NotifiUtils.instance.fromBackgroundId=-1;
    TbaUtils.instance.appEvent(AppEventName.wpdnd_ad_chance,params: {"ad_pos_id":AdPosId.wpdnd_launch.name});
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
}