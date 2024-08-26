import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/event/event_utils.dart';
import 'package:plugin_base/storage/storage_utils.dart';

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

String getMoneyIcon()=>FlutterCheckAdjustCloak.instance.getUserType()?"icon_money3":"coin1";

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


String millisecondsToHMS(int milliseconds) {
  var duration = Duration(milliseconds: milliseconds);
  var h = duration.inHours;
  var m = duration.inMinutes.remainder(60);
  var s = duration.inSeconds.remainder(60);
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}

String getOtherCountryMoneyNum(double money){
  if(!FlutterCheckAdjustCloak.instance.getUserType()){
    return "$money";
  }
  var decimal = (Decimal.fromInt(getExchangeRateByCountry())*Decimal.parse("$money")).toDouble();
  var format = NumberFormat.currency(
    locale: Get.deviceLocale?.toString(),
    symbol: "",
  ).format(decimal);
  var code = Get.deviceLocale?.countryCode??"US";
  if(code=="RU"||code=="VN"){
    return "$format${getMoneyCode()}";
  }
  return "${getMoneyCode()}$format";
}

String formatCurrencyMoney(double money)=>NumberFormat.currency(
  locale: Get.deviceLocale?.toString(),
  symbol: "",
).format(money);