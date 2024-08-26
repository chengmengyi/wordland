import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plugin_base/root/root_controller.dart';

abstract class RootPageNew<T extends RootController>extends StatelessWidget{
  late T rootController;

  @override
  Widget build(BuildContext context) {
    rootController = Get.put(setController());
    rootController.context=context;
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset(),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: contentWidget(),
      ),
    );
  }

  T setController();

  Widget contentWidget();

  bool resizeToAvoidBottomInset()=>true;
}