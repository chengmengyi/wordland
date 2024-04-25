import 'package:wordland/enums/level_status.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_data.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/question_utils.dart';

class HomeCon extends RootController{

  toAnswer(int largeIndex,int smallIndex,LevelStatus levelStatus){
    if(levelStatus==LevelStatus.lock){
      return;
    }
    RoutersUtils.toNamed(
      routerName: RoutersData.answer,
      params: {
        "largeIndex":largeIndex,
        "smallIndex":smallIndex,
        "levelStatus":levelStatus,
      }
    );
  }

  bool getShowOrHideLevel(int largeIndex,int smallIndex){
    var questionNum = QuestionUtils.instance.getQuestionNum();
    var currentTotal = largeIndex*30+(smallIndex+1)*3;
    return currentTotal<=questionNum;
  }

  @override
  bool initEventbus() => true;

  @override
  void receiveBusMsg(EventCode code) {
    switch(code){
      case EventCode.unlockNewLevel:
        update(["list"]);
        break;
      default:

        break;
    }
  }
}