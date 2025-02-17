import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/ad/listener/load_ad_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:plugin_base/root/load_fail/load_fail_dialog.dart';
import 'package:plugin_base/utils/data.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/storage/storage_name.dart';
import 'package:plugin_base/storage/storage_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/adjust_point_utils.dart';
import 'package:plugin_base/utils/data.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';

class AdUtils{
  factory AdUtils() => _getInstance();

  static AdUtils get instance => _getInstance();

  static AdUtils? _instance;

  static AdUtils _getInstance() {
    _instance ??= AdUtils._internal();
    return _instance!;
  }

  AdUtils._internal();

  initAd(){

    FlutterMaxAd.instance.initMax(
      maxKey: maxAdKey.base64(),
      topOnAppId: androidTopOnAppId.base64(),
      topOnAppKey: androidTopOnAppKey.base64(),
      logFacebookPurchase: true,
      maxAdBean: _getMaxAdBean(),
    );
    FlutterMaxAd.instance.setLoadAdListener(
        LoadAdListener(
          startLoad: (){
            // TbaUtils.instance.appEvent(AppEventName.wpdnd_ad_request);
          },
          loadSuccess: (ad,info){
            TbaUtils.instance.appEvent(AppEventName.wpdnd_ad_fill,params: {"platform":info?.plat??"","networkName":ad?.networkName??""});
          },
        )
    );
  }

  showAd({
    required AdType adType,
    required AdPosId adPosId,
    required AdShowListener adShowListener,
    int tryNum=1,
  }){
    if(!NewValueUtils.instance.checkShowAd(adType)){
      adShowListener.onAdHidden.call(null);
      return;
    }

    FlutterMaxAd.instance.loadAdByType(adType);
    if(tryNum>=1){
      TbaUtils.instance.appEvent(AppEventName.wpdnd_ad_chance,params: {"ad_pos_id":adPosId.name});
    }
    var hasCache = FlutterMaxAd.instance.checkHasCache(adType);
    if(hasCache){
      FlutterMaxAd.instance.showAd(
        adType: adType,
        adShowListener: AdShowListener(
          onAdHidden: (ad){
            adShowListener.onAdHidden.call(ad);
          },
          showAdSuccess: (ad,info){
            NumUtils.instance.uploadLaunchDaysAdNum();
            TbaUtils.instance.adEvent(ad, info, adPosId, adType==AdType.reward?AdFomat.rv:AdFomat.int);
            AdjustPointUtils.instance.showAdSuccess(ad,info);
            adShowListener.showAdSuccess?.call(ad,info);
          },
          showAdFail: (ad,error){
            adShowListener.showAdFail?.call(ad,error);
          },
          onAdReceivedReward: (ad,reward){
            adShowListener.onAdReceivedReward?.call(ad,reward);
          },
          onAdRevenuePaidCallback: (ad){
            adShowListener.onAdRevenuePaidCallback?.call(ad);
          }
        )
      );
      return;
    }
    if(tryNum>0){
      RoutersUtils.dialog(
        child: LoadFailDialog(
          result: (again){
            if(again){
              showAd(adType: adType, adPosId: adPosId,adShowListener: adShowListener,tryNum: tryNum-1);
            }else{
              adShowListener.showAdFail?.call(null,null);
            }
          },
        )
      );
      return;
    }
    showToast("Load ad fail,please try again!");
    adShowListener.showAdFail?.call(null,null);
  }

  showOpenAd({
    Function(bool hasCache)? has,
    Function()? closeAd,
  }){
    var hasCache = FlutterMaxAd.instance.checkHasCache(AdType.inter);
    has?.call(hasCache);
    if(hasCache){
      FlutterMaxAd.instance.showAd(
        adType: AdType.inter,
        adShowListener: AdShowListener(
          showAdSuccess: (ad,info){
            NumUtils.instance.uploadLaunchDaysAdNum();
            TbaUtils.instance.adEvent(ad, info, AdPosId.wpdnd_launch, AdFomat.int);
            AdjustPointUtils.instance.showAdSuccess(ad,info);
          },
          onAdHidden: (ad){
            closeAd?.call();
          },
          showAdFail: (ad,error){
            closeAd?.call();
          },
        ),
      );
    }
  }

  List<MaxAdInfoBean> _getAdList(json,adLocationName){
    try{
      List<MaxAdInfoBean> adList=[];
      json.forEach((v) {
        var v2 = v["qebmnbxt"];
        adList.add(
            MaxAdInfoBean(
                id: v["poxghtmn"],
                plat: v["xcwpwgdx"],
                adType: v2=="interstitial"?AdType.inter:v2=="native"?AdType.native:AdType.reward,
                expire: v["wdsshzhd"],
                sort: v["moetqqfa"],
                adLocationName: adLocationName
            )
        );
      });
      return adList;
    }catch(e){
      return [];
    }
  }

  String _getLocalStr(){
    var s = StorageUtils.read<String>(StorageName.localADConf,distType: false)??"";
    if(s.isNotEmpty){
      return s;
    }
    return maxAdStr.base64();
  }

  getFirebaseInfo()async{
    var start = DateTime.now().millisecondsSinceEpoch;
    var s = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("wpdnd_ad_config");
    var end = DateTime.now().millisecondsSinceEpoch;
    TbaUtils.instance.appEvent(AppEventName.wpdnd_config_success,params: {"time":"${(end-start)/1000}"});
    if(s.isNotEmpty){
      StorageUtils.write(StorageName.localADConf, s,distType: false);
      FlutterMaxAd.instance.setMaxAdInfo(_getMaxAdBean());
    }
  }

  MaxAdBean _getMaxAdBean(){
    var json = jsonDecode(_getLocalStr());
    return MaxAdBean(
      maxShowNum: json["xhfhennt"],
      maxClickNum: json["nxscvbbw"],
      firstRewardedAdList: _getAdList(json["wpdnd_rv_one"],"wpdnd_rv_one"),
      secondRewardedAdList: _getAdList(json["wpdnd_rv_two"],"wpdnd_rv_two"),
      firstInterAdList: _getAdList(json["wpdnd_int_one"],"wpdnd_int_one"),
      secondInterAdList: _getAdList(json["wpdnd_int_two"],"wpdnd_int_two"),
    );
  }
}