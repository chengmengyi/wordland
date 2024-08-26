import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/event/event_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/widget/image_widget.dart';

class WheelWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _WheelWidgetState();
}

class _WheelWidgetState extends State<WheelWidget> with TickerProviderStateMixin{
  late AnimationController animationController;
  late Animation<double> animation;
  Timer? _timer;
  late StreamSubscription<EventCode>? bus;

  @override
  void initState() {
    super.initState();
    bus=EventUtils.getInstance()?.on<EventCode>().listen((data) {
      if(data==EventCode.playWheel){
        animationController.repeat();
        _timer=Timer.periodic(const Duration(milliseconds: 1300), (timer) {
          timer.cancel();
          animationController.stop();
          EventCode.stopWheel.sendMsg();
        });
      }
    });
    animationController=AnimationController(duration: const Duration(milliseconds: 500),vsync: this);
    animation=Tween<double>(begin: 0,end: 1).animate(animationController);
  }

  @override
  Widget build(BuildContext context) => RotationTransition(
    turns: animation,
    child: ImageWidget(image: Platform.isIOS?"wheel3":"wheel6",width: 300.w,height: 300.h,),
  );

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    _timer?.cancel();
    _timer=null;
    bus?.cancel();
    super.dispose();

  }
}