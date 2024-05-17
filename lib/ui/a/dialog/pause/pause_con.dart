import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/play_music_utils.dart';

class PauseCon extends RootController{
  clickIndex(index, Function() quitCall, Function() dialogClose){
    RoutersUtils.back();
    switch(index){
      case 0:
        PlayMusicUtils.instance.updatePlayStatus();
        break;
      case 1:
        quitCall.call();
        break;
      case 2:
        break;
    }
    dialogClose.call();
  }
}