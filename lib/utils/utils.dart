import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/event/event_utils.dart';
import 'package:wordland/storage/storage_utils.dart';

extension StringBase64 on String{
  // String base64()=>String.fromCharCodes(base64Decode(this));
  String base64()=>const Utf8Decoder().convert(base64Decode(this));
}

extension RandomStringList on List<String> {
  String random() {
    return this[Random().nextInt(length)];
  }
}

extension SengEvent on EventCode{
  void sendMsg(){
    EventUtils.getInstance()?.fire(this);
  }
}

String getTodayTime(){
  var dateTime = DateTime.now();
  return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
}

int getTodayNum(String key,int defaultNum){
  var str = StorageUtils.read<String>(key)??"";
  try{
    if(str.contains(getTodayTime())){
      return int.parse(str.split("_").last);
    }
    return defaultNum;
  }catch(e){
    return defaultNum;
  }
}

showToast(String text){
  if(text.isEmpty){
    return;
  }
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16
  );
}

extension RandomIntList on List<int> {
  int random() {
    return this[Random().nextInt(length)];
  }
}

extension String2Double on String {
  double toDouble() {
    try{
      return double.parse(this);
    }catch(e){
      return 0.0;
    }
  }
}

extension String2Int on String{
  int toInt({int defaultNum=0}){
    try{
      return int.parse(this);
    }catch(e){
      return defaultNum;
    }
  }
}


Future<bool> requestPermission({required List<Permission> permissionList})async{
  if(permissionList.isEmpty){
    return false;
  }
  Map<Permission, PermissionStatus> statuses = await permissionList.request();
  var hasPermission=true;
  var alwaysRefusePermission=false;
  statuses.forEach((key, value) {
    if(value.isPermanentlyDenied){
      alwaysRefusePermission=true;
    }
    if(!value.isGranted){
      hasPermission=false;
    }
  });
  if(alwaysRefusePermission||!hasPermission){
    showToast("Request Permission Fail");
    return false;
  }
  return hasPermission;
}

String getMoneyUnit()=>Platform.isAndroid?"":"\$";

String getMoneyIcon()=>Platform.isAndroid?"coin1":"icon_money1";

String getMoneyCode(){
  var code = Get.deviceLocale?.countryCode??"US";
  switch(code){
    case "BR": return "R\$";
    case "VN": return "₫";
    case "ID": return "Rp";
    case "TH": return "฿";
    case "RU": return "₽";
    case "PH": return "₱";
    default: return "\$";
  }
}

int getExchangeRateByCountry(){
  var code = Get.deviceLocale?.countryCode??"US";
  switch(code){
    case "BR": return 10;
    case "VN": return 10000;
    case "ID": return 10000;
    case "TH": return 10;
    case "PH": return 100;
    case "RU": return 100;
    default: return 1;
  }
}

extension ReplaceNum on String{
  String replaceNum(int num)=>replaceAll("tihuan", "$num");
}