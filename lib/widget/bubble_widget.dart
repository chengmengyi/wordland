import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/stroked_text_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class BubbleWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget> with SingleTickerProviderStateMixin{
  GlobalKey globalKey=GlobalKey();
  double width=360.w,currentX=0.0;
  double height=760.h,currentY=0.0;
  Timer? _timer;
  bool right=true,down=true,showGuide=false,showBubble=true;
  // late StreamSubscription<EventBean>? _bus;
  var addNum=NewValueUtils.instance.getFloatAddNum();

  @override
  void initState() {
    super.initState();
    // _bus=EventUtils.getInstance()?.on<EventBean>().listen((event) {
    //   if(event.eventName==EventName.updateHomeIndex){
    //     if(event.intValue==0&&event.boolValue==true){
    //       setState(() {
    //         showGuide=true;
    //       });
    //     }
    //   }
    // });
    Future((){
      var size = globalKey.currentContext?.size;
      if(null!=size){
        width=size.width-80.w;
        height=size.height-80.h;
      }
      _initAnimator();
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: double.infinity,
    key: globalKey,
    child: Stack(
      children: [
        Positioned(
          top: currentY,
          left: currentX,
          child: InkWell(
              onTap: (){
                _clickBubble();
              },
              child: Offstage(
                offstage: !showBubble,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ImageWidget(image: Platform.isAndroid?"home15":"home13",width: 80.w,height: 80.h,),
                    // TextWidget(
                    //   text: "\$$addNum",
                    //   size: 14.sp,
                    //   color: colorFFE600,
                    //   fontWeight: FontWeight.w900,
                    // ),
                    StrokedTextWidget(
                      text: "${getMoneyUnit()}$addNum",
                      fontSize: 14.sp,
                      textColor: colorFFE600,
                      strokeColor: color000000,
                    )
                  ],
                ),
              ),
          ),
        ),
      ],
    ),
  );

  _initAnimator(){
    _timer=Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if(right){
        currentX++;
        if(down){
          currentY++;
          if(currentY>=height){
            down=false;
          }
        }else{
          currentY--;
          if(currentY<=0){
            down=true;
          }
        }
        if(currentX>=width){
          right=false;
        }
      }else{
        currentX--;
        if(down){
          currentY++;
          if(currentY>=height){
            down=false;
          }
        }else{
          currentY--;
          if(currentY<=0){
            down=true;
          }
        }
        if(currentX<=0){
          right=true;
        }
      }
      setState(() {});
    });
  }

  _clickBubble(){
    TbaUtils.instance.appEvent(AppEventName.word_float_pop);
    setState(() {
      showGuide=false;
      showBubble=false;
    });
    NumUtils.instance.updateCollectBubbleNum();
    AdUtils.instance.showAd(
      adType: AdType.reward,
      adPosId: AdPosId.wpdnd_rv_float_gold,
      adShowListener: AdShowListener(
          onAdHidden: (ad){
            NumUtils.instance.updateUserMoney(addNum, (){
              _showBubble();
            });
            },
          showAdFail: (ad,err){
            _showBubble();
          }
      ),
    );
  }

  _showBubble(){
    Future.delayed(Duration(seconds:  NumUtils.instance.wordDis),(){
      setState(() {
        showBubble=true;
        addNum=NewValueUtils.instance.getFloatAddNum();
      });
    });
  }

  @override
  void dispose() {
    // _bus?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}