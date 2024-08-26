import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget{
  String image;
  double? width;
  double? height;
  BoxFit? fit;
  ImageWidget({
    required this.image,
    this.width,
    this.height,
    this.fit
  });

  @override
  Widget build(BuildContext context) => Image.asset(
    "images/$image.png",
    width: width,
    height: height,
    fit: fit,
  );
}