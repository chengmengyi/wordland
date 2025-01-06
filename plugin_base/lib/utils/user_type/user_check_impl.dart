import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_check_adjust_cloak/util/check_listener.dart';
import 'package:flutter_max_ad/facebook_utils.dart';
import 'package:plugin_base/routers/routers_data.dart';
import 'package:plugin_base/utils/new_notification/forground_service_utils.dart';
import 'package:plugin_base/utils/notifi/notifi_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/ad/ad_utils.dart';
import 'package:plugin_base/utils/adjust_point_utils.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';

class UserCheckImpl implements CheckListener{
  @override
  adjustChangeToBuyUser() {
    TbaUtils.instance.appEvent(AppEventName.adj_organic_buy);
    _checkBuyType();
  }

  @override
  adjustEventCall(AdjustEventSuccess eventSuccessData) {

  }

  @override
  adjustResultCall(String network) {
    TbaUtils.instance.appEvent(AppEventName.wl_adj_suc,params: {"adjust_user":FlutterCheckAdjustCloak.instance.localAdjustIsBuyUser()==true?"0":"1"});
  }

  @override
  beforeRequestAdjust() {

  }

  @override
  firstRequestCloak() {
    TbaUtils.instance.appEvent(AppEventName.wl_cloak_req);
  }

  @override
  firstRequestCloakSuccess() {
    TbaUtils.instance.appEvent(AppEventName.wl_cloak_suc,params: {"cloak_user":FlutterCheckAdjustCloak.instance.localCloakIsNormalUser()==true?"1":"0"});
    _checkBuyType();
  }

  @override
  initFirebaseSuccess() {
    NumUtils.instance.getFirebaseConfInfo();
    AdUtils.instance.getFirebaseInfo();
    NewValueUtils.instance.getFirebaseInfo();
    AdjustPointUtils.instance.getFirebaseData();
    ForegroundServiceUtils.instance.getFirebaseConf();
    _getFacebookConf();
  }

  @override
  startRequestAdjust() {
    TbaUtils.instance.appEvent(AppEventName.wl_adj_req);
  }

  _checkBuyType(){
    if(!NotifiUtils.instance.launchShowing&&!NotifiUtils.instance.hasBuyHome&&!FlutterCheckAdjustCloak.instance.getUserType()&&FlutterCheckAdjustCloak.instance.checkType()){
      RoutersUtils.toNamed(routerName: RoutersData.bHome);
    }
  }

  _getFacebookConf()async{
    var s = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("fb_inform");
    FacebookUtils.instance.initFacebook(s);
  }
}