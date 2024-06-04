import 'package:wordland/root/root_controller.dart';
import 'package:wordland/utils/ad/ad_pos_id.dart';
import 'package:wordland/utils/tba_utils.dart';

class LoadFailCon extends RootController{
  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.appEvent(AppEventName.try_again_pop);
  }
}