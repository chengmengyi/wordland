import 'dart:convert';
import 'dart:io';
import 'package:flutter_check_adjust_cloak/dio/dio_manager.dart';
import 'package:flutter_check_adjust_cloak/util/utils.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:flutter_max_ad/export.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:plugin_base/storage/storage_name.dart';
import 'package:plugin_base/storage/storage_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/data.dart';

class TbaUtils{
  factory TbaUtils() => _getInstance();

  static TbaUtils get instance => _getInstance();

  static TbaUtils? _instance;

  static TbaUtils _getInstance() {
    _instance ??= TbaUtils._internal();
    return _instance!;
  }

  TbaUtils._internal();

  installEvent({int tryNum=5})async{
    sessionEvent();
    var hasUpload = StorageUtils.read<bool>(StorageName.installEvent)??false;
    if(hasUpload){
      return;
    }
    var map = await _getCommonMap();
    var referrerMap = await FlutterTbaInfo.instance.getReferrerMap();
    Map<String,dynamic> incisive={};
    incisive["rack"]=referrerMap["build"];
    incisive["grover"]=referrerMap["referrer_url"];
    incisive["candela"]=referrerMap["install_version"];
    incisive["societe"]=referrerMap["user_agent"];
    incisive["barrage"]="kayo";
    incisive["desirous"]=referrerMap["referrer_click_timestamp_seconds"];
    incisive["salish"]=referrerMap["install_begin_timestamp_seconds"];
    incisive["palace"]=referrerMap["referrer_click_timestamp_server_seconds"];
    incisive["powdery"]=referrerMap["install_begin_timestamp_server_seconds"];
    incisive["loren"]=referrerMap["install_first_seconds"];
    incisive["ramada"]=referrerMap["last_update_seconds"];
    incisive["tyke"]=referrerMap["google_play_instant"];
    map["incisive"]=incisive;
    var header = await getHeaderMap();
    var url = await getTbaUrl();
    printLogByDebug("tba===install===data->$map");
    var dioResult = await DioManager.instance.requestPost(
      url: url,
      dataMap: map,
      headerMap: header
    );
    printLogByDebug("tba===install===result->success:${dioResult.success}-->result:$map");
    if(dioResult.success){
      StorageUtils.write(StorageName.installEvent, true);
    }else if(tryNum>0){
      Future.delayed(const Duration(milliseconds: 1000),(){
        installEvent(tryNum: tryNum-1);
      });
    }
  }

  sessionEvent({int tryNum=5})async{
    var map = await _getCommonMap();
    map["ravel"]={};
    var header = await getHeaderMap();
    var url = await getTbaUrl();
    printLogByDebug("tba===session===data->$map");
    var dioResult = await DioManager.instance.requestPost(
        url: url,
        dataMap: map,
        headerMap: header
    );
    printLogByDebug("tba===session===result->success:${dioResult.success}-->result:$map");
    if(!dioResult.success&&tryNum>=0){
      Future.delayed(const Duration(milliseconds: 1000),(){
        sessionEvent(tryNum: tryNum-1);
      });
    }
  }

  adEvent(MaxAd? ad,MaxAdInfoBean? info,AdPosId adPosId,AdFomat adFomat,{int tryNum=5})async{
    var map = await _getCommonMap();
    map["milt"]=(ad?.revenue??0)*1000000;
    map["acceptor"]="USD";
    map["seacoast"]=ad?.networkName??"";
    map["wordy"]=info?.plat??"";
    map["hatfield"]=info?.id??"";
    map["selenate"]=adPosId.name;
    map["economic"]=adFomat.name;
    map["verbatim"]=ad?.revenuePrecision??"";
    map["nitrous"]="benz";
    var header = await getHeaderMap();
    var url = await getTbaUrl();
    printLogByDebug("tba===ad===data->$map");
    var dioResult = await DioManager.instance.requestPost(
        url: url,
        dataMap: map,
        headerMap: header
    );
    printLogByDebug("tba===ad===result->success:${dioResult.success}-->result:$map");
    if(!dioResult.success&&tryNum>=0){
      Future.delayed(const Duration(milliseconds: 1000),(){
        adEvent(ad, info, adPosId, adFomat,tryNum: tryNum-1);
      });
    }
  }

  appEvent(dynamic eventName,{Map<String,String>? params,int tryNum=5})async{
    var map = await _getCommonMap();
    map["nitrous"]=eventName is AppEventName?eventName.name:eventName;
    if(null!=params){
      for (var key in params.keys) {
        map["$key~ho"]=params[key];
      }
    }
    var header = await getHeaderMap();
    var url = await getTbaUrl();
    printLogByDebug("tba===app point===data->$map");
    var dioResult = await DioManager.instance.requestPost(
        url: url,
        dataMap: map,
        headerMap: header
    );
    printLogByDebug("tba===app point===result->success:${dioResult.success}-->result:$map");
    if(!dioResult.success&&tryNum>=0){
      Future.delayed(const Duration(milliseconds: 1000),(){
        appEvent(eventName,params: params,tryNum: tryNum-1);
      });
    }
  }

  Future<Map<String,dynamic>> getAppEventMap(AppEventName eventName,{Map<String,String>? params})async{
    var map = await _getCommonMap();
    map["nitrous"]=eventName.name;
    if(null!=params){
      for (var key in params.keys) {
        map["$key~ho"]=params[key];
      }
    }
    return map;
  }

  Future<String> getTbaUrl()async{
    return "$tbaPath?mattress=${await FlutterTbaInfo.instance.getOsCountry()}";
  }

  Future<Map<String,dynamic>> getHeaderMap()async{
    return {
      "grapheme":await FlutterTbaInfo.instance.getOperator(),
      "marathon":await FlutterTbaInfo.instance.getAndroidId(),
      "dead":await FlutterTbaInfo.instance.getBrand(),
    };
  }

  Future<Map<String,dynamic>> _getCommonMap()async{
    var havoc={
      "grapheme":await FlutterTbaInfo.instance.getOperator(),
      "devise":Platform.isIOS?"checkout":"leakage",
      "bouillon":await FlutterTbaInfo.instance.getGaid(),
      "parisian":await FlutterTbaInfo.instance.getBundleId(),
      "casework":await FlutterTbaInfo.instance.getAppVersion(),
      "seedling":await FlutterTbaInfo.instance.getIdfa(),
      "honolulu":await FlutterTbaInfo.instance.getIdfv(),
      "dead":await FlutterTbaInfo.instance.getBrand(),
    };
    var largesse={
      "portent":await FlutterTbaInfo.instance.getSystemLanguage(),
      "aida":await FlutterTbaInfo.instance.getLogId(),
      "puberty":await FlutterTbaInfo.instance.getDistinctId(),
      "marathon":await FlutterTbaInfo.instance.getAndroidId(),
      "mattress":await FlutterTbaInfo.instance.getOsCountry(),
    };
    var horrid={
      "hostage":await FlutterTbaInfo.instance.getDeviceModel(),
      "fat":await FlutterTbaInfo.instance.getManufacturer(),
      "tidal":await FlutterTbaInfo.instance.getNetworkType(),
    };
    var jejunum={
      "diego":await FlutterTbaInfo.instance.getOsVersion(),
      "cyanamid":DateTime.now().millisecondsSinceEpoch,
    };
    return {
      "havoc":havoc,
      "largesse":largesse,
      "horrid":horrid,
      "jejunum":jejunum,
    };
  }
}