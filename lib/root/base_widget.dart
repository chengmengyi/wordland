import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/widget/image_widget.dart';

abstract class BaseWidget<T extends RootController>extends StatelessWidget{
  late T rootController;

  @override
  Widget build(BuildContext context) {
    rootController = Get.put(setController());
    return contentWidget();
  }

  T setController();

  Widget contentWidget();
}