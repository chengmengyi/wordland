import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:get_storage/get_storage.dart';

class StorageUtils{
  static final GetStorage _storageBox = GetStorage();

  static write(String key,dynamic value,{bool distType=true}){
    _storageBox.write("$key-${distType?FlutterCheckAdjustCloak.instance.getUserType():""}", value);
  }

  static T? read<T>(String key,{bool distType=true}){
    try {
      return _storageBox.read("$key-${distType?FlutterCheckAdjustCloak.instance.getUserType():""}") as T;
    } catch (e) {
      return null;
    }
  }
}