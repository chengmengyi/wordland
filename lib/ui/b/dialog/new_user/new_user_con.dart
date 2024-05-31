import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/export.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/guide/guide_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';

class NewUserCon extends RootController{
  var addNum=ValueConfUtils.instance.getCommonAddNum();
  List<String> payTypeList=["pay_type_uns1","pay_type_uns2","pay_type_uns3","pay_type_uns4","pay_type_uns5","pay_type_uns6"];

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
    TbaUtils.instance.appEvent(AppEventName.wl_newuser_pop);
  }

  clickClose(){
    RoutersUtils.back();
    NumUtils.instance.updateCoinNum(addNum);
    GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showIncentDialog);
    NumUtils.instance.updateHasWlandIntCd(AdPosId.wpdnd_step_close);
 }

  clickPayType(index){
    NumUtils.instance.updatePayType(index);
    update(["pay_type"]);
  }

  clickDouble()async{
    TbaUtils.instance.appEvent(AppEventName.wl_newuser_pop_c);
    AdUtils.instance.showAd(
      adType: AdType.reward,
      adPosId: AdPosId.wpdnd_rv_confirm,
      adShowListener: AdShowListener(
        onAdHidden: (MaxAd? ad) {
          RoutersUtils.back();
          NumUtils.instance.updateCoinNum(addNum*2);
          GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showIncentDialog);
        },
        showAdFail: (ad,error){
          RoutersUtils.back();
          NumUtils.instance.updateCoinNum(addNum);
          GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showIncentDialog);
        }
      ),
    );
  }
}