import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget{
  String text;
  Color color;
  double size;
  FontWeight? fontWeight;
  TextAlign? textAlign;

  TextWidget({
    required this.text,
    required this.color,
    required this.size,
    this.fontWeight,
    this.textAlign
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    ),
    textAlign: textAlign,
  );
}