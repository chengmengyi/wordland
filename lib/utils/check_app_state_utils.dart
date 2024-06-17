import 'dart:async';
import 'package:adjust_sdk/adjust.dart';
import 'package:flutter_app_lifecycle/app_state_observer.dart';
import 'package:flutter_app_lifecycle/flutter_app_lifecycle.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/routers/routers_data.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/notifi/notifi_utils.dart';
import 'package:wordland/utils/tba_utils.dart';

class CheckAppStateUtils{
  factory CheckAppStateUtils() => _getInstance();

  static CheckAppStateUtils get instance => _getInstance();

  static CheckAppStateUtils? _instance;

  static CheckAppStateUtils _getInstance() {
    _instance ??= CheckAppStateUtils._internal();
    return _instance!;
  }

  CheckAppStateUtils._internal();

  Timer? _pausedTimer;

  init(){
    FlutterAppLifecycle.instance.setCallObserver(
      AppStateObserver(
        call: (back){
          if(back){
            Adjust.onPause();
            _startPausedTimer();
          }else{
            Adjust.onResume();
            _checkToLaunchPage();
          }
        },
      ),
    );
  }

  _startPausedTimer(){
    _pausedTimer=Timer(const Duration(milliseconds: 3000), () {
      if(NotifiUtils.instance.clickNotification){
        NotifiUtils.instance.appBackGround=false;
        return;
      }
      NotifiUtils.instance.appBackGround=true;
    });
  }

  _checkToLaunchPage(){
    _pausedTimer?.cancel();
    Future.delayed(const Duration(milliseconds: 100),(){
      if(NotifiUtils.instance.clickNotification){
        NotifiUtils.instance.appBackGround=false;
        return;
      }
      if(NotifiUtils.instance.appBackGround){
        TbaUtils.instance.sessionEvent();
        _showAdOrToLaunchPage();
        NotifiUtils.instance.appBackGround=false;
      }
    });
  }

  _showAdOrToLaunchPage(){
    AdUtils.instance.showOpenAd();
  }
}