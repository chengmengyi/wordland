import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plugin_base/root/root_page.dart';
import 'package:plugin_base/routers/routers_utils.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:plugin_base/widget/text_widget.dart';
import 'package:wordland/ui/set/set_con.dart';

class SetPage extends RootPage<SetCon>{
  @override
  String bgName() => "answer1";

  @override
  SetCon setController() => SetCon();

  @override
  Widget contentWidget() => Column(
    children: [
      _topWidget(),
      SizedBox(height: 23.h,),
      _setItemWidget(0),
      _setItemWidget(1),
    ],
  );

  _setItemWidget(index)=>InkWell(
    onTap: (){
      rootController.clickItem(index);
    },
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        ImageWidget(image: "set1",width: double.infinity,height: 70.h,fit: BoxFit.fill,),
        Row(
          children: [
            SizedBox(width: 32.w,),
            TextWidget(
                text: index==0?"Privacy Policy":"Contact Us",
                color: color421000,
                size: 15.sp
            ),
            const Spacer(),
            ImageWidget(image: "set2",width: 24.w,height: 24.w,),
            SizedBox(width: 32.w,),
          ],
        )
      ],
    ),
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