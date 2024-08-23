import 'package:get/get.dart';
import 'package:wordland/bean/ach_bean.dart';
import 'package:wordland/bean/task_bean.dart';
import 'package:wordland/enums/task_type.dart';
import 'package:wordland/language/local.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/utils.dart';
import 'package:wordland/utils/withdraw_task_util.dart';

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

  bool canReceiveTaskBubble(int largeIndex,int smallIndex)=>!_receivedBubbleList.contains("${largeIndex}_$smallIndex");

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

  clickTaskBtn(AchBean taskBean){
    StorageUtils.write("${taskBean.achType.name}_${taskBean.total}", true);
  }

  _getReceivedByType(TaskType taskType)=>StorageUtils.read<bool>(taskType.name)??false;


  List<AchBean> getBTaskList(){
    List<AchBean> list=[];

    list.add(AchBean(
      text: Local.signInFor7Days.tr.replaceNum(2),
      current: WithdrawTaskUtils.instance.signDays,
      total: 2,
      achType: AchType.sign,
      addNum: NewValueUtils.instance.getAchAddNum(0),
    ));
    list.add(AchBean(
      text: Local.collectBubbles.tr.replaceNum(3),
      current: NumUtils.instance.collectBubbleNum,
      total: 3,
      achType: AchType.collect,
      addNum: NewValueUtils.instance.getAchAddNum(1),
    ));
    list.add(AchBean(
      text: Local.reachLevel.tr.replaceNum(3),
      current: QuestionUtils.instance.bAnswerIndex,
      total: 3,
      achType: AchType.level,
      addNum: NewValueUtils.instance.getAchAddNum(2),
    ));

    list.add(AchBean(
      text: Local.signInFor7Days.tr.replaceNum(5),
      current: WithdrawTaskUtils.instance.signDays,
      total: 5,
      achType: AchType.sign,
      addNum: NewValueUtils.instance.getAchAddNum(3),
    ));
    list.add(AchBean(
      text: Local.collectBubbles.tr.replaceNum(10),
      current: NumUtils.instance.collectBubbleNum,
      total: 10,
      achType: AchType.collect,
      addNum: NewValueUtils.instance.getAchAddNum(4),
    ));
    list.add(AchBean(
      text: Local.reachLevel.tr.replaceNum(10),
      current: QuestionUtils.instance.bAnswerIndex,
      total: 10,
      achType: AchType.level,
      addNum: NewValueUtils.instance.getAchAddNum(5),
    ));

    list.add(AchBean(
      text: Local.signInFor7Days.tr.replaceNum(7),
      current: WithdrawTaskUtils.instance.signDays,
      total: 7,
      achType: AchType.sign,
      addNum: NewValueUtils.instance.getAchAddNum(6),
    ));
    list.add(AchBean(
      text: Local.collectBubbles.tr.replaceNum(15),
      current: NumUtils.instance.collectBubbleNum,
      total: 15,
      achType: AchType.collect,
      addNum: NewValueUtils.instance.getAchAddNum(7),
    ));
    list.add(AchBean(
      text: Local.reachLevel.tr.replaceNum(20),
      current: QuestionUtils.instance.bAnswerIndex,
      total: 20,
      achType: AchType.level,
      addNum: NewValueUtils.instance.getAchAddNum(8),
    ));

    list.add(AchBean(
      text: Local.collectBubbles.tr.replaceNum(20),
      current: NumUtils.instance.collectBubbleNum,
      total: 20,
      achType: AchType.collect,
      addNum: NewValueUtils.instance.getAchAddNum(9),
    ));
    list.add(AchBean(
      text: Local.reachLevel.tr.replaceNum(30),
      current: QuestionUtils.instance.bAnswerIndex,
      total: 30,
      achType: AchType.level,
      addNum: NewValueUtils.instance.getAchAddNum(10),
    ));

    list.add(AchBean(
      text: Local.collectBubbles.tr.replaceNum(30),
      current: NumUtils.instance.collectBubbleNum,
      total: 30,
      achType: AchType.collect,
      addNum: NewValueUtils.instance.getAchAddNum(11),
    ));
    list.add(AchBean(
      text: Local.reachLevel.tr.replaceNum(40),
      current: QuestionUtils.instance.bAnswerIndex,
      total: 40,
      achType: AchType.level,
      addNum: NewValueUtils.instance.getAchAddNum(12),
    ));

    list.add(AchBean(
      text: Local.reachLevel.tr.replaceNum(50),
      current: QuestionUtils.instance.bAnswerIndex,
      total: 50,
      achType: AchType.level,
      addNum: NewValueUtils.instance.getAchAddNum(13),
    ));
    list.add(AchBean(
      text: Local.reachLevel.tr.replaceNum(100),
      current: QuestionUtils.instance.bAnswerIndex,
      total: 100,
      achType: AchType.level,
      addNum: NewValueUtils.instance.getAchAddNum(14),
    ));

    for (int i = 0; i < list.length;) {
      var value = list[i];
      if(StorageUtils.read<bool>("${value.achType.name}_${value.total}")??false){
        list.removeAt(i);
      }else{
        i++;
      }
    }
    return list;
  }
}