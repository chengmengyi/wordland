import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/root/congratulations/congratulations_dialog.dart';
import 'package:plugin_base/root/good_comment/good_comment_dialog.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/storage/storage_name.dart';
import 'package:plugin_base/storage/storage_utils.dart';
import 'package:plugin_base/utils/new_notification/forground_service_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';

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
  tipsNum=10,userMoneyNum=0.0,wl_newuser_guide="B",adShowNum=0,h5_show="1",_getCoinsDialogShowing=false,homeRightH5="";
  final List<String> _launchDaysList=[];
  final List<String> _alreadyUploadCoinsNumList=[];
  final List<String> _alreadyUploadAdNumList=[];

  NumUtils._internal();

  initInfo(){
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
    appLaunchNum=StorageUtils.read<int>(StorageName.appLaunchNum)??0;
    adShowNum=StorageUtils.read<int>(StorageName.adShowNum)??0;
    todayAnswerNum=getTodayNum(StorageName.todayAnswerNum, 0);
    tipsNum=getTodayNum(StorageName.tipsNum, 10);
    _initLaunchDaysList();
  }

  updateUserMoney(double num,Function() dismissDialog){
    userMoneyNum=(Decimal.parse("$num")+Decimal.parse("$userMoneyNum")).toDouble();
    StorageUtils.write(StorageName.userMoneyNum, userMoneyNum);
    _uploadLaunchDaysCoinsNum();
    ForegroundServiceUtils.instance.updateForegroundData();
    if(num>0){
      if(_getCoinsDialogShowing){
        return;
      }
      _getCoinsDialogShowing=true;
      RoutersUtils.dialog(
          barrierColor: Colors.transparent,
          child: CongratulationsDialog(
            addNum: num,
            call: (){
              _getCoinsDialogShowing=false;
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
    wl_newuser_guide=await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("wl_newuser_guide");
    h5_show=await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("h5_show");
    homeRightH5 =await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("c37_h5");
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
    EventCode.updateWithdrawTask.sendMsg();
  }

  updateAppLaunchNum(){
    appLaunchNum++;
    StorageUtils.write(StorageName.appLaunchNum, appLaunchNum);
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

  _initLaunchDaysList(){
    var s = StorageUtils.read<String>(StorageName.appLaunchDaysList)??"";
    if(s.isNotEmpty){
      _launchDaysList.clear();
      _launchDaysList.addAll(s.split("|"));
    }
    var todayTime = getTodayTime();
    if(!_launchDaysList.contains(todayTime)){
      _launchDaysList.add(todayTime);
      StorageUtils.write(StorageName.appLaunchDaysList, _launchDaysList.join("|"));
    }
    var t = StorageUtils.read<String>(StorageName.alreadyUploadCoinsNum)??"";
    if(t.isNotEmpty){
      _alreadyUploadCoinsNumList.clear();
      _alreadyUploadCoinsNumList.addAll(t.split("|"));
    }

    var k = StorageUtils.read<String>(StorageName.alreadyUploadAdNum)??"";
    if(k.isNotEmpty){
      _alreadyUploadAdNumList.clear();
      _alreadyUploadAdNumList.addAll(k.split("|"));
    }
  }

  _uploadLaunchDaysCoinsNum(){
    for (var value in [1,2,3,5,7,10,14]) {
      if(_launchDaysList.length==value){
        _uploadCoinsByDay(value);
      }
    }
    for (var value in [100,200,300,400,500,600,700,800]) {
      var stoKey = "coin_dall_$value";
      var hasUploadCoinsNum = _checkHasUploadCoinsNumByKey(stoKey);
      if(userMoneyNum>=value&&!hasUploadCoinsNum){
        TbaUtils.instance.appEvent("coin_dall",params: {"coin_numbers":"$value"});
        StorageUtils.write(stoKey, true);
      }
    }
  }

  _uploadCoinsByDay(int day){
    for (var value in [100,200,300,400,500,600,700,800]) {
      var stoKey = "coin_d${day}_$value";
      var hasUploadCoinsNum = _checkHasUploadCoinsNumByKey(stoKey);
      if(userMoneyNum>=value&&!_alreadyUploadCoinsNumList.contains("$value")&&!hasUploadCoinsNum){
        TbaUtils.instance.appEvent("coin_d$day",params: {"coin_numbers":"$value"});
        StorageUtils.write(stoKey, true);
        _alreadyUploadCoinsNumList.add("$value");
        StorageUtils.write(StorageName.alreadyUploadCoinsNum, _alreadyUploadCoinsNumList.join("|"));
      }
    }
  }

  bool _checkHasUploadCoinsNumByKey(String key)=> StorageUtils.read<bool>(key)??false;

  uploadLaunchDaysAdNum(){
    adShowNum++;
    StorageUtils.write(StorageName.adShowNum, adShowNum);

    for (var value in [1,2,3,5,7,10,14]) {
      if(_launchDaysList.length==value){
        _uploadAdNumByDay(value);
      }
    }
    for (var value in [5,10,15,20,25,30,35,40,45,50]) {
      var stoKey = "pv_dall_$value";
      var hasUploadCoinsNum = _checkHasUploadCoinsNumByKey(stoKey);
      if(adShowNum>=value&&!hasUploadCoinsNum){
        TbaUtils.instance.appEvent("pv_dall",params: {"pv_numbers":"$value"});
        StorageUtils.write(stoKey, true);
      }
    }
  }


  _uploadAdNumByDay(int day){
    for (var value in [5,10,15,20,25,30,35,40,45,50]) {
      var stoKey = "pv_d${day}_$value";
      var hasUploadCoinsNum = _checkHasUploadCoinsNumByKey(stoKey);
      if(adShowNum>=value&&!_alreadyUploadAdNumList.contains("$value")&&!hasUploadCoinsNum){
        TbaUtils.instance.appEvent("pv_d$day",params: {"pv_numbers":"$value"});
        StorageUtils.write(stoKey, true);
        _alreadyUploadAdNumList.add("$value");
        StorageUtils.write(StorageName.alreadyUploadAdNum, _alreadyUploadAdNumList.join("|"));
      }
    }
  }
}