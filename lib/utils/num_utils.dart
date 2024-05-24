import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
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
      payType=0,signDays=0,todaySigned=false,newUserInt=3,hasNewUserCount=0,
  wlandInt=3,hasWlandIntCount=0,heartNum=3,wheelNum=3,wheelInt=3,hasWheelCount=0,
  wordDis=5,collectBubbleNum=0;

  NumUtils._internal(){
    addDownCountNum=getTodayNum(StorageName.addDownCountNum, 2);
    removeFailNum=getTodayNum(StorageName.removeFailNum, 3);
    addTimeNum=getTodayNum(StorageName.addTimeNum, 3);
    heartNum=getTodayNum(StorageName.heartNum, 3);
    wheelNum=getTodayNum(StorageName.wheelNum, 3);
    lastRemoveFailQuestion=StorageUtils.read<String>(StorageName.lastRemoveFailQuestion)??"";
    coinNum=StorageUtils.read<int>(StorageName.coinNum)??0;
    userRemoveFailNum=StorageUtils.read<int>(StorageName.userRemoveFailNum)??0;
    useTimeNum=StorageUtils.read<int>(StorageName.useTimeNum)??0;
    payType=StorageUtils.read<int>(StorageName.payType)??0;
    collectBubbleNum=StorageUtils.read<int>(StorageName.collectBubbleNum)??0;
    _getSignInfo();
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

  updateHeartNum(int num){
    heartNum+=num;
    StorageUtils.write(StorageName.heartNum,heartNum);
    EventCode.updateHeartNum.sendMsg();
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

  _getSignInfo(){
    try {
      var s = StorageUtils.read<String>(StorageName.signInfo)??"";
      var list = s.split("_");
      todaySigned=list.first==getTodayTime();
      signDays=list.last.toInt();
    } catch (e) {

    }
  }

  sign(){
    signDays++;
    todaySigned=true;
    StorageUtils.write(StorageName.signInfo, "${getTodayTime()}_$signDays");
    EventCode.signSuccess.sendMsg();
  }

  getFirebaseConfInfo()async{
    newUserInt=(await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("wland_newuser_int")).toInt(defaultNum: 3);
    wlandInt=(await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("wland_int")).toInt(defaultNum: 3);
    wheelInt=(await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("wland_wheel_int")).toInt(defaultNum: 3);
    wordDis=(await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("word_dis")).toInt(defaultNum: 5);
  }

  updateHasUserCount(){
    hasNewUserCount++;
    if(hasNewUserCount%newUserInt==0){
      _showInterAd();
    }
  }

  updateHasWlandIntCount(){
    hasWlandIntCount++;
    if(hasWlandIntCount%wlandInt==0){
      _showInterAd();
    }
  }

  updateWheelNum(int num){
    wheelNum+=num;
    StorageUtils.write(StorageName.wheelNum, "${getTodayTime()}_$wheelNum");
    EventCode.updateWheelNum.sendMsg();
  }

  updateHasWheelCount(){
    hasWheelCount++;
    if(hasWheelCount%wheelInt==0){
      _showInterAd();
    }
  }

  _showInterAd(){
    FlutterMaxAd.instance.showAd(adType: AdType.inter, adShowListener: AdShowListener(onAdHidden: (ad){}));
  }

  updateCollectBubbleNum(){
    collectBubbleNum++;
    StorageUtils.write(StorageName.collectBubbleNum, collectBubbleNum);
  }
}