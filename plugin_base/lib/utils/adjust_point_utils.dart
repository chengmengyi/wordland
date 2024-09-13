import 'dart:convert';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:applovin_max/src/ad_classes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/bean/adjust_point_bean.dart';
import 'package:plugin_base/storage/storage_name.dart';
import 'package:plugin_base/storage/storage_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/data.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/question_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';

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
    _adRevenueTotal=StorageUtils.read<double>(StorageName.adRevenueTotal,distType: false)??0.0;
    _adShowNumTotal=StorageUtils.read<int>(StorageName.adShowNumTotal,distType: false)??0;
    _adjustPointBean=AdjustPointBean.fromJson(jsonDecode(adjustLocalValue.base64()));
  }

  showAdSuccess(MaxAd? ad, MaxAdInfoBean? info){
    _adShowNumTotal++;
    StorageUtils.write(StorageName.adShowNumTotal, _adShowNumTotal,distType: false);
    _adRevenueTotal+=(ad?.revenue??0.0);
    StorageUtils.write(StorageName.adRevenueTotal, _adRevenueTotal,distType: false);
    if(_firstLaunchAppTimer==getTodayTime()){
      if(_adRevenueTotal>=(_adjustPointBean?.wrLtv0??0.2)){
        AdjustEvent adjustEvent = AdjustEvent("tt0z0s");
        adjustEvent.addPartnerParameter("kwai_key_event_action_type", "4");
        adjustEvent.addPartnerParameter("kwai_key_event_action_value", "${_adjustPointBean?.wrLtv0??0.2}");
        Adjust.trackEvent(adjustEvent);
        TbaUtils.instance.appEvent(AppEventName.wr_ltv0,params: {"kwai_key_event_action_type":"4","kwai_key_event_action_value":"${_adjustPointBean?.wrLtv0??0.2}"});
      }

      if(_adRevenueTotal>=(_adjustPointBean?.wrLtv0Other??0.15)){
        AdjustEvent adjustEvent = AdjustEvent("oxglzt");
        adjustEvent.addPartnerParameter("kwai_key_event_action_type", "4");
        adjustEvent.addPartnerParameter("kwai_key_event_action_value", "${_adjustPointBean?.wrLtv0Other??0.15}");
        Adjust.trackEvent(adjustEvent);
        TbaUtils.instance.appEvent(AppEventName.wr_ltv0_other,params: {"kwai_key_event_action_type":"4","kwai_key_event_action_value":"${_adjustPointBean?.wrLtv0Other??0.15}"});
      }
    }
    if(_adShowNumTotal>=(_adjustPointBean?.wrPv??8)){
      AdjustEvent adjustEvent = AdjustEvent("viyaaw");
      adjustEvent.addPartnerParameter("kwai_key_event_action_type", "1");
      adjustEvent.addPartnerParameter("kwai_key_event_action_value", "${_adjustPointBean?.wrPv??8}");
      Adjust.trackEvent(adjustEvent);
      TbaUtils.instance.appEvent(AppEventName.wr_pv,params: {"kwai_key_event_action_type":"1","kwai_key_event_action_value":"${_adjustPointBean?.wrPv??8}"});
    }
    if(_adShowNumTotal>=(_adjustPointBean?.wrPvOther??5)){
      AdjustEvent adjustEvent = AdjustEvent("5nlem8");
      adjustEvent.addPartnerParameter("kwai_key_event_action_type", "1");
      adjustEvent.addPartnerParameter("kwai_key_event_action_value", "${_adjustPointBean?.wrPvOther??5}");
      Adjust.trackEvent(adjustEvent);
      TbaUtils.instance.appEvent(AppEventName.wr_pv_other,params: {"kwai_key_event_action_type":"1","kwai_key_event_action_value":"${_adjustPointBean?.wrPvOther??5}"});
    }
  }

  answerRight(){
    // if(QuestionUtils.instance.bAnswerRightNum>=(_adjustPointBean?.wrLevel??6)){
    //   AdjustEvent adjustEvent = AdjustEvent("frmf9j");
    //   adjustEvent.addPartnerParameter("kwai_key_event_action_type", "5");
    //   adjustEvent.addPartnerParameter("kwai_key_event_action_value", "${_adjustPointBean?.wrLevel??6}");
    //   Adjust.trackEvent(adjustEvent);
    //   TbaUtils.instance.appEvent(AppEventName.wr_level,params: {"kwai_key_event_action_type":"5","kwai_key_event_action_value":"${_adjustPointBean?.wrLevel??6}"});
    // }
  }
  
  _getFirstLaunchAppTimer(){
    var s = StorageUtils.read<String>(StorageName.firstLaunchAppTimer,distType: false)??"";
    if(s.isEmpty){
      _firstLaunchAppTimer=getTodayTime();
      StorageUtils.write(StorageName.firstLaunchAppTimer, _firstLaunchAppTimer,distType: false);
    }else{
      _firstLaunchAppTimer=s;
    }
  }
  
  getFirebaseData()async{
    try{
      if(!kDebugMode){
        var s = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("kwai_event_other");
        if(s.isNotEmpty){
          _adjustPointBean=AdjustPointBean.fromJson(jsonDecode(s));
        }
      }
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