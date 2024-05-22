import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/export.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/enums/sign_from.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/guide/guide_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';

class SignCon extends RootController{
  SignFrom _signFrom=SignFrom.other;
  List<int> signList=ValueConfUtils.instance.getSignConfList();

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
  }

  setInfo(SignFrom signFrom){
    _signFrom=signFrom;
  }

  int getSignNum(index){
    try{
      return signList[index];
    }catch(e){
      return 2000;
    }
  }

  clickItem(index){
    if(NumUtils.instance.signDays-1==index){
      return;
    }
    AdUtils.instance.showAd(
      adType: AdType.reward,
      adShowListener: AdShowListener(
        onAdHidden: (MaxAd? ad) {
          NumUtils.instance.sign();
          RoutersUtils.back();
          NumUtils.instance.updateCoinNum(getSignNum(index));
        }
      )
    );
  }

  clickClose(){
    RoutersUtils.back();
    if(_signFrom==SignFrom.newUserGuide){
      NumUtils.instance.updateNewUserInt();
      GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showWordsGuide);
    }
  }
}