import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wordland/routers/routers_data.dart';
import 'package:wordland/utils/ad/ad_utils.dart';
import 'package:wordland/utils/user_type/user_type_utils.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
  await GetStorage.init();
  UserTypeUtils.instance.init();
  AdUtils.instance.initAd();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 760),
      builder: (context,child)=>GetMaterialApp(
        title: 'WordLand',
        debugShowCheckedModeBanner: false,
        enableLog: true,
        initialRoute: RoutersData.launch,
        getPages: RoutersData.routersList,
        defaultTransition: Transition.rightToLeft,
        themeMode: ThemeMode.system,
        darkTheme: ThemeData.dark(),
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
