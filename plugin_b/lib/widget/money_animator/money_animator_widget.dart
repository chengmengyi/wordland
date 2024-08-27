import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/event/event_utils.dart';
import 'package:plugin_base/utils/utils.dart';

class MoneyAnimatorWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MoneyAnimatorWidgetState();
}

class _MoneyAnimatorWidgetState extends State<MoneyAnimatorWidget> with TickerProviderStateMixin{
  bool show=false;
  late AnimationController _controller;
  late StreamSubscription<EventCode>? bus;

  @override
  void initState() {
    super.initState();
    bus=EventUtils.getInstance()?.on<EventCode>().listen((data) {
      if(data==EventCode.showMoneyLottie){
        setState(() {
          show=true;
        });
        _controller..reset()..forward();
      }
    });
    _controller=AnimationController(vsync: this,duration: const Duration(milliseconds: 800))..addStatusListener((status) {
      if(status==AnimationStatus.completed){
        setState(() {
          show=false;
        });
        EventCode.updateCoinNum.sendMsg();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Offstage(
    offstage: !show,
    child: Lottie.asset(
        "assets/money_android.zip",
        controller: _controller
      // repeat: false
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    bus?.cancel();
    super.dispose();
  }
}