import 'dart:convert';

import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_max_ad/ad/ad_bean/max_ad_bean.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/ui/b/dialog/load_fail/load_fail_dialog.dart';
import 'package:wordland/ui/b/dialog/loading/loading_dialog.dart';
import 'package:wordland/utils/data.dart';
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
      maxAdBean: MaxAdBean(
        maxShowNum: json["xhfhennt"],
        maxClickNum: json["nxscvbbw"],
        firstOpenAdList: _getAdList(json["wpdnd_launch_one"],"wpdnd_launch_one"),
        secondOpenAdList: _getAdList(json["wpdnd_launch_two"],"wpdnd_launch_two"),
        firstRewardedAdList: _getAdList(json["wpdnd_rv_one"],"wpdnd_rv_one"),
        secondRewardedAdList: _getAdList(json["wpdnd_rv_two"],"wpdnd_rv_two"),
        firstInterAdList: _getAdList(json["wpdnd_int_one"],"wpdnd_int_one"),
        secondInterAdList: _getAdList(json["wpdnd_int_two"],"wpdnd_int_two"),
      ),
      testDeviceAdvertisingIds: ["E49D56F2-A690-4801-86C0-260396FEFA9D"]
    );
  }

  showAd({
    required AdType adType,
    required AdShowListener adShowListener,
    Function()? cancelShow
  }){
    FlutterMaxAd.instance.loadAdByType(adType);
    var hasCache = FlutterMaxAd.instance.checkHasCache(adType);
    if(hasCache){
      _showAd(adType, adShowListener);
      return;
    }
    RoutersUtils.dialog(
      child: LoadingDialog(
        adType: adType,
        result: (success){
          if(success){
            _showAd(adType, adShowListener);
          }else{
            RoutersUtils.dialog(
              child: LoadFailDialog(
                result: (again){
                  if(again){
                    showAd(adType: adType, adShowListener: adShowListener);
                  }else{
                    cancelShow?.call();
                  }
                },
              )
            );
          }
        },
      ),
    );
  }

  _showAd(AdType adType,AdShowListener adShowListener){
    FlutterMaxAd.instance.showAd(adType: adType, adShowListener: adShowListener);
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
                adType: v2=="open"?AdType.open:v2=="interstitial"?AdType.inter:v2=="native"?AdType.native:AdType.reward,
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