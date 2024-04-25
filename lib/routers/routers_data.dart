import 'package:get/get.dart';
import 'package:wordland/ui/a/page/achieve/achieve_page.dart';
import 'package:wordland/ui/a/page/answer/answer_page.dart';
import 'package:wordland/ui/a/page/home/home_page.dart';
import 'package:wordland/ui/a/page/launch/launch_page.dart';
import 'package:wordland/ui/a/page/set/set_page.dart';
import 'package:wordland/ui/a/page/web/web_page.dart';

class RoutersData{
  static const String launch="/launch";
  static const String home="/home";
  static const String answer="/answer";
  static const String achieve="/achieve";
  static const String set="/set";
  static const String web="/web";

  static final routersList=[
    GetPage(
        name: launch,
        page: () => LaunchPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: home,
        page: () => HomePage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: answer,
        page: () => AnswerPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: achieve,
        page: () => AchievePage(),
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
  ];
}