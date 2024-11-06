import 'package:flutter/material.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:plugin_b/b/dialog/new_user/new_user_dialog.dart';
import 'package:plugin_b/guide/guide_step.dart';
import 'package:plugin_b/utils/utils.dart';
import 'package:plugin_base/enums/sign_from.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/storage/storage_name.dart';
import 'package:plugin_base/storage/storage_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/question_utils.dart';
import 'package:plugin_base/utils/utils.dart';

class NewGuideUtils{
  factory NewGuideUtils() => _getInstance();

  static NewGuideUtils get instance => _getInstance();

  static NewGuideUtils? _instance;

  static NewGuideUtils _getInstance() {
    _instance ??= NewGuideUtils._internal();
    return _instance!;
  }

  NewGuideUtils._internal();

  var showBubble=false;
  OverlayEntry? _overlayEntry;

  checkNewUserGuide(){
    var userStep = _getCurrentNewUserStep();
    if(guidePlanB()){
      var indexWhere = BPackageNewUserGuideStep.values.indexWhere((element) => element.name==userStep);
      //老版本的新手步骤不在此版本的步骤中，视为已完成
      if(indexWhere<0){
        updatePlanBNewUserStep(BPackageNewUserGuideStep.completed);
        return;
      }
      if(userStep==BPackageNewUserGuideStep.newUserDialog.name){
        RoutersUtils.dialog(child: NewUserDialog());
      }else if(userStep==BPackageNewUserGuideStep.homeTopCashGuide.name){
        EventCode.showHomeTopCashGuide.sendMsg();
      }else if(userStep==BPackageNewUserGuideStep.rightAnswerGuide.name){
        EventCode.newUserGuideShowRightAnswerGuide.sendMsg();
      }else{
        showBubble=true;
        EventCode.showHomeBubbleGuide.sendMsg();
        // var completeNewUserGuideTimer = StorageUtils.read<String>(StorageName.completeNewUserGuideTimer2)??"";
        // if(completeNewUserGuideTimer!=getTodayTime()){
        //   _checkPlanBUserGuide();
        // }
      }

      // if(userStep==BPackageNewUserGuideStep.newUserDialog.name){
      //   RoutersUtils.dialog(child: NewUserDialog());
      // }else if(userStep==BPackageNewUserGuideStep.withdrawSignBtnGuide.name){
      //   EventCode.showWithdrawChild.sendMsg();
      //   EventCode.bPackageShowCashSignOverlay.sendMsg();
      // }else if(userStep==BPackageNewUserGuideStep.showSignDialog.name){
      //   Utils.showSignDialog(signFrom: SignFrom.newUserGuide);
      // }else if(userStep==BPackageNewUserGuideStep.level20Guide.name){
      //   EventCode.showWithdrawChild.sendMsg();
      //   EventCode.bPackageShowCashLevel20Overlay.sendMsg();
      // }else if(userStep==BPackageNewUserGuideStep.showRightWordsGuide.name){
      //   EventCode.showWordChild.sendMsg();
      //   EventCode.bPackageShowWordsFinger.sendMsg();
      // }else if(userStep==BPackageNewUserGuideStep.showHomeBubbleGuide.name){
      //   if(QuestionUtils.instance.bAnswerIndex>=1){
      //     EventCode.showHomeBubbleGuide.sendMsg();
      //   }
      // }else{
      //   showBubble=true;
      //   var completeNewUserGuideTimer = StorageUtils.read<String>(StorageName.completeNewUserGuideTimer2)??"";
      //   if(completeNewUserGuideTimer!=getTodayTime()){
      //     _checkPlanBUserGuide();
      //   }
      // }
    }else{
      if(userStep==NewNewUserGuideStep.newUserDialog.name){
        RoutersUtils.dialog(child: NewUserDialog());
      }else if(userStep==NewNewUserGuideStep.newUserWordsGuide.name){
        EventCode.showNewUserWordsGuide.sendMsg();
      }else if(userStep==NewNewUserGuideStep.showHomeBubble.name){
        if(QuestionUtils.instance.bAnswerIndex>=1){
          EventCode.showHomeBubbleGuide.sendMsg();
        }
      }else{
        showBubble=true;
        var completeNewUserGuideTimer = StorageUtils.read<String>(StorageName.completeNewUserGuideTimer2)??"";
        if(completeNewUserGuideTimer!=getTodayTime()){
          _checkOldUserGuide();
        }
      }
    }
  }

  _checkOldUserGuide(){
    var oldUserStep=OldUserGuideStep.showSignDialog;
    if((StorageUtils.read<String>(StorageName.lastOldUserGuideTimer)??"")==getTodayTime()){
      oldUserStep = StorageUtils.read<int>(StorageName.oldUserGuideStep)??OldUserGuideStep.showSignDialog;
    }
    switch(oldUserStep){
      case OldUserGuideStep.showSignDialog:
        Utils.showSignDialog(signFrom: SignFrom.oldUserGuide);
        break;
    }
  }

  _checkPlanBUserGuide(){
    var oldUserStep = _getPlanBOldUserStep();
    if(oldUserStep==BPackageOldUserGuideStep.showSignDialog.name){
      Utils.showSignDialog(signFrom: SignFrom.oldUserGuide);
    }else if(oldUserStep==BPackageOldUserGuideStep.showWheelGuideOverlay.name){
      EventCode.showWheelOverlayGuide.sendMsg();
    }
  }

  String _getPlanBOldUserStep(){
    try{
      var s = StorageUtils.read<String>(StorageName.planBOldUserGuide)??"";
      var list = s.split("_");
      if(list.first==getTodayTime()){
        return list.last;
      }
      return BPackageOldUserGuideStep.showSignDialog.name;
    }catch(e){
      return BPackageOldUserGuideStep.showSignDialog.name;
    }
  }

  bool checkCompletedWordsGuide()=>_getCurrentNewUserStep()==BPackageNewUserGuideStep.completed.name;

  bool checkNewUserGuideCompleted(){
    var currentNewUserStep = _getCurrentNewUserStep();
    return currentNewUserStep==NewNewUserGuideStep.complete.name||currentNewUserStep==BPackageNewUserGuideStep.completed.name;
  }

  String _getCurrentNewUserStep(){
    if(guidePlanB()){
      return StorageUtils.read<String>(StorageName.bPackageNewUserSteps)??BPackageNewUserGuideStep.newUserDialog.name;
    }else{
      return StorageUtils.read<String>(StorageName.newNewUserSteps)??NewNewUserGuideStep.newUserDialog.name;
    }
  }

  updateNewUserStep(NewNewUserGuideStep step){
    StorageUtils.write(StorageName.newNewUserSteps, step.name);
    if(step==NewNewUserGuideStep.complete){
      StorageUtils.write(StorageName.completeNewUserGuideTimer2, getTodayTime());
    }
    checkNewUserGuide();
  }


  updatePlanBNewUserStep(BPackageNewUserGuideStep step){
    StorageUtils.write(StorageName.bPackageNewUserSteps, step.name);
    if(step==BPackageNewUserGuideStep.completed){
      StorageUtils.write(StorageName.completeNewUserGuideTimer2, getTodayTime());
    }
    checkNewUserGuide();
  }

  updatePlanBOldUser(BPackageOldUserGuideStep step){
    StorageUtils.write(StorageName.planBOldUserGuide, "${getTodayTime()}_${step.name}");
    _checkPlanBUserGuide();
  }

  updateOldUserGuideStep(int step){
    StorageUtils.write(StorageName.oldUserGuideStep, step);
    if(step==OldUserGuideStep.completeOldUserGuide){
      StorageUtils.write(StorageName.lastOldUserGuideTimer, getTodayTime());
    }
  }

  showGuideOver({required BuildContext context,required Widget widget}){
    _overlayEntry=OverlayEntry(builder: (c)=>widget);
    Overlay.of(context).insert(_overlayEntry!);
  }

  hideGuideOver(){
    _overlayEntry?.remove();
    _overlayEntry=null;
  }

  guideOverShowing()=>null!=_overlayEntry;

  bool guidePlanB()=>FlutterCheckAdjustCloak.instance.getUserType()&&NumUtils.instance.wl_newuser_guide=="B";
}