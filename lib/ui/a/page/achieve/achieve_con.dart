import 'package:wordland/bean/task_bean.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/task_utils.dart';

class AchieveCon extends RootController{
  List<TaskBean> taskList=[];

  @override
  void onReady() {
    super.onReady();
    _updateList();
  }

  _updateList(){
    taskList.clear();
    taskList.addAll(TaskUtils.instance.getTaskList());
    update(["list"]);
  }

  clickBtn(TaskBean bean){
    if(!bean.canReceive){
      return;
    }
    TaskUtils.instance.clickTaskBtn(bean);
    NumUtils.instance.updateCoinNum(bean.addNum);
    _updateList();
  }
}