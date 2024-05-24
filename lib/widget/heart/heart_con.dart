import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';

class HeartCon extends RootController{
  @override
  bool initEventbus() => true;

  @override
  void receiveBusMsg(EventCode code) {
    if(code==EventCode.updateHeartNum){
      update(["heart"]);
    }
  }
}