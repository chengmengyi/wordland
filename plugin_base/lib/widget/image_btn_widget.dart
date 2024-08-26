import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:plugin_base/widget/stroked_text_widget.dart';

class ImageBtnWidget extends StatelessWidget{
  String text;
  String? bg;
  bool? showVideo;
  Function()? click;
  ImageBtnWidget({
    required this.text,
    this.click,
    this.bg,
    this.showVideo,
});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: (){
      click?.call();
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        ImageWidget(image: bg??"icon_btn",width: 180.w,height: 48.h,fit: BoxFit.fill,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Offstage(
              offstage: showVideo!=true,
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                child: ImageWidget(image: "icon_video",width: 20.w,height: 20.w,),
              ),
            ),
            StrokedTextWidget(
                text: text,
                fontSize: 16.sp,
                textColor: colorFFFFFF,
                strokeColor: color5B2600
            )
          ],
        )
      ],
    ),
  );
}