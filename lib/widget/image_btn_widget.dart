import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/stroked_text_widget.dart';

class ImageBtnWidget extends StatelessWidget{
  String text;
  String? bg;
  Function()? click;
  ImageBtnWidget({
    required this.text,
    this.click,
    this.bg,
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
        StrokedTextWidget(
            text: text,
            fontSize: 16.sp,
            textColor: colorFFFFFF,
            strokeColor: color5B2600
        )
      ],
    ),
  );
}