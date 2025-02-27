import 'dart:convert';
import 'package:wordland/bean/question_bean.dart';
import 'package:wordland/enums/level_status.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/utils/data.dart';
import 'package:wordland/utils/utils.dart';

class QuestionUtils{
  factory QuestionUtils() => _getInstance();

  static QuestionUtils get instance => _getInstance();

  static QuestionUtils? _instance;

  static QuestionUtils _getInstance() {
    _instance ??= QuestionUtils._internal();
    return _instance!;
  }

  final List<QuestionBean> _questionList=[];
  var currentLevel=1,currentAnswerIndex=0;

  QuestionUtils._internal(){
    _initQuestionList();
    currentLevel=StorageUtils.read<int>(StorageName.currentLevel)??1;
    currentAnswerIndex=StorageUtils.read<int>(StorageName.currentAnswerIndex)??0;
  }

  _initQuestionList(){
    try{
      var json = jsonDecode(questionStr.base64());
      for (var element in (json as List)) {
        var answer = element["answer"];
        if(answer is String && answer.length<=5){
          var question = element["question"];
          _questionList.add(QuestionBean(question: question, answer: answer));
        }
      }
    }catch(e){

    }
  }

  int getQuestionListLength() => (_questionList.length/30).ceil();

  int getQuestionNum()=>_questionList.length;

  LevelStatus getLevelStatus(int largeIndex,int smallIndex){
    var i = largeIndex*10+smallIndex+1;
    if(currentLevel==i){
      return LevelStatus.current;
    }
    if(i<currentLevel){
      return LevelStatus.unlock;
    }
    return LevelStatus.lock;
  }

  List<QuestionBean> getQuestionListByIndex(int largeIndex,int smallIndex){
    var end = largeIndex*30+(smallIndex+1)*3;
    var start = end-3;
    List<QuestionBean> list=[];
    for(int index=start;index<end;index++){
      list.add(_questionList[index]);
    }
    return list;
  }

  updateCurrentLevel(){
    currentLevel++;
    StorageUtils.write(StorageName.currentLevel, currentLevel);
  }

  resetCurrentAnswerIndex(){
    currentAnswerIndex=0;
    StorageUtils.write(StorageName.currentAnswerIndex, currentAnswerIndex);
  }

  updateCurrentAnswerIndex(int largeIndex,int smallIndex,int answerIndex){
    currentAnswerIndex=largeIndex*30+smallIndex*3+answerIndex;
    StorageUtils.write(StorageName.currentAnswerIndex, currentAnswerIndex);
  }
}
