import 'package:wordland/enums/task_type.dart';

class TaskBean{
  String text;
  bool canReceive;
  int addNum;
  TaskType taskType;
  TaskBean({
    required this.text,
    required this.canReceive,
    required this.addNum,
    required this.taskType,
  });
}