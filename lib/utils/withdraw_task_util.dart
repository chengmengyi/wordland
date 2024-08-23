import 'package:flutter/material.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:get/get.dart';
import 'package:wordland/bean/withdraw_task_bean.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/language/local.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/utils/notifi/notifi_id.dart';
import 'package:wordland/utils/notifi/notifi_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/utils.dart';

class WithdrawTaskUtils{
  factory WithdrawTaskUtils() => _getInstance();

  static WithdrawTaskUtils get instance => _getInstance();

  static WithdrawTaskUtils? _instance;

  static WithdrawTaskUtils _getInstance() {
    _instance ??= WithdrawTaskUtils._internal();
    return _instance!;
  }

  var signDays=0,todaySigned=false,playWheelNum=0;

  WithdrawTaskUtils._internal(){
    _getSignInfo();
  }

  List<WithdrawTaskBean> getWithdrawTaskList(){
    List<WithdrawTaskBean> list=[];
    if(!FlutterCheckAdjustCloak.instance.getUserType()){
      list.add(WithdrawTaskBean(
        text: Local.signInFor7Days.tr.replaceNum(7),
        current: WithdrawTaskUtils.instance.signDays,
        total: 7,
        btn: WithdrawTaskUtils.instance.signDays>=7?Local.done.tr:WithdrawTaskUtils.instance.todaySigned?Local.tomorrow.tr:Local.signIn.tr,
        type: WithdrawTaskType.sign,
        globalKey: GlobalKey(),
      ));
      list.add(WithdrawTaskBean(text: Local.reachLevel.tr.replaceNum(10), current: QuestionUtils.instance.bAnswerIndex,btn: Local.play.tr, total: 10,type: WithdrawTaskType.level10,globalKey: GlobalKey(),));
    }else{
      if(WithdrawTaskUtils.instance.signDays<7&&list.length<2){
        list.add(WithdrawTaskBean(
          text: Local.signInFor7Days.tr.replaceNum(7),
          current: WithdrawTaskUtils.instance.signDays,
          total: 7,
          btn: WithdrawTaskUtils.instance.signDays>=7?Local.done.tr:WithdrawTaskUtils.instance.todaySigned?Local.tomorrow.tr:Local.signIn.tr,
          type: WithdrawTaskType.sign,
          globalKey: GlobalKey(),
        ));
      }
      if(QuestionUtils.instance.bAnswerIndex<20&&list.length<2){
        list.add(WithdrawTaskBean(text: Local.reachLevel.tr.replaceNum(20), current: QuestionUtils.instance.bAnswerIndex, total: 20,btn: Local.play.tr,type: WithdrawTaskType.level20,globalKey: GlobalKey(),));
      }
      if(NumUtils.instance.collectBubbleNum<10&&list.length<2){
        list.add(WithdrawTaskBean(text: Local.collectBubbles.tr.replaceNum(10), current: NumUtils.instance.collectBubbleNum, total: 10,btn: Local.collect.tr,type: WithdrawTaskType.collectBubble,globalKey: GlobalKey(),));
      }
      if(WithdrawTaskUtils.instance.playWheelNum<10&&list.length<2){
        list.add(WithdrawTaskBean(text: Local.spinx.tr.replaceNum(10), current: WithdrawTaskUtils.instance.playWheelNum, total: 10,btn: Local.spin.tr,type: WithdrawTaskType.wheel,globalKey: GlobalKey(),));
      }
      if(QuestionUtils.instance.bAnswerIndex<50&&list.length<2){
        list.add(WithdrawTaskBean(text: Local.reachLevel.tr.replaceNum(50), current: QuestionUtils.instance.bAnswerIndex, total: 50,btn: Local.play.tr,type: WithdrawTaskType.level50,globalKey: GlobalKey(),));
      }
    }
    return list;
  }

  updateWheelNum(){
    playWheelNum++;
    StorageUtils.write(StorageName.playWheelNum, playWheelNum);
    EventCode.updateWithdrawTask.sendMsg();
  }

  _getSignInfo(){
    playWheelNum=StorageUtils.read<int>(StorageName.playWheelNum)??0;
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
    StorageUtils.write(StorageName.lastSignTime, DateTime.now().millisecondsSinceEpoch);
    EventCode.updateWithdrawTask.sendMsg();
    EventCode.signSuccess.sendMsg();
    NotifiUtils.instance.cancelNotification(NotifiId.qiandao);
  }
}