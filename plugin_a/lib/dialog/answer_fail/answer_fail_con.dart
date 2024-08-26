import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/ad/ad_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';

class AnswerFailCon extends RootController{
  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
    TbaUtils.instance.appEvent(AppEventName.word_flase_pop);
  }

  clickAgain(Function(bool) nextWordsCall){
    TbaUtils.instance.appEvent(AppEventName.word_flase_pop_c);
    AdUtils.instance.showAd(
      adType: AdType.reward,
      adPosId: AdPosId.wpdnd_rv_wrong_ag,
      adShowListener: AdShowListener(
        onAdHidden: (ad){
          RoutersUtils.back();
          nextWordsCall.call(false);
        },
      ),
    );
  }

  clickContinue(Function(bool) nextWordsCall){
    TbaUtils.instance.appEvent(AppEventName.word_flase_pop_continue);
    AdUtils.instance.showAd(
      adType: AdType.inter,
      adPosId: AdPosId.wpdnd_rv_wrong_con,
      adShowListener: AdShowListener(
        onAdHidden: (ad){
          RoutersUtils.back();
          nextWordsCall.call(true);
        },
      ),
    );
  }
}