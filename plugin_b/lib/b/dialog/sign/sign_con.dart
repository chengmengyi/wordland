import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:get/get.dart';
import 'package:plugin_b/guide/guide_step.dart';
import 'package:plugin_b/guide/new_guide_utils.dart';
import 'package:plugin_b/utils/task_utils.dart';
import 'package:plugin_base/enums/sign_from.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/ad/ad_utils.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/question_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/utils/withdraw_task_util.dart';

class SignCon extends RootController{
  SignFrom _signFrom=SignFrom.other;
  List<int> signList=NewValueUtils.instance.getSignList();
  List<GlobalKey> globalList=[];
  Offset? guideOffset;

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
    for (var value in signList) {
      globalList.add(GlobalKey());
    }
    if(NewGuideUtils.instance.guidePlanB()){
      TbaUtils.instance.appEvent(AppEventName.userb_sign);
    }
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
    var renderBox = globalList[WithdrawTaskUtils.instance.signDays].currentContext!.findRenderObject() as RenderBox;
    guideOffset = renderBox.localToGlobal(Offset.zero);
    update(["guide"]);
  }

  setInfo(SignFrom signFrom){
    _signFrom=signFrom;
    TbaUtils.instance.appEvent(AppEventName.wl_signin_pop,params: {"sign_from":_signFrom==SignFrom.newUserGuide?"new":_signFrom==SignFrom.oldUserGuide?"old":"other"});
  }

  int getSignNum(index){
    try{
      return signList[index];
    }catch(e){
      return 5;
    }
  }

  clickItem(index){
    if(WithdrawTaskUtils.instance.signDays!=index){
      return;
    }
    if(WithdrawTaskUtils.instance.todaySigned){
      showToast(Local.pleaseSignInTomorrow.tr);
      return;
    }
    TbaUtils.instance.appEvent(
        AppEventName.wl_signin_pop_c,
        params: {"sign_from":_signFrom==SignFrom.newUserGuide?"new":_signFrom==SignFrom.oldUserGuide?"old":"other"}
    );
    AdUtils.instance.showAd(
        adType: AdType.reward,
        adPosId: AdPosId.wpdnd_rv_sign_in,
        adShowListener: AdShowListener(
            onAdHidden: (ad){
              WithdrawTaskUtils.instance.sign();
              NumUtils.instance.updateUserMoney(getSignNum(index).toDouble(),(){
                _watchAdCall();
              });
            },
            showAdFail: (ad,error){
              _watchAdCall();
            }
        )
    );
  }

  _watchAdCall(){
    RoutersUtils.back();
    // if(_signFrom==SignFrom.newUserGuide){
    //   GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.showWordsGuide);
    // }else

    if(_signFrom==SignFrom.newUserGuide&&NewGuideUtils.instance.guidePlanB()){
      NewGuideUtils.instance.updatePlanBNewUserStep(BPackageNewUserGuideStep.level20Guide);
    }

    if(_signFrom==SignFrom.oldUserGuide){
      if(NewGuideUtils.instance.guidePlanB()){
        NewGuideUtils.instance.updatePlanBOldUser(BPackageOldUserGuideStep.showWheelGuideOverlay);
      }else{
        var largeLength = (QuestionUtils.instance.getQuestionNum()/10).ceil();
        var hasCompleteTask=false;
        for(int largeIndex=0;largeIndex<largeLength;largeIndex++){
          for(int smallIndex=0;smallIndex<10;smallIndex++){
            var show = (largeIndex*10+smallIndex+1)<=QuestionUtils.instance.getQuestionNum();
            if(show){
              var completeTask = (largeIndex*10+smallIndex+1)<=QuestionUtils.instance.bAnswerRightNum;
              var showBubble = TaskUtils.instance.canReceiveTaskBubble(largeIndex, smallIndex);
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
  }


  clickClose(){
    AdUtils.instance.showAd(
      adType: AdType.inter,
      adPosId: AdPosId.wpdnd_step_close,
      adShowListener: AdShowListener(
        onAdHidden: (ad){
          _watchAdCall();
        },
        showAdFail: (ad,error){
          _watchAdCall();
        }
      ),
    );
  }
}