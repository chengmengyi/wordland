
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/tba_utils.dart';

class LoadFailCon extends RootController{
  @override
  void onInit() {
    super.onInit();
    TbaUtils.instance.appEvent(AppEventName.try_again_pop);
  }
}