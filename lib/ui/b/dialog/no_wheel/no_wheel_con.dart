import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/num_utils.dart';

class NoWheelCon extends RootController{

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
  }

  clickClose(){
    RoutersUtils.back();
    NumUtils.instance.updateHasWheelCount();
  }

  clickGet(Function() addNumCall){
    AdUtils.instance.showAd(
        adType: AdType.reward,
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