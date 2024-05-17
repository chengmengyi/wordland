import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';

class CloakUtils{
  factory CloakUtils() => _getInstance();

  static CloakUtils get instance => _getInstance();

  static CloakUtils? _instance;

  static CloakUtils _getInstance() {
    _instance ??= CloakUtils._internal();
    return _instance!;
  }

  Dio? _dio;
  var _requestNum=0;

  CloakUtils._internal(){
    _dio ??= Dio(BaseOptions(
          responseType: ResponseType.json,
          receiveDataWhenStatusError: false,
          connectTimeout: const Duration(milliseconds: 30000),
          receiveTimeout: const Duration(milliseconds: 300000)
      ));
  }

  request()async{
    if(_requestNum>=20){
      return;
    }
    //{“leakage”: “android”, “checkout”: “ios”, “marmoset”: “web”}
    var path="https://ashman.wordlandwin.com/felicity/european?"
        "puberty=${await FlutterTbaInfo.instance.getDistinctId()}&"
        "cyanamid=${DateTime.now().millisecondsSinceEpoch}&"
        "hostage=${await FlutterTbaInfo.instance.getDeviceModel()}&"
        "parisian=${await FlutterTbaInfo.instance.getBundleId()}&"
        "diego=${await FlutterTbaInfo.instance.getOsVersion()}&"
        "honolulu=${await FlutterTbaInfo.instance.getIdfv()}&"
        "bouillon=${await FlutterTbaInfo.instance.getGaid()}&"
        "marathon=${await FlutterTbaInfo.instance.getAndroidId()}&"
        "devise=${Platform.isAndroid?"leakage":"checkout"}&"
        "seedling=${await FlutterTbaInfo.instance.getIdfa()}&"
        "casework=${await FlutterTbaInfo.instance.getAppVersion()}&"
        "dead=${await FlutterTbaInfo.instance.getBrand()}";
    var result = await _getRequest(path);
    if(result.isNotEmpty&&(result=="middle"||result=="binaural")){
    }else{
      _requestNum++;
      Future.delayed(const Duration(milliseconds: 1000),(){
        request();
      });
    }
  }

  Future<String> _getRequest(String url) async{
    try{
      var response = await _dio?.request<String>(url,options: Options(method: "get"));
      if(response?.statusCode==200){
        return response?.data?.toString()??"";
      }
      return "";
    }catch(e){
      return "";
    }
  }
}