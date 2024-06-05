import 'package:wordland/enums/sign_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/utils.dart';

class IncompleteCon extends RootController{

  String getStr(){
    if(NumUtils.instance.signDays<7&&!NumUtils.instance.todaySigned){
      return "Pending：Sign 7 days";
    }
    return "Pending：Collect 10 cash coins";
  }

  clickGo(){
    RoutersUtils.back();
    if(NumUtils.instance.signDays<7&&!NumUtils.instance.todaySigned){
      RoutersUtils.showSignDialog(signFrom: SignFrom.other);
    }else{
      EventCode.showWordChild.sendMsg();
    }
  }
}