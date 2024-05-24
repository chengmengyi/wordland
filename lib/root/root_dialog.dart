import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordland/root/root_controller.dart';

abstract class RootDialog<T extends RootController> extends StatelessWidget{
  late T rootController;

  @override
  Widget build(BuildContext context) {
    rootController = Get.put(setController());
    rootController.context=context;
    return WillPopScope(
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: contentWidget(),
          ),
        ),
        onWillPop: ()async{
          clickBack();
          return false;
        }
    );
  }

  Widget contentWidget();

  T setController();

  clickBack(){}
}