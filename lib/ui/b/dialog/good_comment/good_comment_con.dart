import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/good_comment/comment_success_dialog.dart';
import 'package:wordland/utils/num_utils.dart';

class GoodCommentCon extends RootController{
  GlobalKey lastGlobalKey=GlobalKey();
  Offset? lastOffset;
  int chooseIndex=-1;

  @override
  void onInit() {
    super.onInit();
    NumUtils.instance.updateCommentDialogShowNum();
  }

  clickStar(index){
    chooseIndex=index;
    update(["list"]);
    NumUtils.instance.updateHasCommentApp();
    Future.delayed(const Duration(milliseconds: 500),(){
      RoutersUtils.back();
      if(chooseIndex>=3){
        _showSystemDialog();
      }else{
        RoutersUtils.dialog(child: CommentSuccessDialog());
      }
    });
  }

  _showSystemDialog()async{
    var instance = InAppReview.instance;
    var ava = await instance.isAvailable();
    if(ava){
      instance.requestReview();
    }
  }

  @override
  void onReady() {
    super.onReady();
    var renderBox = lastGlobalKey.currentContext!.findRenderObject() as RenderBox;
    lastOffset = renderBox.localToGlobal(Offset.zero);
    update(["figer"]);
  }
}