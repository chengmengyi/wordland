import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/ui/a/dialog/pause/pause_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/play_music_utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class PauseDialog extends RootDialog<PauseCon>{
  Function() quitCall;
  Function() dialogClose;
  PauseDialog({required this.quitCall,required this.dialogClose});

  @override
  PauseCon setController() => PauseCon();

  @override
  Widget contentWidget() => Stack(
    alignment: Alignment.bottomCenter,
    children: [
      ImageWidget(image: "pause1",width: 286.w,height: 174.h,),
      Container(
        margin: EdgeInsets.only(bottom: 20.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _itemWidget(0),
            SizedBox(width: 20.w,),
            _itemWidget(1),
            SizedBox(width: 20.w,),
            _itemWidget(2),
          ],
        ),
      )
    ],
  );

  _itemWidget(index)=>InkWell(
    onTap: (){
      rootController.clickIndex(index,quitCall,dialogClose);
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageWidget(
          image: index==0?(PlayMusicUtils.instance.playStatus?"pause2":"pause5"):index==1?"pause3":"pause4",
          width: 60.w,
          height: 60.h,
        ),
        SizedBox(height: 2.h,),
        TextWidget(
          text: index==0?"Music":index==1?"Quit":"Resume",
          color: color421000,
          size: 14.sp,
          fontWeight: FontWeight.w600,
        )
      ],
    ),
  );
}