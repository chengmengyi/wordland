import 'package:flutter/material.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/ad/listener/ad_show_listener.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/enums/incent_from.dart';
import 'package:wordland/event/event_code.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/guide/guide_step.dart';
import 'package:wordland/utils/guide/new_guide_utils.dart';
import 'package:wordland/utils/guide/task_bubble_guide_widget.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/utils/question_utils.dart';
import 'package:wordland/utils/task_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/utils.dart';

class BTaskChildCon extends RootController{
  Map<String,GlobalKey> globalMap={};
  Map<String,double> rewardMap={};
  // int firstLargeIndex=-1,firstSmallIndex=-1;
  // Offset? firstFingerOffset;

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.inter);
    TbaUtils.instance.appEvent(AppEventName.task_page);
  }

  getTaskLength()=>(QuestionUtils.instance.getQuestionNum()/30).ceil();

  getShowOrHideTask(int largeIndex,int smallIndex)=>(largeIndex*30+(smallIndex+1)*3)<=QuestionUtils.instance.getQuestionNum();

  getCompleteTask(int largeIndex,int smallIndex)=>(largeIndex*30+(smallIndex+1)*3)<=QuestionUtils.instance.bAnswerRightNum;

  bool isCurrentTask(int largeIndex,int smallIndex){
    var i = largeIndex*30+(smallIndex+1)*3-QuestionUtils.instance.bAnswerRightNum;
    return i<=3&&i>0;
  }


  clickItem(bool completeTask,bool currentTask,int largeIndex,int smallIndex,double addNum,bool showBubble){
    if(showBubble&&completeTask){
      TbaUtils.instance.appEvent(AppEventName.task_pop_claim,params: {"task_from":"${largeIndex*30+smallIndex+1}"});
      if(!currentTask&&!completeTask){
        showToast("Level Locked!");
        return;
      }
      if(currentTask){
        EventCode.showWordChild.sendMsg();
        return;
      }
      if(!showBubble){
        return;
      }
      clickBubbleShowAd(largeIndex, smallIndex);
      return;
    }
    TbaUtils.instance.appEvent(AppEventName.task_pop_go,params: {"task_from":"${largeIndex*30+smallIndex+1}"});
    if(!currentTask&&!completeTask){
      showToast("Level Locked!");
      return;
    }
    EventCode.showWordChild.sendMsg();
  }

  // clickFinger(){
  //   try{
  //     var completeTask = getCompleteTask(firstLargeIndex, firstSmallIndex);
  //     var currentTask = isCurrentTask(firstLargeIndex, firstSmallIndex);
  //     var showBubble = TaskUtils.instance.showBubble(firstLargeIndex, firstSmallIndex);
  //     var addNum = getAddNum(firstLargeIndex, firstSmallIndex);
  //     clickItem(completeTask, currentTask, firstLargeIndex, firstSmallIndex, addNum,showBubble);
  //   }catch(e){
  //
  //   }
  // }

  // _hideFinger(){
  //   if(null!=firstFingerOffset){
  //     firstFingerOffset=null;
  //     firstLargeIndex=-1;
  //     firstSmallIndex=-1;
  //     update(["finger"]);
  //   }
  // }

  GlobalKey getGlobalKey(int largeIndex,int smallIndex){
    var key = "${largeIndex}_$smallIndex";
    if(null==globalMap[key]){
      globalMap[key]=GlobalKey();
    }
    return globalMap[key]!;
  }

  double getAddNum(int largeIndex,int smallIndex){
    var key="${largeIndex}_$smallIndex";
    if(null==rewardMap[key]){
      rewardMap[key]=NewValueUtils.instance.getLevelAddNum();
    }
    return rewardMap[key]!;
  }

  @override
  bool initEventbus() => true;

  @override
  void receiveBusMsg(EventCode code) {
    switch(code){
      case EventCode.answerRight:
        update(["list"]);
        // _checkShowFirstBubbleFinger();
        break;
      case EventCode.oldUserShowBubbleGuide:
        NewGuideUtils.instance.updateOldUserGuideStep(OldUserGuideStep.completeOldUserGuide);
        _showBubbleGuide();
        break;
      default:

        break;
    }
  }

  // _checkShowFirstBubbleFinger(){
  //   // var hasCompleteTask=false;
  //   var largeLength = (QuestionUtils.instance.getQuestionNum()/30).ceil();
  //   for(int largeIndex=0;largeIndex<largeLength;largeIndex++){
  //     for(int smallIndex=0;smallIndex<10;smallIndex++){
  //       var show = (largeIndex*30+(smallIndex+1)*3)<=QuestionUtils.instance.getQuestionNum();
  //       if(show){
  //         var completeTask = (largeIndex*30+(smallIndex+1)*3)<=QuestionUtils.instance.bAnswerRightNum;
  //         var showBubble = TaskUtils.instance.showBubble(largeIndex, smallIndex);
  //         if(completeTask&&showBubble){
  //           firstLargeIndex=largeIndex;
  //           firstSmallIndex=smallIndex;
  //           // hasCompleteTask=true;
  //           break;
  //         }
  //       }
  //     }
  //   }
  //
  //   if(firstLargeIndex!=-1&&firstSmallIndex!=-1){
  //     var renderBox = getGlobalKey(firstLargeIndex, firstSmallIndex).currentContext!.findRenderObject() as RenderBox;
  //     firstFingerOffset = renderBox.localToGlobal(Offset.zero);
  //     update(["finger"]);
  //     EventCode.taskHasBubble.sendMsg();
  //   }
  // }

  _showBubbleGuide(){
    var renderBox = getGlobalKey(TaskUtils.instance.largeIndex, TaskUtils.instance.smallIndex).currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    NewGuideUtils.instance.showGuideOver(
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
        adPosId: AdPosId.wpdnd_int_task_claim,
        adShowListener: AdShowListener(
            onAdHidden: (ad){
              TaskUtils.instance.updateBubbleList(largeIndex, smallIndex);
              update(["list"]);
              RoutersUtils.showIncentDialog(incentFrom: IncentFrom.task,addNum: getAddNum(largeIndex, smallIndex));
            })
    );
  }
}