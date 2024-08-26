import 'package:plugin_b/b/page/ach/ach_page.dart';
import 'package:plugin_b/b/page/home/b_home_page.dart';
import 'package:plugin_b/b/page/wheel/wheel_page.dart';
import 'package:plugin_base/export.dart';
import 'package:plugin_base/routers/routers_data.dart';
import 'package:wordland/ui/launch/launch_page.dart';
import 'package:wordland/ui/set/set_page.dart';
import 'package:wordland/ui/web/web_page.dart';


final mainRoutersList=[
  GetPage(
      name: RoutersData.launch,
      page: () => LaunchPage(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: RoutersData.set,
      page: () => SetPage(),
      transition: Transition.fadeIn
  ),
  GetPage(
      name: RoutersData.web,
      page: () => WebPage(),
      transition: Transition.fadeIn
  ),
];