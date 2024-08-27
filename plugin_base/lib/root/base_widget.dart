import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plugin_base/root/root_controller.dart';

abstract class BaseWidget<T extends RootController>extends StatelessWidget{
  late T rootController;

  @override
  Widget build(BuildContext context) {
    rootController = Get.put(setController());
    rootController.context=context;
    return contentWidget();
  }

  T setController();

  Widget contentWidget();
}