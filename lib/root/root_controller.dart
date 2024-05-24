
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/event/event_utils.dart';

abstract class RootController extends GetxController{
  late BuildContext context;
  late StreamSubscription<EventCode>? bus;

  @override
  void onInit() {
    super.onInit();
    if(initEventbus()){
      bus=EventUtils.getInstance()?.on<EventCode>().listen((data) {
        receiveBusMsg(data);
      });
    }
  }

  bool initEventbus() => false;

  void receiveBusMsg(EventCode code){}

  @override
  void onClose() {
    super.onClose();
    if(initEventbus()){
      bus?.cancel();
      bus=null;
    }
  }
}