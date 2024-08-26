import 'package:flutter/material.dart';
import 'package:plugin_a/dialog/new_user/new_user_dialog.dart';
import 'package:plugin_a/utils/guide/guide_step.dart';
import 'package:plugin_a/utils/utils.dart';
import 'package:plugin_base/enums/sign_from.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/storage/storage_name.dart';
import 'package:plugin_base/storage/storage_utils.dart';
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

  initInfo(){
    showBubble=checkNewUserGuideCompleted();
  }

  checkNewUserGuide(){
    var userStep = _getCurrentNewUserStep();
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


  bool checkCompletedWordsGuide(){
    var guideCompleted = _getCurrentNewUserStep();
    return guideCompleted==NewNewUserGuideStep.showHomeBubble.name||guideCompleted==NewNewUserGuideStep.complete.name;
  }

  bool checkNewUserGuideCompleted()=>_getCurrentNewUserStep()==NewNewUserGuideStep.complete.name;

  String _getCurrentNewUserStep()=>StorageUtils.read<String>(StorageName.newNewUserSteps)??NewNewUserGuideStep.newUserDialog.name;

  updateNewUserStep(NewNewUserGuideStep step){
    StorageUtils.write(StorageName.newNewUserSteps, step.name);
    if(step==NewNewUserGuideStep.complete){
      StorageUtils.write(StorageName.completeNewUserGuideTimer2, getTodayTime());
    }
    checkNewUserGuide();
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
}