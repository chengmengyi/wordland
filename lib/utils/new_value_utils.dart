import 'dart:convert';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:wordland/bean/new_value_bean.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/utils/data.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/utils.dart';

class NewValueUtils{
  factory NewValueUtils() => _getInstance();

  static NewValueUtils get instance => _getInstance();

  static NewValueUtils? _instance;

  static NewValueUtils _getInstance() {
    _instance ??= NewValueUtils._internal();
    return _instance!;
  }

  NewValueBean? _valueBean;

  NewValueUtils._internal();

  initValue(){
    _valueBean=NewValueBean.fromJson(jsonDecode(_getLocalValueConf()));
  }

  double getNewReward()=>_valueBean?.newReward?.toDouble()??134.0;

  double getRewardAddNum() => _getRandomReward(_valueBean?.rewardWord??[]);

  double getLevelAddNum() => _getRandomReward(_valueBean?.levelReward??[]);

  double getFloatAddNum() => _getRandomReward(_valueBean?.floatReward??[]);

  double getWheelAddNum() => _getRandomReward(_valueBean?.wheelReward??[]);

  List<int> getCashList()=>_valueBean?.wordRange??[800,1000,1500,2000];

  List<int> getSignList()=>_valueBean?.checkReward??[5,6,8,10,15,20,50];

  int getCurrentCashRange(){
    var list = getCashList();
    for(var value in list){
      if(NumUtils.instance.userMoneyNum<value){
        return value;
      }
    }
    return list.last;
  }

  double getCashProgress(){
    var d = NumUtils.instance.userMoneyNum/getCurrentCashRange();
    if(d>=1.0){
      return 1.0;
    }else if(d<=0.0){
      return 0.0;
    }else{
      return d;
    }
  }

  double _getRandomReward(List<FloatReward> common){
    if(common.isEmpty){
      return 3.0;
    }
    var userMoney = NumUtils.instance.userMoneyNum;
    if(userMoney>(common.last.endNumber??700)){
      var d = _randomMinMax(common.last.wordReward?.first??3, common.last.wordReward?.last??5);
      // print("本次随机1--->$d---${common.last.wordReward?.first??3}--${common.last.wordReward?.last??5}");
      return d;
    }
    for (var value in common) {
      if(userMoney>=(value.firstNumber??0)&&userMoney<(value.endNumber??0)){
        var d = _randomMinMax(value.wordReward?.first??5, value.wordReward?.last??10);
        // print("本次随机2--->$d---${value.wordReward?.first??5}----${value.wordReward?.last??10}");
        return d;
      }
    }
    return 3.0;
  }

  double getDoubleNum(double num){
   return (Decimal.parse("$num")*Decimal.fromInt(2)).toDouble();
  }

  bool checkShowAd(AdType adType){
    // if(kDebugMode){
    //   return true;
    // }
    List<IntAd> list=[];
    switch(adType){
      case AdType.inter:
        list=_valueBean?.intAd??[];
        break;
      case AdType.reward:
        list=_valueBean?.rvAd??[];
        break;
      default:
        list=[];
        break;
    }
    if(list.isEmpty){
      return false;
    }
    var userMoney = NumUtils.instance.userMoneyNum;
    if(userMoney>(list.last.endNumber??500)){
      return _randomShowAd(list.last.point??0);
    }
    for (var value in list) {
      if(userMoney>=(value.firstNumber??0)&&userMoney<(value.endNumber??0)){
        return _randomShowAd(value.point??0);
      }
    }
    return false;
  }

  bool _randomShowAd(int intAd)=> Random().nextInt(100)<intAd;

  double _randomMinMax(int min,int max) {
    var num = Random().nextDouble() * (max - min) + min;
    return num.toStringAsFixed(2).toDouble();
  }

  test()=>_getLocalValueConf();

  String _getLocalValueConf(){
    var s = StorageUtils.read<String>(StorageName.newLocalValueConf)??"";
    if(s.isNotEmpty){
      return s;
    }
    return newValueStr.base64();
  }


  getFirebaseInfo()async{
    var s = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("wland_numbers2");
    if(s.isNotEmpty){
      StorageUtils.write(StorageName.newLocalValueConf, s);
      _valueBean=NewValueBean.fromJson(jsonDecode(_getLocalValueConf()));
    }
  }
}