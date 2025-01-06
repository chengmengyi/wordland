import 'dart:convert';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter_max_ad/export.dart';

class FacebookUtils{
  static final FacebookUtils _instance = FacebookUtils();
  static FacebookUtils get instance => _instance;


  var _initSuccess=false;
  final _facebookAppEvents = FacebookAppEvents();

  initFacebook(String s)async{
    try{
      if(s.isEmpty){
        return;
      }
      var json = jsonDecode(s);
      var appId = json["app_id"];
      var token = json["client_token"];
      await _facebookAppEvents.initFaceBook(appId: appId, token: token, appName: "");
      _initSuccess=true;
    }catch(e){
      _initSuccess=false;
    }
  }

  logPurchase(MaxAd ad){
    if(_initSuccess){
      _facebookAppEvents.logPurchase(amount: ad.revenue, currency: "USD");
    }
  }
}