import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_check_adjust_cloak/util/check_listener.dart';
import 'package:wordland/routers/routers_data.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/adjust_point_utils.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/utils/notifi/notifi_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/tba_utils.dart';

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
  }

  @override
  startRequestAdjust() {
    TbaUtils.instance.appEvent(AppEventName.wl_adj_req);
  }

  _checkBuyType(){
    if(!FlutterCheckAdjustCloak.instance.getUserType()&&FlutterCheckAdjustCloak.instance.checkType()&&!NotifiUtils.instance.launchShowing&&!NotifiUtils.instance.hasBuyHome){
      RoutersUtils.toNamed(routerName: RoutersData.bHome);
    }
  }
}