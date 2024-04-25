import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/event/event_utils.dart';
import 'package:wordland/storage/storage_utils.dart';

extension StringBase64 on String{
  String base64()=>String.fromCharCodes(base64Decode(this));
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