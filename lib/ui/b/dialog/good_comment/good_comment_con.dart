import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/good_comment/comment_success_dialog.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/utils.dart';

class GoodCommentCon extends RootController{
  int chooseIndex=-1;

  clickStar(index){
    chooseIndex=index;
    update(["list"]);
    NumUtils.instance.updateHasCommentApp();
    Future.delayed(const Duration(milliseconds: 500),(){
      RoutersUtils.back();
      if(chooseIndex==4){
        _showSystemDialog();
      }else{
        showToast("Thanks your feedback");
      }
    });
  }

  _showSystemDialog()async{
    var url="https://play.google.com/store/apps/details?id=${await FlutterTbaInfo.instance.getBundleId()}";
    if(await canLaunchUrlString(url)){
      launchUrlString(url);
    }
  }
}