import 'dart:async';

import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';

class LoadingCon extends RootController{
  AdType? _adType;
  Function(bool)? _result;
  Timer? _timer;
  var _count=0;

  setInfo(AdType? adType,Function(bool)? result){
    _adType=adType;
    _result=result;
  }

  @override
  void onReady() {
    super.onReady();
    _startProgress();
  }

  _startProgress(){
    _timer=Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _count++;
      update(["pro"]);
      if(_count>=600){
        _stopProgress();
        RoutersUtils.back();
        _result?.call(false);
        return;
      }
      _checkHasAd();
    });
  }
  
  _checkHasAd(){
    if(_count<40){
      return;
    }
    var hasCache = FlutterMaxAd.instance.checkHasCache(_adType??AdType.reward);
    if(hasCache){
      _stopProgress();
      RoutersUtils.back();
      _result?.call(true);
    }
  }

  _stopProgress(){
    _timer?.cancel();
    _timer=null;
  }

  double getProgress(){
    var d = _count/600;
    if(d>=1.0){
      return 1.0;
    }else if(d<=0.0){
      return 0.0;
    }else{
      return d;
    }
  }

  @override
  void onClose() {
    super.onClose();
    _stopProgress();
  }
}