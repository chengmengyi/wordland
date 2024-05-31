import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';

class LevelCon extends RootController{
  bool upLevel=false;
  var addNum=ValueConfUtils.instance.getCommonAddNum();

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
  }

  clickClose(Function() closeCall){
    RoutersUtils.back();
    NumUtils.instance.updateCoinNum(addNum);
    closeCall.call();
    NumUtils.instance.updateHasWlandIntCd(AdPosId.wpdnd_int_answer);
  }

  clickDouble(Function() closeCall){
    AdUtils.instance.showAd(
        adType: AdType.reward,
        adPosId: upLevel?AdPosId.wpdnd_rv_next_level:AdPosId.wpdnd_rv_right_bounce,
        adShowListener: AdShowListener(
            onAdHidden: (ad){
              RoutersUtils.back();
              NumUtils.instance.updateCoinNum(addNum*2);
              closeCall.call();
            },
        )
    );
  }

  int getLevel()=>QuestionUtils.instance.bAnswerRightNum~/3+1;

  String getLevelItemIcon(index,upLevel){
    if(upLevel){
      return "sign6";
    }else{
      if(QuestionUtils.instance.bAnswerRightNum%3<=index){
        return "sign5";
      }
      return "sign6";
    }
  }
}