import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plugin_b/b/dialog/account/account_dialog.dart';
import 'package:plugin_b/b/dialog/cash_congratulations/cash_congratulations_dialog.dart';
import 'package:plugin_b/b/dialog/cash_task/cash_task_dialog.dart';
import 'package:plugin_b/b/dialog/incomplete/incomplete_dialog.dart';
import 'package:plugin_b/b/dialog/no_money/no_money_dialog.dart';
import 'package:plugin_b/guide/guide_step.dart';
import 'package:plugin_b/guide/new_guide_utils.dart';
import 'package:plugin_b/guide/withdraw_level20_guide_widget.dart';
import 'package:plugin_b/guide/withdraw_sign_btn_guide_widget.dart';
import 'package:plugin_b/utils/cash_task/cash_task_utils.dart';
import 'package:plugin_b/utils/utils.dart';
import 'package:plugin_base/bean/cash_bg_bean.dart';
import 'package:plugin_base/bean/withdraw_task_bean.dart';
import 'package:plugin_base/enums/sign_from.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_data.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/storage/storage_name.dart';
import 'package:plugin_base/storage/storage_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/question_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/utils/withdraw_task_util.dart';

class BWithdrawChildCon extends RootController{
  var chooseIndex=0,marqueeStr="",_completedTask=false;
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
    _updateCashBtn();
  }

  clickTask(WithdrawTaskBean bean){
    TbaUtils.instance.appEvent(AppEventName.withdraw_page_task_c,params: {"task_type":bean.type.name});
    switch(bean.type){
      case WithdrawTaskType.sign:
        if(WithdrawTaskUtils.instance.todaySigned){
          showToast(Local.pleaseSignInTomorrow.tr);
        }else{
          Utils.showSignDialog(signFrom: SignFrom.other);
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
        RoutersUtils.toNamed(routerName: RoutersData.bWheel);
        break;
    }
  }

  clickPayType(index){
    NumUtils.instance.updatePayType(index);
    update(["child"]);
    _updateCashBtn();
  }

  clickWithdraw(){
    TbaUtils.instance.appEvent(AppEventName.withdraw_page_c);
    var chooseMoneyNum = withdrawNumList[chooseIndex];
    _showCashTaskDialog(chooseMoneyNum);
  }

  _showCashTaskDialog(int chooseMoneyNum)async{
    var caskTaskBean = await CashTaskUtils.instance.getCashTaskBeanByCashTypeNum(NumUtils.instance.payType, chooseMoneyNum);
    if(null!=caskTaskBean){
      if(caskTaskBean.taskComplete==1){
        RoutersUtils.dialog(
          child: CashCongratulationsDialog(
            dismiss: ()async{
              await CashTaskUtils.instance.deleteCashTask(NumUtils.instance.payType, chooseMoneyNum);
              _updateCashBtn();
            },
          ),
        );
      }else{
        RoutersUtils.dialog(
            child: CashTaskDialog(caskTaskBean: caskTaskBean,)
        );
      }
      return;
    }
    if(NumUtils.instance.userMoneyNum<chooseMoneyNum){
      RoutersUtils.dialog(child: NoMoneyDialog());
      return;
    }
    _createCashTask(chooseMoneyNum);
  }

  _createCashTask(int chooseMoneyNum){
    RoutersUtils.dialog(
      child: AccountDialog(
        chooseNum: chooseMoneyNum,
        dismiss: (account)async{
          StorageUtils.write(StorageName.hasCash, true);
          NumUtils.instance.updateUserMoney(-chooseMoneyNum.toDouble(), (){});
          var caskTaskBean = await CashTaskUtils.instance.createCashTask(NumUtils.instance.payType, chooseMoneyNum, account);
          if(null!=caskTaskBean){
            RoutersUtils.dialog(
                child: CashTaskDialog(caskTaskBean: caskTaskBean,)
            );
          }
        },
      ),
    );
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
      case EventCode.updateCashTask:
        _updateCashBtn();
        break;
      default:

        break;
    }
  }

  _updateCashBtn()async{
    var chooseMoneyNum = withdrawNumList[chooseIndex];
    _completedTask=await CashTaskUtils.instance.checkCompletedTask(NumUtils.instance.payType, chooseMoneyNum);
    update(["cash_btn"]);
  }

  String getCashBtnStr()=>_completedTask?Local.claimNow.tr:Local.cashOut.tr;

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
          // NewGuideUtils.instance.updatePlanBNewUserStep(BPackageNewUserGuideStep.showRightWordsGuide);
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
          // NewGuideUtils.instance.updatePlanBNewUserStep(BPackageNewUserGuideStep.showSignDialog);
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