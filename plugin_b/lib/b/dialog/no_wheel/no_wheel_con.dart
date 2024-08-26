import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/ad/ad_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';

class NoWheelCon extends RootController{

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
    TbaUtils.instance.appEvent(AppEventName.wheel_over_pop);
  }

  clickClose(){
    AdUtils.instance.showAd(
      adType: AdType.inter,
      adPosId: AdPosId.wpdnd_int_close_spin,
      adShowListener: AdShowListener(
        onAdHidden: (ad){
          RoutersUtils.back();
        },
      ),
    );
  }

  clickGet(Function() addNumCall){
    TbaUtils.instance.appEvent(AppEventName.wheel_over_pop_c);
    AdUtils.instance.showAd(
        adType: AdType.reward,
        adPosId: AdPosId.wpdnd_rv_spin_chance,
        adShowListener: AdShowListener(
          onAdHidden: (ad){
            RoutersUtils.back();
            NumUtils.instance.updateWheelNum(3);
            addNumCall.call();
          },
        )
    );
  }
}