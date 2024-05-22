import 'dart:convert';

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
        maxShowNum: json["ykoomnqv"],
        maxClickNum: json["xghkvcmk"],
        firstOpenAdList: _getAdList(json["wodbn_launch_one"],"wodbn_launch_one"),
        secondOpenAdList: _getAdList(json["wodbn_launch_two"],"wodbn_launch_two"),
        firstRewardedAdList: _getAdList(json["wodbn_rv_one"],"wodbn_rv_one"),
        secondRewardedAdList: _getAdList(json["wodbn_rv_two"],"wodbn_rv_two"),
        firstInterAdList: _getAdList(json["wodbn_int_one"],"wodbn_int_one"),
        secondInterAdList: _getAdList(json["wodbn_int_two"],"wodbn_int_two"),
      ),
    );
  }

  showAd({
    required AdType adType,
    required AdShowListener adShowListener,
    Function()? cancelShow
  }){
    adShowListener.onAdHidden.call(null);
    return;

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
        var v2 = v["woquhkgf"];
        adList.add(
            MaxAdInfoBean(
                id: v["phhdxvnc"],
                plat: v["wstyghxx"],
                adType: v2=="open"?AdType.open:v2=="interstitial"?AdType.inter:v2=="native"?AdType.native:AdType.reward,
                expire: v["qhdsxmno"],
                sort: v["mugghxat"],
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
}