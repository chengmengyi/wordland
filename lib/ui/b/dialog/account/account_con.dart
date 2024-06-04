import 'package:flutter/material.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';

class AccountCon extends RootController{
  TextEditingController editingController=TextEditingController();

  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.appEvent(AppEventName.withdraw_success_pop);
  }
  
  clickWithdraw(int chooseNum){
    TbaUtils.instance.appEvent(AppEventName.withdraw_success_pop_c);
    var content = editingController.text.toString().trim();
    if(content.isEmpty){
      showToast("Please enter the correct withdrawal account number");
      return;
    }
    RoutersUtils.back();
    showToast("Congratulations on your successful withdrawal. Your money has arrived");
    NumUtils.instance.updateCoinNum(-ValueConfUtils.instance.getMoneyToCoin(chooseNum));
  }

  @override
  void onClose() {
    super.onClose();
    editingController.dispose();
  }
}