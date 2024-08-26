import 'dart:io';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:plugin_base/utils/data.dart';
import 'package:plugin_base/utils/user_type/user_check_impl.dart';

class UserTypeUtils{
  factory UserTypeUtils() => _getInstance();

  static UserTypeUtils get instance => _getInstance();

  static UserTypeUtils? _instance;

  static UserTypeUtils _getInstance() {
    _instance ??= UserTypeUtils._internal();
    return _instance!;
  }

  UserTypeUtils._internal();

  init()async{
    var distinctId = await FlutterTbaInfo.instance.getDistinctId();
    var cloakStr = await _getCloakStr(distinctId);
    FlutterCheckAdjustCloak.instance.forceBuyUser(true);
    FlutterCheckAdjustCloak.instance.initCheck(
      cloakPath: cloakStr,
      normalModeStr: "binaural",
      blackModeStr: "middle",
      adjustToken: adjustToken,
      distinctId: distinctId,
      unknownFirebaseKey: "word_unknown",
      referrerConfKey: "referr",
      adjustConfKey: "wland_adjust_on",
      checkListener: UserCheckImpl(),
    );
  }

  Future<String> _getCloakStr(String distinctId)async{
    return "${Platform.isIOS?"https://ashman.wordlandwin.com/felicity/european":"https://father.wordlandwin.com/skull/past"}?"
        "puberty=$distinctId&"
        "cyanamid=${DateTime.now().millisecondsSinceEpoch}&"
        "hostage=${await FlutterTbaInfo.instance.getDeviceModel()}&"
        "parisian=${await FlutterTbaInfo.instance.getBundleId()}&"
        "diego=${await FlutterTbaInfo.instance.getOsVersion()}&"
        "honolulu=${await FlutterTbaInfo.instance.getIdfv()}&"
        "bouillon=${await FlutterTbaInfo.instance.getGaid()}&"
        "marathon=${await FlutterTbaInfo.instance.getAndroidId()}&"
        "devise=${Platform.isAndroid?"leakage":"checkout"}&"
        "seedling=${await FlutterTbaInfo.instance.getIdfa()}&"
        "casework=${await FlutterTbaInfo.instance.getAppVersion()}&"
        "dead=${await FlutterTbaInfo.instance.getBrand()}";
  }
}