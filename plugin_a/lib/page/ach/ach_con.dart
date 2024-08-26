import 'package:plugin_a/utils/task_utils.dart';
import 'package:plugin_a/utils/utils.dart';
import 'package:plugin_base/bean/task_bean.dart';
import 'package:plugin_base/enums/incent_from.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/tba_utils.dart';

class AchCon extends RootController{
  List<TaskBean> taskList=[];

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

  clickBtn(TaskBean bean){
    if(!bean.canReceive){
      TbaUtils.instance.appEvent(AppEventName.achievement_page_c);
      return;
    }
    TbaUtils.instance.appEvent(AppEventName.achievement_page_receieve);
    Utils.showIncentDialog(
      incentFrom: IncentFrom.ach,
      addNum: bean.addNum.toDouble(),
      dismissDialog: (){
        TaskUtils.instance.clickTaskBtn(bean);
        _updateList();
      }
    );
  }
}