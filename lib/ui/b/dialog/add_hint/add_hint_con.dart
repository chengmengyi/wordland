import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/utils/num_utils.dart';

class AddHintCon extends RootController{

  @override
  void onInit() {
    super.onInit();
    FlutterMaxAd.instance.loadAdByType(AdType.reward);
  }

  clickGet(){
    RoutersUtils.back();
    NumUtils.instance.updateRemoveFailNum(1);
    // addNumCall.call();
  }
}