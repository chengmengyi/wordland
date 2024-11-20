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
import 'package:plugin_b/b/dialog/add_chance/add_chance_dialog.dart';
import 'package:plugin_b/b/dialog/add_hint/add_hint_dialog.dart';
import 'package:plugin_b/b/dialog/answer_fail/answer_fail_dialog.dart';
import 'package:plugin_b/b/dialog/answer_right/answer_right_dialog.dart';
import 'package:plugin_b/guide/guide_step.dart';
import 'package:plugin_b/guide/home_bubble_guide_widget.dart';
import 'package:plugin_b/guide/new_guide_utils.dart';
import 'package:plugin_b/guide/wheel_guide_widget.dart';
import 'package:plugin_b/utils/progress/progress_bean.dart';
import 'package:plugin_b/utils/progress/progress_utils.dart';
import 'package:plugin_b/utils/task_utils.dart';
import 'package:plugin_b/utils/utils.dart';
import 'package:plugin_base/bean/answer_bean.dart';
import 'package:plugin_base/bean/question_bean.dart';
import 'package:plugin_base/bean/words_choose_bean.dart';
import 'package:plugin_base/enums/incent_from.dart';
import 'package:plugin_base/enums/sign_from.dart';
import 'package:plugin_base/enums/word_finger_from.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/export.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_data.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/storage/storage_name.dart';
import 'package:plugin_base/storage/storage_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/ad/ad_utils.dart';
import 'package:plugin_base/utils/adjust_point_utils.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/utils/data.dart';
import 'package:plugin_base/utils/new_notification/forground_service_utils.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/notifi/notifi_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/question_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/utils/withdraw_task_util.dart';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';

class BWordChildCon extends RootController{
  var downCountTime=30,_totalCountTime=30,signDownCountTimer="",achNum=0,_chooseAnswerIndex=-1;
  QuestionBean? currentQuestion;
  // List<WordsChooseBean> chooseList=[];
  // List<AnswerBean> answerList=[];
  Timer? _wordsTipsTimer,_signDownCountTimer;
  Offset? guideOffset;
  WordFingerFrom? _wordFingerFrom;
  GlobalKey wheelGlobalKey=GlobalKey();
  GlobalKey answerAGlobalKey=GlobalKey();
  GlobalKey answerBGlobalKey=GlobalKey();
  GlobalKey progressListGlobalKey=GlobalKey();
  ScrollController progressListController=ScrollController();

  @override
  void onInit() {
    super.onInit();
    _startSignDownCount();
  }

  @override
  void onReady() {
    super.onReady();
    NewGuideUtils.instance.checkNewUserGuide();
    _updateQuestionData(fromNext: false);
    NumUtils.instance.updateAppLaunchNum();
    update(["bubble"]);
    _refreshAchNum();
    _checkProgressPosition();
  }

  _updateQuestionData({bool fromNext=true}){
    // if(QuestionUtils.instance.bAnswerIndex==1&&fromNext){
    //   NewGuideUtils.instance.checkNewUserGuide();
    // }
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
    update(["question","choose","answer","level","bottom","wheel_pro","wheel_text"]);
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
    if(_wordFingerFrom==WordFingerFrom.bPackageNewUserGuide){
      NewGuideUtils.instance.updatePlanBNewUserStep(BPackageNewUserGuideStep.completed);
    }
    Future.delayed(const Duration(milliseconds: 500),(){
      if(result) {
        EventCode.answerRight.sendMsg();
        QuestionUtils.instance.updateBAnswerIndex(updateAnswerRight: true);
        update(["wheel_pro"]);
        NumUtils.instance.updateTodayAnswerRightNum();

        //-1没有 0box  1wheel
        var showBoxOrWheel = ProgressUtils.instance.checkShowBoxOrWheel();
        ProgressUtils.instance.updateProIndex();
        update(["pro"]);
        _checkProgressPosition();
        if(showBoxOrWheel==-1){
          RoutersUtils.dialog(
              child: AnswerRightDialog(
                isBox: false,
                addNum: NewValueUtils.instance.getRewardAddNum(),
                call: (money){
                  NumUtils.instance.updateUserMoney(money, (){
                    update(["level"]);
                    _updateQuestionData();
                  });
                },
              )
          );
        }else if(showBoxOrWheel==0){
          RoutersUtils.dialog(
              child: AnswerRightDialog(
                addNum: NewValueUtils.instance.getBoxAddNum(),
                isBox: true,
                call: (money){
                  NumUtils.instance.updateUserMoney(money, (){
                    update(["level"]);
                    _updateQuestionData();
                  });
                },
              )
          );
        }else{
          update(["level"]);
          NumUtils.instance.updateWheelNum(1);
          RoutersUtils.toNamed(
              routerName: RoutersData.bWheel,
              params: {"auto": true},
              backResult: (map) {
                if (null != map && map["back"] == true) {
                  _updateQuestionData();
                }
              }
          );
        }

        // if (QuestionUtils.instance.bAnswerRightNum % 4 == 0) {
        //   update(["level"]);
        //   NumUtils.instance.updateWheelNum(1);
        //   RoutersUtils.toNamed(
        //       routerName: RoutersData.bWheel,
        //       params: {"auto": true},
        //       backResult: (map) {
        //         if (null != map && map["back"] == true) {
        //           _updateQuestionData();
        //         }
        //       }
        //   );
        // }else{
        //   RoutersUtils.dialog(
        //       child: AnswerRightDialog(
        //         call: (money){
        //           NumUtils.instance.updateUserMoney(money, (){
        //             update(["level"]);
        //             _updateQuestionData();
        //           });
        //         },
        //       )
        //   );
        // }
      }else{
        QuestionUtils.instance.updateBAnswerIndex(updateAnswerRight: false);
        _updateQuestionData();
        // RoutersUtils.dialog(
        //     child: AnswerFailDialog(
        //       nextWordsCall: (next){
        //         if(next){
        //           QuestionUtils.instance.updateBAnswerIndex(updateAnswerRight: false);
        //           _updateQuestionData();
        //         }else{
        //           update(["answer"]);
        //         }
        //       },
        //     )
        // );
      }
      _chooseAnswerIndex=-1;
    });
  }

  _showBubbleGuideOverlay(){
    if(NewGuideUtils.instance.guidePlanB()){
      TbaUtils.instance.appEvent(AppEventName.userb_float_ball);
    }
    TbaUtils.instance.appEvent(AppEventName.float_guide);
    NewGuideUtils.instance.showGuideOver(
      context: context,
      widget: HomeBubbleGuideWidget(
        hideCall: (money){
          TbaUtils.instance.appEvent(AppEventName.float_guide_c);
          NumUtils.instance.updateUserMoney(money,(){
            if(NewGuideUtils.instance.guidePlanB()){
              NewGuideUtils.instance.updatePlanBNewUserStep(BPackageNewUserGuideStep.completed);
            }else{
              NewGuideUtils.instance.updateNewUserStep(NewNewUserGuideStep.complete);
            }
            update(["bubble"]);
          });
        },
      ),
    );
  }

  clickWheel(){
    TbaUtils.instance.appEvent(AppEventName.wheel_c);
    // if(QuestionUtils.instance.bAnswerIndex<3){
    //   showToast(Local.afterPass3);
    //   return;
    // }
    RoutersUtils.toNamed(routerName: RoutersData.bWheel);
  }

  clickAch(){
    TbaUtils.instance.appEvent(AppEventName.word_page_achievement);
    RoutersUtils.toNamed(
      routerName: RoutersData.bAch,
      backResult: (map){
        if(map?["back"]==true){
          _refreshAchNum();
        }
      }
    );
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

  String getBottomFuncIcon(index){
    switch(index){
      case 0:
        return "home18";
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
      case EventCode.bPackageShowWordsFinger:
      case EventCode.newUserGuideShowRightAnswerGuide:
        TbaUtils.instance.appEvent(AppEventName.userb_abc);
        _showWordsGuide(WordFingerFrom.bPackageNewUserGuide);
        // NewGuideUtils.instance.updatePlanBNewUserStep(BPackageNewUserGuideStep.showHomeBubbleGuide);
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
      case EventCode.signSuccess:
        _startSignDownCount();
        break;
      case EventCode.showWheelOverlayGuide:
        _showWheelOverlayGuide();
        break;
      case EventCode.refreshAchNum:
        _refreshAchNum();
        break;
      default:

        break;
    }
  }

  _refreshAchNum(){
    var list = TaskUtils.instance.getBTaskList();
    achNum=0;
    for (var value in list) {
      if(value.current>=value.total){
        achNum++;
      }
    }
    update(["ach"]);
  }

  _showWheelOverlayGuide(){
    var renderBox = wheelGlobalKey.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    TbaUtils.instance.appEvent(AppEventName.wheel_guide);
    NewGuideUtils.instance.showGuideOver(
      context: context,
      widget: WheelGuideWidget(
        offset: offset,
        hideCall: (){
          TbaUtils.instance.appEvent(AppEventName.wheel_guide_c);
          NewGuideUtils.instance.updatePlanBOldUser(BPackageOldUserGuideStep.completed);
          clickWheel();
        },
      ),
    );
  }

  _startSignDownCount(){
    _signDownCountTimer?.cancel();

    var lastSignTime = StorageUtils.read<int>(StorageName.lastSignTime)??0;
    DateTime now = DateTime.now();
    DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
    int tomorrowMidnightTimestamp = DateTime(tomorrow.year, tomorrow.month, tomorrow.day).millisecondsSinceEpoch;
    var time = tomorrowMidnightTimestamp-lastSignTime-(now.millisecondsSinceEpoch-lastSignTime);
    _signDownCountTimer=Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      time-=1000;
      if(time<=0||!WithdrawTaskUtils.instance.todaySigned){
        _signDownCountTimer?.cancel();
        return;
      }
      signDownCountTimer=millisecondsToHMS(time);
      update(["sign_down_count"]);
    });
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

  clickTopSign(){
    // if(WithdrawTaskUtils.instance.todaySigned){
    //   return;
    // }
    TbaUtils.instance.appEvent(AppEventName.word_page_sign);
    Utils.showSignDialog(signFrom: SignFrom.other);
  }

  int getNextWheelNum(){
    var i = QuestionUtils.instance.bAnswerIndex~/5;
    return (i+1)*5;
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

  String getProBg(ProgressBean progressBean){
    if(progressBean.proStatus==ProStatus.received){
      return "pro_bg1";
    }
    return "pro_bg2";
  }

  String getProIcon(ProgressBean progressBean){
    if(progressBean.proType==ProType.box){
      switch(progressBean.proStatus){
        case ProStatus.received: return "box1";
        case ProStatus.current: return "box2";
        default: return "box3";
      }
    }else{
      switch(progressBean.proStatus){
        case ProStatus.received: return "pro_wheel1";
        case ProStatus.current: return "pro_wheel2";
        default: return "pro_wheel3";
      }
    }
  }

  _checkProgressPosition(){
    var renderBox = progressListGlobalKey.currentContext!.findRenderObject() as RenderBox;
    var width = renderBox.size.width;
    var d = width~/(52.w);
    var indexWhere = ProgressUtils.instance.proList.indexWhere((element) => element.proStatus==ProStatus.current);
    if(indexWhere==-1){
      indexWhere=ProgressUtils.instance.proList.lastIndexWhere((element) => element.proStatus==ProStatus.received);
    }
    if(indexWhere>=d-1){
      progressListController.jumpTo((indexWhere-3)*(52.w));
    }
  }

  test()async{
    if(!kDebugMode){
      return;
    }
  }

  @override
  void onClose() {
    _stopWordsTipsTimer();
    progressListController.dispose();
    super.onClose();
  }
}