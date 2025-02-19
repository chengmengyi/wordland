import 'package:plugin_b/utils/cash_task/cash_task_utils.dart';
import 'package:plugin_b/utils/cash_task/cask_task_bean.dart';
import 'package:plugin_base/event/event_code.dart';
import 'package:plugin_base/export.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/utils.dart';

class CashTaskCon extends RootController{

  String getTaskIcon(CaskTaskBean caskTaskBean){
    switch(caskTaskBean.taskName){
      case CashTaskName.bubble: return "task_bubble";
      case CashTaskName.box: return "task_box";
      case CashTaskName.wheel: return "task_wheel";
      case CashTaskName.quiz: return "task_quiz";
      default: return "task_bubble";
    }
  }

  String getTaskContent(CaskTaskBean caskTaskBean){
    switch(caskTaskBean.taskName){
      case CashTaskName.bubble: return Local.collect10Balls.tr;
      case CashTaskName.box: return Local.tap10Chests.tr;
      case CashTaskName.wheel: return Local.spinTheWheel5Times.tr;
      case CashTaskName.quiz: return Local.answer20Questions.tr;
      default: return "Answer 20 questions";
    }
  }
}