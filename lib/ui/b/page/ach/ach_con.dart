import 'package:wordland/bean/ach_bean.dart';
import 'package:wordland/bean/task_bean.dart';
import 'package:wordland/enums/incent_from.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/task_utils.dart';
import 'package:wordland/utils/tba_utils.dart';

class AchCon extends RootController{
  List<AchBean> taskList=[];

  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.appEvent(AppEventName.achievement_page);
  }

  @override
  void onReady() {
    super.onReady();
    _updateList();
  }

  _updateList(){
    taskList.clear();
    taskList.addAll(TaskUtils.instance.getBTaskList());
    update(["list"]);
  }

  clickBtn(AchBean bean){
    if(bean.current<bean.total){
      TbaUtils.instance.appEvent(AppEventName.achievement_page_c);
      return;
    }
    TbaUtils.instance.appEvent(AppEventName.achievement_page_receieve);
    RoutersUtils.showIncentDialog(
      incentFrom: IncentFrom.ach,
      addNum: bean.addNum.toDouble(),
      dismissDialog: (){
        TaskUtils.instance.clickTaskBtn(bean);
        _updateList();
      }
    );
  }
}