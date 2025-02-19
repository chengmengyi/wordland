import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:plugin_b/utils/cash_task/cask_task_bean.dart';
import 'package:plugin_b/utils/cash_task/max_cash_bean.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/utils/sql_utils.dart';
import 'package:plugin_base/utils/utils.dart';

class CashTaskName{
  static const String bubble="bubble";
  static const String wheel="wheel";
  static const String box="box";
  static const String quiz="quiz";
  static const String sign="sign";
}

class CashTaskUtils{
  static final CashTaskUtils _instance=CashTaskUtils();
  static CashTaskUtils get instance => _instance;

  final _maxTaskList=kDebugMode?
  [
    MaxCashBean(taskName: CashTaskName.bubble, maxTask: 1, maxSign: 1),
    MaxCashBean(taskName: CashTaskName.wheel, maxTask: 1, maxSign: 1),
    MaxCashBean(taskName: CashTaskName.box, maxTask: 1, maxSign: 1),
    MaxCashBean(taskName: CashTaskName.quiz, maxTask: 1, maxSign: 1),
    MaxCashBean(taskName: CashTaskName.sign, maxTask: 0, maxSign: 2),
  ]:
  [
    MaxCashBean(taskName: CashTaskName.bubble, maxTask: 10, maxSign: 2),
    MaxCashBean(taskName: CashTaskName.wheel, maxTask: 10, maxSign: 2),
    MaxCashBean(taskName: CashTaskName.box, maxTask: 10, maxSign: 2),
    MaxCashBean(taskName: CashTaskName.quiz, maxTask: 10, maxSign: 2),
    MaxCashBean(taskName: CashTaskName.sign, maxTask: 0, maxSign: 10),
  ];

  Future<CaskTaskBean?> createCashTask(int cashType,int cashNum,String account)async{
    var database = await SqlUtils.instance.initDB();
    var list = await database.query(TableName.cashTaskRecord,where: '"cashType" = ? AND "cashNum" = ?', whereArgs: [cashType,cashNum]);
    if(list.isNotEmpty){
      return null;
    }
    var indexWhere = _maxTaskList.indexWhere((element) => element.taskName==CashTaskName.bubble);
    if(indexWhere<0){
      return null;
    }
    var maxCashBean = _maxTaskList[indexWhere];
    var caskTaskBean = CaskTaskBean(
      taskComplete: 0,
      taskName: maxCashBean.taskName,
      cashType: cashType,
      cashNum: cashNum,
      taskPro: 0,
      signPro: 0,
      account: account,
    );
    await database.insert(TableName.cashTaskRecord, caskTaskBean.toJson());
    return caskTaskBean;
  }

  Future<CaskTaskBean?> getCashTaskBeanByCashTypeNum(int cashType,int cashNum,)async{
    var database = await SqlUtils.instance.initDB();
    var list = await database.query(TableName.cashTaskRecord,where: '"cashType" = ? AND "cashNum" = ?', whereArgs: [cashType,cashNum]);
    if(list.isEmpty){
      return null;
    }
    return CaskTaskBean.fromJson(list.first);
  }

  updateCashTaskPro(String currentTaskName)async{
    var database = await SqlUtils.instance.initDB();
    var list = await database.query(TableName.cashTaskRecord,where: 'taskComplete = 0');
    if(list.isEmpty){
      return;
    }
    for (var value in list) {
      var newMap = Map<String, Object?>.from(value);
      var signPro = value["signPro"] as int;
      var taskPro = value["taskPro"] as int;
      var taskName = value["taskName"] as String;
      if(currentTaskName!=taskName&&currentTaskName!=CashTaskName.sign){
        continue;
      }
      if(currentTaskName==CashTaskName.sign){
        newMap["signPro"]=signPro+1;
      }else{
        if(currentTaskName==taskName){
          newMap["taskPro"]=taskPro+1;
        }
      }
      //已完成任务
      var maxTaskBean = getMaxTaskBean(taskName);
      if(signPro+1>=(maxTaskBean?.maxSign??0)&&taskPro+1>=(maxTaskBean?.maxTask??0)){
        //已完成所有任务
        if(taskName==CashTaskName.sign){
          newMap["taskComplete"]=1;
        }else{
          newMap["taskName"]=_getNextTaskName(taskName);
          newMap["taskPro"]=0;
          newMap["signPro"]=0;
        }
      }
      print("kk===${newMap}");
      await database.update(TableName.cashTaskRecord, newMap,where: '"id" = ?', whereArgs: [newMap["id"]]);
    }
    EventCode.updateCashTask.sendMsg();
  }

  deleteCashTask(int cashType,int cashNum,)async{
    var database = await SqlUtils.instance.initDB();
    await database.delete(TableName.cashTaskRecord,where: '"cashType" = ? AND "cashNum" = ?', whereArgs: [cashType,cashNum]);
  }

  Future<bool> checkCompletedTask(int cashType,int cashNum)async{
    var database = await SqlUtils.instance.initDB();
    var list = await database.query(TableName.cashTaskRecord,where: '"cashType" = ? AND "cashNum" = ? AND taskComplete = 1', whereArgs: [cashType,cashNum]);
    if(list.isEmpty){
      return false;
    }
    return true;
  }

  String _getNextTaskName(String taskName){
    switch(taskName){
      case CashTaskName.bubble: return CashTaskName.wheel;
      case CashTaskName.wheel: return CashTaskName.box;
      case CashTaskName.box: return CashTaskName.quiz;
      case CashTaskName.quiz: return CashTaskName.sign;
      default: return CashTaskName.wheel;
    }
  }

  MaxCashBean? getMaxTaskBean(String? taskName){
    var indexWhere = _maxTaskList.indexWhere((element) => element.taskName==taskName);
    if(indexWhere<0){
      return null;
    }
    return _maxTaskList[indexWhere];
  }
}