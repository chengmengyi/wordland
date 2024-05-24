import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wordland/enums/incent_from.dart';
import 'package:wordland/enums/sign_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/ui/b/dialog/new_user/new_user_dialog.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/utils.dart';

class GuideUtils{
  factory GuideUtils() => _getInstance();

  static GuideUtils get instance => _getInstance();

  static GuideUtils? _instance;

  static GuideUtils _getInstance() {
    _instance ??= GuideUtils._internal();
    return _instance!;
  }

  GuideUtils._internal();

  OverlayEntry? _overlayEntry;

  checkNewUserGuide({bool fromNewUserStep=false}){
    var newUserGuideStep = StorageUtils.read<int>(StorageName.newUserGuideStep)??NewUserGuideStep.showNewUserDialog;
    switch(newUserGuideStep){
      case NewUserGuideStep.showNewUserDialog:
        RoutersUtils.dialog(child: NewUserDialog());
        break;
      case NewUserGuideStep.showIncentDialog:
        RoutersUtils.showIncentDialog(incentFrom: IncentFrom.newUserGuide);
        break;
      case NewUserGuideStep.showSignDialog:
        RoutersUtils.showSignDialog(signFrom: SignFrom.newUserGuide);
        break;
      case NewUserGuideStep.showWordsGuide:
        EventCode.showNewUserWordsGuide.sendMsg();
        break;
      case NewUserGuideStep.completeNewUserGuide:
        if(!fromNewUserStep){
          _checkOldUserGuide();
        }
        break;
    }
  }

  _checkOldUserGuide(){
    if(!_checkHasCompleteOldUserGuide()){
      var oldUserStep = StorageUtils.read<int>(StorageName.oldUserGuideStep)??OldUserGuideStep.showSignDialog;
      switch(oldUserStep){
        case OldUserGuideStep.showSignDialog:
          RoutersUtils.showSignDialog(signFrom: SignFrom.oldUserGuide);
          break;
      }
    }
  }

  _checkHasCompleteOldUserGuide()=>(StorageUtils.read<String>(StorageName.lastOldUserGuideTimer)??"")==getTodayTime();

  updateNewUserGuideStep(int step,{bool fromNewUserStep=false}){
    StorageUtils.write(StorageName.newUserGuideStep, step);
    checkNewUserGuide(fromNewUserStep: fromNewUserStep);
  }

  updateOldUserGuideStep(int step){
    StorageUtils.write(StorageName.oldUserGuideStep, step);
    if(step==OldUserGuideStep.completeOldUserGuide){
      StorageUtils.write(StorageName.lastOldUserGuideTimer, getTodayTime());
    }
  }

  // bool checkCompleteNewOldGuide(){
  //   StorageUtils.read<int>(StorageName.newUserGuideStep)==NewUserGuideStep.completeNewUserGuide
  //       // &&_checkHasCompleteOldUserGuide();
  // }

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