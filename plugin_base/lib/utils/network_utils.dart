import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_check_adjust_cloak/flutter_check_adjust_cloak.dart';

class NetWorkUtils{
  factory NetWorkUtils() => _getInstance();

  static NetWorkUtils get instance => _getInstance();

  static NetWorkUtils? _instance;

  static NetWorkUtils _getInstance() {
    _instance ??= NetWorkUtils._internal();
    return _instance!;
  }

  NetWorkUtils._internal();

  // StreamSubscription<List<ConnectivityResult>>? _subscription;

  initListen(){
    // _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> connectivityResult) {
    //   if (!connectivityResult.contains(ConnectivityResult.none)) {
    //     FlutterCheckAdjustCloak.instance.requestCloakAgain();
    //   }
    // });
  }

  cancelListen(){
    // _subscription?.cancel();
  }
}