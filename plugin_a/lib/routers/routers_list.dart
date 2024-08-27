import 'package:plugin_a/page/ach/ach_page.dart';
import 'package:plugin_a/page/home/b_home_page.dart';
import 'package:plugin_a/page/wheel/wheel_page.dart';
import 'package:plugin_base/export.dart';
import 'package:plugin_base/routers/routers_data.dart';


final aRoutersList=[
  GetPage(
      name: RoutersData.aHome,
      page: () => BHomePage(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: RoutersData.aWheel,
      page: () => WheelPage(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: RoutersData.aAch,
      page: () => AchPage(),
      transition: Transition.fadeIn
  ),
];