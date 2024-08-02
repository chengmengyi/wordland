import 'dart:collection';
import 'dart:convert';
import 'package:get/get.dart';
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
  var currentLevel=1,currentAnswerIndex=0,bAnswerIndex=0,bAnswerRightNum=0;

  QuestionUtils._internal(){
    _initQuestionList();
    currentLevel=StorageUtils.read<int>(StorageName.currentLevel)??1;
    currentAnswerIndex=StorageUtils.read<int>(StorageName.currentAnswerIndex)??0;
    bAnswerIndex=StorageUtils.read<int>(StorageName.bAnswerIndex)??0;
    bAnswerRightNum=StorageUtils.read<int>(StorageName.bAnswerRightNum)??0;
  }

  _initQuestionList(){
    try{
      var json = jsonDecode(_getQuestionStrByCountryCode().base64());
      for (var element in (json as List)) {
        var answer = element["answer"];
        if(answer is String && answer.length<=5){
          var question = element["question"];
          var bean = QuestionBean(question: question, answer: answer);
          var indexWhere = _questionList.indexWhere((element) => element.answer==bean.answer);
          if(indexWhere<0){
            _questionList.add(bean);
          }
        }
      }
      _questionList.sort((a, b) => (a.answer.length).compareTo(b.answer.length));
    }catch(e){

    }
  }

  int getQuestionListLength() => (_questionList.length/30).ceil();

  int getQuestionNum()=>_questionList.length;

  // int getLevel() => QuestionUtils.instance.bAnswerRightNum~/3+1;

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

  QuestionBean getBQuestion(){
    if(bAnswerIndex>=_questionList.length){
      bAnswerIndex=-1;
      updateBAnswerIndex();
    }
    return _questionList[bAnswerIndex];
  }

  updateBAnswerIndex({bool updateAnswerRight=false}){
    bAnswerIndex++;
    StorageUtils.write(StorageName.bAnswerIndex, bAnswerIndex);
    if(updateAnswerRight){
      bAnswerRightNum++;
      StorageUtils.write(StorageName.bAnswerRightNum, bAnswerRightNum);
    }
  }

  // updateAnswerRightNum(){
  //   bAnswerRightNum++;
  //   StorageUtils.write(StorageName.bAnswerRightNum, bAnswerRightNum);
  // }

  String _getQuestionStrByCountryCode(){
    var code = Get.deviceLocale?.countryCode??"US";
    switch(code){
      case "BR": return questionStrBaxi;
      case "VN": return questionStrYuenan;
      case "ID": return questionStrYinni;
      case "TH": return qeustionStrTaiguo;
      case "RU": return questionStrEluosi;
      default: return questionStr;
    }
  }
}
