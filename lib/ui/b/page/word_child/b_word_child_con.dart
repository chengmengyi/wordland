import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:get/get.dart';
import 'package:wordland/bean/answer_bean.dart';
import 'package:wordland/bean/question_bean.dart';
import 'package:wordland/bean/words_choose_bean.dart';
import 'package:wordland/enums/sign_from.dart';
import 'package:wordland/enums/word_finger_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_data.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/add_chance/add_chance_dialog.dart';
import 'package:wordland/ui/b/dialog/add_hint/add_hint_dialog.dart';
import 'package:wordland/ui/b/dialog/answer_fail/answer_fail_dialog.dart';
import 'package:wordland/ui/b/dialog/good_comment/good_comment_dialog.dart';
import 'package:wordland/ui/b/dialog/level/level_dialog.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/data.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/guide/guide_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/play_music_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';

class BWordChildCon extends RootController{
  var canClick=true,downCountTime=30,_totalCountTime=30,showBubble=true;
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
    Future((){
      GuideUtils.instance.checkNewUserGuide();
      _updateQuestionData();
    });
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //
  // }

  _updateQuestionData(){
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
    _startDownCountTimer();
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
        if(isRight&&answerList.last.result.isEmpty){
          _startWordsTipsTimer();
        }
        if(answerList.last.result.isNotEmpty){
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
            }else if(QuestionUtils.instance.bAnswerRightNum%3==0){
              RoutersUtils.dialog(
                  child: LevelDialog(
                    upLevel: true,
                    closeCall: (){
                      update(["level"]);
                      _updateQuestionData();
                    },
                  )
              );
            }else{
              RoutersUtils.dialog(
                  child: LevelDialog(
                    upLevel: false,
                    closeCall: (){
                      _updateQuestionData();
                    },
                  )
              );
            }
            if(NumUtils.instance.checkCanShowCommentDialog()){
              RoutersUtils.dialog(child: GoodCommentDialog());
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
        if(QuestionUtils.instance.getLevel()<3){
          showToast("After pass 3 levels you can play the Lucky Wheel");
          return;
        }
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
    _startDownCountTimer(reset: false);
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

  _startDownCountTimer({bool reset=true}){
    if(reset){
      downCountTime=30;
      _totalCountTime=30;
    }
    _timer=Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if(downCountTime<=0){
        timer.cancel();
        _showWordsGuide(null);
        return;
      }
      downCountTime--;
      update(["time"]);
    });
  }

  _startWordsTipsTimer(){
    if(NumUtils.instance.tipsNum<=0){
      _stopWordsTipsTimer();
      _wordsTipsTimer=Timer(const Duration(milliseconds: 5000), () {
        if(NumUtils.instance.tipsNum<=0){
          _showWordsGuide(WordFingerFrom.other);
        }
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
    var pro = QuestionUtils.instance.bAnswerRightNum%9/9;
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
        GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.completeNewUserGuide);
        break;
      case EventCode.showWordsGuideFromOther:
        _showWordsGuide(WordFingerFrom.cash_task);
        break;
      case EventCode.oldUserShowWordsGuide:
        _showWordsGuide(WordFingerFrom.old);
        GuideUtils.instance.updateOldUserGuideStep(OldUserGuideStep.completeOldUserGuide);
        break;
      // case EventCode.showSignDialog:
      //   if(!NumUtils.instance.todaySigned){
      //     RoutersUtils.showSignDialog(signFrom: SignFrom.other);
      //   }
      //   break;
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
            _showOrHideBubble(true);
            NumUtils.instance.updateCoinNum(ValueConfUtils.instance.getCommonAddNum());
          },
          showAdFail: (ad,err){
            _showOrHideBubble(true);
          }
      ),
    );
  }

  _showOrHideBubble(bool show){
    if(!show){
      showBubble=show;
      update(["bubble"]);
      return;
    }
    Future.delayed(Duration(seconds: NumUtils.instance.wordDis),(){
      showBubble=show;
      update(["bubble"]);
    });

  }

  @override
  void onClose() {
    _timer?.cancel();
    _stopWordsTipsTimer();
    PlayMusicUtils.instance.stopMusic();
    super.onClose();
  }
}