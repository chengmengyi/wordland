import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:get/get.dart';
import 'package:plugin_base/bean/new_value_bean.dart';
import 'package:plugin_base/storage/storage_name.dart';
import 'package:plugin_base/storage/storage_utils.dart';
import 'package:plugin_base/utils/data.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/utils.dart';

class NewValueUtils{
  factory NewValueUtils() => _getInstance();

  static NewValueUtils get instance => _getInstance();

  static NewValueUtils? _instance;

  static NewValueUtils _getInstance() {
    _instance ??= NewValueUtils._internal();
    return _instance!;
  }

  NewValueBean? _valueBean;
  final List<FloatReward> _boxRewardList=[];

  NewValueUtils._internal();

  initValue(){
    try{
      _valueBean=NewValueBean.fromJson(jsonDecode(_getLocalValueConf()));
      jsonDecode(_getBoxRewardConf()).forEach((v) {
        _boxRewardList.add(FloatReward.fromJson(v));
      });
    }catch(e){

    }
  }

  double getNewReward()=>_valueBean?.newReward?.toDouble()??134.0;

  double getRewardAddNum() => _getRandomReward(_valueBean?.rewardWord??[]);

  double getLevelAddNum() => _getRandomReward(_valueBean?.levelReward??[]);

  double getFloatAddNum() => _getRandomReward(_valueBean?.floatReward??[]);

  double getWheelAddNum() => _getRandomReward(_valueBean?.wheelReward??[]);

  double getBoxAddNum() => _getRandomReward(_boxRewardList);

  List<int> getCashList() => _valueBean?.wordRange??[800,1000,1500,2000];

  List<int> getSignList()=>_valueBean?.checkReward??[5,6,8,10,15,20,50];

  int getAchAddNum(int index){
    try{
      return _valueBean?.achievementReward?[index]??20;
    }catch(e){
      return 20;
    }
  }

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

  int getCoinToMoney(int coins){
    if(Platform.isIOS){
      return coins;
    }
    return coins~/(_valueBean?.conversion??10000)*getExchangeRateByCountry();
  }

  int getConversion()=>_valueBean?.conversion??10000;

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
    //   return false;
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

  test(){
    _boxRewardList.clear();
    jsonDecode(_getBoxRewardConf()).forEach((v) {
      _boxRewardList.add(FloatReward.fromJson(v));
    });
    print("kk====${_boxRewardList.length}");
  }

  String _getLocalValueConf(){
    if(Platform.isIOS){
      var s = StorageUtils.read<String>(StorageName.newLocalValueConf)??"";
      if(s.isNotEmpty){
        return s;
      }
      return newValueStr.base64();
    }else{
      var userType = FlutterCheckAdjustCloak.instance.getUserType();
      var s = StorageUtils.read<String>(userType?StorageName.androidLargeValueConf:StorageName.androidSmallValueConf,distType: false)??"";
      if(s.isNotEmpty){
        return s;
      }
      return (userType?androidLargeValueStr:androidSmallValueStr).base64();
    }
  }
  
  String _getBoxRewardConf(){
    var localBoxRewardsStr = StorageUtils.read<String>(StorageName.localBoxRewardsStr,distType: false)??"";
    if(localBoxRewardsStr.isEmpty){
      return androidBoxRewardLocalStr.base64();
    }
    return localBoxRewardsStr;
  }

  getFirebaseInfo()async{
    var localSmall = StorageUtils.read<String>(StorageName.androidSmallValueConf,distType: false)??"";
    if(localSmall.isEmpty){
      var small = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("word_a_number");
      if(small.isNotEmpty){
        StorageUtils.write(StorageName.androidSmallValueConf, small,distType: false);
      }
    }

    var localLarge = StorageUtils.read<String>(StorageName.androidLargeValueConf,distType: false)??"";
    if(localLarge.isEmpty){
      var large = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("word_b_number");
      if(large.isNotEmpty){
        StorageUtils.write(StorageName.androidLargeValueConf, large, distType: false);
      }
    }

    var localBoxRewardsStr = StorageUtils.read<String>(StorageName.localBoxRewardsStr,distType: false)??"";
    if(localBoxRewardsStr.isNotEmpty){
      var box_reward = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("box_reward");
      if(box_reward.isNotEmpty){
        StorageUtils.write(StorageName.localBoxRewardsStr, box_reward, distType: false);
      }
    }
  }
}