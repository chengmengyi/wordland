import 'dart:math';

import 'package:wordland/root/root_controller.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/utils/utils.dart';

class HeadCon extends RootController{
  var headName="",userName="";

  @override
  void onInit() {
    super.onInit();
    var head = StorageUtils.read<String>(StorageName.headName)??"";
    if(head.isEmpty){
      headName=["head2","head3","head4","head5"].random();
      StorageUtils.write(StorageName.headName, headName);
    }else{
      headName=head;
    }

    var name = StorageUtils.read<String>(StorageName.userName)??"";
    if(name.isEmpty){
      userName="word-${Random().nextInt(888888)+100000}";
      StorageUtils.write(StorageName.userName, userName);
    }else{
      userName=name;
    }
  }
}