import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:plugin_a/utils/guide/guide_step.dart';
import 'package:plugin_a/utils/guide/new_guide_utils.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';

class NewUserCon extends RootController{
  var addNum=NewValueUtils.instance.getNewReward();
  List<String> payTypeList=["pay_type_uns1","pay_type_uns2","pay_type_uns3","pay_type_uns4","pay_type_uns5","pay_type_uns6"];

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
    TbaUtils.instance.appEvent(AppEventName.wl_newuser_pop);
  }

 //  clickClose(){
 //    RoutersUtils.back();
 //    NumUtils.instance.updateCoinNum(addNum);
 //    GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showIncentDialog);
 //    NumUtils.instance.updateHasWlandIntCd(AdPosId.wpdnd_step_close);
 // }

  clickPayType(index){
    NumUtils.instance.updatePayType(index);
    update(["pay_type"]);
  }

  clickDouble()async{
    TbaUtils.instance.appEvent(AppEventName.wl_newuser_pop_c);
    RoutersUtils.back();
    NumUtils.instance.updateUserMoney(addNum,(){
      NewGuideUtils.instance.updateNewUserStep(NewNewUserGuideStep.newUserWordsGuide);
    });

    // AdUtils.instance.showAd(
    //   adType: AdType.reward,
    //   adPosId: AdPosId.wpdnd_rv_confirm,
    //   adShowListener: AdShowListener(
    //     onAdHidden: (MaxAd? ad) {
    //       RoutersUtils.back();
    //       NumUtils.instance.updateCoinNum(addNum*2);
    //       GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showIncentDialog);
    //     },
    //     showAdFail: (ad,error){
    //       RoutersUtils.back();
    //       NumUtils.instance.updateCoinNum(addNum);
    //       GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showIncentDialog);
    //     }
    //   ),
    // );
  }
}