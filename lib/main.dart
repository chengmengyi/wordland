import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wordland/routers/routers_data.dart';

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
      ),
    );
  }
}
