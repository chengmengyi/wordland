import 'dart:convert';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:applovin_max/src/ad_classes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:wordland/bean/adjust_point_bean.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/data.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';

class AdjustPointUtils{
  factory AdjustPointUtils() => _getInstance();

  static AdjustPointUtils get instance => _getInstance();

  static AdjustPointUtils? _instance;

  static AdjustPointUtils _getInstance() {
    _instance ??= AdjustPointUtils._internal();
    return _instance!;
  }

  var _firstLaunchAppTimer="",_adRevenueTotal=0.0,_adShowNumTotal=0;
  AdjustPointBean? _adjustPointBean;
  
  AdjustPointUtils._internal();

  initInfo(){
    _getFirstLaunchAppTimer();
    _adRevenueTotal=StorageUtils.read<double>(StorageName.adRevenueTotal)??0.0;
    _adShowNumTotal=StorageUtils.read<int>(StorageName.adShowNumTotal)??0;
    _adjustPointBean=AdjustPointBean.fromJson(jsonDecode(adjustLocalValue.base64()));
  }

  showAdSuccess(MaxAd? ad, MaxAdInfoBean? info){
    _adShowNumTotal++;
    StorageUtils.write(StorageName.adShowNumTotal, _adShowNumTotal);
    _adRevenueTotal+=(ad?.revenue??0.0);
    StorageUtils.write(StorageName.adRevenueTotal, _adRevenueTotal);
    if(_firstLaunchAppTimer==getTodayTime()&&_adRevenueTotal>=(_adjustPointBean?.wrLtv0??1.5)){
      AdjustEvent adjustEvent = AdjustEvent(kDebugMode?"vitqr9":"tt0z0s");
      adjustEvent.addPartnerParameter("kwai_key_event_action_type", "4");
      adjustEvent.addPartnerParameter("kwai_key_event_action_value", "${_adjustPointBean?.wrLtv0??1.5}");
      Adjust.trackEvent(adjustEvent);
      TbaUtils.instance.appEvent(AppEventName.wr_ltv0,params: {"kwai_key_event_action_type":"4","kwai_key_event_action_value":"${_adjustPointBean?.wrLtv0??1.5}"});
    }
    if(_adShowNumTotal>=(_adjustPointBean?.wrPv??10)){
      AdjustEvent adjustEvent = AdjustEvent(kDebugMode?"lrtsfe":"viyaaw");
      adjustEvent.addPartnerParameter("kwai_key_event_action_type", "1");
      adjustEvent.addPartnerParameter("kwai_key_event_action_value", "${_adjustPointBean?.wrPv??10}");
      Adjust.trackEvent(adjustEvent);
      TbaUtils.instance.appEvent(AppEventName.wr_pv,params: {"kwai_key_event_action_type":"1","kwai_key_event_action_value":"${_adjustPointBean?.wrPv??10}"});
    }
    var ecpm = _adRevenueTotal/_adShowNumTotal*1000;
    if(ecpm>=(_adjustPointBean?.wrEcpm??3)){
      AdjustEvent adjustEvent = AdjustEvent(kDebugMode?"323baw":"59vbtr");
      adjustEvent.addPartnerParameter("kwai_key_event_action_type", "2");
      adjustEvent.addPartnerParameter("kwai_key_event_action_value", "${_adjustPointBean?.wrEcpm??3}");
      Adjust.trackEvent(adjustEvent);
      TbaUtils.instance.appEvent(AppEventName.wr_ecpm,params: {"kwai_key_event_action_type":"2","kwai_key_event_action_value":"${_adjustPointBean?.wrEcpm??3}"});

    }
  }

  answerRight(){
    if(QuestionUtils.instance.bAnswerRightNum>=(_adjustPointBean?.wrLevel??6)){
      AdjustEvent adjustEvent = AdjustEvent(kDebugMode?"bo4muy":"frmf9j");
      adjustEvent.addPartnerParameter("kwai_key_event_action_type", "5");
      adjustEvent.addPartnerParameter("kwai_key_event_action_value", "${_adjustPointBean?.wrLevel??6}");
      Adjust.trackEvent(adjustEvent);
      TbaUtils.instance.appEvent(AppEventName.wr_level,params: {"kwai_key_event_action_type":"5","kwai_key_event_action_value":"${_adjustPointBean?.wrLevel??6}"});
    }
  }
  
  _getFirstLaunchAppTimer(){
    var s = StorageUtils.read<String>(StorageName.firstLaunchAppTimer)??"";
    if(s.isEmpty){
      _firstLaunchAppTimer=getTodayTime();
      StorageUtils.write(StorageName.firstLaunchAppTimer, _firstLaunchAppTimer);
    }else{
      _firstLaunchAppTimer=s;
    }
  }
  
  getFirebaseData()async{
    try{
      var s = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("kwai_event");
      _adjustPointBean=AdjustPointBean.fromJson(jsonDecode(s));
    }catch(e){
      
    }
  }

  test(){
    // AdjustEvent adjustEvent = AdjustEvent("bo4muy");
    // adjustEvent.addPartnerParameter("kwai_key_event_action_type", "5");
    // adjustEvent.addPartnerParameter("kwai_key_event_action_value", "${_adjustPointBean?.wrLevel??6}");
    // Adjust.trackEvent(adjustEvent);

  }
}