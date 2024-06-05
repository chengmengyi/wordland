import 'dart:io';
import 'package:flutter_check_adjust_cloak/dio/dio_manager.dart';
import 'package:flutter_check_adjust_cloak/util/utils.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:flutter_max_ad/export.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/data.dart';

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
    var hasUpload = StorageUtils.read<bool>(StorageName.installEvent)??false;
    if(hasUpload){
      return;
    }
    var map = await _getCommonMap();
    var referrerMap = await FlutterTbaInfo.instance.getReferrerMap();
    map["rack"]=referrerMap["build"];
    map["grover"]=referrerMap["referrer_url"];
    map["candela"]=referrerMap["install_version"];
    map["societe"]=referrerMap["user_agent"];
    map["barrage"]="kayo";
    map["desirous"]=referrerMap["referrer_click_timestamp_seconds"];
    map["salish"]=referrerMap["install_begin_timestamp_seconds"];
    map["palace"]=referrerMap["referrer_click_timestamp_server_seconds"];
    map["powdery"]=referrerMap["install_begin_timestamp_server_seconds"];
    map["loren"]=referrerMap["install_first_seconds"];
    map["ramada"]=referrerMap["last_update_seconds"];
    map["tyke"]=referrerMap["google_play_instant"];
    var header = await _getHeaderMap();
    var url = await _getTbaUrl();
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
    var header = await _getHeaderMap();
    var url = await _getTbaUrl();
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
    var header = await _getHeaderMap();
    var url = await _getTbaUrl();
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

  appEvent(AppEventName eventName,{Map<String,String>? params,int tryNum=5})async{
    var map = await _getCommonMap();
    map["nitrous"]=eventName.name;
    if(null!=params){
      for (var key in params.keys) {
        map["$key~ho"]=params[key];
      }
    }
    var header = await _getHeaderMap();
    var url = await _getTbaUrl();
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

  Future<String> _getTbaUrl()async{
    return "$tbaPath?mattress=${await FlutterTbaInfo.instance.getOsCountry()}";
  }

  Future<Map<String,dynamic>> _getHeaderMap()async{
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