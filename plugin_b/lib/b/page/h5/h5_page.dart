import 'package:flutter/material.dart';
import 'package:plugin_b/b/page/h5/h5_controller.dart';
import 'package:plugin_base/export.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/root_page.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:plugin_base/widget/text_widget.dart';

class H5Page extends RootPage<H5Controller>{

  @override
  H5Controller setController() => H5Controller();

  @override
  String bgName() => "answer1";

  @override
  Widget contentWidget() => WillPopScope(
    child: Column(
      children: [
        _topWidget(),
        SizedBox(height: 10.h,),
        Expanded(
          child: WebViewWidget(controller: rootController.webViewController),
        )
      ],
    ),
    onWillPop: ()async{
      rootController.clickBack();
      return false;
    },
  );

  _topWidget()=>Row(
    children: [
      SizedBox(width: 12.w,),
      InkWell(
        onTap: (){
          rootController.clickBack();
        },
        child: ImageWidget(image: "back2",width: 36.w,height: 36.h,),
      ),
      SizedBox(width: 12.w,),
      TextWidget(text: Local.playGames, color: colorFFFFFF, size: 18.sp,)
    ],
  );
}