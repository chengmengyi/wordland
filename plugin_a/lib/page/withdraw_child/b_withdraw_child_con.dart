import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';
import 'package:plugin_a/dialog/account/account_dialog.dart';
import 'package:plugin_a/dialog/incomplete/incomplete_dialog.dart';
import 'package:plugin_a/dialog/no_money/no_money_dialog.dart';
import 'package:plugin_a/utils/utils.dart';
import 'package:plugin_base/bean/cash_bg_bean.dart';
import 'package:plugin_base/enums/sign_from.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/question_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/utils/withdraw_task_util.dart';

class BWithdrawChildCon extends RootController{
  var chooseIndex=0,marqueeStr="";
  List<int> withdrawNumList=NewValueUtils.instance.getCashList();

  @override
  void onInit() {
    super.onInit();
    _initMarqueeStr();
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

  clickSign(){
    if(WithdrawTaskUtils.instance.todaySigned){
      showToast("Signed in today, please come back tomorrow");
      return;
    }
    Utils.showSignDialog(signFrom: SignFrom.other);
  }

  clickLevel(){
    EventCode.showWordChild.sendMsg();
    EventCode.showWordsGuideFromOther.sendMsg();
  }

  clickPayType(index){
    NumUtils.instance.updatePayType(index);
    update(["child"]);
  }

  clickWithdraw(){
    TbaUtils.instance.appEvent(AppEventName.withdraw_page_c);
    var chooseMoneyNum = withdrawNumList[chooseIndex];
    if(WithdrawTaskUtils.instance.signDays<7||QuestionUtils.instance.bAnswerIndex<10){
      RoutersUtils.dialog(child: IncompleteDialog(chooseNum: chooseMoneyNum,));
      return;
    }
    if(NumUtils.instance.userMoneyNum<chooseMoneyNum){
      RoutersUtils.dialog(child: NoMoneyDialog());
      return;
    }
    RoutersUtils.dialog(child: AccountDialog(chooseNum: chooseMoneyNum,));
  }

  @override
  void receiveBusMsg(EventCode code) {
    switch(code){
      case EventCode.updateCoinNum:
      case EventCode.signSuccess:
        update(["child"]);
        break;
      default:

        break;
    }
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