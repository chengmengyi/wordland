import 'package:plugin_b/utils/task_utils.dart';
import 'package:plugin_b/utils/utils.dart';
import 'package:plugin_base/bean/ach_bean.dart';
import 'package:plugin_base/bean/task_bean.dart';
import 'package:plugin_base/enums/incent_from.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/tba_utils.dart';

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
    Utils.showIncentDialog(
      incentFrom: IncentFrom.ach,
      addNum: bean.addNum.toDouble(),
      dismissDialog: (){
        TaskUtils.instance.clickTaskBtn(bean);
        _updateList();
      }
    );
  }

  double getProgress(AchBean bean){
    var d = bean.current/bean.total;
    if(d>=1.0) {
      return 1.0;
    } else if(d<=0) {
      return 0.0;
    } else {
      return d;
    }
  }

  clickBack(){
    RoutersUtils.back(backParams: {"back":true});
  }
}