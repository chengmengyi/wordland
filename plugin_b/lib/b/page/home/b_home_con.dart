import 'dart:async';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:plugin_b/b/page/task_child/b_task_child_page.dart';
import 'package:plugin_b/b/page/withdraw_child/b_withdraw_child_page.dart';
import 'package:plugin_b/b/page/word_child/b_word_child_page.dart';
import 'package:plugin_base/bean/home_bottom_bean.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_data.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/ad/ad_utils.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/notifi/notifi_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';

class BHomeCon extends RootController{
  var homeIndex=0,showFinger=false;
  List<Widget> pageList=[BWordChildPage(),BTaskChildPage(),BWithdrawChildPage()];
  List<HomeBottomBean> bottomList=[
    HomeBottomBean(selIcon: "icon_home_sel", unsIcon: "icon_home_uns"),
    HomeBottomBean(selIcon: "icon_task_sel", unsIcon: "icon_task_uns"),
    HomeBottomBean(selIcon: "icon_withdraw_sel", unsIcon: "icon_withdraw_uns"),
  ];

  @override
  void onInit() {
    NewValueUtils.instance.initValue();
    super.onInit();
    AppTrackingTransparency.requestTrackingAuthorization();
    NotifiUtils.instance.hasBuyHome=true;
    NotifiUtils.instance.initNotifi();
    TbaUtils.instance.appEvent(AppEventName.wl_word_page);
  }

  clickBottom(index){
    if(index==0){
      EventCode.refreshAchNum.sendMsg();
    }
    if(homeIndex==index){
      return;
    }
    if(showFinger){
      showFinger=false;
      update(["finger"]);
    }
    homeIndex=index;
    update(["home"]);
  }

  @override
  bool initEventbus() => true;

  @override
  void receiveBusMsg(EventCode code) {
    switch(code){
      case EventCode.showWordChild:
        clickBottom(0);
        break;
      case EventCode.oldUserShowBubbleGuide:
      case EventCode.showTaskChild:
        clickBottom(1);
        break;
      case EventCode.showWithdrawChild:
        clickBottom(2);
        break;
      case EventCode.taskHasBubble:
        if(homeIndex!=1){
          showFinger=true;
          update(["finger"]);
        }
        break;
      default:

        break;
    }
  }

  @override
  void onClose() {
    NotifiUtils.instance.hasBuyHome=false;
    super.onClose();
  }
}