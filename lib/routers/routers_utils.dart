import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordland/enums/incent_from.dart';
import 'package:wordland/enums/sign_from.dart';
import 'package:wordland/ui/b/dialog/incent/incent_dialog.dart';
import 'package:wordland/ui/b/dialog/sign/sign_dialog.dart';
import 'package:wordland/utils/color_utils.dart';

class RoutersUtils{

  static toNamed({
    required String routerName,
    Map<String, dynamic>? params,
    Function(Map<String,dynamic>?)? backResult,
  }){
    Get.toNamed(routerName, arguments: params)?.then((value){
      if(null!=backResult&&null!=value){
        backResult.call(value);
      }
    });
  }

  static offNamed({required String router,}){
    Get.offNamed(router);
  }

  static offAllNamed({required String router, Map<String, dynamic>? params}) {
    Get.offAllNamed(router, arguments: params);
  }

  static back({Map<String,dynamic>? backParams}) {
    Get.back(result: backParams);
  }

  static Map<String, dynamic> getParams() {
    try {
      return Get.arguments as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  static dialog({
    required Widget child,
    dynamic arguments,
    bool? barrierDismissible,
    Color? barrierColor,
    bool useSafeArea = true,
  }) {
    Get.dialog(
      child,
      arguments: arguments,
      barrierColor: barrierColor??color000000.withOpacity(0.8),
      barrierDismissible: barrierDismissible ?? false,
      useSafeArea: useSafeArea,
    );
  }

  static showIncentDialog({required IncentFrom incentFrom,int? addNum,Function()? dismissDialog}){
    dialog(
      child: IncentDialog(incentFrom: incentFrom,addNum: addNum,dismissDialog: dismissDialog,)
    );
  }

  static showSignDialog({required SignFrom signFrom}){
    dialog(
      child: SignDialog(signFrom: signFrom,),
      useSafeArea: false
    );
  }
}