

import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';

class CongratulationsCon extends RootController{
  Function()? call;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 1000),(){
      RoutersUtils.back();
      call?.call();
    });
  }
}