import 'dart:async';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_max_ad/ad/ad_type.dart';
import 'package:flutter_max_ad/flutter_max_ad.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plugin_base/utils/ad/ad_pos_id.dart';
import 'package:plugin_base/utils/notifi/notifi_id.dart';
import 'package:plugin_base/utils/tba_utils.dart';

class NotifiUtils {
  factory NotifiUtils() => _getInstance();

  static NotifiUtils get instance => _getInstance();

  static NotifiUtils? _instance;

  static NotifiUtils _getInstance() {
    _instance ??= NotifiUtils._internal();
    return _instance!;
  }

  NotifiUtils._internal();

  var fromBackgroundId=-1,hasBuyHome=false,launchShowing=false,appBackGround=false;

  // var flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  initNotifi()async {
    // InitializationSettings initializationSettings = InitializationSettings(
    //   android: _getAndroidInitializationSettings(),
    //   iOS: _getDarwinInitializationSettings(),
    // );
    // var success = await flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse: (
    //       NotificationResponse notificationResponse) {
    //     switch (notificationResponse.notificationResponseType) {
    //       case NotificationResponseType.selectedNotification:
    //         _clickNotification(notificationResponse);
    //         break;
    //       case NotificationResponseType.selectedNotificationAction:
    //         _clickNotification(notificationResponse);
    //         break;
    //     }
    //   },
    // );
    // if(success==true){
    //   _initNotifiType();
    // }
  }

  // _initNotifiType(){
  //   _show(
  //     id: NotifiId.guding,
  //     repeatInterval: RepeatInterval.daily,
  //     title: "Win money from WordLand",
  //     body: ["💰Guess the word, challenge your cognition- it's time to turn your words into cash!","🎁Guess the Word, Earn Cash: A Winning Combination!","🔥Word up and cash in - play our word game and start making money today!"].random()
  //   );
  //   if(NumUtils.instance.todaySigned){
  //     cancelNotification(NotifiId.qiandao);
  //   }else{
  //     Future.delayed(const Duration(milliseconds: 5000),(){
  //       _show(
  //           id: NotifiId.qiandao,
  //           repeatInterval: RepeatInterval.hourly,
  //           title: "Spell, sign in, and earn cash",
  //           body: "Earn Daily with Our Word Guessing Sign-In Challenge"
  //       );
  //     });
  //   }
  //   Future.delayed(const Duration(milliseconds: 10000),(){
  //     _show(
  //         id: NotifiId.renwu,
  //         repeatInterval: RepeatInterval.daily,
  //         title: "Earn Cash with Our Word Tasks！",
  //         body: ["🔥Take on word tasks, unlock earnings","Put your word skills to work, earn cash - accomplish missions and watch your bank account grow!"].random()
  //     );
  //   });
  //   Future.delayed(const Duration(milliseconds: 15000),(){
  //     _show(
  //         id: NotifiId.tixian,
  //         repeatInterval: RepeatInterval.hourly,
  //         title: "Money arrives",
  //         body: "100 cash waiting to be claimed！"
  //     );
  //   });
  // }
  //
  // _getAndroidInitializationSettings()=>const AndroidInitializationSettings('@mipmap/ic_launcher');
  //
  // _getDarwinInitializationSettings()=>const DarwinInitializationSettings(
  //   requestAlertPermission: true,
  //   requestBadgePermission: true,
  //   requestSoundPermission: true,
  // );
  //
  // _show({
  //   required int id,
  //   required RepeatInterval repeatInterval,
  //   required String title,
  //   required String body
  // }){
  //   const AndroidNotificationDetails androidNotificationDetails =
  //   AndroidNotificationDetails('wordguss channel id', 'wordguss channel name',
  //       channelDescription: 'wordguss channel description',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       ticker: 'ticker'
  //   );
  //   const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
  //   flutterLocalNotificationsPlugin.periodicallyShow(
  //       id,
  //       title,
  //       body,
  //       repeatInterval,
  //       notificationDetails
  //   );
  // }
  //
  // _clickNotification(NotificationResponse notificationResponse){
  //   if(FlutterMaxAd.instance.fullAdShowing()){
  //     return;
  //   }
  //   TbaUtils.instance.appEvent(AppEventName.wpdnd_ad_chance,params: {"ad_pos_id":AdPosId.wpdnd_launch.name});
  //   AdUtils.instance.showOpenAd(
  //       has: (has){
  //         if(!has){
  //           FlutterMaxAd.instance.loadAdByType(AdType.inter);
  //         }
  //       }
  //   );
  // }

  // Future<NotificationAppLaunchDetails?> getNotiDetails()async{
  //   return await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  // }

  cancelNotification(int id){
    // flutterLocalNotificationsPlugin.cancel(id);
  }

  checkPermission()async{
    // var plugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    // var options = await plugin?.checkPermissions();
    // if(options?.isEnabled==true){
    //   TbaUtils.instance.appEvent(AppEventName.push_status);
    // }
  }

  notificationTbaPoint(int id){
    switch(id){
      case NotifiId.guding:
        TbaUtils.instance.appEvent(AppEventName.wl_fix_inform_c);
        break;
      case NotifiId.qiandao:
        TbaUtils.instance.appEvent(AppEventName.wl_sign_inform_c);
        break;
      case NotifiId.renwu:
        TbaUtils.instance.appEvent(AppEventName.wl_task_inform_c);
        break;
      case NotifiId.tixian:
        TbaUtils.instance.appEvent(AppEventName.wl_paypel_inform_c);
        break;
    }
  }

  // test() {
  //
  //   //Build.VERSION_CODES.TIRAMISU
  //   // requestPermission(permissionList: [Permission.notification]);
  //
  //   print("kk=======");
  //
  //   const AndroidNotificationDetails androidNotificationDetails =
  //   AndroidNotificationDetails('wordguss channel id', 'wordguss channel name',
  //       channelDescription: 'wordguss channel description',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       ticker: 'ticker'
  //   );
  //   const NotificationDetails notificationDetails = NotificationDetails(
  //       android: androidNotificationDetails);
  //   flutterLocalNotificationsPlugin.periodicallyShow(
  //       2000,
  //       "kkkk",
  //       "body",
  //       RepeatInterval.everyMinute,
  //       notificationDetails,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //   );
  // }
}