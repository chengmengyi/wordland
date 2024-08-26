import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:plugin_b/guide/new_guide_utils.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/widget/image_widget.dart';

class TaskBubbleGuideWidget extends StatelessWidget{
  Offset offset;
  Function() hideCall;

  TaskBubbleGuideWidget({
    required this.offset,
    required this.hideCall,
  });

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: InkWell(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: color000000.withOpacity(0.6),
        child:InkWell(
          onTap: (){
            NewGuideUtils.instance.hideGuideOver();
            hideCall.call();
          },
          child: Stack(
            children: [
              Positioned(
                top: offset.dy,
                left: offset.dx,
                child: ImageWidget(image: "task1",width: 92.h,height: 72.h,),
              ),
              Positioned(
                top: offset.dy+20.w,
                left: offset.dx+30.w,
                child: Lottie.asset("assets/guide1.json",width: 52.w,height: 52.w),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}