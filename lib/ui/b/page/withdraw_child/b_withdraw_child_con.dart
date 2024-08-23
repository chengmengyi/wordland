import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordland/bean/cash_bg_bean.dart';
import 'package:wordland/bean/withdraw_task_bean.dart';
import 'package:wordland/enums/sign_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/language/local.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_data.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/account/account_dialog.dart';
import 'package:wordland/ui/b/dialog/incomplete/incomplete_dialog.dart';
import 'package:wordland/ui/b/dialog/no_money/no_money_dialog.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/guide/new_guide_utils.dart';
import 'package:wordland/utils/guide/withdraw_level20_guide_widget.dart';
import 'package:wordland/utils/guide/withdraw_sign_btn_guide_widget.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/utils/withdraw_task_util.dart';

class BWithdrawChildCon extends RootController{
  var chooseIndex=0,marqueeStr="";
  List<int> withdrawNumList=NewValueUtils.instance.getCashList();
  List<WithdrawTaskBean> taskList=[];

  @override
  void onInit() {
    super.onInit();
    _initMarqueeStr();
  }

  @override
  void onReady() {
    super.onReady();
    _initTaskList();
  }

  @override
  bool initEventbus() => true;

  double getCashPro(int num){
    var d = NumUtils.instance.userMoneyNum/num;
    if(d>=1.0){
      return 1.0;
    }else if(d<=0.0){
      return 0.0;
    }else {
      return d;
    }
  }

  clickWithdrawNumItem(int index){
    if(chooseIndex!=index){
      chooseIndex=index;
      update(["child"]);
    }
  }

  clickTask(WithdrawTaskBean bean){
    TbaUtils.instance.appEvent(AppEventName.withdraw_page_task_c,params: {"task_type":bean.type.name});
    switch(bean.type){
      case WithdrawTaskType.sign:
        if(WithdrawTaskUtils.instance.todaySigned){
          showToast(Local.pleaseSignInTomorrow.tr);
        }else{
          RoutersUtils.showSignDialog(signFrom: SignFrom.other);
        }
        break;
      case WithdrawTaskType.level10:
      case WithdrawTaskType.level20:
      case WithdrawTaskType.level50:
        EventCode.showWordChild.sendMsg();
        EventCode.showWordsGuideFromOther.sendMsg();
        break;
      case WithdrawTaskType.collectBubble:
        EventCode.showWordChild.sendMsg();
        EventCode.showBubbleFinger.sendMsg();
        break;
      case WithdrawTaskType.wheel:
        RoutersUtils.toNamed(routerName: RoutersData.wheel);
        break;
    }
  }

  clickPayType(index){
    NumUtils.instance.updatePayType(index);
    update(["child"]);
  }

  clickWithdraw(){
    TbaUtils.instance.appEvent(AppEventName.withdraw_page_c);
    var chooseMoneyNum = withdrawNumList[chooseIndex];
    if(NumUtils.instance.userMoneyNum<chooseMoneyNum){
      RoutersUtils.dialog(child: NoMoneyDialog());
      return;
    }
    if(taskList.isNotEmpty){
      TbaUtils.instance.appEvent(AppEventName.withdraw_task_pop);
      RoutersUtils.dialog(
        child: IncompleteDialog(
          chooseNum: chooseMoneyNum,
          bean: taskList.first,
          clickGo: (){
            TbaUtils.instance.appEvent(AppEventName.withdraw_task_pop_go);
            clickTask(taskList.first);
          },
        ),
      );
      return;
    }
    RoutersUtils.dialog(child: AccountDialog(chooseNum: chooseMoneyNum,));
  }

  @override
  void receiveBusMsg(EventCode code) {
    switch(code){
      case EventCode.updateCoinNum:
        update(["child"]);
        break;
      case EventCode.updateWithdrawTask:
        _initTaskList();
        update(["child"]);
        break;
      case EventCode.bPackageShowCashSignOverlay:
        _showSignOverlay();
        break;
      case EventCode.bPackageShowCashLevel20Overlay:
        _showLevel20Overlay();
        break;
      default:

        break;
    }
  }

  _showLevel20Overlay(){
    var indexWhere = taskList.indexWhere((element) => element.type==WithdrawTaskType.level20);
    if(indexWhere<0){
      return;
    }
    var renderBox = taskList[indexWhere].globalKey.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    TbaUtils.instance.appEvent(AppEventName.userb_withdraw_reach20);
    NewGuideUtils.instance.showGuideOver(
      context: context,
      widget: WithdrawLevel20GuideWidget(
        offset: offset,
        hideCall: (){
          NewGuideUtils.instance.updatePlanBNewUserStep(BPackageNewUserGuideStep.showRightWordsGuide);
        },
      ),
    );
  }


  _showSignOverlay(){
    var indexWhere = taskList.indexWhere((element) => element.type==WithdrawTaskType.sign);
    if(indexWhere<0){
      return;
    }
    var renderBox = taskList[indexWhere].globalKey.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    NewGuideUtils.instance.showGuideOver(
      context: context,
      widget: WithdrawSignBtnGuideWidget(
        offset: offset,
        hideCall: (){
          TbaUtils.instance.appEvent(AppEventName.userb_withdraw_sign);
          NewGuideUtils.instance.updatePlanBNewUserStep(BPackageNewUserGuideStep.showSignDialog);
        },
      ),
    );
  }

  _initTaskList(){
    taskList.clear();
    taskList.addAll(WithdrawTaskUtils.instance.getWithdrawTaskList());
    update(["task"]);
  }

  _initMarqueeStr(){
    for(var index=0; index<5;index++){
      var phone = "${Random().nextInt(9)}${Random().nextInt(9)}${Random().nextInt(9)}${Random().nextInt(9)}";
      var cash = NewValueUtils.instance.getCashList().random();
      marqueeStr+=_getMarqueeByCode(phone,cash);
    }
  }

  String _getMarqueeByCode(String phone,int cash){
    var code = Get.deviceLocale?.countryCode??"US";
    switch(code){
      case "BR": return "Parabéns 1*******$phone acabou de sacar $cash     ";
      case "VN": return "Xin chúc mừng 1*******$phone vừa rút được $cash     ";
      case "ID": return "Selamat 1*******$phone baru cair $cash     ";
      case "TH": return "ยินดีด้วย 1*******$phone เพิ่งถอนเงินออกไป $cash     ";
      case "RU": return "Тахния 1*******$phone бару тунайкан $cash     ";
      case "PH": return "Congratulations 1*******$phone kaka-cash out lang ng $cash     ";
      default: return "Congratulations 1*******$phone just cashed out $cash     ";
    }
  }

  List<String> getCashTypeList(){
    List<String> list=[];
    var code = Get.deviceLocale?.countryCode??"US";
    switch(code){
      case "BR":
        list.add("baxi_1");
        list.add("baxi_2");
        break;
      case "VN":
        list.add("yuenan_1");
        list.add("yuenan_2");
        break;
      case "ID":
        list.add("yinni_1");
        list.add("yinni_2");
        break;
      case "TH":
        list.add("taiguo_1");
        break;
      case "RU":
        list.add("eluosi_1");
        break;
      case "PH":
        list.add("feilvbin_1");
        list.add("feilvbin_2");
        break;
      default:
        list.add("cash_pay1");
        list.add("cash_pay2");
        list.add("cash_pay3");
        list.add("cash_pay4");
        list.add("cash_pay5");
        list.add("cash_pay6");
        break;
    }
    return list;
  }

  CashBgBean getCashBgBean(){
    var payType = NumUtils.instance.payType;
    var code = Get.deviceLocale?.countryCode??"US";
    switch(code){
      case "BR":
        return CashBgBean(unsBg: "baxi_${payType+1}_uns", selBg: "baxi_${payType+1}_sel");
      case "VN":
        return CashBgBean(unsBg: "yuenan_${payType+1}_uns", selBg: "yuenan_${payType+1}_sel");
      case "ID":
        return CashBgBean(unsBg: "yinni_${payType+1}_uns", selBg: "yinni_${payType+1}_sel");
      case "TH":
        return CashBgBean(unsBg: "taiguo_1_uns", selBg: "taiguo_1_sel");
      case "RU":
        return CashBgBean(unsBg: "eluosi_1_uns", selBg: "eluosi_1_sel");
      case "PH":
        return CashBgBean(unsBg: "feilvbin_${payType+1}_uns", selBg: "feilvbin_${payType+1}_sel");
      default:
        return CashBgBean(unsBg: "cash_num_uns${payType+1}", selBg: "cash_num_sel${payType+1}");
    }
  }
}