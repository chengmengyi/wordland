import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:plugin_b/guide/new_guide_utils.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/utils/withdraw_task_util.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:plugin_base/widget/text_widget.dart';

class TopCashGuideWidget extends StatelessWidget{
  Offset offset;
  Function() hideCall;

  TopCashGuideWidget({
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
        child: Stack(
          children: [
            Positioned(
              top: offset.dy,
              left: offset.dx+30.w,
              child: InkWell(
                onTap: (){
                  NewGuideUtils.instance.hideGuideOver();
                  hideCall.call();
                },
                child: Lottie.asset("assets/guide1.json",width: 52.w,height: 52.w),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}