import 'package:plugin_b/b/page/ach/ach_page.dart';
import 'package:plugin_b/b/page/home/b_home_page.dart';
import 'package:plugin_b/b/page/wheel/wheel_page.dart';
import 'package:plugin_base/export.dart';
import 'package:plugin_base/routers/routers_data.dart';


final bRoutersList=[
  GetPage(
      name: RoutersData.bHome,
      page: () => BHomePage(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: RoutersData.bAch,
      page: () => AchPage(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: RoutersData.bWheel,
      page: () => WheelPage(),
      transition: Transition.fadeIn
  ),
];