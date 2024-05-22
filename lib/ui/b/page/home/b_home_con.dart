import 'package:flutter/material.dart';
import 'package:wordland/bean/home_bottom_bean.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/ui/b/page/task_child/b_task_child_page.dart';
import 'package:wordland/ui/b/page/withdraw_child/b_withdraw_child_page.dart';
import 'package:wordland/ui/b/page/word_child/b_word_child_page.dart';

class BHomeCon extends RootController{
  var homeIndex=0;
  List<Widget> pageList=[BWordChildPage(),BTaskChildPage(),BWithdrawChildPage()];
  List<HomeBottomBean> bottomList=[
    HomeBottomBean(selIcon: "icon_home_sel", unsIcon: "icon_home_uns"),
    HomeBottomBean(selIcon: "icon_task_sel", unsIcon: "icon_task_uns"),
    HomeBottomBean(selIcon: "icon_withdraw_sel", unsIcon: "icon_withdraw_uns"),
  ];

  clickBottom(index){
    if(homeIndex==index){
      return;
    }
    homeIndex=index;
    update(["home"]);
  }
}