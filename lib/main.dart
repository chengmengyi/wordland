import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wordland/language/messages.dart';
import 'package:wordland/routers/routers_data.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/check_app_state_utils.dart';
import 'package:wordland/utils/guide/new_guide_utils.dart';
import 'package:wordland/utils/network_utils.dart';
import 'package:wordland/utils/new_value_utils.dart';
import 'package:wordland/utils/notifi/notifi_utils.dart';
import 'package:wordland/utils/tba_utils.dart';
import 'package:wordland/utils/user_type/user_type_utils.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var details = await NotifiUtils.instance.getNotiDetails();
  if(null!=details&&details.didNotificationLaunchApp){
    NotifiUtils.instance.fromBackgroundId=details.notificationResponse?.id??-1;
  }

  initInfo();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarDividerColor: null,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      )
  );
  runApp(const MyApp());
}

initInfo()async{
  CheckAppStateUtils.instance.init();
  await GetStorage.init();
  // NewValueUtils.instance.initValue();
  NewGuideUtils.instance.initInfo();
  NetWorkUtils.instance.initListen();
  UserTypeUtils.instance.init();
  AdUtils.instance.initAd();
  TbaUtils.instance.installEvent();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 760),
      builder: (context,child)=>GetMaterialApp(
        title: Platform.isAndroid?'WordRing':'WordLand',
        debugShowCheckedModeBanner: false,
        enableLog: true,
        initialRoute: RoutersData.launch,
        getPages: RoutersData.routersList,
        defaultTransition: Transition.rightToLeft,
        themeMode: ThemeMode.system,
        darkTheme: ThemeData.dark(),
        translations: Messages(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale("en", "US"),
        builder: (context,widget)=>Material(
          child: InkWell(
            onTap: (){
              var node = FocusScope.of(context);
              if(!node.hasPrimaryFocus&&node.focusedChild!=null){
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!
            ),
          ),
        ),
      ),
    );
  }
}
