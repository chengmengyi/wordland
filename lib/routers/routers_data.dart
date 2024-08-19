import 'package:get/get.dart';
import 'package:wordland/ui/a/page/launch/launch_page.dart';
import 'package:wordland/ui/a/page/set/set_page.dart';
import 'package:wordland/ui/a/page/web/web_page.dart';
import 'package:wordland/ui/b/page/ach/ach_page.dart';
import 'package:wordland/ui/b/page/home/b_home_page.dart';
import 'package:wordland/ui/b/page/wheel/wheel_page.dart';

class RoutersData{
  static const String launch="/launch";
  static const String home="/home";
  static const String answer="/answer";
  static const String achieve="/achieve";
  static const String set="/set";
  static const String web="/web";
  static const String bHome="/bHome";
  static const String wheel="/wheel";
  static const String bAch="/bAch";

  static final routersList=[
    GetPage(
        name: launch,
        page: () => LaunchPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: set,
        page: () => SetPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: web,
        page: () => WebPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: bHome,
        page: () => BHomePage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: wheel,
        page: () => WheelPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: bAch,
        page: () => AchPage(),
        transition: Transition.fadeIn
    ),
  ];
}