import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';
import 'package:flutter_workmanager_notification/notification_observer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plugin_base/export.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/storage/storage_name.dart';
import 'package:plugin_base/storage/storage_utils.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/data.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';

class NotificationId{
  static const int timerNotificationId=100;
  static const int foregroundNotificationId=101;
  static const int unlockNotificationId=102;
}

class ForegroundServiceUtils {
  factory ForegroundServiceUtils() => _getInstance();

  static ForegroundServiceUtils get instance => _getInstance();

  static ForegroundServiceUtils? _instance;

  static ForegroundServiceUtils _getInstance() {
    _instance ??= ForegroundServiceUtils._internal();
    return _instance!;
  }

  ForegroundServiceUtils._internal();

  checkPermissionA() async {
    var result = await Permission.notification.request();
    if (result.isGranted) {
      _startForegroundService();
      FlutterWorkmanagerNotification.instance.startWorkManager(
        id: NotificationId.timerNotificationId,
        title: Local.checkYourAccount.tr,
        desc: Local.completeTasks.tr,
        btn: Local.check.tr,
        tbaUrl: await TbaUtils.instance.getTbaUrl(),
        tbaHeader: await TbaUtils.instance.getHeaderMap(),
        tbaParams: await TbaUtils.instance.getAppEventMap(AppEventName.time_pop_t,),
      );
      _addClickListener();
      FirebaseMessaging.instance.subscribeToTopic("BR~ALL");
    }
  }

  checkPermissionB() async {
    var result = await Permission.notification.request();
    if (result.isGranted) {
      _registerBroadcast();
      _startForegroundService();
      FlutterWorkmanagerNotification.instance.startBPackageWorkManager(
        id: NotificationId.timerNotificationId,
        contentListStr: _getNotificationContentStr(),
        notificationConfStr: _getNotificationConfStr(),
        btn: Local.check.tr,
        tbaUrl: await TbaUtils.instance.getTbaUrl(),
        tbaHeader: await TbaUtils.instance.getHeaderMap(),
        tbaParams: await TbaUtils.instance.getAppEventMap(AppEventName.time_pop_t,),
      );

      var firstInstall = StorageUtils.read<bool>(StorageName.firstInstall)??true;
      if(firstInstall){
        StorageUtils.write(StorageName.firstInstall, false);
        FlutterWorkmanagerNotification.instance.firstInstallSendNotification(
          id: NotificationId.timerNotificationId,
          title: Local.checkYourAccount.tr,
          desc: Local.completeTasks.tr,
          firstTime: jsonDecode(_getNotificationConfStr())["first_time"],
          btn: Local.check.tr,
          tbaUrl: await TbaUtils.instance.getTbaUrl(),
          tbaHeader: await TbaUtils.instance.getHeaderMap(),
          tbaParams: await TbaUtils.instance.getAppEventMap(AppEventName.time_pop_t,),
        );
      }
      _addClickListener();
      FirebaseMessaging.instance.subscribeToTopic("BR~ALL");
    }
  }

  _startForegroundService() async{
    var result = await FlutterWorkmanagerNotification.instance.startForegroundService(
      id: NotificationId.foregroundNotificationId,
      title: Local.myCash.tr,
      desc: getOtherCountryMoneyNum(NumUtils.instance.userMoneyNum),
      btn: Local.check.tr,
    );
    if(result){
      TbaUtils.instance.appEvent(AppEventName.fix_pop_t);
    }
  }

  updateForegroundData() async {
    var status = await Permission.notification.status;
    if(status.isGranted){
      _startForegroundService();
    }
  }

  _addClickListener(){
    FlutterWorkmanagerNotification.instance.setCallObserver(
        NotificationObserver(clickNotification: (id) {
          notificationTba(id);
        }));
  }

  notificationTba(int id){
    switch(id){
      case NotificationId.foregroundNotificationId:
        TbaUtils.instance.appEvent(AppEventName.fix_pop_c);
        break;
      case NotificationId.timerNotificationId:
        TbaUtils.instance.appEvent(AppEventName.time_pop_c);
        break;
      case NotificationId.unlockNotificationId:
        TbaUtils.instance.appEvent(AppEventName.unlock_pop_c);
        break;
    }
  }

  String _getNotificationConfStr(){
    var s = StorageUtils.read<String>(StorageName.notificationConf,distType: false)??"";
    if(s.isEmpty){
      return notificationConfStr.base64();
    }
    return s;
  }

  String _getNotificationContentStr()=>jsonEncode([
    {
      "title":Local.checkYourAccount.tr,
      "content":Local.completeTasks.tr
    },
    {
      "title":Local.answerThisQuestion.tr,
      "content":Local.cashOutNow.tr
    },
    {
      "title":Local.tryYourLuck.tr,
      "content":Local.tryItNow.tr
    },
    {
      "title":"2+2=?",
      "content":Local.answerCorrectly.tr
    },
  ]);

  getFirebaseConf()async{
    var s = await FlutterCheckAdjustCloak.instance.getFirebaseStrValue("wordland_push");
    if(s.isNotEmpty){
      StorageUtils.write(StorageName.notificationConf, s,distType: false);
    }
  }

  _registerBroadcast(){
    var receiver = BroadcastReceiver(names: ["android.intent.action.BOOT_COMPLETED","android.intent.action.USER_PRESENT"]);
    receiver.messages.listen((event) async{
      TbaUtils.instance.appEvent(AppEventName.unlocck_pop_t);
      FlutterWorkmanagerNotification.instance.showNotification(
        id: NotificationId.unlockNotificationId,
        contentListStr: _getNotificationContentStr(),
        btn: Local.check.tr,
        tbaUrl: await TbaUtils.instance.getTbaUrl(),
        tbaHeader: await TbaUtils.instance.getHeaderMap(),
        tbaParams: await TbaUtils.instance.getAppEventMap(AppEventName.time_pop_t,),
      );
    });
    receiver.start();
  }
}