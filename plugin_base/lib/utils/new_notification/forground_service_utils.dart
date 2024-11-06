import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_workmanager_notification/notification_observer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plugin_base/export.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationId{
  static const int timerNotificationId=10000;
  static const int foregroundNotificationId=10001;
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

  checkPermission() async {
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
    }
  }
}