import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';

class CoinWidgetCon extends RootController{
  @override
  bool initEventbus() => true;

  @override
  void receiveBusMsg(EventCode code) {
    if(code==EventCode.updateCoinNum){
      update(["coin"]);
    }
  }
}