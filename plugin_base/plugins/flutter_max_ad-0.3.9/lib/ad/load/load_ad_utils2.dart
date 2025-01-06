import 'package:anythink_sdk/at_index.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_result_bean.dart';
import 'package:flutter_max_ad/ad/ad_num_utils.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';

class LoadAdUtils2{
  static final LoadAdUtils2 _instance = LoadAdUtils2();

  static LoadAdUtils2 get instance => _instance;

  late MaxAdBean _maxAdBean;
  final List<AdType> _loadingList=[];
  final Map<AdType,MaxAdResultBean> _resultMap={};

  initAdInfo(MaxAdBean bean){
    _maxAdBean=bean;
  }

  loadAd(AdType adType){
    if(_loadingList.contains(adType)){
      printDebug("FlutterMaxAd --->$adType is loading  2");
      return;
    }
    if(checkHasCache(adType)){
      printDebug("FlutterMaxAd --->$adType has cache  2");
      return;
    }
    var list = _getAdListByType(adType);
    if(list.isEmpty){
      printDebug("FlutterMaxAd --->$adType list is empty  2");
      return;
    }
    _loadingList.add(adType);
    _loadAdByType(adType,list.first);
  }

  _loadAdByType(AdType adType,MaxAdInfoBean bean){
    printDebug("FlutterMaxAd --->start load $adType ad, 2  data=${bean.toString()}");
    switch(adType){
      // case AdType.open:
      //   if(bean.adType==AdType.open){
      //     FlutterMaxAd.instance.startLoadAd();
      //     AppLovinMAX.loadAppOpenAd(bean.id);
      //   }else if(bean.adType==AdType.inter){
      //     FlutterMaxAd.instance.startLoadAd();
      //     AppLovinMAX.loadInterstitial(bean.id);
      //   }else{
      //     _loadingList.remove(adType);
      //   }
      //   break;
      case AdType.reward:
        FlutterMaxAd.instance.startLoadAd();
        if(bean.plat=="max"){
          AppLovinMAX.loadRewardedAd(bean.id);
        }else if(bean.plat=="topon"){
          ATRewardedManager.loadRewardedVideo(
            placementID: bean.id,
            extraMap: {
              ATSplashManager.tolerateTimeout(): 20000
            },
          );
        }
        break;
      case AdType.inter:
        FlutterMaxAd.instance.startLoadAd();
        if(bean.plat=="max"){
          AppLovinMAX.loadInterstitial(bean.id);
        }else if(bean.plat=="topon"){
          ATInterstitialManager.loadInterstitialAd(
            placementID: bean.id,
            extraMap: {
              ATSplashManager.tolerateTimeout(): 20000
            },
          );
        }
        break;
      default:

        break;
    }
  }

  bool checkHasCache(AdType adType){
    var bean = _resultMap[adType];
    if(null!=bean){
      var expired = DateTime.now().millisecondsSinceEpoch-bean.loadTime>(bean.maxAdInfoBean.expire*1000);
      if(expired){
        removeAdByType(bean.maxAdInfoBean.id);
        return false;
      }else{
        return true;
      }
    }
    return false;
  }

  List<MaxAdInfoBean> _getAdListByType(AdType adType){
    switch(adType){
      // case AdType.open: return _maxAdBean.secondOpenAdList;
      case AdType.reward: return _maxAdBean.secondRewardedAdList;
      case AdType.inter: return _maxAdBean.secondInterAdList;
      default: return [];
    }
  }

  loadAdSuccess(String adUnitId){
    var info = getAdInfoById(adUnitId);
    if(null!=info){
      // var adType = checkIsOpenTypeById(ad.adUnitId)?AdType.open:info.adType;
      printDebug("FlutterMaxAd ---> 2  ${info.adType}--->${adUnitId}--->${info.id} load success");
      _loadingList.remove(info.adType);
      _resultMap[info.adType]=MaxAdResultBean(loadTime: DateTime.now().millisecondsSinceEpoch, maxAdInfoBean: info);
      // AdNumUtils.instance.resetLoadFailNum(info.adLocationName);
    }
  }

  loadAdFail(String adUnitId){
    var info = getAdInfoById(adUnitId);
    if(null!=info){
      // var adType = checkIsOpenTypeById(adUnitId)?AdType.open:info.adType;
      printDebug("FlutterMaxAd ---> 2  ${info.adType}--->$adUnitId--->${info.id} load fail");
      var nextAdInfo = _getNextAdInfoById(adUnitId);
      if(null!=nextAdInfo){
        printDebug("FlutterMaxAd ---> 2  has next info--->${nextAdInfo.toString()}");
        _loadAdByType(info.adType, nextAdInfo);
      }else{
        printDebug("FlutterMaxAd ---> 2 no next info");
        _loadingList.remove(info.adType);
        loadAd(info.adType);
      }
    }
  }

  MaxAdResultBean? getAdResultByAdType(AdType adType)=>_resultMap[adType];

  MaxAdInfoBean? getAdInfoById(String id){
    var indexWhere2 = _maxAdBean.secondRewardedAdList.indexWhere((element) => element.id==id);
    if(indexWhere2>=0){
      return _maxAdBean.secondRewardedAdList[indexWhere2];
    }
    var indexWhere3 = _maxAdBean.secondInterAdList.indexWhere((element) => element.id==id);
    if(indexWhere3>=0){
      return _maxAdBean.secondInterAdList[indexWhere3];
    }
    return null;
  }

  MaxAdInfoBean? _getNextAdInfoById(String id){
    var indexWhere2 = _maxAdBean.secondRewardedAdList.indexWhere((element) => element.id==id);
    if(indexWhere2>=0&&_maxAdBean.secondRewardedAdList.length>indexWhere2+1){
      return _maxAdBean.secondRewardedAdList[indexWhere2+1];
    }
    var indexWhere3 = _maxAdBean.secondInterAdList.indexWhere((element) => element.id==id);
    if(indexWhere3>=0&&_maxAdBean.secondInterAdList.length>indexWhere3+1){
      return _maxAdBean.secondInterAdList[indexWhere3+1];
    }
    return null;
  }

  removeAdByType(String? adUnitId){
    _resultMap.removeWhere((key, value) => value.maxAdInfoBean.id==adUnitId);
  }

  printDebug(Object? object){
    if(kDebugMode){
      print(object);
    }
  }
}