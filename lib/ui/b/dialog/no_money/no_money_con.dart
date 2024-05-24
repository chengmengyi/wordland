import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/utils.dart';

class NoMoneyCon extends RootController{
  clickClose(){
    RoutersUtils.back();
  }
  clickMore(){
    RoutersUtils.back();
    EventCode.showWordChild.sendMsg();
  }
}