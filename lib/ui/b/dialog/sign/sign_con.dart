import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/enums/sign_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/task_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/utils/withdraw_task_util.dart';

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
    if(_signFrom==SignFrom.oldUserGuide){
      var largeLength = (QuestionUtils.instance.getQuestionNum()/30).ceil();
      var hasCompleteTask=false;
      for(int largeIndex=0;largeIndex<largeLength;largeIndex++){
        for(int smallIndex=0;smallIndex<10;smallIndex++){
          var show = (largeIndex*30+(smallIndex+1)*3)<=QuestionUtils.instance.getQuestionNum();
          if(show){
            var completeTask = (largeIndex*30+(smallIndex+1)*3)<=QuestionUtils.instance.bAnswerRightNum;
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


  clickClose(){
    AdUtils.instance.showAd(
      adType: AdType.inter,
      adPosId: AdPosId.wpdnd_step_close,
      adShowListener: AdShowListener(
        onAdHidden: (ad){
          RoutersUtils.back();
        },
        showAdFail: (ad,error){
          RoutersUtils.back();
        }
      ),
    );

  }
}