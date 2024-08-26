import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plugin_base/root/root_page.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wordland/ui/web/web_con.dart';

class WebPage extends RootPage<WebCon>{
  @override
  String bgName() => "answer1";

  @override
  WebCon setController() => WebCon();

  @override
  Widget contentWidget() => Column(
    children: [
      _topWidget(),
      SizedBox(height: 23.h,),
      Expanded(
        child: WebViewWidget(controller: rootController.webViewController),
      )
    ],
  );

  _topWidget()=>Row(
    children: [
      SizedBox(width: 12.w,),
      InkWell(
        onTap: (){
          RoutersUtils.back();
        },
        child: ImageWidget(image: "back",width: 36.w,height: 36.h,),
      ),
    ],
  );
}