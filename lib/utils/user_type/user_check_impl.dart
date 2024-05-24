import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:flutter_check_adjust_cloak/util/check_listener.dart';
import 'package:wordland/utils/num_utils.dart';

class UserCheckImpl implements CheckListener{
  @override
  adjustChangeToBuyUser() {

  }

  @override
  adjustEventCall(AdjustEventSuccess eventSuccessData) {

  }

  @override
  adjustResultCall(String network) {

  }

  @override
  beforeRequestAdjust() {

  }

  @override
  firstRequestCloak() {

  }

  @override
  firstRequestCloakSuccess() {

  }

  @override
  initFirebaseSuccess() {
    NumUtils.instance.getFirebaseConfInfo();
  }

  @override
  startRequestAdjust() {

  }

}