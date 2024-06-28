import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';

class CongratulationsCon extends RootController{
  Function()? call;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 2000),(){
      RoutersUtils.back();
      call?.call();
    });
  }
}