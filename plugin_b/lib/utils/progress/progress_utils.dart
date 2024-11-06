import 'package:plugin_b/utils/progress/progress_bean.dart';
import 'package:plugin_base/storage/storage_name.dart';
import 'package:plugin_base/storage/storage_utils.dart';
import 'package:plugin_base/utils/question_utils.dart';

class ProgressUtils{
  factory ProgressUtils() => _getInstance();
  static ProgressUtils get instance => _getInstance();
  static ProgressUtils? _instance;
  static ProgressUtils _getInstance() {
    _instance ??= ProgressUtils._internal();
    return _instance!;
  }

  var _currentProIndex=1;
  final List<String> _receivedList=[];
  List<ProgressBean> proList=[];

  ProgressUtils._internal(){
    _initReceivedList();
    _currentProIndex=StorageUtils.read<int>(StorageName.currentProIndex)??1;
  }

  initProList(){
    proList.clear();
    for(int index=0;index<QuestionUtils.instance.getQuestionNum();index++){
      if(index==0){
        continue;
      }
      var isBox = index==1||(index-1)%3==0;
      var isWheel = index%5==0;
      if(isBox||isWheel){
        var received = _receivedList.contains("$index");
        proList.add(
            ProgressBean(
              index: index,
              proStatus: _currentProIndex==index?ProStatus.current:received?ProStatus.received:ProStatus.grey,
              proType: isWheel?ProType.wheel:ProType.box,
            )
        );
      }
    }
  }

  updateProIndex(){
    _receivedList.add("$_currentProIndex");
    StorageUtils.write(StorageName.proReceivedIndex, _receivedList.join(","));
    _currentProIndex++;
    StorageUtils.write(StorageName.currentProIndex,_currentProIndex);
    initProList();
  }

  //-1没有 0box  1wheel
  int checkShowBoxOrWheel(){
    var indexWhere = proList.indexWhere((element) => element.proStatus==ProStatus.current);
    if(indexWhere>=0){
      return proList[indexWhere].proType==ProType.box?0:1;
    }
    return -1;
  }

  _initReceivedList(){
    _receivedList.clear();
    var s = StorageUtils.read<String>(StorageName.proReceivedIndex)??"";
    try{
      _receivedList.addAll(s.split(","));
    }catch(e){

    }
  }

  test(){
    print("kkkk===${_currentProIndex}==${QuestionUtils.instance.bAnswerIndex}");
  }
}