import 'dart:math';

import 'package:wordland/enums/sign_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/account/account_dialog.dart';
import 'package:wordland/ui/b/dialog/incomplete/incomplete_dialog.dart';
import 'package:wordland/ui/b/dialog/no_money/no_money_dialog.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';

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
    if(NumUtils.instance.todaySigned){
      showToast("Signed in today, please come back tomorrow");
      return;
    }
    RoutersUtils.showSignDialog(signFrom: SignFrom.other);
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
    if(NumUtils.instance.signDays<7||QuestionUtils.instance.bAnswerIndex<10){
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
      marqueeStr+="Congratulations 1*******$phone just cashed out \$$cash     ";
    }
  }
}