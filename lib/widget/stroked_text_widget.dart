import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StrokedTextWidget extends StatelessWidget{
  String text;
  double fontSize;
  Color textColor;
  Color strokeColor;
  double? strokeWidth;

  StrokedTextWidget({
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.strokeColor,
    this.strokeWidth,
  });


  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      Text(
        text,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth??2.w
              ..color = strokeColor
        ),
      ),
      Text(
        text,
        style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold
        ),
      ),
    ],
  );

}