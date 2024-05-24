import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/num_utils.dart';

class AnswerFailCon extends RootController{
  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
  }

  clickAgain(Function(bool) nextWordsCall){
    AdUtils.instance.showAd(
      adType: AdType.reward,
      adShowListener: AdShowListener(
        onAdHidden: (ad){
          RoutersUtils.back();
          nextWordsCall.call(false);
        },
      ),
    );
  }

  clickContinue(Function(bool) nextWordsCall){
    RoutersUtils.back();
    nextWordsCall.call(true);
    NumUtils.instance.updateHasWlandIntCount();
  }
}