import 'package:wordland/bean/task_bean.dart';
import 'package:wordland/enums/task_type.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/question_utils.dart';

class TaskUtils{
  factory TaskUtils() => _getInstance();

  static TaskUtils get instance => _getInstance();

  static TaskUtils? _instance;

  static TaskUtils _getInstance() {
    _instance ??= TaskUtils._internal();
    return _instance!;
  }

  TaskUtils._internal();

  List<TaskBean> getTaskList(){
    List<TaskBean> list=[];

    if(!_getReceivedByType(TaskType.get50Coin)){
      list.add(TaskBean(text: "Acquire 50 Diamond", canReceive: NumUtils.instance.coinNum>=50, addNum: 20,taskType: TaskType.get50Coin));
    }
    if(!_getReceivedByType(TaskType.useRemove)){
      list.add(TaskBean(text: "The “Erase”prop was used 2 times in total", canReceive: NumUtils.instance.userRemoveFailNum>=2, addNum: 20,taskType: TaskType.useRemove));
    }
    if(!_getReceivedByType(TaskType.useTime)){
      list.add(TaskBean(text: "The “Time”prop was used 2 times in total", canReceive: NumUtils.instance.useTimeNum>=2, addNum: 20,taskType: TaskType.useTime));
    }
    if(!_getReceivedByType(TaskType.upLevel5)){
      list.add(TaskBean(text: "Pass 5 normal mode levels", canReceive: QuestionUtils.instance.currentLevel>=5, addNum: 20,taskType: TaskType.upLevel5));
    }
    return list;
  }

  clickTaskBtn(TaskBean taskBean){
    StorageUtils.write(taskBean.taskType.name, true);
  }

  _getReceivedByType(TaskType taskType)=>StorageUtils.read<bool>(taskType.name)??false;
}