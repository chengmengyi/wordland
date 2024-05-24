import 'package:flutter/material.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';

class AccountCon extends RootController{
  TextEditingController editingController=TextEditingController();
  
  clickWithdraw(int chooseNum){
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