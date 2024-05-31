import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/export.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/enums/sign_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/guide/guide_utils.dart';
import 'package:wordland/utils/guide/sign_guide_widget.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/task_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';

class SignCon extends RootController{
  SignFrom _signFrom=SignFrom.other;
  List<int> signList=ValueConfUtils.instance.getSignConfList();
  List<GlobalKey> globalList=[];

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
    for (var value in signList) {
      globalList.add(GlobalKey());
    }
    TbaUtils.instance.appEvent(AppEventName.wl_signin_pop,params: {"sign_from":_signFrom==SignFrom.newUserGuide?"new":_signFrom==SignFrom.oldUserGuide?"old":"other"});
  }

  @override
  void onReady() {
    super.onReady();
    _showGuideOver();
  }

  _showGuideOver(){
    if(_signFrom!=SignFrom.newUserGuide&&_signFrom!=SignFrom.oldUserGuide){
      return;
    }
    var renderBox = globalList[NumUtils.instance.signDays].currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    GuideUtils.instance.showGuideOver(
      context: context,
      widget: SignGuideWidget(
        offset: offset,
        hideCall: (){
          TbaUtils.instance.appEvent(AppEventName.wl_signin_pop_c,params: {"sign_from":_signFrom==SignFrom.newUserGuide?"new":_signFrom==SignFrom.oldUserGuide?"old":"other"});
          AdUtils.instance.showAd(
              adType: AdType.reward,
              adPosId: AdPosId.wpdnd_rv_sign_in,
              adShowListener: AdShowListener(
                  onAdHidden: (ad){
                    _watchAdCall(true);
                  },
                  showAdFail: (ad,error){
                    NumUtils.instance.updateHasWlandIntCd(AdPosId.wpdnd_step_close);
                    _watchAdCall(false);
                  }
              )
          );
        },
      )
    );
  }

  _watchAdCall(bool sign){
    if(sign){
      NumUtils.instance.sign();
    }
    RoutersUtils.back();
    if(_signFrom==SignFrom.newUserGuide){
      GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showWordsGuide);
    }else if(_signFrom==SignFrom.oldUserGuide){
      var largeLength = (QuestionUtils.instance.getQuestionNum()/30).ceil();
      var hasCompleteTask=false;
      for(int largeIndex=0;largeIndex<largeLength;largeIndex++){
        for(int smallIndex=0;smallIndex<10;smallIndex++){
          var show = (largeIndex*30+(smallIndex+1)*3)<=QuestionUtils.instance.getQuestionNum();
          if(show){
            var completeTask = (largeIndex*30+(smallIndex+1)*3)<=QuestionUtils.instance.bAnswerRightNum;
            var showBubble = TaskUtils.instance.showBubble(largeIndex, smallIndex);
            if(completeTask&&showBubble){
              TaskUtils.instance.largeIndex=largeIndex;
              TaskUtils.instance.smallIndex=smallIndex;
              hasCompleteTask=true;
            }
          }
        }
      }
      if(hasCompleteTask){
        EventCode.oldUserShowBubbleGuide.sendMsg();
      }else{
        EventCode.oldUserShowWordsGuide.sendMsg();
      }
    }
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
      adPosId: AdPosId.wpdnd_rv_sign_in,
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
    if(_signFrom==SignFrom.newUserGuide||_signFrom==SignFrom.oldUserGuide){
      NumUtils.instance.updateHasWlandIntCd(AdPosId.wpdnd_step_close);
    }
  }
}