import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:get/get.dart';
import 'package:plugin_a/dialog/add_chance/add_chance_dialog.dart';
import 'package:plugin_a/dialog/add_hint/add_hint_dialog.dart';
import 'package:plugin_a/dialog/answer_fail/answer_fail_dialog.dart';
import 'package:plugin_a/dialog/answer_right/answer_right_dialog.dart';
import 'package:plugin_a/utils/guide/guide_step.dart';
import 'package:plugin_a/utils/guide/home_bubble_guide_widget.dart';
import 'package:plugin_a/utils/guide/new_guide_utils.dart';
import 'package:plugin_base/bean/answer_bean.dart';
import 'package:plugin_base/bean/question_bean.dart';
import 'package:plugin_base/bean/words_choose_bean.dart';
import 'package:plugin_base/enums/word_finger_from.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_data.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/ad/ad_utils.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/utils/data.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/notifi/notifi_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/question_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';

class BWordChildCon extends RootController{
  var downCountTime=30,_totalCountTime=30,_chooseAnswerIndex=-1;
  QuestionBean? currentQuestion;
  // List<WordsChooseBean> chooseList=[];
  // List<AnswerBean> answerList=[];
  Timer? _wordsTipsTimer;
  Offset? guideOffset;
  WordFingerFrom? _wordFingerFrom;
  GlobalKey answerAGlobalKey=GlobalKey();
  GlobalKey answerBGlobalKey=GlobalKey();

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onReady() {
    super.onReady();
    NewGuideUtils.instance.checkNewUserGuide();
    _updateQuestionData(fromNext: false);
    NumUtils.instance.updateAppLaunchNum();
  }

  _updateQuestionData({bool fromNext=true}){
    if(QuestionUtils.instance.bAnswerIndex==1&&fromNext){
      NewGuideUtils.instance.checkNewUserGuide();
    }
    currentQuestion=QuestionUtils.instance.getBQuestion();
    // chooseList.clear();
    // answerList.clear();
    // List<String> currentAnswerList=[];
    // for (var value in currentQuestion?.answer.split("")??[]) {
    //   if(value.isNotEmpty){
    //     var words = value.toUpperCase();
    //     currentAnswerList.add(words);
    //     chooseList.add(WordsChooseBean(words: words, globalKey: GlobalKey()));
    //     answerList.add(AnswerBean(result: "", isRight: false));
    //   }
    // }
    // currentQuestion?.answerList=currentAnswerList;
    // var cha = 10-chooseList.length;
    // for(int index=0;index<cha;index++){
    //   chooseList.add(WordsChooseBean(words: charList.random(), globalKey: GlobalKey()));
    // }
    // chooseList.shuffle();
    // if(answerList.isNotEmpty){
    //   answerList.first=AnswerBean(result: currentQuestion?.answerList?.first??"", isRight: true);
    //   if(answerList.length>3){
    //     answerList[1]=AnswerBean(result: currentQuestion?.answerList?[1]??"", isRight: true);
    //   }
    // }
    update(["question","answer","level","bottom","wheel_pro"]);
    _startWordsTipsTimer();
  }

  clickAnswer(int index){
    if(_chooseAnswerIndex!=-1){
      return;
    }
    _stopWordsTipsTimer();
    _hideWordsGuide();
    _chooseAnswerIndex=index;
    update(["answer"]);
    var result = _checkAnswerResult();
    if(result){
      TbaUtils.instance.appEvent(AppEventName.word_true_c);
    }else{
      TbaUtils.instance.appEvent(AppEventName.word_flase_c);
    }
    Future.delayed(const Duration(milliseconds: 500),(){
      if(result) {
        EventCode.answerRight.sendMsg();
        QuestionUtils.instance.updateBAnswerIndex(updateAnswerRight: true);
        update(["wheel_pro"]);
        NumUtils.instance.updateTodayAnswerRightNum();
        if (QuestionUtils.instance.bAnswerRightNum % 9 == 0) {
          update(["level"]);
          NumUtils.instance.updateWheelNum(1);
          RoutersUtils.toNamed(
              routerName: RoutersData.aWheel,
              params: {"auto": true},
              backResult: (map) {
                if (null != map && map["back"] == true) {
                  _updateQuestionData();
                }
              }
          );
        }else{
          RoutersUtils.dialog(
              child: AnswerRightDialog(
                call: (money){
                  NumUtils.instance.updateUserMoney(money, (){
                    update(["level"]);
                    _updateQuestionData();
                  });
                },
              )
          );
        }
      }else{
        RoutersUtils.dialog(
            child: AnswerFailDialog(
              nextWordsCall: (next){
                if(next){
                  QuestionUtils.instance.updateBAnswerIndex(updateAnswerRight: false);
                  _updateQuestionData();
                }else{
                  // for (var element in answerList) {
                  //   element.result="";
                  //   element.isRight=false;
                  // }
                  update(["answer"]);
                }
              },
            )
        );
      }
      _chooseAnswerIndex=-1;
    });
  }

  _showBubbleGuideOverlay(){
    TbaUtils.instance.appEvent(AppEventName.float_guide);
    NewGuideUtils.instance.showGuideOver(
      context: context,
      widget: HomeBubbleGuideWidget(
        hideCall: (money){
          TbaUtils.instance.appEvent(AppEventName.float_guide_c);
          NumUtils.instance.updateUserMoney(money,(){
            NewGuideUtils.instance.updateNewUserStep(NewNewUserGuideStep.complete);
            update(["bubble"]);
          });
        },
      ),
    );
  }

  clickBottom(index){
    switch(index){
      case 0:
        TbaUtils.instance.appEvent(AppEventName.hint_c);
        _clickHint();
        break;
      case 1:
        TbaUtils.instance.appEvent(AppEventName.add_time_c);
        _clickAddNum();
        break;
      case 2:
        TbaUtils.instance.appEvent(AppEventName.wheel_c);
        if(QuestionUtils.instance.bAnswerIndex<3){
          showToast("After pass 3 levels you can play the Lucky Wheel");
          return;
        }
        RoutersUtils.toNamed(routerName: RoutersData.aWheel);
        break;
    }
  }

  _clickAddNum(){
    if(NumUtils.instance.addTimeNum<=0){
      RoutersUtils.dialog(child: AddChanceDialog());
      return;
    }
    downCountTime+=20;
    _totalCountTime+=20;
    NumUtils.instance.updateTimeNum(-1);
  }

  _clickHint(){
    if(NumUtils.instance.tipsNum<=0){
      RoutersUtils.dialog(
          child: AddHintDialog()
      );
      return;
    }
    // var hasHint=false;
    // for (var value in answerList) {
    //   if(null!=value.hint){
    //     hasHint=true;
    //     break;
    //   }
    // }
    // if(hasHint){
    //   return;
    // }
    // for(int index=0;index<answerList.length;index++){
    //   var bean = answerList[index];
    //   if(bean.result.isEmpty){
    //     bean.hint=currentQuestion?.answerList?[index]??"";
    //   }
    // }
    NumUtils.instance.updateTipsNum(-1);
    _showWordsGuide(WordFingerFrom.other);
    update(["answer"]);
  }

  String getBottomFuncIcon(index){
    switch(index){
      case 0:
        return "answer14";
      case 1:return "answer10";
      default:return "answer13";
    }
  }

  _startWordsTipsTimer(){
    if(NewGuideUtils.instance.checkCompletedWordsGuide()){
      _stopWordsTipsTimer();
      _wordsTipsTimer=Timer(const Duration(milliseconds: 5000), () {
        _showWordsGuide(WordFingerFrom.other);
      });
    }
  }

  _stopWordsTipsTimer(){
    _wordsTipsTimer?.cancel();
    _wordsTipsTimer=null;
  }

  double getTimeProgress(){
    var pro = (_totalCountTime-downCountTime)/_totalCountTime;
    if(pro<=0){
      return 0.0;
    }else if(pro>=1){
      return 1.0;
    }else{
      return pro;
    }
  }

  double getWheelProgress(){
    var pro = QuestionUtils.instance.bAnswerIndex%9/9;
    if(pro<=0){
      return 0.0;
    }else if(pro>=1){
      return 1.0;
    }else{
      return pro;
    }
  }

  @override
  bool initEventbus() => true;

  @override
  void receiveBusMsg(EventCode code) {
    switch(code){
      case EventCode.updateRemoveFailNum:
      case EventCode.updateTimeNum:
      case EventCode.updateWheelNum:
      case EventCode.updateHintNum:
        update(["bottom"]);
        break;
      case EventCode.showNewUserWordsGuide:
        _showWordsGuide(WordFingerFrom.guide);
        // GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.completeNewUserGuide);
        NewGuideUtils.instance.updateNewUserStep(NewNewUserGuideStep.showHomeBubble);
        break;
      case EventCode.showWordsGuideFromOther:
        _showWordsGuide(WordFingerFrom.cash_task);
        break;
      case EventCode.oldUserShowWordsGuide:
        _showWordsGuide(WordFingerFrom.old);
        NewGuideUtils.instance.updateOldUserGuideStep(OldUserGuideStep.completeOldUserGuide);
        break;
      // case EventCode.showSignDialog:
      //   if(!NumUtils.instance.todaySigned){
      //     RoutersUtils.showSignDialog(signFrom: SignFrom.other);
      //   }
      //   break;
      case EventCode.showHomeBubbleGuide:
        update(["bubble"]);
        if(QuestionUtils.instance.bAnswerIndex==1){
          _showBubbleGuideOverlay();
        }
        break;
      default:

        break;
    }
  }

  _showWordsGuide(WordFingerFrom? wordFingerFrom){
    if(null!=guideOffset){
      return;
    }
    var key = currentQuestion?.answer=="a"?answerAGlobalKey:answerBGlobalKey;
    var renderBox = key.currentContext!.findRenderObject() as RenderBox;
    guideOffset = renderBox.localToGlobal(Offset.zero);
    _wordFingerFrom=wordFingerFrom;
    update(["guide"]);
  }

  clickGuide(){
    if(null==guideOffset){
      return;
    }
    TbaUtils.instance.appEvent(
      AppEventName.wl_word_c,
      params: {
        "word_from": _wordFingerFrom?.name??""
      },
    );
    clickAnswer(currentQuestion?.answer=="a"?0:1);
  }

  _hideWordsGuide(){
    guideOffset=null;
    update(["guide"]);
  }

  clickBubble(){
    TbaUtils.instance.appEvent(AppEventName.word_float_pop);
    _showOrHideBubble(false);
    NumUtils.instance.updateCollectBubbleNum();
    AdUtils.instance.showAd(
      adType: AdType.reward,
      adPosId: AdPosId.wpdnd_rv_float_gold,
      adShowListener: AdShowListener(
          onAdHidden: (ad){
            NumUtils.instance.updateUserMoney(NewValueUtils.instance.getFloatAddNum(), (){
              _showOrHideBubble(true);
            });
          },
          showAdFail: (ad,err){
            _showOrHideBubble(true);
          }
      ),
    );
  }

  _showOrHideBubble(bool show){
    if(!show){
      NewGuideUtils.instance.showBubble=show;
      update(["bubble"]);
      return;
    }
    Future.delayed(Duration(seconds: NumUtils.instance.wordDis),(){
      NewGuideUtils.instance.showBubble=show;
      update(["bubble"]);
    });

  }

  bool _checkAnswerResult(){
    if(_chooseAnswerIndex==0){
      return currentQuestion?.answer=="a";
    }
    if(_chooseAnswerIndex==1){
      return currentQuestion?.answer=="b";
    }
    return false;
  }

  String getAnswerBg(int index){
    if(_chooseAnswerIndex==-1){
      return "answer_normal_bg";
    }
    if(_chooseAnswerIndex==index){
      return _checkAnswerResult()?"answer_right_bg":"answer_error_bg";
    }
    return "answer_normal_bg";
  }

  Color getAnswerTextColor(int index){
    if(_chooseAnswerIndex==-1){
      return colorA44400;
    }
    if(_chooseAnswerIndex==index){
      return colorFFFFFF;
    }
    return colorA44400;
  }

  test()async{
    if(!kDebugMode){
      return;
    }
  }

  @override
  void onClose() {
    _stopWordsTipsTimer();
    super.onClose();
  }
}