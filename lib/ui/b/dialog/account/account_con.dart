import 'package:flutter/material.dart';
import 'package:wordland/root/root_controller.dart';

class AccountCon extends RootController{
  TextEditingController editingController=TextEditingController();

  @override
  void onClose() {
    super.onClose();
    editingController.dispose();
  }
}