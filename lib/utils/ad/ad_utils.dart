import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/ui/b/dialog/load_fail/load_fail_dialog.dart';
import 'package:wordland/ui/b/dialog/loading/loading_dialog.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/adjust_point_utils.dart';
import 'package:wordland/utils/data.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';

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
    var json = jsonDecode(_getLocalStr());
    FlutterMaxAd.instance.initMax(
      maxKey: maxAdKey.base64(),
      topOnAppId: androidTopOnAppId.base64(),
      topOnAppKey: androidTopOnAppKey.base64(),
      maxAdBean: MaxAdBean(
        maxShowNum: json["xhfhennt"],
        maxClickNum: json["nxscvbbw"],
        firstRewardedAdList: _getAdList(json["wpdnd_rv_one"],"wpdnd_rv_one"),
        secondRewardedAdList: _getAdList(json["wpdnd_rv_two"],"wpdnd_rv_two"),
        firstInterAdList: _getAdList(json["wpdnd_int_one"],"wpdnd_int_one"),
        secondInterAdList: _getAdList(json["wpdnd_int_two"],"wpdnd_int_two"),
      ),
      topOnTestDeviceId: "df0c1cf7-6405-463f-9105-10ca1ad1abe1",
      // topOnTestDeviceId: "57535bec-dff7-437d-849a-d4a66292214d",
      // maxTestDeviceIds: ["df0c1cf7-6405-463f-9105-10ca1ad1abe1","57535bec-dff7-437d-849a-d4a66292214d"]
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
    Function(bool hasCache)? has
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
          },
          showAdFail: (ad,error){
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
    var s = StorageUtils.read<String>(StorageName.localADConf)??"";
    if(s.isNotEmpty){
      return s;
    }
    return maxAdStr.base64();
  }

  getFirebaseInfo()async{
    var s = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("wpdnd_ad_config");
    if(s.isNotEmpty){
      StorageUtils.write(StorageName.localADConf, s);
    }
  }
}