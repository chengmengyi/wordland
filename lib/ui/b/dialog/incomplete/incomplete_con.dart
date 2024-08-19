import 'package:get/get.dart';
import 'package:wordland/enums/sign_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/language/local.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/utils/withdraw_task_util.dart';

class IncompleteCon extends RootController{

  String getStr(){
    if(WithdrawTaskUtils.instance.signDays<7){
      return Local.pendingSign7Days.tr;
    }
    return Local.pendingPass10Level.tr;
  }

  clickGo(){
    RoutersUtils.back();
    if(WithdrawTaskUtils.instance.signDays<7&&!WithdrawTaskUtils.instance.todaySigned){
      RoutersUtils.showSignDialog(signFrom: SignFrom.other);
    }else{
      EventCode.showWordChild.sendMsg();
    }
  }
}