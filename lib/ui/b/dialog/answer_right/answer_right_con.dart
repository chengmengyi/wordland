import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/utils/tba_utils.dart';

class AnswerRightCon extends RootController{

  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.appEvent(AppEventName.word_ture_pop);
  }

  clickDouble(Function(double) call,double addNum){
    TbaUtils.instance.appEvent(AppEventName.word_ture_pop_c);
    AdUtils.instance.showAd(
      adType: AdType.reward,
      adPosId: AdPosId.wpdnd_rv_right_bounce,
      adShowListener: AdShowListener(
          onAdHidden: (ad){
            RoutersUtils.back();
            call.call(NewValueUtils.instance.getDoubleNum(addNum));
          }
      ),
    );
  }

  clickContinue(Function(double) call,double addNum){
    TbaUtils.instance.appEvent(AppEventName.word_ture_pop_continue);
    RoutersUtils.back();
    call.call(addNum);
  }
}