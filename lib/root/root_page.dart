import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/widget/image_widget.dart';

abstract class RootPage<T extends RootController>extends StatelessWidget{
  late T rootController;

  @override
  Widget build(BuildContext context) {
    rootController = Get.put(setController());
    rootController.context=context;
    return Scaffold(
      body: Stack(
        children: [
          bgName().isEmpty?
          const SizedBox():
          ImageWidget(image: bgName(),width: double.infinity,height: double.infinity,fit: BoxFit.fill,),
          SafeArea(
            top: true,
            bottom: true,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: contentWidget(),
            ),
          )
        ],
      ),
    );
  }

  T setController();

  String bgName()=> "";

  Widget contentWidget();
}