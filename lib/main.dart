import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plugin_a/routers/routers_list.dart';
import 'package:plugin_b/routers/routers_list.dart';
import 'package:plugin_base/export.dart';
import 'package:plugin_base/utils/check_app_state_utils.dart';
import 'package:plugin_base/language/messages.dart';
import 'package:plugin_base/routers/routers_data.dart';
import 'package:plugin_base/utils/ad/ad_utils.dart';
import 'package:plugin_base/utils/adjust_point_utils.dart';
import 'package:plugin_base/utils/new_notification/forground_service_utils.dart';
import 'package:plugin_base/utils/tba_utils.dart';
import 'package:plugin_base/utils/user_type/user_type_utils.dart';
import 'package:wordland/routers_list.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  var id = await FlutterWorkmanagerNotification.instance.getAppLaunchNotificationId();
  ForegroundServiceUtils.instance.notificationTba(id??0);

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
  AdjustPointUtils.instance.initInfo();
  UserTypeUtils.instance.init();
  AdUtils.instance.initAd();
  TbaUtils.instance.installEvent();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    var list=bRoutersList+aRoutersList+mainRoutersList;

    return ScreenUtilInit(
      designSize: const Size(360, 760),
      builder: (context,child)=>GetMaterialApp(
        title: 'WordRing',
        debugShowCheckedModeBanner: false,
        enableLog: true,
        initialRoute: RoutersData.launch,
        getPages: list,
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
