import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:get/get.dart';
import 'package:wordland/bean/answer_bean.dart';
import 'package:wordland/bean/question_bean.dart';
import 'package:wordland/bean/words_choose_bean.dart';
import 'package:wordland/enums/word_finger_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/language/local.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_data.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/add_chance/add_chance_dialog.dart';
import 'package:wordland/ui/b/dialog/add_hint/add_hint_dialog.dart';
import 'package:wordland/ui/b/dialog/answer_fail/answer_fail_dialog.dart';
import 'package:wordland/ui/b/dialog/answer_right/answer_right_dialog.dart';
import 'package:wordland/ui/b/dialog/good_comment/good_comment_dialog.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/data.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/guide/home_bubble_guide_widget.dart';
import 'package:wordland/utils/guide/new_guide_utils.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/utils/notifi/notifi_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/play_music_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/utils/withdraw_task_util.dart';

class BWordChildCon extends RootController{
  var canClick=true,downCountTime=30,_totalCountTime=30;
  QuestionBean? currentQuestion;
  List<WordsChooseBean> chooseList=[];
  List<AnswerBean> answerList=[];
  Timer? _timer,_wordsTipsTimer;
  Offset? guideOffset;
  WordFingerFrom? _wordFingerFrom;

  @override
  void onInit() {
    super.onInit();
    PlayMusicUtils.instance.playMusic();
    NumUtils.instance.updateAppLaunchNum();
  }

  @override
  void onReady() {
    super.onReady();
    NewGuideUtils.instance.checkNewUserGuide();
    _updateQuestionData(fromNext: false);
  }

  _updateQuestionData({bool fromNext=true}){
    if(QuestionUtils.instance.bAnswerIndex==1&&fromNext){
      NewGuideUtils.instance.checkNewUserGuide();
    }
    currentQuestion=QuestionUtils.instance.getBQuestion();
    chooseList.clear();
    answerList.clear();
    List<String> currentAnswerList=[];
    for (var value in currentQuestion?.answer.split("")??[]) {
      if(value.isNotEmpty){
        var words = value.toUpperCase();
        currentAnswerList.add(words);
        chooseList.add(WordsChooseBean(words: words, globalKey: GlobalKey()));
        answerList.add(AnswerBean(result: "", isRight: false));
      }
    }
    currentQuestion?.answerList=currentAnswerList;
    var cha = 10-chooseList.length;
    for(int index=0;index<cha;index++){
      chooseList.add(WordsChooseBean(words: charList.random(), globalKey: GlobalKey()));
    }
    chooseList.shuffle();
    if(answerList.isNotEmpty){
      answerList.first=AnswerBean(result: currentQuestion?.answerList?.first??"", isRight: true);
      if(answerList.length>3){
        answerList[1]=AnswerBean(result: currentQuestion?.answerList?[1]??"", isRight: true);
      }
    }
    update(["question","choose","answer","level","bottom","wheel_pro"]);
    _startWordsTipsTimer();
  }

  clickAnswer(String char){
    if(!canClick||char.isEmpty){
      return;
    }
    _hideWordsGuide();
    canClick=false;
    var indexWhere = answerList.indexWhere((element) => element.result.isEmpty);
    if(indexWhere>=0){
      var isRight = char==currentQuestion?.answerList?[indexWhere];
      answerList[indexWhere]=AnswerBean(result: char, isRight: isRight);
      update(["answer"]);
      Future.delayed(const Duration(milliseconds: 500),(){
        canClick=true;
        if(answerList.last.result.isEmpty){
          _startWordsTipsTimer();
        }else{
          if(isRight){
            TbaUtils.instance.appEvent(AppEventName.word_true_c);
            _timer?.cancel();
            EventCode.answerRight.sendMsg();
            QuestionUtils.instance.updateBAnswerIndex(updateAnswerRight: true);
            update(["wheel_pro"]);
            NumUtils.instance.updateTodayAnswerRightNum();
            if(QuestionUtils.instance.bAnswerRightNum%9==0){
              update(["level"]);
              NumUtils.instance.updateWheelNum(1);
              RoutersUtils.toNamed(
                  routerName: RoutersData.wheel,
                  params: {"auto":true},
                  backResult: (map){
                    if(null!=map&&map["back"]==true){
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
            TbaUtils.instance.appEvent(AppEventName.word_flase_c);
            RoutersUtils.dialog(
                child: AnswerFailDialog(
                  nextWordsCall: (next){
                    if(next){
                      QuestionUtils.instance.updateBAnswerIndex(updateAnswerRight: false);
                      _updateQuestionData();
                    }else{
                      for (var element in answerList) {
                        element.result="";
                        element.isRight=false;
                      }
                      update(["answer"]);
                    }
                  },
                )
            );
          }
        }
      });
    }
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
        // if(QuestionUtils.instance.bAnswerIndex<3){
        //   showToast(Local.afterPass3);
        //   return;
        // }
        RoutersUtils.toNamed(routerName: RoutersData.wheel);
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
    _timer?.cancel();
  }

  _clickHint(){
    if(NumUtils.instance.tipsNum<=0){
      RoutersUtils.dialog(
          child: AddHintDialog()
      );
      return;
    }
    var hasHint=false;
    for (var value in answerList) {
      if(null!=value.hint){
        hasHint=true;
        break;
      }
    }
    if(hasHint){
      return;
    }
    for(int index=0;index<answerList.length;index++){
      var bean = answerList[index];
      if(bean.result.isEmpty){
        bean.hint=currentQuestion?.answerList?[index]??"";
      }
    }
    NumUtils.instance.updateTipsNum(-1);
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
    var indexWhere = answerList.indexWhere((element) => element.result.isEmpty);
    if(indexWhere>=0&&indexWhere<(currentQuestion?.answerList?.length??0)){
      var index = chooseList.indexWhere((element) => element.words==currentQuestion?.answerList?[indexWhere]);
      if(index>=0){
        var renderBox = chooseList[index].globalKey.currentContext!.findRenderObject() as RenderBox;
        guideOffset = renderBox.localToGlobal(Offset.zero);
        _wordFingerFrom=wordFingerFrom;
        update(["guide"]);
      }
    }
  }

  clickGuide(){
    if(null==guideOffset){
      return;
    }
    var indexWhere = answerList.indexWhere((element) => element.result.isEmpty);
    if(indexWhere>=0&&indexWhere<(currentQuestion?.answerList?.length??0)){
      var index = chooseList.indexWhere((element) => element.words==currentQuestion?.answerList?[indexWhere]);
      if(index>=0){
        if(null!=_wordFingerFrom){
          TbaUtils.instance.appEvent(
              AppEventName.wl_word_c,
              params: {
                "word_from": _wordFingerFrom?.name??""
              },
          );
        }
        clickAnswer(chooseList[index].words);
      }
    }
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

  test()async{
    if(!kDebugMode){
      return;
    }
    print("kk====${QuestionUtils.instance.bAnswerRightNum}");
  }

  @override
  void onClose() {
    _timer?.cancel();
    _stopWordsTipsTimer();
    PlayMusicUtils.instance.stopMusic();
    super.onClose();
  }
}