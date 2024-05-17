import 'dart:async';

import 'package:get/get.dart';
import 'package:wordland/bean/answer_bean.dart';
import 'package:wordland/bean/question_bean.dart';
import 'package:wordland/enums/level_status.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/a/dialog/answer_right/answer_right_dialog.dart';
import 'package:wordland/ui/a/dialog/pause/pause_dialog.dart';
import 'package:wordland/ui/a/dialog/remove_num/remove_num_dialog.dart';
import 'package:wordland/ui/a/dialog/time_out/time_out_dialog.dart';
import 'package:wordland/utils/data.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/play_music_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/utils.dart';

class AnswerCon extends RootController{
  var _largeIndex=0,_smallIndex=0,smallAnswerIndex=0,_levelStatus=LevelStatus.current,canClick=true,downCountTime=30,_totalCountTime=30,_pause=false;
  final List<QuestionBean> _questionList=[];
  QuestionBean? currentQuestion;
  List<String> chooseList=[];
  List<AnswerBean> answerList=[];
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    var params = RoutersUtils.getParams();
    _largeIndex=params["largeIndex"];
    _smallIndex=params["smallIndex"];
    _levelStatus=params["levelStatus"];
    _updateQuestionList();
    _countSmallAnswerIndex();
    PlayMusicUtils.instance.playMusic();
  }

  @override
  void onReady() {
    super.onReady();
    _updateQuestionData();
  }

  _updateQuestionList(){
    var list = QuestionUtils.instance.getQuestionListByIndex(_largeIndex, _smallIndex);
    _questionList.clear();
    _questionList.addAll(list);
  }

  _updateQuestionData(){
    currentQuestion=_questionList[smallAnswerIndex];
    chooseList.clear();
    answerList.clear();
    for (var value in currentQuestion?.answer.split("")??[]) {
      if(value.isNotEmpty){
        chooseList.add(value.toUpperCase());
        answerList.add(AnswerBean(result: "", isRight: false));
      }
    }
    currentQuestion?.answerList=chooseList.toList();
    var cha = 10-chooseList.length;
    for(int index=0;index<cha;index++){
      chooseList.add(charList.random());
    }
    chooseList.shuffle();
    update(["question","choose","answer","question_index","level","bottom"]);
    _startDownCountTimer();
  }

  _countSmallAnswerIndex(){
    if(_levelStatus!=LevelStatus.current){
      return;
    }
    var currentAnswerIndex = QuestionUtils.instance.currentAnswerIndex;
    var i = currentAnswerIndex-_largeIndex*30-_smallIndex*3;
    if(i>=0&&i<=2){
      smallAnswerIndex=i;
    }
  }

  clickAnswer(String char,int index){
    if(!canClick||char.isEmpty){
      return;
    }
    canClick=false;
    var indexWhere = answerList.indexWhere((element) => element.result.isEmpty);
    if(indexWhere>=0){
      var isRight = char==currentQuestion?.answerList?[indexWhere];
      answerList[indexWhere]=AnswerBean(result: char, isRight: isRight);
      update(["answer"]);
      Future.delayed(const Duration(milliseconds: 500),(){
        if(!isRight){
          answerList[indexWhere]=AnswerBean(result: "", isRight: false);
        }
        canClick=true;
        update(["answer"]);
        if(isRight&&answerList.last.result.isNotEmpty){
          _timer?.cancel();
          _updateNextQuestion();
        }
      });
    }
  }

  _updateNextQuestion(){
    NumUtils.instance.updateCoinNum(2);
    var total = 30*_largeIndex+3*_smallIndex+1;
    if(smallAnswerIndex!=2){
      smallAnswerIndex++;
      QuestionUtils.instance.updateCurrentAnswerIndex(_largeIndex,_smallIndex,smallAnswerIndex);
      _updateQuestionData();
    }else{
      RoutersUtils.dialog(
        child: AnswerRightDialog(
          clickContinue: (){
            smallAnswerIndex=0;
            if(total==QuestionUtils.instance.getQuestionNum()&&smallAnswerIndex==2){
              _largeIndex=0;
              _smallIndex=0;
              QuestionUtils.instance.resetCurrentAnswerIndex();
            }else{
              if(getLevel()==QuestionUtils.instance.currentLevel){
                QuestionUtils.instance.updateCurrentLevel();
                EventCode.unlockNewLevel.sendMsg();
              }
              if(_smallIndex>=9){
                _smallIndex=0;
                _largeIndex++;
              }else{
                _smallIndex++;
              }
              QuestionUtils.instance.updateCurrentAnswerIndex(_largeIndex,_smallIndex,smallAnswerIndex);
            }
            _updateQuestionList();
            _updateQuestionData();
          },
        )
      );
    }
  }

  clickBottom(index){
    switch(index){
      case 0:
        _pause=true;
        RoutersUtils.dialog(
            child: PauseDialog(
              quitCall: (){
                RoutersUtils.back();
              },
              dialogClose: (){
                _pause=false;
              },
            )
        );
        break;
      case 1:
        _clickRemoveFail();
        break;
      case 2:
        _clickAddNum();
        break;
    }
  }

  _clickAddNum(){
    if(NumUtils.instance.addTimeNum<=0){
      return;
    }
    downCountTime+=20;
    _totalCountTime+=20;
    NumUtils.instance.updateTimeNum(-1);
  }

  _clickRemoveFail(){
    if(NumUtils.instance.lastRemoveFailQuestion==currentQuestion?.question){
      showToast("Today's opportunity has been exhausted");
      return;
    }
    if(NumUtils.instance.removeFailNum<=0){
      RoutersUtils.dialog(child: RemoveNumDialog());
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
    var indexWhere = chooseList.indexWhere((element) => element.isNotEmpty&&currentQuestion?.answerList?.contains(element)==false);
    if(indexWhere>=0){
      chooseList[indexWhere]="";
      update(["choose"]);
      _removeFailChar(removeNum-1);
    }
  }

  String getBottomFuncIcon(index){
    switch(index){
      case 0:return "answer8";
      case 1:
        if(NumUtils.instance.lastRemoveFailQuestion==currentQuestion?.question){
          return "answer12";
        }else{
          return "answer9";
        }
      default:return "answer10";
    }
  }

  int getLevel() => 10*_largeIndex+_smallIndex+1;

  _startDownCountTimer(){
    downCountTime=30;
    _totalCountTime=30;
    _timer=Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if(!_pause){
        downCountTime--;
        update(["time"]);
        if(downCountTime<=0){
          timer.cancel();
          RoutersUtils.dialog(
              child: TimeOutDialog(
                clickCall: (){
                  RoutersUtils.back();
                },
              )
          );
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

  @override
  bool initEventbus() => true;

  @override
  void receiveBusMsg(EventCode code) {
    switch(code){
      case EventCode.updateRemoveFailNum:
      case EventCode.updateTimeNum:
        update(["bottom"]);
        break;
      default:

        break;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    PlayMusicUtils.instance.stopMusic();
    super.onClose();
  }
}