import 'package:get/get.dart';
import 'package:plugin_b/utils/utils.dart';
import 'package:plugin_base/enums/sign_from.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/utils/withdraw_task_util.dart';

class IncompleteCon extends RootController{

  clickGo(){
    RoutersUtils.back();
    if(WithdrawTaskUtils.instance.signDays<7&&!WithdrawTaskUtils.instance.todaySigned){
      Utils.showSignDialog(signFrom: SignFrom.other);
    }else{
      EventCode.showWordChild.sendMsg();
    }
  }

}