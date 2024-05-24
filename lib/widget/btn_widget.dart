import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class BtnWidget extends StatelessWidget{
  String text;
  double? width;
  double? height;
  bool? showVideo;
  List<Color>? colors;
  Function() click;
  BtnWidget({
    required this.text,
    required this.click,
    this.width,
    this.height,
    this.colors,
    this.showVideo,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: (){
      click.call();
    },
    child: Container(
      width: width??200.w,
      height: height??36.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(52.w),
        gradient: LinearGradient(
          colors: colors??[colorF7A300,colorEF6400],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight
        )
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Offstage(
            offstage: showVideo!=true,
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              child: ImageWidget(image: "icon_video",width: 20.w,height: 20.w,),
            ),
          ),
          TextWidget(
            text: text,
            color: colorFFFFFF,
            size: 16.sp,
            fontWeight: FontWeight.w700,
          )
        ],
      ),
    ),
  );
}