import 'package:wordland/root/root_controller.dart';
import 'package:wordland/utils/question_utils.dart';

class BTaskChildCon extends RootController{

  getTaskLength()=>(QuestionUtils.instance.getQuestionNum()/30).ceil();

  getShowOrHideTask(int largeIndex,int smallIndex)=>(largeIndex*30+(smallIndex+1)*3)<=QuestionUtils.instance.getQuestionNum();

  getCompleteTask(int largeIndex,int smallIndex)=>(largeIndex*30+(smallIndex+1)*3)<=QuestionUtils.instance.bAnswerIndex;

  bool isCurrentTask(int largeIndex,int smallIndex){
    var i = largeIndex*30+(smallIndex+1)*3-QuestionUtils.instance.bAnswerIndex;
    return i<=3&&i>0;
  }
}