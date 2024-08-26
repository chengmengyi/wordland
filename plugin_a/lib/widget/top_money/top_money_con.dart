import 'package:plugin_base/enums/top_cash.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';

class TopMoneyCon extends RootController{
  
  clickCash(TopCash topCash,Function()? clickCall){
    switch(topCash){
      case TopCash.word:
        TbaUtils.instance.appEvent(AppEventName.word_page_cash);
        break;
      default:
        
        break;
    }
    
    clickCall?.call();
    EventCode.showWithdrawChild.sendMsg();
  }
  
  @override
  bool initEventbus() => true;

  @override
  void receiveBusMsg(EventCode code) {
    if(code==EventCode.updateCoinNum){
      update(["coin"]);
    }
  }
}