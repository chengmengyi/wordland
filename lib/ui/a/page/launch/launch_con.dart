import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_data.dart';
import 'package:wordland/routers/routers_utils.dart';

class LaunchCon extends RootController with WidgetsBindingObserver{
  var progress=0.0,_count=0,_totalCount=60,_onResume=true;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _startTimer();
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
        RoutersUtils.offNamed(router: RoutersData.bHome);
      }
    });
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

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}