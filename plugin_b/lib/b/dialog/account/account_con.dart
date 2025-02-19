import 'package:flutter/material.dart';
import 'package:plugin_b/b/dialog/cash_congratulations/cash_congratulations_dialog.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/storage/storage_name.dart';
import 'package:plugin_base/storage/storage_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';

class AccountCon extends RootController{
  TextEditingController editingController=TextEditingController();

  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.appEvent(AppEventName.withdraw_success_pop);
  }
  
  clickWithdraw(Function(String account) dismiss){
    TbaUtils.instance.appEvent(AppEventName.withdraw_success_pop_c);
    var content = editingController.text.toString().trim();
    if(content.isEmpty){
      showToast("Please enter the correct withdrawal account number");
      return;
    }
    RoutersUtils.back();
    dismiss.call(content);
  }

  @override
  void onClose() {
    super.onClose();
    editingController.dispose();
  }
}