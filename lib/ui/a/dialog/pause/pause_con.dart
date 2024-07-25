import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';

class PauseCon extends RootController{
  clickIndex(index, Function() quitCall, Function() dialogClose){
    RoutersUtils.back();
    switch(index){
      case 1:
        quitCall.call();
        break;
      case 2:
        break;
    }
    dialogClose.call();
  }
}