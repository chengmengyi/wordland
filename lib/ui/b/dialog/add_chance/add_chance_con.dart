import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/tba_utils.dart';

class AddChanceCon extends RootController{

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
    TbaUtils.instance.appEvent(AppEventName.add_time_pop);
  }

  clickGet(){
    TbaUtils.instance.appEvent(AppEventName.add_time_pop_c);
    AdUtils.instance.showAd(
      adType: AdType.reward,
      adPosId: AdPosId.wpdnd_rv_int,
      adShowListener: AdShowListener(
        onAdHidden: (ad){
          RoutersUtils.back();
          NumUtils.instance.updateTimeNum(1);
        },
      ),
    );
  }
}