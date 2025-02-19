import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:plugin_b/b/dialog/no_wheel/no_wheel_dialog.dart';
import 'package:plugin_b/utils/cash_task/cash_task_utils.dart';
import 'package:plugin_b/utils/utils.dart';
import 'package:plugin_base/enums/incent_from.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/ad/ad_utils.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/utils/withdraw_task_util.dart';

class WheelCon extends RootController{
  var playing=false,autoPlay=false;
  @override
  void onInit() {
    super.onInit();
    autoPlay=RoutersUtils.getParams()["auto"]??false;

    FlutterMaxAd.instance.loadAdByType(AdType.reward);
    FlutterMaxAd.instance.loadAdByType(AdType.inter);
    TbaUtils.instance.appEvent(AppEventName.wheel_pop);
  }

  @override
  void onReady() {
    super.onReady();
    if(autoPlay){
      clickPlay();
    }
  }

  clickClose(bool clickBack){
    if(clickBack){
      // AdUtils.instance.showAd(
      //   adType: AdType.inter,
      //   adPosId: AdPosId.wpdnd_int_close_spin,
      //   adShowListener: AdShowListener(
      //     onAdHidden: (ad){
      //       RoutersUtils.back(backParams: {"back":true});
      //     },
      //     showAdFail: (ad,error){
      //       RoutersUtils.back(backParams: {"back":true});
      //     }
      //   ),
      // );
      RoutersUtils.back(backParams: {"back":true});
    }else{
      RoutersUtils.back(backParams: {"back":false});
    }
  }

  clickPlay(){
    if(playing){
      return;
    }
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
    playing=true;
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
        CashTaskUtils.instance.updateCashTaskPro(CashTaskName.wheel);
        NumUtils.instance.updateWheelNum(-1);
        WithdrawTaskUtils.instance.updateWheelNum();
        if(autoPlay){
          playing=false;
          Utils.showIncentDialog(
              incentFrom: IncentFrom.wheel,
              addNum: NewValueUtils.instance.getWheelAddNum()
          );
        }else{
          AdUtils.instance.showAd(
              adType: AdType.inter,
              adPosId: AdPosId.wpdnd_int_spin_go,
              adShowListener: AdShowListener(
                  onAdHidden: (ad){
                    playing=false;
                    Utils.showIncentDialog(
                        incentFrom: IncentFrom.wheel,
                        addNum: NewValueUtils.instance.getWheelAddNum()
                    );
                  },
                  showAdFail: (ad,error){
                    playing=false;
                  }
              )
          );
        }
        break;
      default:

        break;
    }
  }
}