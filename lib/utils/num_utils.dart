import 'package:wordland/event/event_code.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/utils/utils.dart';

class NumUtils{
  factory NumUtils() => _getInstance();

  static NumUtils get instance => _getInstance();

  static NumUtils? _instance;

  static NumUtils _getInstance() {
    _instance ??= NumUtils._internal();
    return _instance!;
  }

  var addDownCountNum=2,removeFailNum=2,lastRemoveFailQuestion="",addTimeNum=2,coinNum=0,userRemoveFailNum=0,useTimeNum=0;

  NumUtils._internal(){
    addDownCountNum=getTodayNum(StorageName.addDownCountNum, 2);
    removeFailNum=getTodayNum(StorageName.removeFailNum, 2);
    addTimeNum=getTodayNum(StorageName.addTimeNum, 2);
    lastRemoveFailQuestion=StorageUtils.read<String>(StorageName.lastRemoveFailQuestion)??"";
    coinNum=StorageUtils.read<int>(StorageName.coinNum)??0;
    userRemoveFailNum=StorageUtils.read<int>(StorageName.userRemoveFailNum)??0;
    useTimeNum=StorageUtils.read<int>(StorageName.useTimeNum)??0;
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
    EventCode.updateCoinNum.sendMsg();
  }
}