import 'dart:async';
import 'package:adjust_sdk/adjust.dart';
import 'package:flutter_app_lifecycle/app_state_observer.dart';
import 'package:flutter_app_lifecycle/flutter_app_lifecycle.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/ad/ad_utils.dart';
import 'package:plugin_base/utils/notifi/notifi_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';

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
      NotifiUtils.instance.appBackGround=true;
    });
  }

  _checkToLaunchPage(){
    _pausedTimer?.cancel();
    TbaUtils.instance.sessionEvent();
    Future.delayed(const Duration(milliseconds: 100),(){
      if(FlutterMaxAd.instance.fullAdShowing()){
        NotifiUtils.instance.appBackGround=false;
        return;
      }

      if(NotifiUtils.instance.appBackGround){
        TbaUtils.instance.appEvent(AppEventName.wpdnd_ad_chance,params: {"ad_pos_id":AdPosId.wpdnd_launch.name});
        AdUtils.instance.showOpenAd(
          has: (has){
            if(!has){
              FlutterMaxAd.instance.loadAdByType(AdType.inter);
            }
          }
        );
        NotifiUtils.instance.appBackGround=false;
        NumUtils.instance.updateAppLaunchNum();
      }
    });
  }
}