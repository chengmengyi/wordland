import 'package:anythink_sdk/at_index.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_result_bean.dart';
import 'package:flutter_max_ad/ad/ad_num_utils.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';

class LoadAdUtils{
  static final LoadAdUtils _instance = LoadAdUtils();

  static LoadAdUtils get instance => _instance;

  late MaxAdBean _maxAdBean;
  final List<AdType> _loadingList=[];
  final Map<AdType,MaxAdResultBean> _resultMap={};

  initAdInfo(MaxAdBean bean){
    _maxAdBean=bean;
  }

  loadAd(AdType adType){
    if(_loadingList.contains(adType)){
      printDebug("FlutterMaxAd --->$adType is loading");
      return;
    }
    if(checkHasCache(adType)){
      printDebug("FlutterMaxAd --->$adType has cache");
      return;
    }
    var list = _getAdListByType(adType);
    if(list.isEmpty){
      printDebug("FlutterMaxAd --->$adType list is empty");
      return;
    }
    _loadingList.add(adType);
    _loadAdByType(adType,list.first);
  }

  _loadAdByType(AdType adType,MaxAdInfoBean bean){
    printDebug("FlutterMaxAd --->start load $adType ad,data=${bean.toString()}");
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
      var expired = DateTime.now().millisecondsSinceEpoch-(bean.loadTime)>((bean.maxAdInfoBean.expire)*1000);
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
      // case AdType.open: return _maxAdBean.firstOpenAdList;
      case AdType.reward: return _maxAdBean.firstRewardedAdList;
      case AdType.inter: return _maxAdBean.firstInterAdList;
      default: return [];
    }
  }

  loadAdSuccess(String adUnitId){
    var info = getAdInfoById(adUnitId);
    if(null!=info){
      printDebug("FlutterMaxAd --->${info.adType}--->${adUnitId}--->${info.id} load success");
      _loadingList.remove(info.adType);
      _resultMap[info.adType]=MaxAdResultBean(loadTime: DateTime.now().millisecondsSinceEpoch, maxAdInfoBean: info);
      // AdNumUtils.instance.resetLoadFailNum(info.adLocationName);
    }
  }

  loadAdFail(String adUnitId){
    var info = getAdInfoById(adUnitId);
    if(null!=info){
      printDebug("FlutterMaxAd --->${info.adType}--->$adUnitId--->${info.id} load fail");
      var nextAdInfo = _getNextAdInfoById(adUnitId);
      if(null!=nextAdInfo){
        printDebug("FlutterMaxAd --->has next info--->${nextAdInfo.toString()}");
        _loadAdByType(info.adType, nextAdInfo);
      }else{
        printDebug("FlutterMaxAd --->no next info");
        _loadingList.remove(info.adType);
        loadAd(info.adType);
      }
    }
  }

  MaxAdResultBean? getAdResultByAdType(AdType adType)=>_resultMap[adType];

  MaxAdInfoBean? getAdInfoById(String id){
    var indexWhere2 = _maxAdBean.firstRewardedAdList.indexWhere((element) => element.id==id);
    if(indexWhere2>=0){
      return _maxAdBean.firstRewardedAdList[indexWhere2];
    }
    var indexWhere3 = _maxAdBean.firstInterAdList.indexWhere((element) => element.id==id);
    if(indexWhere3>=0){
      return _maxAdBean.firstInterAdList[indexWhere3];
    }
    return null;
  }

  MaxAdInfoBean? _getNextAdInfoById(String id){
    var indexWhere2 = _maxAdBean.firstRewardedAdList.indexWhere((element) => element.id==id);
    if(indexWhere2>=0&&_maxAdBean.firstRewardedAdList.length>indexWhere2+1){
      return _maxAdBean.firstRewardedAdList[indexWhere2+1];
    }
    var indexWhere3 = _maxAdBean.firstInterAdList.indexWhere((element) => element.id==id);
    if(indexWhere3>=0&&_maxAdBean.firstInterAdList.length>indexWhere3+1){
      return _maxAdBean.firstInterAdList[indexWhere3+1];
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