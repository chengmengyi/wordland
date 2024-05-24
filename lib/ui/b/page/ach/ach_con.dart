import 'package:wordland/bean/task_bean.dart';
import 'package:wordland/enums/incent_from.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/task_utils.dart';

class AchCon extends RootController{
  List<TaskBean> taskList=[];

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
      return;
    }
    RoutersUtils.showIncentDialog(
      incentFrom: IncentFrom.ach,
      addNum: bean.addNum,
      dismissDialog: (){
        TaskUtils.instance.clickTaskBtn(bean);
        _updateList();
      }
    );
  }
}