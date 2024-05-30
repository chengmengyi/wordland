import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/enums/incent_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/no_wheel/no_wheel_dialog.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';

class WheelCon extends RootController{
  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
    FlutterMaxAd.instance.loadAdByType(AdType.inter);
  }

  @override
  void onReady() {
    super.onReady();
    if(RoutersUtils.getParams()["auto"]==true){
      clickPlay();
    }
  }

  clickClose(){
    RoutersUtils.back(backParams: {"back":true});
    NumUtils.instance.updateHasWheelCount();
  }

  clickPlay(){
    if(NumUtils.instance.wheelNum<=0){
      RoutersUtils.dialog(
        child: NoWheelDialog(
          addNumCall: (){
            clickPlay();
          },
        )
      );
      return;
    }
    EventCode.playWheel.sendMsg();
  }

  @override
  bool initEventbus() => true;

  @override
  void receiveBusMsg(EventCode code) {
    switch(code){
      case EventCode.updateWheelNum:
        update(["bottom"]);
        break;
      case EventCode.stopWheel:
        NumUtils.instance.updateWheelNum(-1);
        AdUtils.instance.showAd(
            adType: AdType.inter,
            adShowListener: AdShowListener(
              onAdHidden: (ad){
                RoutersUtils.showIncentDialog(
                    incentFrom: IncentFrom.wheel,
                    addNum: ValueConfUtils.instance.getWheelAddNum()
                );
              },
            )
        );
        break;
      default:

        break;
    }
  }
}