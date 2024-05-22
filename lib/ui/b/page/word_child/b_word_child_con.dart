import 'dart:async';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/bean/answer_bean.dart';
import 'package:wordland/bean/question_bean.dart';
import 'package:wordland/enums/level_status.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/a/dialog/pause/pause_dialog.dart';
import 'package:wordland/ui/a/dialog/remove_num/remove_num_dialog.dart';
import 'package:wordland/ui/a/dialog/time_out/time_out_dialog.dart';
import 'package:wordland/ui/b/dialog/account/account_dialog.dart';
import 'package:wordland/ui/b/dialog/add_chance/add_chance_dialog.dart';
import 'package:wordland/ui/b/dialog/add_hint/add_hint_dialog.dart';
import 'package:wordland/ui/b/dialog/incent/incent_dialog.dart';
import 'package:wordland/ui/b/dialog/incomplete/incomplete_dialog.dart';
import 'package:wordland/ui/b/dialog/level/level_dialog.dart';
import 'package:wordland/ui/b/dialog/load_fail/load_fail_dialog.dart';
import 'package:wordland/ui/b/dialog/loading/loading_dialog.dart';
import 'package:wordland/ui/b/dialog/new_user/new_user_dialog.dart';
import 'package:wordland/ui/b/dialog/no_money/no_money_dialog.dart';
import 'package:wordland/ui/b/dialog/sign/sign_dialog.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/data.dart';
import 'package:wordland/utils/guide/guide_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/play_music_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/utils.dart';

class BWordChildCon extends RootController{
  var canClick=true,downCountTime=30,_totalCountTime=30,_pause=false;
  QuestionBean? currentQuestion;
  List<String> chooseList=[];
  List<AnswerBean> answerList=[];
  Timer? _timer;


  @override
  void onInit() {
    super.onInit();
    PlayMusicUtils.instance.playMusic();
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
    update(["question","choose","answer","level","bottom"]);
    _startDownCountTimer();
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
          // _updateNextQuestion();
          QuestionUtils.instance.updateBAnswerIndex();
          _updateQuestionData();
        }
      });
    }
  }

  clickBottom(index){
    GuideUtils.instance.checkNewUserGuide();

    // RoutersUtils.dialog(
    //   child: LoadingDialog(
    //     adType: AdType.reward,
    //     result: (success){
    //
    //     },
    //   ),
    // );
    // switch(index){
    //   case 0:
    //     _clickRemoveFail();
    //     break;
    //   case 1:
    //     _clickAddNum();
    //     break;
    // }
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
      case 0:
        if(NumUtils.instance.lastRemoveFailQuestion==currentQuestion?.question){
          return "answer12";
        }else{
          return "answer9";
        }
      case 1:return "answer10";
      default:return "answer13";
    }
  }

  int getLevel() => QuestionUtils.instance.bAnswerIndex~/5+1;

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