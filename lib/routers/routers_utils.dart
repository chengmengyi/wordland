import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible ?? false,
    );
  }
}