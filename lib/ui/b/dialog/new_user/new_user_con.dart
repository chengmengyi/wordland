import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/guide/new_guide_utils.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/tba_utils.dart';

class NewUserCon extends RootController{
  var addNum=NewValueUtils.instance.getNewReward();
  List<String> payTypeList=["pay_type_uns1","pay_type_uns2","pay_type_uns3","pay_type_uns4","pay_type_uns5","pay_type_uns6"];

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
    TbaUtils.instance.appEvent(AppEventName.wl_newuser_pop,params: {"user_type":FlutterCheckAdjustCloak.instance.getUserType()?"B":"A"});
    if(NewGuideUtils.instance.guidePlanB()){
      TbaUtils.instance.appEvent(AppEventName.userb_newuser_pop);
    }
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
    TbaUtils.instance.appEvent(AppEventName.wl_newuser_pop_c,params: {"user_type":FlutterCheckAdjustCloak.instance.getUserType()?"B":"A"});
    RoutersUtils.back();
    NumUtils.instance.updateUserMoney(addNum,(){
      if(NewGuideUtils.instance.guidePlanB()){
        NewGuideUtils.instance.updatePlanBNewUserStep(BPackageNewUserGuideStep.withdrawSignBtnGuide);
      }else{
        NewGuideUtils.instance.updateNewUserStep(NewNewUserGuideStep.newUserWordsGuide);
      }
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