import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/num_utils.dart';

class AddChanceCon extends RootController{

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
  }

  clickGet(bool isHeart){
    AdUtils.instance.showAd(
      adType: AdType.reward,
      adPosId: isHeart?AdPosId.wpdnd_rv_life:AdPosId.wpdnd_rv_int,
      adShowListener: AdShowListener(
        onAdHidden: (ad){
          RoutersUtils.back();
          if(isHeart){
            NumUtils.instance.updateHeartNum(3);
          }else{
            NumUtils.instance.updateTimeNum(1);
          }
        },
      ),
    );
  }
}