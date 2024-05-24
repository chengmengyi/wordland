import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/enums/incent_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/guide/guide_utils.dart';
import 'package:wordland/utils/guide/task_bubble_guide_widget.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/task_utils.dart';
import 'package:wordland/utils/utils.dart';

class BTaskChildCon extends RootController{
  Map<String,GlobalKey> globalMap={};

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.inter);
  }

  getTaskLength()=>(QuestionUtils.instance.getQuestionNum()/30).ceil();

  getShowOrHideTask(int largeIndex,int smallIndex)=>(largeIndex*30+(smallIndex+1)*3)<=QuestionUtils.instance.getQuestionNum();

  getCompleteTask(int largeIndex,int smallIndex)=>(largeIndex*30+(smallIndex+1)*3)<=QuestionUtils.instance.bAnswerRightNum;

  bool isCurrentTask(int largeIndex,int smallIndex){
    var i = largeIndex*30+(smallIndex+1)*3-QuestionUtils.instance.bAnswerRightNum;
    return i<=3&&i>0;
  }


  clickItem(bool completeTask,bool currentTask,bool ShowBubble,int largeIndex,int smallIndex){
    if(!currentTask&&!completeTask){
      showToast("Level Locked!");
      return;
    }
    if(currentTask){
      EventCode.showWordChild.sendMsg();
      return;
    }
    if(!ShowBubble){
      return;
    }
    clickBubbleShowAd(largeIndex, smallIndex);
  }

  GlobalKey getGlobalKey(int largeIndex,int smallIndex){
    var key = "${largeIndex}_$smallIndex";
    if(null==globalMap[key]){
      globalMap[key]=GlobalKey();
    }
    return globalMap[key]!;
  }

  @override
  bool initEventbus() => true;

  @override
  void receiveBusMsg(EventCode code) {
    switch(code){
      case EventCode.answerRight:
        update(["list"]);
        break;
      case EventCode.oldUserShowBubbleGuide:
        GuideUtils.instance.updateOldUserGuideStep(OldUserGuideStep.completeOldUserGuide);
        _showBubbleGuide();
        break;
      default:

        break;
    }
  }

  _showBubbleGuide(){
    var renderBox = getGlobalKey(TaskUtils.instance.largeIndex, TaskUtils.instance.smallIndex).currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    GuideUtils.instance.showGuideOver(
        context: context,
        widget: TaskBubbleGuideWidget(
            offset: offset,
            hideCall: (){
              clickBubbleShowAd(TaskUtils.instance.largeIndex, TaskUtils.instance.smallIndex);
            })
    );
  }

  clickBubbleShowAd(int largeIndex,int smallIndex){
    AdUtils.instance.showAd(
        adType: AdType.inter,
        adShowListener: AdShowListener(
            onAdHidden: (ad){
              TaskUtils.instance.updateBubbleList(largeIndex, smallIndex);
              update(["list"]);
              RoutersUtils.showIncentDialog(incentFrom: IncentFrom.task);
            })
    );
  }
}