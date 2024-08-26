import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_data.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/data.dart';

class SetCon extends RootController{

  clickItem(index){
    if(index==0){
      RoutersUtils.toNamed(routerName: RoutersData.web,params: {"url":privacy});
    }else if(index==1){
      FlutterTbaInfo.instance.jumpToEmail(email);
    }
  }
}