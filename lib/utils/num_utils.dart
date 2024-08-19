import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/ui/b/dialog/congratulations/congratulations_dialog.dart';
import 'package:wordland/ui/b/dialog/good_comment/good_comment_dialog.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/notifi/notifi_id.dart';
import 'package:wordland/utils/notifi/notifi_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';

class NumUtils{
  factory NumUtils() => _getInstance();

  static NumUtils get instance => _getInstance();

  static NumUtils? _instance;

  static NumUtils _getInstance() {
    _instance ??= NumUtils._internal();
    return _instance!;
  }

  var addDownCountNum=2,removeFailNum=2,lastRemoveFailQuestion="",
      addTimeNum=2,coinNum=0,userRemoveFailNum=0,useTimeNum=0,
      payType=0,wheelNum=3,
  wordDis=5,collectBubbleNum=0,hasCommentApp=false,appLaunchNum=0,todayAnswerNum=0,
  tipsNum=10,userMoneyNum=0.0;

  NumUtils._internal(){
    addDownCountNum=getTodayNum(StorageName.addDownCountNum, 2);
    removeFailNum=getTodayNum(StorageName.removeFailNum, 3);
    addTimeNum=getTodayNum(StorageName.addTimeNum, 3);
    wheelNum=getTodayNum(StorageName.wheelNum, 3);
    lastRemoveFailQuestion=StorageUtils.read<String>(StorageName.lastRemoveFailQuestion)??"";
    coinNum=StorageUtils.read<int>(StorageName.coinNum)??0;
    userRemoveFailNum=StorageUtils.read<int>(StorageName.userRemoveFailNum)??0;
    useTimeNum=StorageUtils.read<int>(StorageName.useTimeNum)??0;
    // payType=StorageUtils.read<int>(StorageName.payType)??0;
    collectBubbleNum=StorageUtils.read<int>(StorageName.collectBubbleNum)??0;
    userMoneyNum=StorageUtils.read<double>(StorageName.userMoneyNum)??0.0;
    hasCommentApp=StorageUtils.read<bool>(StorageName.hasCommentApp)??false;
    appLaunchNum=getTodayNum(StorageName.appLaunchNum, 0);
    todayAnswerNum=getTodayNum(StorageName.todayAnswerNum, 0);
    tipsNum=getTodayNum(StorageName.tipsNum, 10);
  }

  updateUserMoney(double num,Function() dismissDialog){
    userMoneyNum=(Decimal.parse("$num")+Decimal.parse("$userMoneyNum")).toDouble();
    StorageUtils.write(StorageName.userMoneyNum, userMoneyNum);
    if(num>0){
      RoutersUtils.dialog(
          barrierColor: Colors.transparent,
          child: CongratulationsDialog(
            addNum: num,
            call: (){
              EventCode.showMoneyLottie.sendMsg();
              dismissDialog.call();
            },
          )
      );
    }else{
      EventCode.updateCoinNum.sendMsg();
    }
  }

  updateAddDownCountNum(int add){
    addDownCountNum+=add;
    StorageUtils.write(StorageName.addDownCountNum, "${getTodayTime()}_$addDownCountNum");
  }

  updateRemoveFailNum(int add){
    removeFailNum+=add;
    if(add<0){
      userRemoveFailNum++;
      StorageUtils.write(StorageName.userRemoveFailNum, userRemoveFailNum);
    }
    StorageUtils.write(StorageName.removeFailNum, "${getTodayTime()}_$removeFailNum");
    EventCode.updateRemoveFailNum.sendMsg();
  }

  updateLastRemoveFailQuestion(String question){
    lastRemoveFailQuestion=question;
    StorageUtils.write(StorageName.lastRemoveFailQuestion,question);
  }

  updateTimeNum(int add){
    addTimeNum+=add;
    if(add<0){
      useTimeNum++;
      StorageUtils.write(StorageName.useTimeNum, useTimeNum);
    }
    StorageUtils.write(StorageName.addTimeNum, "${getTodayTime()}_$addTimeNum");
    EventCode.updateTimeNum.sendMsg();
  }

  updateCoinNum(int addNum){
    coinNum+=addNum;
    StorageUtils.write(StorageName.coinNum, coinNum);
    EventCode.showMoneyLottie.sendMsg();
  }

  String getNewUserBg() => "new_bg${payType+1}";
  String getPayTypeSel() => "pay_type_sel${payType+1}";

  updatePayType(index){
    payType=index;
    StorageUtils.write(StorageName.payType, payType);
    EventCode.updatePayType.sendMsg();
  }

  getFirebaseConfInfo()async{
    // wlandIntCd=(await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("wland_int_cd")).toInt(defaultNum: 3);
    wordDis=(await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("word_dis")).toInt(defaultNum: 5);
  }

  // updateHasWlandIntCd(AdPosId adPosId){
  //   hasWlandIntCd++;
  //   if(hasWlandIntCd%wlandIntCd==0){
  //     TbaUtils.instance.appEvent(AppEventName.wpdnd_ad_chance,params: {"ad_pos_id":adPosId.name});
  //     FlutterMaxAd.instance.showAd(
  //       adType: AdType.inter,
  //       adShowListener: AdShowListener(
  //         showAdSuccess: (ad,info){
  //           TbaUtils.instance.adEvent(ad, info, adPosId, AdFomat.int);
  //         },
  //         onAdHidden: (ad){
  //
  //         },
  //       ),
  //     );
  //   }
  // }

  updateWheelNum(int num){
    wheelNum+=num;
    StorageUtils.write(StorageName.wheelNum, "${getTodayTime()}_$wheelNum");
    EventCode.updateWheelNum.sendMsg();
  }

  updateCollectBubbleNum(){
    collectBubbleNum++;
    StorageUtils.write(StorageName.collectBubbleNum, collectBubbleNum);
  }

  bool checkCanShowCommentDialog() {
    if(appLaunchNum<2&&!hasCommentApp){
      return todayAnswerNum==2||todayAnswerNum==5;
    }
    return false;
  }

  updateAppLaunchNum(){
    appLaunchNum++;
    StorageUtils.write(StorageName.appLaunchNum, "${getTodayTime()}_$appLaunchNum");
    if(appLaunchNum==2){
      RoutersUtils.dialog(child: GoodCommentDialog());
    }
  }

  updateHasCommentApp(){
    hasCommentApp=true;
    StorageUtils.write(StorageName.hasCommentApp, true);
  }

  updateTodayAnswerRightNum(){
    todayAnswerNum++;
    StorageUtils.write(StorageName.todayAnswerNum, "${getTodayTime()}_$todayAnswerNum");
  }

  updateTipsNum(int addNum){
    tipsNum+=addNum;
    StorageUtils.write(StorageName.tipsNum, "${getTodayTime()}_$tipsNum");
    EventCode.updateHintNum.sendMsg();
  }
}