import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/bean/answer_bean.dart';
import 'package:wordland/bean/question_bean.dart';
import 'package:wordland/bean/words_choose_bean.dart';
import 'package:wordland/enums/level_status.dart';
import 'package:wordland/enums/sign_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_data.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/a/dialog/pause/pause_dialog.dart';
import 'package:wordland/ui/a/dialog/remove_num/remove_num_dialog.dart';
import 'package:wordland/ui/a/dialog/time_out/time_out_dialog.dart';
import 'package:wordland/ui/b/dialog/account/account_dialog.dart';
import 'package:wordland/ui/b/dialog/add_chance/add_chance_dialog.dart';
import 'package:wordland/ui/b/dialog/add_hint/add_hint_dialog.dart';
import 'package:wordland/ui/b/dialog/answer_fail/answer_fail_dialog.dart';
import 'package:wordland/ui/b/dialog/incent/incent_dialog.dart';
import 'package:wordland/ui/b/dialog/incomplete/incomplete_dialog.dart';
import 'package:wordland/ui/b/dialog/level/level_dialog.dart';
import 'package:wordland/ui/b/dialog/load_fail/load_fail_dialog.dart';
import 'package:wordland/ui/b/dialog/loading/loading_dialog.dart';
import 'package:wordland/ui/b/dialog/new_user/new_user_dialog.dart';
import 'package:wordland/ui/b/dialog/no_money/no_money_dialog.dart';
import 'package:wordland/ui/b/dialog/sign/sign_dialog.dart';
import 'package:wordland/ui/b/page/wheel/wheel_page.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/data.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/guide/guide_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/play_music_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/utils.dart';

class BWordChildCon extends RootController{
  var canClick=true,downCountTime=30,_totalCountTime=30,_pause=false,showBubble=true;
  QuestionBean? currentQuestion;
  List<WordsChooseBean> chooseList=[];
  List<AnswerBean> answerList=[];
  Timer? _timer;
  Offset? guideOffset;

  @override
  void onInit() {
    super.onInit();
    PlayMusicUtils.instance.playMusic();
    Future((){
      GuideUtils.instance.checkNewUserGuide();
    });
  }

  @override
  void onReady() {
    super.onReady();
    _updateQuestionData();
  }

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
    update(["question","choose","answer","level","bottom","wheel_pro"]);
    _startDownCountTimer();
  }

  clickAnswer(String char){
    if(!canClick||char.isEmpty){
      return;
    }
    _hideWordsGuide();
    if(NumUtils.instance.heartNum<=0){
      RoutersUtils.dialog(child: AddChanceDialog(isHeart: true,));
      return;
    }
    canClick=false;
    var indexWhere = answerList.indexWhere((element) => element.result.isEmpty);
    if(indexWhere>=0){
      var isRight = char==currentQuestion?.answerList?[indexWhere];
      answerList[indexWhere]=AnswerBean(result: char, isRight: isRight);
      update(["answer"]);
      Future.delayed(const Duration(milliseconds: 200),(){
        canClick=true;
        if(!isRight){
          NumUtils.instance.updateHeartNum(-1);
          RoutersUtils.dialog(
            child: AnswerFailDialog(
              nextWordsCall: (next){
                if(next){
                  QuestionUtils.instance.updateBAnswerIndex(updateAnswerRight: false);
                  _updateQuestionData();
                }else{
                  answerList[indexWhere]=AnswerBean(result: "", isRight: false);
                  update(["answer"]);
                }
              },
            )
          );
        }else{
          if(isRight&&answerList.last.result.isNotEmpty){
            _timer?.cancel();
            EventCode.answerRight.sendMsg();
            QuestionUtils.instance.updateBAnswerIndex(updateAnswerRight: true);
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
          }
        }
      });
    }
  }

  clickBottom(index){
    switch(index){
      case 0:
        _clickRemoveFail();
        break;
      case 1:
        _clickAddNum();
        break;
      case 2:
        if(QuestionUtils.instance.getLevel()<3){
          showToast("After pass 3 levels you can play the Lucky Wheel");
          return;
        }
        RoutersUtils.toNamed(routerName: RoutersData.wheel,params: {"auto":true});
        break;
    }
  }

  _clickAddNum(){
    if(NumUtils.instance.addTimeNum<=0){
      RoutersUtils.dialog(
        child: AddChanceDialog(isHeart: false,)
      );
      return;
    }
    downCountTime+=20;
    _totalCountTime+=20;
    NumUtils.instance.updateTimeNum(-1);
    _startDownCountTimer(reset: false);
  }

  _clickRemoveFail(){
    if(NumUtils.instance.removeFailNum<=0){
      RoutersUtils.dialog(
          child: AddHintDialog()
      );
      return;
    }
    _removeFailChar(2);
  }

  _removeFailChar(int removeNum){
    if(removeNum<=0){
      NumUtils.instance.updateLastRemoveFailQuestion(currentQuestion?.question??"");
      NumUtils.instance.updateRemoveFailNum(-1);
      return;
    }
    var indexWhere = chooseList.indexWhere((element) => element.words.isNotEmpty&&currentQuestion?.answerList?.contains(element.words)==false);
    if(indexWhere>=0){
      chooseList[indexWhere].words="";
      update(["choose"]);
      _removeFailChar(removeNum-1);
    }
  }

  String getBottomFuncIcon(index){
    switch(index){
      case 0:
        return "answer9";
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
      if(!_pause){
        downCountTime--;
        update(["time"]);
        if(downCountTime<=0){
          timer.cancel();
          _showWordsGuide();
        }
      }
    });
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
    var pro = QuestionUtils.instance.bAnswerRightNum~/3/3;
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
        update(["bottom"]);
        break;
      case EventCode.showNewUserWordsGuide:
        _showWordsGuide();
        GuideUtils.instance.updateNewUserGuideStep(NewUserGuideStep.completeNewUserGuide,fromNewUserStep: true);
        break;
      case EventCode.showWordsGuideFromOther:
        _showWordsGuide();
        break;
      case EventCode.oldUserShowWordsGuide:
        _showWordsGuide();
        GuideUtils.instance.updateOldUserGuideStep(OldUserGuideStep.completeOldUserGuide);
        break;
      default:

        break;
    }
  }

  _showWordsGuide(){
    if(null!=guideOffset){
      return;
    }
    var indexWhere = answerList.indexWhere((element) => element.result.isEmpty);
    if(indexWhere>=0&&indexWhere<(currentQuestion?.answerList?.length??0)){
      var index = chooseList.indexWhere((element) => element.words==currentQuestion?.answerList?[indexWhere]);
      if(index>=0){
        var renderBox = chooseList[index].globalKey.currentContext!.findRenderObject() as RenderBox;
        guideOffset = renderBox.localToGlobal(Offset.zero);
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
        clickAnswer(chooseList[index].words);
      }
    }
  }

  _hideWordsGuide(){
    guideOffset=null;
    update(["guide"]);
  }

  clickBubble(){
    _showOrHideBubble(false);
    AdUtils.instance.showAd(
      adType: AdType.reward,
      cancelShow: (){
        _showOrHideBubble(true);
      },
      adShowListener: AdShowListener(
          onAdHidden: (ad){
            _showOrHideBubble(true);
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
    PlayMusicUtils.instance.stopMusic();
    super.onClose();
  }
}