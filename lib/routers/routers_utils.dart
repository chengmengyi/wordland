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
    Map<String, dynamic>? params
  }){
    Get.toNamed(routerName, arguments: params);
  }

  static offNamed({required String router,}){
    Get.offNamed(router);
  }

  static offAllNamed({required String router, Map<String, dynamic>? params}) {
    Get.offAllNamed(router, arguments: params);
  }

  static back() {
    Get.back();
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
    Color? barrierColor
  }) {
    Get.dialog(
      child,
      arguments: arguments,
      barrierColor: barrierColor??color000000.withOpacity(0.8),
      barrierDismissible: barrierDismissible ?? false,
    );
  }

  static showIncentDialog({required IncentFrom incentFrom}){
    dialog(
      child: IncentDialog(incentFrom: incentFrom,)
    );
  }

  static showSignDialog({required SignFrom signFrom}){
    dialog(
        child: SignDialog(signFrom: signFrom,)
    );
  }
}