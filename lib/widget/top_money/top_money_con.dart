import 'package:wordland/enums/top_cash.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';

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