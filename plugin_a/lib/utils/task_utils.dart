import 'package:get/get.dart';
import 'package:plugin_base/bean/task_bean.dart';
import 'package:plugin_base/enums/task_type.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/storage/storage_name.dart';
import 'package:plugin_base/storage/storage_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/question_utils.dart';

class TaskUtils{
  factory TaskUtils() => _getInstance();

  static TaskUtils get instance => _getInstance();

  static TaskUtils? _instance;

  static TaskUtils _getInstance() {
    _instance ??= TaskUtils._internal();
    return _instance!;
  }
  final List<String> _receivedBubbleList=[];

  var largeIndex=0,smallIndex=0;

  TaskUtils._internal(){
    var list = StorageUtils.read<List>(StorageName.receivedBubble)??[];
    for (var element in list) {
      if(element is String){
        _receivedBubbleList.add(element);
      }
    }
  }

  bool showBubble(int largeIndex,int smallIndex)=>!_receivedBubbleList.contains("${largeIndex}_$smallIndex");

  updateBubbleList(int largeIndex,int smallIndex){
    _receivedBubbleList.add("${largeIndex}_$smallIndex");
    StorageUtils.write(StorageName.receivedBubble, _receivedBubbleList);
  }

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


  List<TaskBean> getBTaskList(){
    List<TaskBean> list=[];
    if(!_getReceivedByType(TaskType.useRemove)){
      list.add(TaskBean(text: Local.theErase.tr, canReceive: NumUtils.instance.tipsNum>=2, addNum: 5,taskType: TaskType.useRemove));
    }
    if(!_getReceivedByType(TaskType.useTime)){
      list.add(TaskBean(text: Local.theTime.tr, canReceive: NumUtils.instance.useTimeNum>=2, addNum: 5,taskType: TaskType.useTime));
    }
    if(!_getReceivedByType(TaskType.collect5Bubble)){
      list.add(TaskBean(text: Local.collect5.tr, canReceive: NumUtils.instance.collectBubbleNum>=5, addNum: 10,taskType: TaskType.collect5Bubble));
    }

    if(!_getReceivedByType(TaskType.upLevel5)){
      list.add(TaskBean(text: Local.pass5.tr, canReceive: QuestionUtils.instance.bAnswerIndex>=5, addNum: 20,taskType: TaskType.upLevel5));
    }
    return list;
  }
}