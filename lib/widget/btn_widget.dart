import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/text_widget.dart';

class BtnWidget extends StatelessWidget{
  String text;
  double? width;
  double? height;
  List<Color>? colors;
  Function() click;
  BtnWidget({
    required this.text,
    required this.click,
    this.width,
    this.height,
    this.colors
  });

  @override
  Widget build(BuildContext context) => InkWell(
    child: Container(
      width: width??200.w,
      height: height??36.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(52.w),
        gradient: LinearGradient(
          colors: colors??[colorF7A300,colorEF6400],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight
        )
      ),
      child: TextWidget(
        text: text,
        color: colorFFFFFF,
        size: 16.sp,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}