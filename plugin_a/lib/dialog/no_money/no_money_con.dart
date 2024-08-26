import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';

class NoMoneyCon extends RootController{
  clickClose(){
    RoutersUtils.back();
  }
  clickMore(){
    TbaUtils.instance.appEvent(AppEventName.withdraw_no_pop_c);
    RoutersUtils.back();
    EventCode.showWordChild.sendMsg();
  }

  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.appEvent(AppEventName.withdraw_no_pop);
  }
}