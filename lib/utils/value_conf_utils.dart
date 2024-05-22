import 'dart:convert';
import 'package:wordland/bean/value_conf_bean.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/utils/data.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/utils.dart';

class ValueConfUtils{
  factory ValueConfUtils() => _getInstance();

  static ValueConfUtils get instance => _getInstance();

  static ValueConfUtils? _instance;

  static ValueConfUtils _getInstance() {
    _instance ??= ValueConfUtils._internal();
    return _instance!;
  }

  ValueConfBean? _valueConfBean;

  ValueConfUtils._internal(){
    _valueConfBean=ValueConfBean.fromJson(jsonDecode(_getLocalValueConf()));
  }

  int getCommonAddNum(){
    var common = _valueConfBean?.rewardWord??[];
    if(common.isEmpty){
      return 2000;
    }
    var coinNum = NumUtils.instance.coinNum;
    if(coinNum>(common.last.endNumber??1000000)){
      return (common.last.wordReward??[2000]).random();
    }
    for (var value in common) {
      if(coinNum>=(value.firstNumber??0)&&coinNum<(value.endNumber??0)){
        return (value.wordReward??[2000]).random();
      }
    }
    return 2000;
  }

  double getCoinToMoney(int coin){
    var fixed = (coin/(_valueConfBean?.wordConversion??10000)).toStringAsFixed(2);
    return fixed.toDouble();
  }

  int getMoneyToCoin(int money) => money*(_valueConfBean?.wordConversion??10000);

  List<int> getWithdrawList()=>_valueConfBean?.wordRange??[300,500,600,800];

  double getWithdrawProgress(){
    var d = NumUtils.instance.coinNum/getMoneyToCoin(getWithdrawList().first);
    if(d>=1.0){
      return 1.0;
    }else if(d<=0.0){
      return 0.0;
    }else{
      return d;
    }
  }

  List<int> getSignConfList()=>_valueConfBean?.checkReward??[2000,2000,3000,5000,7000,8000,10000];

  String _getLocalValueConf(){
    var s = StorageUtils.read<String>(StorageName.localValueConf)??"";
    if(s.isNotEmpty){
      return s;
    }
    return valueConfStr.base64();
  }
}