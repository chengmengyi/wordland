import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';

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