import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/event/event_utils.dart';
import 'package:wordland/utils/utils.dart';

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
        "assets/money.json",
        controller: _controller
      // repeat: false
    ),
  );

}