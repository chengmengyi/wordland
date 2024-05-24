import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/widget/image_widget.dart';

abstract class RootChild<T extends RootController>extends StatelessWidget{
  late T rootController;

  @override
  Widget build(BuildContext context) {
    rootController = Get.put(setController());
    rootController.context=context;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: contentWidget(),
    );
  }

  T setController();

  Widget contentWidget();
}