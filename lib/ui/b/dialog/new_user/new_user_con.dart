import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/export.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/guide/guide_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';

class NewUserCon extends RootController{
  var addNum=ValueConfUtils.instance.getCommonAddNum();
  List<String> payTypeList=["pay_type_uns1","pay_type_uns2","pay_type_uns3","pay_type_uns4","pay_type_uns5","pay_type_uns6"];

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
  }

  clickClose(){
    RoutersUtils.back();
    NumUtils.instance.updateCoinNum(addNum);
    GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showIncentDialog);
    NumUtils.instance.updateNewUserInt();
 }

  clickPayType(index){
    NumUtils.instance.updatePayType(index);
    update(["pay_type"]);
  }

  clickDouble(){
    AdUtils.instance.showAd(
      adType: AdType.reward,
      adShowListener: AdShowListener(
          onAdHidden: (MaxAd? ad) {
            RoutersUtils.back();
            NumUtils.instance.updateCoinNum(addNum*2);
            GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showIncentDialog);
          }),
    );
  }
}